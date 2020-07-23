//
//  AttributedString.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 09.10.17.
//  Copyright 2017 Florian Friedrich
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import Foundation
import CoreFoundation

public struct AttributedString: ReferenceConvertible {
    public typealias ReferenceType = NSAttributedString
    public typealias EnumerationOptions = ReferenceType.EnumerationOptions
    public typealias AttributesDictionary = ReferenceType.AttributesDictionary
    public typealias Key = ReferenceType.Key
    public typealias Index = String.Index

    @CoW
    private var attrString: CFMutableAttributedString

    public var string: String { CFAttributedStringGetString(attrString) as String }
    public var length: Int { CFAttributedStringGetLength(attrString) }

    public var startIndex: Index { string.startIndex }
    public var endIndex: Index { string.endIndex }

    fileprivate init(attrString: CFMutableAttributedString) {
        _attrString = CoW(wrappedValue: attrString,
                          copyingWith: { CFAttributedStringCreateMutableCopy(kCFAllocatorDefault, 0, $0) })
    }

    public init() {
        self.init(attrString: CFAttributedStringCreateMutable(kCFAllocatorDefault, 0))
    }

    public init(string: String) {
        self.init()
        CFAttributedStringReplaceString(attrString, CFRange(location: 0, length: length), string as CFString)
    }

    public init(string: String, attributes: AttributesDictionary) {
        self.init(string: string)
        CFAttributedStringSetAttributes(attrString, CFRange(location: 0, length: length), .fromAttributes(attributes), true)
    }
}

extension AttributedString {
    fileprivate struct EnumerationRange {
        let string: String
        let indices: Range<Index>
        let reversed: Bool
        var currentIndex: Index

        var isAtEnd: Bool {
            return reversed ? currentIndex <= indices.lowerBound : currentIndex >= indices.upperBound
        }

        init(range: Range<Index>, in string: String, reversed: Bool) {
            self.string = string
            self.indices = range
            self.reversed = reversed
            currentIndex = reversed ? range.upperBound : range.lowerBound
        }

        mutating func advance(range: Range<Index>? = nil) {
            let step = range.map { string.distance(from: $0.lowerBound, to: $0.upperBound) } ?? 1
            currentIndex = string.index(currentIndex, offsetBy: reversed ? -step : step)
        }
    }

    fileprivate struct RangeInfo {
        let rangePointer: NSRangePointer?
        let longestEffectiveRangeSearchRange: NSRange?

        static func withInfo<T>(to range: inout Range<Index>?, in string: String, longestEffectiveRangeSearchRange: Range<Index>? = nil, do work: (RangeInfo) throws -> T) rethrows -> T {
            var _nsRange = NSRange(location: NSNotFound, length: 0)
            defer { range = Range(_nsRange, in: string) }
            return try withUnsafeMutablePointer(to: &_nsRange) {
                let rangeInfo = RangeInfo(
                    rangePointer: $0,
                    longestEffectiveRangeSearchRange: longestEffectiveRangeSearchRange.map { NSRange($0, in: string) })
                return try work(rangeInfo)
            }
        }
    }

    fileprivate func _attributes(at location: Int, rangeInfo: RangeInfo) -> AttributesDictionary {
        var cfRange = CFRange()
        return withUnsafeMutablePointer(to: &cfRange) { ptr in
            defer { rangeInfo.rangePointer?.pointee = ptr.pointee.nsRange }
            if let searchRange = rangeInfo.longestEffectiveRangeSearchRange {
                return CFAttributedStringGetAttributesAndLongestEffectiveRange(attrString, location, CFRange(searchRange), ptr).toAttributesDictionary()
            } else {
                return CFAttributedStringGetAttributes(attrString, location, ptr).toAttributesDictionary()
            }
        }
    }

    fileprivate func _attribute(_ attrName: Key, atIndex location: Int, rangeInfo: RangeInfo) -> Any? {
        var cfRange = CFRange()
        return withUnsafeMutablePointer(to: &cfRange) { ptr in
            defer { rangeInfo.rangePointer?.pointee = ptr.pointee.nsRange }
            if let searchRange = rangeInfo.longestEffectiveRangeSearchRange {
                return CFAttributedStringGetAttributeAndLongestEffectiveRange(attrString, location, attrName.rawValue as CFString, CFRange(searchRange), ptr)
            } else {
                return CFAttributedStringGetAttribute(attrString, location, attrName.rawValue as CFString, ptr)
            }
        }
    }

    fileprivate func _enumerate(in enumerationRange: Range<Index>, reversed: Bool, using block: (Index, inout Bool) -> Range<Index>?) {
        var attributeEnumerationRange = EnumerationRange(range: enumerationRange, in: string, reversed: reversed)
        while !attributeEnumerationRange.isAtEnd {
            var stop = false
            let effectiveRange = block(attributeEnumerationRange.currentIndex, &stop)
            guard !stop else { break }
            attributeEnumerationRange.advance(range: effectiveRange)
        }
    }

    public func attributedSubstring(from range: Range<Index>) -> AttributedString {
        let attributedSubstring = CFAttributedStringCreateWithSubstring(kCFAllocatorDefault, attrString, CFRange(NSRange(range, in: string)))
        let mutableString = CFAttributedStringCreateMutableCopy(kCFAllocatorDefault, 0, attributedSubstring)!
        return AttributedString(attrString: mutableString)
    }

    public func attributes(at location: Index, effectiveRange range: inout Range<Index>?) -> AttributesDictionary {
        let str = string
        return RangeInfo.withInfo(to: &range, in: str) { _attributes(at: str.cfIndex(for: location), rangeInfo: $0) }
    }

    public func attribute(_ attrName: Key, at location: Index, effectiveRange range: inout Range<Index>?) -> Any? {
        let str = string
        return RangeInfo.withInfo(to: &range, in: str) { _attribute(attrName, atIndex: str.cfIndex(for: location), rangeInfo: $0) }
    }

    public func attributes(at location: Index, longestEffectiveRange range: inout Range<Index>?, in rangeLimit: Range<Index>) -> AttributesDictionary {
        let str = string
        return RangeInfo.withInfo(to: &range, in: str, longestEffectiveRangeSearchRange: rangeLimit) {
            _attributes(at: str.cfIndex(for: location), rangeInfo: $0)
        }
    }

    public func attribute(_ attrName: Key, at location: Index, longestEffectiveRange range: inout Range<Index>?, in rangeLimit: Range<Index>) -> Any? {
        let str = string
        return RangeInfo.withInfo(to: &range, in: str, longestEffectiveRangeSearchRange: rangeLimit) {
            _attribute(attrName, atIndex: str.cfIndex(for: location), rangeInfo: $0)
        }
    }

    public func enumerateAttributes(in range: Range<Index>, options: EnumerationOptions = [], using block: (AttributesDictionary, Range<Index>, inout Bool) -> ()) {
        _enumerate(in: range, reversed: options.contains(.reverse)) { idx, stop in
            var effectiveRange: Range<Index>?
            let attrs: AttributesDictionary
            if options.contains(.longestEffectiveRangeNotRequired) {
                attrs = attributes(at: idx, effectiveRange: &effectiveRange)
            } else {
                attrs = attributes(at: idx, longestEffectiveRange: &effectiveRange, in: range)
            }
            if let range = effectiveRange {
                block(attrs, range, &stop)
            }
            return effectiveRange
        }
    }
}

// NSMutableAttributedString
extension AttributedString {
    private func cfRange(for range: Range<Index>) -> CFRange {
        return CFRange(NSRange(range, in: string))
    }

    public mutating func replaceCharacters(in range: Range<Index>, with str: String) {
        _attrString.copyIfNeeded()
        CFAttributedStringReplaceString(attrString, cfRange(for: range), str as CFString)
    }

    public mutating func setAttributes(_ attrs: AttributesDictionary?, range: Range<Index>) {
        _attrString.copyIfNeeded()
        // TODO: Will this work with nil? Or do we have to remove attributes here?
        CFAttributedStringSetAttributes(attrString, cfRange(for: range), attrs.map { .fromAttributes($0) }, false)
    }

    public mutating func addAttribute(_ name: Key, value: AttributesDictionary.Value, range: Range<Index>) {
        _attrString.copyIfNeeded()
        CFAttributedStringSetAttribute(attrString, cfRange(for: range), name.rawValue as CFString, value as CFTypeRef)
    }

    public mutating func addAttributes(_ attrs: AttributesDictionary = [:], range: Range<Index>) {
        _attrString.copyIfNeeded()
        CFAttributedStringSetAttributes(attrString, cfRange(for: range), .fromAttributes(attrs), false)
    }

    public mutating func removeAttribute(_ name: Key, range: Range<Index>) {
        _attrString.copyIfNeeded()
        CFAttributedStringRemoveAttribute(attrString, cfRange(for: range), name.rawValue as CFString)
    }

    public mutating func replaceCharacters(in range: Range<Index>, with attrString: AttributedString) {
        _attrString.copyIfNeeded()
        CFAttributedStringReplaceAttributedString(self.attrString, cfRange(for: range), attrString.attrString)
    }

    public mutating func insert(_ attrString: AttributedString, at loc: Index) {
        replaceCharacters(in: loc..<loc, with: attrString)
    }

    public mutating func append(_ attrString: AttributedString) {
        insert(attrString, at: endIndex)
    }

    public mutating func deleteCharacters(in range: Range<Index>) {
        replaceCharacters(in: range, with: "")
    }

    public mutating func setAttributedString(_ attrString: AttributedString) {
        // We copy the wrapper since it would otherwise trigger a copy instantly.
        _attrString = attrString._attrString
    }

    public mutating func beginEditing() {
        _attrString.copyIfNeeded()
        CFAttributedStringBeginEditing(attrString)
    }

    public mutating func endEditing() {
        _attrString.copyIfNeeded()
        CFAttributedStringEndEditing(attrString)
    }
}

extension AttributedString {
    public var description: String {
        var attributes = AttributesDictionary()
        enumerateAttributes(in: startIndex..<endIndex) { attr, _, _ in
            attributes += attr
        }
        return """
        \(AttributedString.self): {
            string: \(string)
            attributes: \(attributes)
        }
        """
    }

    public var debugDescription: String {
        return CFCopyTypeIDDescription(CFGetTypeID(attrString)) as String
    }
}

extension AttributedString {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(CFHash(attrString))
    }

    public static func ==(lhs: AttributedString, rhs: AttributedString) -> Bool {
        return CFEqual(lhs.attrString, rhs.attrString)
    }
}

extension AttributedString {
    public typealias _ObjectiveCType = NSAttributedString

    @_semantics("convertToObjectiveC")
    public func _bridgeToObjectiveC() -> NSAttributedString {
        return CFAttributedStringCreateCopy(kCFAllocatorDefault, attrString) as NSAttributedString
    }

    public static func _forceBridgeFromObjectiveC(_ source: NSAttributedString, result: inout AttributedString?) {
        result = AttributedString(attrString: CFAttributedStringCreateMutableCopy(kCFAllocatorDefault, 0, source as CFAttributedString))
    }

    @discardableResult
    public static func _conditionallyBridgeFromObjectiveC(_ source: NSAttributedString, result: inout AttributedString?) -> Bool {
        _forceBridgeFromObjectiveC(source, result: &result)
        return result != nil
    }

    @_effects(readonly)
    public static func _unconditionallyBridgeFromObjectiveC(_ source: NSAttributedString?) -> AttributedString {
        var result: AttributedString? = nil
        _forceBridgeFromObjectiveC(source!, result: &result)
        return result!
    }
}

fileprivate extension CFRange {
    @inline(__always)
    var nsRange: NSRange {
        return NSRange(location: location, length: length)
    }

    @inline(__always)
    init(_ nsRange: NSRange) {
        self.init(location: nsRange.location, length: nsRange.length)
    }
}

fileprivate extension CFDictionary {
    static func fromAttributes(_ attrs: AttributedString.AttributesDictionary) -> CFDictionary {
        return NSDictionary(objects: Array(attrs.values),
                            forKeys: attrs.keys.map { $0.rawValue as NSString }) as CFDictionary
    }

    func toAttributesDictionary() -> AttributedString.AttributesDictionary {
        // Casting to NSDictionary is fine since it's basically an `unsafeBitCast`.
        let nsDict = self as NSDictionary
        var result = AttributedString.AttributesDictionary(minimumCapacity: nsDict.count)
        // We could use `reduce` here, but it would likely (unnecessarily) bridge the NSDictionary into Swift.Dictionary
        nsDict.enumerateKeysAndObjects { (key, object, _) in
            guard let strKey = key as? String else { return }
            result[AttributedString.Key(strKey)] = object
        }
        return result
    }
}

fileprivate extension String {
    func cfIndex(for index: Index) -> CFIndex {
        return distance(from: startIndex, to: index)
    }
}
#endif

//#if canImport(UIKit)
//import UIKit

//extension UILabel {
//    var attributedString: AttributedString? {
//        get { attributedText as AttributedString? }
//        set { attributedText = newValue as NSAttributedString? }
//    }
//}
//#endif

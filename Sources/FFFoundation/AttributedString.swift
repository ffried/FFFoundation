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

//#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import Foundation
import CoreFoundation

public struct AttributedString: ReferenceConvertible {
    public typealias ReferenceType = NSAttributedString
    public typealias EnumerationOptions = ReferenceType.EnumerationOptions
    public typealias AttributesDictionary = ReferenceType.AttributesDictionary
    public typealias Key = ReferenceType.Key
    public typealias Index = String.Index

    private var _attrString: CFMutableAttributedString
    private var attrString: CFMutableAttributedString {
        get { return _attrString }
        set {
            if !isKnownUniquelyReferenced(&_attrString) {
                _attrString = CFAttributedStringCreateMutableCopy(kCFAllocatorDefault, 0, newValue)
            } else {
                _attrString = newValue
            }
        }
    }

    public var string: String { return CFAttributedStringGetString(attrString) as String }
    public var length: Int { return CFAttributedStringGetLength(attrString) }

    public var startIndex: Index { return string.startIndex }
    public var endIndex: Index { return string.endIndex }

    fileprivate init(attrString: CFMutableAttributedString) {
        _attrString = attrString
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
        CFAttributedStringSetAttributes(attrString, CFRange(location: 0, length: length), attributes as CFDictionary, true)
    }
}

public extension AttributedString {
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
            let rangeInfo = RangeInfo(
                rangePointer: &_nsRange,
                longestEffectiveRangeSearchRange: longestEffectiveRangeSearchRange.map { NSRange($0, in: string) })
            return try work(rangeInfo)
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
        return RangeInfo.withInfo(to: &range, in: str, longestEffectiveRangeSearchRange: rangeLimit) { _attributes(at: str.cfIndex(for: location), rangeInfo: $0) }
    }

    public func attribute(_ attrName: Key, at location: Index, longestEffectiveRange range: inout Range<Index>?, in rangeLimit: Range<Index>) -> Any? {
        let str = string
        return RangeInfo.withInfo(to: &range, in: str, longestEffectiveRangeSearchRange: rangeLimit) { _attribute(attrName, atIndex: str.cfIndex(for: location), rangeInfo: $0) }
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

public extension AttributedString {
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

public extension AttributedString {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(CFHash(attrString))
    }

    public static func ==(lhs: AttributedString, rhs: AttributedString) -> Bool {
        return CFEqual(lhs.attrString, rhs.attrString)
    }
}

public extension AttributedString {
    public typealias _ObjectiveCType = NSAttributedString

    public func _bridgeToObjectiveC() -> NSAttributedString {
        return CFAttributedStringCreateCopy(kCFAllocatorDefault, attrString) as NSAttributedString
    }

    public static func _forceBridgeFromObjectiveC(_ source: NSAttributedString, result: inout AttributedString?) {
        result = AttributedString(attrString: CFAttributedStringCreateMutableCopy(kCFAllocatorDefault, 0, source as CFAttributedString))
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: NSAttributedString, result: inout AttributedString?) -> Bool {
        _forceBridgeFromObjectiveC(source, result: &result)
        return result != nil
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: NSAttributedString?) -> AttributedString {
        var result: AttributedString? = nil
        _forceBridgeFromObjectiveC(source!, result: &result)
        return result!
    }
}

fileprivate extension CFRange {
    var nsRange: NSRange {
        return NSRange(location: location, length: length)
    }

    init(_ nsRange: NSRange) {
        self.init(location: nsRange.location, length: nsRange.length)
    }
}

fileprivate extension CFDictionary {
    func toAttributesDictionary() -> AttributedString.AttributesDictionary {
        return (self as NSDictionary).reduce(into: [:]) {
            guard let key = $1.key as? String else { return }
            $0[AttributedString.Key(key)] = $1.value
        }
    }
}

fileprivate extension String {
    func cfIndex(for index: Index) -> Int {
        return distance(from: startIndex, to: index)
    }
}

//#endif

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
    public typealias AttributesDictionary = ReferenceType.AttributesDictionary
    public typealias EnumerationOptions = ReferenceType.EnumerationOptions

    public let string: String
    private var _attrString: CFAttributedString

    public var hashValue: Int {
        return string.hashValue
    }

    public var description: String {
        var range = CFRange(location: 0, length: CFAttributedStringGetLength(_attrString))
        let attrs = CFAttributedStringGetAttributes(_attrString, 0, &range)
        return "AttributedString: " + String(describing: attrs)
    }

    public var debugDescription: String {
        var range = CFRange(location: 0, length: CFAttributedStringGetLength(_attrString))
        let attrs = CFAttributedStringGetAttributes(_attrString, 0, &range)
        return "AttributedString: " + String(describing: attrs)
    }

    public static func ==(lhs: AttributedString, rhs: AttributedString) -> Bool {
        return lhs.string == rhs.string
    }
}

public extension AttributedString {
    public typealias _ObjectiveCType = NSAttributedString

    public func _bridgeToObjectiveC() -> NSAttributedString {
        return NSAttributedString(string: string, attributes: attributes)
    }

    public static func _forceBridgeFromObjectiveC(_ source: NSAttributedString, result: inout AttributedString?) {
        result = AttributedString(string: source.string, attributes: [:])
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: NSAttributedString, result: inout AttributedString?) -> Bool {
        result = AttributedString(string: source.string, attributes: [:])
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: NSAttributedString?) -> AttributedString {
        return AttributedString(string: source?.string ?? "", attributes: [:])
    }
}

//#endif


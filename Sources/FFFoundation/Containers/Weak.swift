//
//  Weak.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 22.08.17.
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

@propertyWrapper
public struct Weak<Object: AnyObject> {
    public weak var wrappedValue: Object?

    @inlinable
    public var wasReleased: Bool { wrappedValue == nil }

    public init(object: Object) {
        wrappedValue = object
    }

    public init(wrappedValue: Object?) {
        self.wrappedValue = wrappedValue
    }
}

extension Sequence {
    @inlinable
    public func nonReleasedObjects<Object>() -> [Object] where Element == Weak<Object> {
        compactMap(\.wrappedValue)
    }
}

extension MutableCollection where Self: RangeReplaceableCollection {
    public mutating func removeReleasedObjects<Object>() where Element == Weak<Object> {
        removeAll(where: \.wasReleased)
    }
    
    public mutating func appendWeakly<Object>(_ object: Object) where Element == Weak<Object> {
        append(.init(object: object))
    }
}

// MARK: - Property Wrappers
extension Weak where Object: ExpressibleByNilLiteral {
    @inlinable
    public init() { self.init(object: nil) }
}

// MARK: - Conditional Conformances
extension Weak: Equatable where Object: Equatable {
    public static func ==(lhs: Weak, rhs: Weak) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Weak: Hashable where Object: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

//extension Weak: Comparable where Object: Comparable {
//    public static func <(lhs: Weak, rhs: Weak) -> Bool {
//        lhs.wrappedValue < rhs.wrappedValue
//    }
//}

extension Weak: Encodable where Object: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension Weak: Decodable where Object: Decodable {
    public init(from decoder: Decoder) throws {
        try self.init(object: Object(from: decoder))
    }
}

extension Weak: ExpressibleByNilLiteral where Object: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(object: Object(nilLiteral: nilLiteral))
    }
}

extension Weak: ExpressibleByBooleanLiteral where Object: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Object.BooleanLiteralType) {
        self.init(object: Object(booleanLiteral: value))
    }
}

extension Weak: ExpressibleByIntegerLiteral where Object: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Object.IntegerLiteralType) {
        self.init(object: Object(integerLiteral: value))
    }
}

extension Weak: ExpressibleByFloatLiteral where Object: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Object.FloatLiteralType) {
        self.init(object: Object(floatLiteral: value))
    }
}

extension Weak: ExpressibleByUnicodeScalarLiteral where Object: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Object.UnicodeScalarLiteralType) {
        self.init(object: Object(unicodeScalarLiteral: value))
    }
}

extension Weak: ExpressibleByExtendedGraphemeClusterLiteral where Object: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: Object.ExtendedGraphemeClusterLiteralType) {
        self.init(object: Object(extendedGraphemeClusterLiteral: value))
    }
}

extension Weak: ExpressibleByStringLiteral where Object: ExpressibleByStringLiteral {
    public init(stringLiteral value: Object.StringLiteralType) {
        self.init(object: Object(stringLiteral: value))
    }
}

extension Weak: ExpressibleByStringInterpolation where Object: ExpressibleByStringInterpolation {
    public init(stringInterpolation: Object.StringInterpolation) {
        self.init(object: Object(stringInterpolation: stringInterpolation))
    }
}

#if compiler(>=5.5.2) && canImport(_Concurrency)
extension Weak: Sendable where Object: Sendable {}
#endif

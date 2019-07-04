//
//  CoW.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 09.06.19.
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

public protocol Copyable: AnyObject {
    func copy() -> Self
}

@propertyWrapper
public struct CoW<Value: Copyable> {
    private var _wrappedValue: Value

    public var wrappedValue: Value {
        get { return _wrappedValue }
        set {
            _wrappedValue = newValue
            if !isKnownUniquelyReferenced(&_wrappedValue) {
                _wrappedValue = _wrappedValue.copy()
            }
        }
    }

    public var projectedValue: Value {
        get { return wrappedValue }
        set { wrappedValue = newValue }
    }

    public init(initialValue: Value) {
        _wrappedValue = initialValue
    }
}

extension CoW where Value: ExpressibleByNilLiteral {
    @inlinable
    public init() { self.init(initialValue: nil) }
}

// MARK: - Conditional Conformances
extension CoW: Equatable where Value: Equatable {
    public static func ==(lhs: CoW, rhs: CoW) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

extension CoW: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension CoW: Comparable where Value: Comparable {
    public static func <(lhs: CoW, rhs: CoW) -> Bool {
        return lhs.wrappedValue < rhs.wrappedValue
    }
}

extension CoW: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension CoW: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        try self.init(initialValue: Value(from: decoder))
    }
}

extension CoW: ExpressibleByNilLiteral where Value: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(initialValue: Value(nilLiteral: nilLiteral))
    }
}

extension CoW: ExpressibleByBooleanLiteral where Value: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Value.BooleanLiteralType) {
        self.init(initialValue: Value(booleanLiteral: value))
    }
}

extension CoW: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(initialValue: Value(integerLiteral: value))
    }
}

extension CoW: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Value.FloatLiteralType) {
        self.init(initialValue: Value(floatLiteral: value))
    }
}

extension CoW: ExpressibleByUnicodeScalarLiteral where Value: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Value.UnicodeScalarLiteralType) {
        self.init(initialValue: Value(unicodeScalarLiteral: value))
    }
}

extension CoW: ExpressibleByExtendedGraphemeClusterLiteral where Value: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: Value.ExtendedGraphemeClusterLiteralType) {
        self.init(initialValue: Value(extendedGraphemeClusterLiteral: value))
    }
}

extension CoW: ExpressibleByStringLiteral where Value: ExpressibleByStringLiteral {
    public init(stringLiteral value: Value.StringLiteralType) {
        self.init(initialValue: Value(stringLiteral: value))
    }
}

extension CoW: ExpressibleByStringInterpolation where Value: ExpressibleByStringInterpolation {
    public init(stringInterpolation: Value.StringInterpolation) {
        self.init(initialValue: Value(stringInterpolation: stringInterpolation))
    }
}


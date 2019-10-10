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
public struct CoW<Value: AnyObject> {
    public typealias Copier = (Value) -> Value

    private let copier: Copier

    private var _wrappedValue: Value
    public var wrappedValue: Value {
        get { _wrappedValue }
        set {
            _wrappedValue = newValue
            copyIfNeeded()
        }
    }

    public init(wrappedValue: Value, copyingWith copier: @escaping Copier) {
        _wrappedValue = wrappedValue
        self.copier = copier
        copyIfNeeded()
    }

    public mutating func copyIfNeeded() {
        if !isKnownUniquelyReferenced(&_wrappedValue) {
            _wrappedValue = copier(_wrappedValue)
        }
    }
}

extension CoW where Value: Copyable {
    @inlinable
    public init(wrappedValue: Value) { self.init(wrappedValue: wrappedValue, copyingWith: { $0.copy() }) }
}

extension CoW where Value: ExpressibleByNilLiteral {
    @inlinable
    public init(copyingWith copier: @escaping Copier) { self.init(wrappedValue: nil, copyingWith: copier) }
}

extension CoW where Value: Copyable, Value: ExpressibleByNilLiteral {
    @inlinable
    public init() { self.init(wrappedValue: nil) }
}

// MARK: - Conditional Conformances
extension CoW: Equatable where Value: Equatable {
    public static func ==(lhs: CoW, rhs: CoW) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension CoW: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension CoW: Comparable where Value: Comparable {
    public static func <(lhs: CoW, rhs: CoW) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }
}

extension CoW: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension CoW: Decodable where Value: Decodable, Value: Copyable {
    public init(from decoder: Decoder) throws {
        try self.init(wrappedValue: Value(from: decoder))
    }
}

extension CoW: ExpressibleByNilLiteral where Value: ExpressibleByNilLiteral, Value: Copyable {
    public init(nilLiteral: ()) {
        self.init(wrappedValue: Value(nilLiteral: nilLiteral))
    }
}

extension CoW: ExpressibleByBooleanLiteral where Value: ExpressibleByBooleanLiteral, Value: Copyable {
    public init(booleanLiteral value: Value.BooleanLiteralType) {
        self.init(wrappedValue: Value(booleanLiteral: value))
    }
}

extension CoW: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral, Value: Copyable {
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(wrappedValue: Value(integerLiteral: value))
    }
}

extension CoW: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral, Value: Copyable {
    public init(floatLiteral value: Value.FloatLiteralType) {
        self.init(wrappedValue: Value(floatLiteral: value))
    }
}

extension CoW: ExpressibleByUnicodeScalarLiteral where Value: ExpressibleByUnicodeScalarLiteral, Value: Copyable {
    public init(unicodeScalarLiteral value: Value.UnicodeScalarLiteralType) {
        self.init(wrappedValue: Value(unicodeScalarLiteral: value))
    }
}

extension CoW: ExpressibleByExtendedGraphemeClusterLiteral where Value: ExpressibleByExtendedGraphemeClusterLiteral, Value: Copyable {
    public init(extendedGraphemeClusterLiteral value: Value.ExtendedGraphemeClusterLiteralType) {
        self.init(wrappedValue: Value(extendedGraphemeClusterLiteral: value))
    }
}

extension CoW: ExpressibleByStringLiteral where Value: ExpressibleByStringLiteral, Value: Copyable {
    public init(stringLiteral value: Value.StringLiteralType) {
        self.init(wrappedValue: Value(stringLiteral: value))
    }
}

extension CoW: ExpressibleByStringInterpolation where Value: ExpressibleByStringInterpolation, Value: Copyable {
    public init(stringInterpolation: Value.StringInterpolation) {
        self.init(wrappedValue: Value(stringInterpolation: stringInterpolation))
    }
}

//
//  Ref.swift
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

@propertyWrapper
public final class Ref<Referenced>: Copyable {
    public var wrappedValue: Referenced

    public var projectedValue: Lens<Referenced> {
        Lens(getter: { self.wrappedValue },
             setter: { self.wrappedValue = $0 })
    }

    public init(wrappedValue: Referenced) {
        self.wrappedValue = wrappedValue
    }

    @inlinable
    public convenience init(initialValue: Referenced) {
        self.init(wrappedValue: initialValue)
    }

    @inlinable
    public func copy() -> Self {
        return .init(wrappedValue: wrappedValue)
    }
}

extension Ref where Referenced: ExpressibleByNilLiteral {
    @inlinable
    public convenience init() { self.init(wrappedValue: nil) }
}

// MARK: - Conditional Conformances
extension Ref: Equatable where Referenced: Equatable {
    public static func ==(lhs: Ref, rhs: Ref) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Ref: Hashable where Referenced: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension Ref: Comparable where Referenced: Comparable {
    public static func <(lhs: Ref, rhs: Ref) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }
}

extension Ref: Encodable where Referenced: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension Ref: Decodable where Referenced: Decodable {
    public convenience init(from decoder: Decoder) throws {
        let value = try Referenced(from: decoder)
        self.init(wrappedValue: value)
    }
}

extension Ref: ExpressibleByNilLiteral where Referenced: ExpressibleByNilLiteral {
    public convenience init(nilLiteral: ()) {
        self.init(wrappedValue: Referenced(nilLiteral: nilLiteral))
    }
}

extension Ref: ExpressibleByBooleanLiteral where Referenced: ExpressibleByBooleanLiteral {
    public convenience init(booleanLiteral value: Referenced.BooleanLiteralType) {
        self.init(wrappedValue: Referenced(booleanLiteral: value))
    }
}

extension Ref: ExpressibleByIntegerLiteral where Referenced: ExpressibleByIntegerLiteral {
    public convenience init(integerLiteral value: Referenced.IntegerLiteralType) {
        self.init(wrappedValue: Referenced(integerLiteral: value))
    }
}

extension Ref: ExpressibleByFloatLiteral where Referenced: ExpressibleByFloatLiteral {
    public convenience init(floatLiteral value: Referenced.FloatLiteralType) {
        self.init(wrappedValue: Referenced(floatLiteral: value))
    }
}

extension Ref: ExpressibleByUnicodeScalarLiteral where Referenced: ExpressibleByUnicodeScalarLiteral {
    public convenience init(unicodeScalarLiteral value: Referenced.UnicodeScalarLiteralType) {
        self.init(wrappedValue: Referenced(unicodeScalarLiteral: value))
    }
}

extension Ref: ExpressibleByExtendedGraphemeClusterLiteral where Referenced: ExpressibleByExtendedGraphemeClusterLiteral {
    public convenience init(extendedGraphemeClusterLiteral value: Referenced.ExtendedGraphemeClusterLiteralType) {
        self.init(wrappedValue: Referenced(extendedGraphemeClusterLiteral: value))
    }
}

extension Ref: ExpressibleByStringLiteral where Referenced: ExpressibleByStringLiteral {
    public convenience init(stringLiteral value: Referenced.StringLiteralType) {
        self.init(wrappedValue: Referenced(stringLiteral: value))
    }
}

extension Ref: ExpressibleByStringInterpolation where Referenced: ExpressibleByStringInterpolation {
    public convenience init(stringInterpolation: Referenced.StringInterpolation) {
        self.init(wrappedValue: Referenced(stringInterpolation: stringInterpolation))
    }
}

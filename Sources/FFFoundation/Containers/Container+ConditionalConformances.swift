//
//  Container+ConditionalConformances.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 24.08.18.
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

extension Container where Self: Equatable, Value: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Container where Self: Hashable, Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension Container where Self: Comparable, Value: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Container where Self: Encodable, Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

extension Container where Self: Decodable, Value: Decodable {
    public init(from decoder: Decoder) throws {
        try self.init(value: Value(from: decoder))
    }
}

extension Container where Self: ExpressibleByNilLiteral, Value: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(value: Value(nilLiteral: nilLiteral))
    }
}

extension Container where Self: ExpressibleByBooleanLiteral, Value: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = Value.BooleanLiteralType
}
extension Container where Self: ExpressibleByBooleanLiteral, Value: ExpressibleByBooleanLiteral, Self.BooleanLiteralType == Value.BooleanLiteralType {
    public init(booleanLiteral: BooleanLiteralType) {
        self.init(value: Value(booleanLiteral: booleanLiteral))
    }
}

extension Container where Self: ExpressibleByIntegerLiteral, Value: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Value.IntegerLiteralType
}
extension Container where Self: ExpressibleByIntegerLiteral, Value: ExpressibleByIntegerLiteral, Self.IntegerLiteralType == Value.IntegerLiteralType {
    public init(integerLiteral: IntegerLiteralType) {
        self.init(value: Value(integerLiteral: integerLiteral))
    }
}

extension Container where Self: ExpressibleByFloatLiteral, Value: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Value.FloatLiteralType
}
extension Container where Self: ExpressibleByFloatLiteral, Value: ExpressibleByFloatLiteral, Self.FloatLiteralType == Value.FloatLiteralType {
    public init(floatLiteral: FloatLiteralType) {
        self.init(value: Value(floatLiteral: floatLiteral))
    }
}

extension Container where Self: ExpressibleByUnicodeScalarLiteral, Value: ExpressibleByUnicodeScalarLiteral {
    public typealias UnicodeScalarLiteralType = Value.UnicodeScalarLiteralType
}
extension Container where Self: ExpressibleByUnicodeScalarLiteral, Value: ExpressibleByUnicodeScalarLiteral, Self.UnicodeScalarLiteralType == Value.UnicodeScalarLiteralType {
    public init(unicodeScalarLiteral: UnicodeScalarLiteralType) {
        self.init(value: Value(unicodeScalarLiteral: unicodeScalarLiteral))
    }
}

extension Container where Self: ExpressibleByExtendedGraphemeClusterLiteral, Value: ExpressibleByExtendedGraphemeClusterLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = Value.ExtendedGraphemeClusterLiteralType
}
extension Container where Self: ExpressibleByExtendedGraphemeClusterLiteral, Value: ExpressibleByExtendedGraphemeClusterLiteral, Self.ExtendedGraphemeClusterLiteralType == Value.ExtendedGraphemeClusterLiteralType {
    public init(extendedGraphemeClusterLiteral: ExtendedGraphemeClusterLiteralType) {
        self.init(value: Value(extendedGraphemeClusterLiteral: extendedGraphemeClusterLiteral))
    }
}

extension Container where Self: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral {
    public typealias StringLiteralType = Value.StringLiteralType
}
extension Container where Self: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral, Self.StringLiteralType == Value.StringLiteralType {
    public init(stringLiteral: StringLiteralType) {
        self.init(value: Value(stringLiteral: stringLiteral))
    }
}

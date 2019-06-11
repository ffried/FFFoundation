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
public final class Ref<Referenced> {
    public var value: Referenced

    public init(initialValue: Referenced) {
        value = initialValue
    }
}

extension Ref where Referenced: ExpressibleByNilLiteral {
    @inlinable
    public convenience init() { self.init(initialValue: nil) }
}

// MARK: - Conditional Conformances
extension Ref: Equatable where Referenced: Equatable {
    public static func ==(lhs: Ref, rhs: Ref) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Ref: Hashable where Referenced: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension Ref: Comparable where Referenced: Comparable {
    public static func <(lhs: Ref, rhs: Ref) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Ref: Encodable where Referenced: Encodable {
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

extension Ref: Decodable where Referenced: Decodable {
    public convenience init(from decoder: Decoder) throws {
        let value = try Referenced(from: decoder)
        self.init(initialValue: value)
    }
}

extension Ref: ExpressibleByNilLiteral where Referenced: ExpressibleByNilLiteral {
    public convenience init(nilLiteral: ()) {
        self.init(initialValue: Referenced(nilLiteral: nilLiteral))
    }
}

extension Ref: ExpressibleByBooleanLiteral where Referenced: ExpressibleByBooleanLiteral {
    public convenience init(booleanLiteral value: Referenced.BooleanLiteralType) {
        self.init(initialValue: Referenced(booleanLiteral: value))
    }
}

extension Ref: ExpressibleByIntegerLiteral where Referenced: ExpressibleByIntegerLiteral {
    public convenience init(integerLiteral value: Referenced.IntegerLiteralType) {
        self.init(initialValue: Referenced(integerLiteral: value))
    }
}

extension Ref: ExpressibleByFloatLiteral where Referenced: ExpressibleByFloatLiteral {
    public convenience init(floatLiteral value: Referenced.FloatLiteralType) {
        self.init(initialValue: Referenced(floatLiteral: value))
    }
}

extension Ref: ExpressibleByUnicodeScalarLiteral where Referenced: ExpressibleByUnicodeScalarLiteral {
    public convenience init(unicodeScalarLiteral value: Referenced.UnicodeScalarLiteralType) {
        self.init(initialValue: Referenced(unicodeScalarLiteral: value))
    }
}

extension Ref: ExpressibleByExtendedGraphemeClusterLiteral where Referenced: ExpressibleByExtendedGraphemeClusterLiteral {
    public convenience init(extendedGraphemeClusterLiteral value: Referenced.ExtendedGraphemeClusterLiteralType) {
        self.init(initialValue: Referenced(extendedGraphemeClusterLiteral: value))
    }
}

extension Ref: ExpressibleByStringLiteral where Referenced: ExpressibleByStringLiteral {
    public convenience init(stringLiteral value: Referenced.StringLiteralType) {
        self.init(initialValue: Referenced(stringLiteral: value))
    }
}

extension Ref: ExpressibleByStringInterpolation where Referenced: ExpressibleByStringInterpolation {
    public convenience init(stringInterpolation: Referenced.StringInterpolation) {
        self.init(initialValue: Referenced(stringInterpolation: stringInterpolation))
    }
}

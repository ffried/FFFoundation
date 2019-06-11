//
//  Lazy.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 26/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
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
public struct Lazy<Deferred> {
    private let constructor: () -> Deferred

    @CoW private var _value: Deferred? = nil

    public var value: Deferred {
        get {
            if let val = _value { return val }
            $_value.updateIgnoringCoW(with: constructor())
            return self.value
        }
        set {
            _value = newValue
        }
    }

    private init(_constructor: @escaping () -> Deferred) {
        constructor = _constructor
    }

    public init(initialValue constructor: @escaping @autoclosure () -> Deferred) {
        self.init(_constructor: constructor)
    }
    
    public init(other: Lazy) {
        self.init(_constructor: other.constructor)
    }
    
    public mutating func reset() {
        _value = nil
    }
}

// MARK: - Property Wrappers
extension Lazy where Deferred: ExpressibleByNilLiteral {
    @inlinable
    public init() { self.init(initialValue: nil) }
}

// MARK: - Conditional Conformance
extension Lazy: Equatable where Deferred: Equatable {
    public static func ==(lhs: Lazy, rhs: Lazy) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Lazy: Hashable where Deferred: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension Lazy: Comparable where Deferred: Comparable {
    public static func <(lhs: Lazy, rhs: Lazy) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Lazy: Encodable where Deferred: Encodable {
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

extension Lazy: Decodable where Deferred: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try Deferred(from: decoder)
        self.init(initialValue: value)
    }
}

extension Lazy: ExpressibleByNilLiteral where Deferred: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(initialValue: Deferred(nilLiteral: nilLiteral))
    }
}

extension Lazy: ExpressibleByBooleanLiteral where Deferred: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Deferred.BooleanLiteralType) {
        self.init(initialValue: Deferred(booleanLiteral: value))
    }
}

extension Lazy: ExpressibleByIntegerLiteral where Deferred: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Deferred.IntegerLiteralType) {
        self.init(initialValue: Deferred(integerLiteral: value))
    }
}

extension Lazy: ExpressibleByFloatLiteral where Deferred: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Deferred.FloatLiteralType) {
        self.init(initialValue: Deferred(floatLiteral: value))
    }
}

extension Lazy: ExpressibleByUnicodeScalarLiteral where Deferred: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Deferred.UnicodeScalarLiteralType) {
        self.init(initialValue: Deferred(unicodeScalarLiteral: value))
    }
}

extension Lazy: ExpressibleByExtendedGraphemeClusterLiteral where Deferred: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: Deferred.ExtendedGraphemeClusterLiteralType) {
        self.init(initialValue: Deferred(extendedGraphemeClusterLiteral: value))
    }
}

extension Lazy: ExpressibleByStringLiteral where Deferred: ExpressibleByStringLiteral {
    public init(stringLiteral value: Deferred.StringLiteralType) {
        self.init(initialValue: Deferred(stringLiteral: value))
    }
}

extension Lazy: ExpressibleByStringInterpolation where Deferred: ExpressibleByStringInterpolation {
    public init(stringInterpolation: Deferred.StringInterpolation) {
        self.init(initialValue: Deferred(stringInterpolation: stringInterpolation))
    }
}

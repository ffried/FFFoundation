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

    @CoW private var _wrappedValue: Ref<Deferred?> = .init()

    public var wrappedValue: Deferred {
        get {
            if let val = _wrappedValue.wrappedValue { return val }
            _wrappedValue.wrappedValue = constructor()
            return self.wrappedValue
        }
        set {
            __wrappedValue.copyIfNeeded()
            _wrappedValue.wrappedValue = newValue
        }
    }

    public init(constructor: @escaping () -> Deferred) {
        self.constructor = constructor
    }

    @inlinable
    public init(wrappedValue constructor: @escaping @autoclosure () -> Deferred) {
        self.init(constructor: constructor)
    }

    public init(other: Lazy) {
        self.init(constructor: other.constructor)
    }
    
    public mutating func reset() {
        _wrappedValue = nil
    }
}

// MARK: - Property Wrappers
extension Lazy where Deferred: ExpressibleByNilLiteral {
    @inlinable
    public init() { self.init(wrappedValue: nil) }
}

// MARK: - Conditional Conformance
extension Lazy: Equatable where Deferred: Equatable {
    public static func ==(lhs: Lazy, rhs: Lazy) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Lazy: Hashable where Deferred: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension Lazy: Comparable where Deferred: Comparable {
    public static func <(lhs: Lazy, rhs: Lazy) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }
}

extension Lazy: Encodable where Deferred: Encodable {
    public func encode(to encoder: any Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension Lazy: Decodable where Deferred: Decodable {
    public init(from decoder: any Decoder) throws {
        let value = try Deferred(from: decoder)
        self.init(wrappedValue: value)
    }
}

extension Lazy: ExpressibleByNilLiteral where Deferred: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(wrappedValue: Deferred(nilLiteral: nilLiteral))
    }
}

extension Lazy: ExpressibleByBooleanLiteral where Deferred: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Deferred.BooleanLiteralType) {
        self.init(wrappedValue: Deferred(booleanLiteral: value))
    }
}

extension Lazy: ExpressibleByIntegerLiteral where Deferred: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Deferred.IntegerLiteralType) {
        self.init(wrappedValue: Deferred(integerLiteral: value))
    }
}

extension Lazy: ExpressibleByFloatLiteral where Deferred: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Deferred.FloatLiteralType) {
        self.init(wrappedValue: Deferred(floatLiteral: value))
    }
}

extension Lazy: ExpressibleByUnicodeScalarLiteral where Deferred: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Deferred.UnicodeScalarLiteralType) {
        self.init(wrappedValue: Deferred(unicodeScalarLiteral: value))
    }
}

extension Lazy: ExpressibleByExtendedGraphemeClusterLiteral where Deferred: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: Deferred.ExtendedGraphemeClusterLiteralType) {
        self.init(wrappedValue: Deferred(extendedGraphemeClusterLiteral: value))
    }
}

extension Lazy: ExpressibleByStringLiteral where Deferred: ExpressibleByStringLiteral {
    public init(stringLiteral value: Deferred.StringLiteralType) {
        self.init(wrappedValue: Deferred(stringLiteral: value))
    }
}

extension Lazy: ExpressibleByStringInterpolation where Deferred: ExpressibleByStringInterpolation {
    public init(stringInterpolation: Deferred.StringInterpolation) {
        self.init(wrappedValue: Deferred(stringInterpolation: stringInterpolation))
    }
}

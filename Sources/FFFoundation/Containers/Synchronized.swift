//
//  Synchronized.swift
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

import Dispatch

@propertyWrapper
public final class Synchronized<Guarded> {
    private var _wrappedValue: Guarded
    private let queue: DispatchQueue

    public var wrappedValue: Guarded {
        dispatchPrecondition(condition: .notOnQueue(queue))
        return queue.sync { _wrappedValue }
    }

    public init(value: Guarded, qos: DispatchQoS) {
        _wrappedValue = value
        queue = DispatchQueue(label: "net.ffried.containers.synchronized<\(String(describing: Guarded.self).lowercased())>.queue", qos: qos)
    }

    public convenience init(wrappedValue: Guarded) {
        self.init(value: wrappedValue, qos: .default)
    }

    public subscript<T>(keyPath: KeyPath<Guarded, T>) -> T {
        dispatchPrecondition(condition: .notOnQueue(queue))
        return queue.sync { _wrappedValue[keyPath: keyPath] }
    }

    @inline(__always)
    private func withMutableValue<T>(do work: (inout Guarded) throws -> T) rethrows -> T {
        dispatchPrecondition(condition: .onQueue(queue))
        return try work(&_wrappedValue)
    }

    public func withValue<T>(do work: (inout Guarded) throws -> T) rethrows -> T {
        dispatchPrecondition(condition: .notOnQueue(queue))
        return try queue.sync { try withMutableValue(do: work) }
    }

    @inlinable
    public func withValueVoid(do work: (inout Guarded) throws -> Void) rethrows {
        try withValue(do: work)
    }

    public func coordinated(with other: Synchronized) -> (Guarded, Guarded) {
        dispatchPrecondition(condition: .notOnQueue(queue))
        return queue.sync { (_wrappedValue, queue === other.queue ? other._wrappedValue : other.wrappedValue) }
    }

    public func coordinated<OtherGuarded>(with other: Synchronized<OtherGuarded>) -> (Guarded, OtherGuarded) {
        dispatchPrecondition(condition: .notOnQueue(queue))
        return queue.sync { (_wrappedValue, other.wrappedValue) }
    }

    public func combined(with other: Synchronized) -> Synchronized<(Guarded, Guarded)> {
        Synchronized<(Guarded, Guarded)>(value: coordinated(with: other), qos: max(queue.qos, other.queue.qos))
    }

    public func combined<OtherGuarded>(with other: Synchronized<OtherGuarded>) -> Synchronized<(Guarded, OtherGuarded)> {
        Synchronized<(Guarded, OtherGuarded)>(value: coordinated(with: other), qos: max(queue.qos, other.queue.qos))
    }

    @discardableResult
    @inlinable
    public func exchange(with newValue: Guarded) -> Guarded {
        withValue { curVal in
            defer { curVal = newValue }
            return curVal
        }
    }
}

// MARK: - Property Wrapper
extension Synchronized where Guarded: ExpressibleByNilLiteral {
    @inlinable
    public convenience init() { self.init(wrappedValue: nil) }
}

// MARK: - Conditional Conformances
extension Synchronized: Equatable where Guarded: Equatable {
    public static func ==(lhs: Synchronized, rhs: Synchronized) -> Bool {
        let coordinated = lhs.coordinated(with: rhs)
        return coordinated.0 == coordinated.1
    }
}

extension Synchronized: Hashable where Guarded: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension Synchronized: Comparable where Guarded: Comparable {
    public static func <(lhs: Synchronized, rhs: Synchronized) -> Bool {
        let coordinated = lhs.coordinated(with: rhs)
        return coordinated.0 < coordinated.1
    }
}

extension Synchronized: Encodable where Guarded: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension Synchronized: Decodable where Guarded: Decodable {
    public convenience init(from decoder: Decoder) throws {
        try self.init(wrappedValue: Guarded(from: decoder))
    }
}

extension Synchronized: ExpressibleByNilLiteral where Guarded: ExpressibleByNilLiteral {
    public convenience init(nilLiteral: ()) {
        self.init(wrappedValue: Guarded(nilLiteral: nilLiteral))
    }
}

extension Synchronized: ExpressibleByBooleanLiteral where Guarded: ExpressibleByBooleanLiteral {
    public convenience init(booleanLiteral value: Guarded.BooleanLiteralType) {
        self.init(wrappedValue: Guarded(booleanLiteral: value))
    }
}

extension Synchronized: ExpressibleByIntegerLiteral where Guarded: ExpressibleByIntegerLiteral {
    public convenience init(integerLiteral value: Guarded.IntegerLiteralType) {
        self.init(wrappedValue: Guarded(integerLiteral: value))
    }
}

extension Synchronized: ExpressibleByFloatLiteral where Guarded: ExpressibleByFloatLiteral {
    public convenience init(floatLiteral value: Guarded.FloatLiteralType) {
        self.init(wrappedValue: Guarded(floatLiteral: value))
    }
}

extension Synchronized: ExpressibleByUnicodeScalarLiteral where Guarded: ExpressibleByUnicodeScalarLiteral {
    public convenience init(unicodeScalarLiteral value: Guarded.UnicodeScalarLiteralType) {
        self.init(wrappedValue: Guarded(unicodeScalarLiteral: value))
    }
}

extension Synchronized: ExpressibleByExtendedGraphemeClusterLiteral where Guarded: ExpressibleByExtendedGraphemeClusterLiteral {
    public convenience init(extendedGraphemeClusterLiteral value: Guarded.ExtendedGraphemeClusterLiteralType) {
        self.init(wrappedValue: Guarded(extendedGraphemeClusterLiteral: value))
    }
}

extension Synchronized: ExpressibleByStringLiteral where Guarded: ExpressibleByStringLiteral {
    public convenience init(stringLiteral value: Guarded.StringLiteralType) {
        self.init(wrappedValue: Guarded(stringLiteral: value))
    }
}

extension Synchronized: ExpressibleByStringInterpolation where Guarded: ExpressibleByStringInterpolation {
    public convenience init(stringInterpolation: Guarded.StringInterpolation) {
        self.init(wrappedValue: Guarded(stringInterpolation: stringInterpolation))
    }
}

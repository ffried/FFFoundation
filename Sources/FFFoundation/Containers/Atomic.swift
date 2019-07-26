//
//  Atomic.swift
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
public final class Atomic<Guarded> {
    private var _wrappedValue: Guarded
    private let queue: DispatchQueue

    public var wrappedValue: Guarded {
        precondition(notOn: queue)
        return queue.sync { _wrappedValue }
    }

    public init(value: Guarded, qos: DispatchQoS) {
        _wrappedValue = value
        queue = DispatchQueue(label: "net.ffried.containers.atomic<\(String(describing: Guarded.self).lowercased())>.queue", qos: qos)
    }

    public convenience init(wrappedValue: Guarded) {
        self.init(value: wrappedValue, qos: .default)
    }

    @inlinable
    public convenience init(initialValue: Guarded) {
        self.init(wrappedValue: initialValue)
    }

    public subscript<T>(keyPath: KeyPath<Guarded, T>) -> T {
        precondition(notOn: queue)
        return queue.sync { _wrappedValue[keyPath: keyPath] }
    }

    public subscript<T>(keyPath: WritableKeyPath<Guarded, T>) -> T {
        get {
            precondition(notOn: queue)
            return queue.sync { _wrappedValue[keyPath: keyPath] }
        }
        set {
            precondition(notOn: queue)
            queue.sync { withMutableValue { $0[keyPath: keyPath] = newValue } }
        }
    }

    @inline(__always)
    private func withMutableValue<T>(do work: (inout Guarded) throws -> T) rethrows -> T {
        precondition(on: queue)
        return try work(&_wrappedValue)
    }

    public func withValue<T>(do work: (inout Guarded) throws -> T) rethrows -> T {
        precondition(notOn: queue)
        return try queue.sync { try withMutableValue(do: work) }
    }

    @inlinable
    public func withValueVoid(do work: (inout Guarded) throws -> Void) rethrows {
        try withValue(do: work)
    }

    public func coordinated(with other: Atomic) -> (Guarded, Guarded) {
        precondition(notOn: queue)
        return queue.sync { (_wrappedValue, queue === other.queue ? other._wrappedValue : other.wrappedValue) }
    }

    public func coordinated<OtherGuarded>(with other: Atomic<OtherGuarded>) -> (Guarded, OtherGuarded) {
        precondition(notOn: queue)
        return queue.sync { (_wrappedValue, other.wrappedValue) }
    }

    public func combined(with other: Atomic) -> Atomic<(Guarded, Guarded)> {
        Atomic<(Guarded, Guarded)>(value: coordinated(with: other), qos: max(queue.qos, other.queue.qos))
    }

    public func combined<OtherGuarded>(with other: Atomic<OtherGuarded>) -> Atomic<(Guarded, OtherGuarded)> {
        Atomic<(Guarded, OtherGuarded)>(value: coordinated(with: other), qos: max(queue.qos, other.queue.qos))
    }
}

// MARK: - Property Wrapper
extension Atomic where Guarded: ExpressibleByNilLiteral {
    @inlinable
    public convenience init() { self.init(wrappedValue: nil) }
}

// MARK: - Conditional Conformances
extension Atomic: Equatable where Guarded: Equatable {
    public static func ==(lhs: Atomic, rhs: Atomic) -> Bool {
        let coordinated = lhs.coordinated(with: rhs)
        return coordinated.0 == coordinated.1
    }
}

extension Atomic: Hashable where Guarded: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension Atomic: Comparable where Guarded: Comparable {
    public static func <(lhs: Atomic, rhs: Atomic) -> Bool {
        let coordinated = lhs.coordinated(with: rhs)
        return coordinated.0 < coordinated.1
    }
}

extension Atomic: Encodable where Guarded: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension Atomic: Decodable where Guarded: Decodable {
    public convenience init(from decoder: Decoder) throws {
        try self.init(wrappedValue: Guarded(from: decoder))
    }
}

extension Atomic: ExpressibleByNilLiteral where Guarded: ExpressibleByNilLiteral {
    public convenience init(nilLiteral: ()) {
        self.init(wrappedValue: Guarded(nilLiteral: nilLiteral))
    }
}

extension Atomic: ExpressibleByBooleanLiteral where Guarded: ExpressibleByBooleanLiteral {
    public convenience init(booleanLiteral value: Guarded.BooleanLiteralType) {
        self.init(wrappedValue: Guarded(booleanLiteral: value))
    }
}

extension Atomic: ExpressibleByIntegerLiteral where Guarded: ExpressibleByIntegerLiteral {
    public convenience init(integerLiteral value: Guarded.IntegerLiteralType) {
        self.init(wrappedValue: Guarded(integerLiteral: value))
    }
}

extension Atomic: ExpressibleByFloatLiteral where Guarded: ExpressibleByFloatLiteral {
    public convenience init(floatLiteral value: Guarded.FloatLiteralType) {
        self.init(wrappedValue: Guarded(floatLiteral: value))
    }
}

extension Atomic: ExpressibleByUnicodeScalarLiteral where Guarded: ExpressibleByUnicodeScalarLiteral {
    public convenience init(unicodeScalarLiteral value: Guarded.UnicodeScalarLiteralType) {
        self.init(wrappedValue: Guarded(unicodeScalarLiteral: value))
    }
}

extension Atomic: ExpressibleByExtendedGraphemeClusterLiteral where Guarded: ExpressibleByExtendedGraphemeClusterLiteral {
    public convenience init(extendedGraphemeClusterLiteral value: Guarded.ExtendedGraphemeClusterLiteralType) {
        self.init(wrappedValue: Guarded(extendedGraphemeClusterLiteral: value))
    }
}

extension Atomic: ExpressibleByStringLiteral where Guarded: ExpressibleByStringLiteral {
    public convenience init(stringLiteral value: Guarded.StringLiteralType) {
        self.init(wrappedValue: Guarded(stringLiteral: value))
    }
}

extension Atomic: ExpressibleByStringInterpolation where Guarded: ExpressibleByStringInterpolation {
    public convenience init(stringInterpolation: Guarded.StringInterpolation) {
        self.init(wrappedValue: Guarded(stringInterpolation: stringInterpolation))
    }
}

// MARK: - Helpers
@inline(__always)
private func precondition(notOn queue: DispatchQueue) {
    if #available(
        iOS 10.0, iOSApplicationExtension 10.0,
        macOS 10.12, macOSApplicationExtension 10.12,
        tvOS 10.0, tvOSApplicationExtension 10.0,
        watchOS 3.0, watchOSApplicationExtension 3.0,
        *) {
        dispatchPrecondition(condition: .notOnQueue(queue))
    }
}

@inline(__always)
private func precondition(on queue: DispatchQueue) {
    if #available(
        iOS 10.0, iOSApplicationExtension 10.0,
        macOS 10.12, macOSApplicationExtension 10.12,
        tvOS 10.0, tvOSApplicationExtension 10.0,
        watchOS 3.0, watchOSApplicationExtension 3.0,
        *) {
        dispatchPrecondition(condition: .onQueue(queue))
    }
}

@inline(__always)
private func precondition(onBarrier queue: DispatchQueue) {
    if #available(
        iOS 10.0, iOSApplicationExtension 10.0,
        macOS 10.12, macOSApplicationExtension 10.12,
        tvOS 10.0, tvOSApplicationExtension 10.0,
        watchOS 3.0, watchOSApplicationExtension 3.0,
        *) {
        dispatchPrecondition(condition: .onQueueAsBarrier(queue))
    }
}

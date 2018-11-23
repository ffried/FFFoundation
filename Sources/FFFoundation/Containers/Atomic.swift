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

public protocol AtomicProtocol: Container {
    init(value: Value, qos: DispatchQoS)

    func coordinated(with other: Self) -> (Value, Value)
    func coordinated<Other: AtomicProtocol>(with other: Other) -> (Value, Other.Value)

    func combined(with other: Self) -> Atomic<(Value, Value)>
    func combined<Other: AtomicProtocol>(with other: Other) -> Atomic<(Value, Other.Value)>
}

public extension AtomicProtocol {
    public init(value: Value) { self.init(value: value, qos: .default) }
}

public final class Atomic<Guarded>: AtomicProtocol {
    public typealias Value = Guarded

//    private var _value: Ref<Value>
    private var _value: Value
    private let queue: DispatchQueue

    public var value: Value {
        get {
            precondition(notOn: queue)
            return queue.sync { _value/*.value*/ }
        }
        set {
            precondition(notOn: queue)
            queue.sync { withMutableValue { $0 = newValue } }
        }
    }

    public init(value: Value, qos: DispatchQoS) {
        _value = /*Ref(value: */value/*)*/
        queue = DispatchQueue(label: "net.ffried.fffoundation.atomic<\(String(describing: Guarded.self).lowercased())>.queue", qos: qos)
    }

    public subscript<T>(keyPath: KeyPath<Guarded, T>) -> T {
        precondition(notOn: queue)
        return queue.sync { _value/*.value*/[keyPath: keyPath] }
    }

    public subscript<T>(keyPath: WritableKeyPath<Guarded, T>) -> T {
        get {
            precondition(notOn: queue)
            return queue.sync { _value/*.value*/[keyPath: keyPath] }
        }
        set {
            precondition(notOn: queue)
            queue.sync { withMutableValue { $0[keyPath: keyPath] = newValue } }
        }
    }

    private /*mutating*/ func withMutableValue<T>(do work: (inout Guarded) throws -> T) rethrows -> T {
        precondition(on: queue)
//        if !isKnownUniquelyReferenced(&_value) {
//            _value = Ref(value: _value.value)
//        }
        return try work(&_value/*.value*/)
    }

    public func coordinated(with other: Atomic) -> (Guarded, Guarded) {
        precondition(notOn: queue)
        return queue.sync { (value, queue === other.queue ? other._value/*.value*/ : other.value) }
    }

    public func coordinated<OtherGuarded>(with other: Atomic<OtherGuarded>) -> (Guarded, OtherGuarded) {
        precondition(notOn: queue)
        return queue.sync { (_value/*.value*/, other.value) }
    }

    public func coordinated<Other: AtomicProtocol>(with other: Other) -> (Guarded, Other.Value) {
        precondition(notOn: queue)
        return queue.sync { (_value/*.value*/, other.value) }
    }

    public func combined(with other: Atomic) -> Atomic<(Guarded, Guarded)> {
        return Atomic<(Guarded, Guarded)>(value: coordinated(with: other), qos: max(queue.qos, other.queue.qos))
    }

    public func combined<OtherGuarded>(with other: Atomic<OtherGuarded>) -> Atomic<(Guarded, OtherGuarded)> {
        return Atomic<(Guarded, OtherGuarded)>(value: coordinated(with: other), qos: max(queue.qos, other.queue.qos))
    }

    public func combined<Other: AtomicProtocol>(with other: Other) -> Atomic<(Guarded, Other.Value)> {
        return Atomic<(Guarded, Other.Value)>(value: coordinated(with: other), qos: queue.qos)
    }
}

extension Atomic: Equatable where Guarded: Equatable {}
extension Atomic: Hashable where Guarded: Hashable {}
extension Atomic: Comparable where Guarded: Comparable {}
extension Atomic: Encodable where Guarded: Encodable {}
extension Atomic: ExpressibleByNilLiteral where Guarded: ExpressibleByNilLiteral {}
extension Atomic: ExpressibleByBooleanLiteral where Guarded: ExpressibleByBooleanLiteral {}
extension Atomic: ExpressibleByIntegerLiteral where Guarded: ExpressibleByIntegerLiteral {}
extension Atomic: ExpressibleByFloatLiteral where Guarded: ExpressibleByFloatLiteral {}
extension Atomic: ExpressibleByUnicodeScalarLiteral where Guarded: ExpressibleByExtendedGraphemeClusterLiteral {}
extension Atomic: ExpressibleByExtendedGraphemeClusterLiteral where Guarded: ExpressibleByExtendedGraphemeClusterLiteral {}
extension Atomic: ExpressibleByStringLiteral where Guarded: ExpressibleByStringLiteral {}

extension Atomic: NestedContainer where Guarded: Container {
    public typealias NestedValue = Guarded.Value
}

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

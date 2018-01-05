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

public protocol AtomicProtocol {
    associatedtype Value

    var value: Value { get set }

    init(value: Value, qos: DispatchQoS)
    init(value: Value)

    subscript<T>(keyPath: KeyPath<Value, T>) -> T { get }
    subscript<T>(keyPath: WritableKeyPath<Value, T>) -> T { get set }

    func coordinated(with other: Self) -> (Value, Value)
    func coordinated<Other: AtomicProtocol>(with other: Other) -> (Value, Other.Value)

    func combined(with other: Self) -> Atomic<(Value, Value)>
    func combined<Other: AtomicProtocol>(with other: Other) -> Atomic<(Value, Other.Value)>
}

public extension AtomicProtocol {
    public init(value: Value) { self.init(value: value, qos: .default) }
}

public struct Atomic<Value>: AtomicProtocol {
    private var _value: Value
    private let queue: DispatchQueue

    public var value: Value {
        get {
            precondition(notOn: queue)
            return queue.sync { _value }
        }
        set {
            precondition(notOn: queue)
            queue.sync { _value = newValue }
        }
    }

    public init(value: Value, qos: DispatchQoS = .default) {
        _value = value
        queue = DispatchQueue(label: "net.ffried.fffoundation.atomic.queue", qos: qos)
    }

    public subscript<T>(keyPath: KeyPath<Value, T>) -> T {
        get {
            precondition(notOn: queue)
            return queue.sync { _value[keyPath: keyPath] }
        }
    }

    public subscript<T>(keyPath: WritableKeyPath<Value, T>) -> T {
        get {
            precondition(notOn: queue)
            return queue.sync { _value[keyPath: keyPath] }
        }
        set {
            precondition(notOn: queue)
            queue.sync { _value[keyPath: keyPath] = newValue }
        }
    }

    public func coordinated(with other: Atomic<Value>) -> (Value, Value) {
        precondition(notOn: queue)
        return queue.sync { (value, queue === other.queue ? other._value : other.value) }
    }

    public func coordinated<OtherValue>(with other: Atomic<OtherValue>) -> (Value, OtherValue) {
        precondition(notOn: queue)
        return queue.sync { (value, other.value) }
    }

    public func coordinated<Other: AtomicProtocol>(with other: Other) -> (Value, Other.Value) {
        precondition(notOn: queue)
        return queue.sync { (value, other.value) }
    }

    public func combined(with other: Atomic<Value>) -> Atomic<(Value, Value)> {
        return Atomic<(Value, Value)>(value: coordinated(with: other), qos: max(queue.qos, other.queue.qos))
    }

    public func combined<OtherValue>(with other: Atomic<OtherValue>) -> Atomic<(Value, OtherValue)> {
        return Atomic<(Value, OtherValue)>(value: coordinated(with: other), qos: max(queue.qos, other.queue.qos))
    }

    public func combined<Other: AtomicProtocol>(with other: Other) -> Atomic<(Value, Other.Value)> {
        return Atomic<(Value, Other.Value)>(value: coordinated(with: other), qos: queue.qos)
    }
}

extension Atomic: Equatable {
    public static func ==(lhs: Atomic<Value>, rhs: Atomic<Value>) -> Bool {
        return lhs.queue === rhs.queue
    }
}

extension Atomic where Value: Equatable {
    public static func ==(lhs: Atomic<Value>, rhs: Atomic<Value>) -> Bool {
        return lhs.value == rhs.value
    }
}

public extension AtomicProtocol where Value: RefProtocol {
    public var refValue: Value.Value {
        get { return value.value }
        set { value.value = newValue }
    }
}

public extension AtomicProtocol where Value: WeakProtocol {
    public var weakValue: Value.StoredObject? {
        get { return value.object }
        set { value.object = newValue }
    }
}

public extension AtomicProtocol where Value: RefProtocol, Value.Value: WeakProtocol {
    public var refWeakValue: Value.Value.StoredObject? {
        get { return value.value.object }
        set { value.value.object = newValue }
    }
}

public extension AtomicProtocol where Value: WeakProtocol, Value.StoredObject: RefProtocol {
    public var weakValue: Value.StoredObject.Value? {
        get { return value.object?.value }
        set { if let val = newValue { value.object?.value = val } }
    }
}

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

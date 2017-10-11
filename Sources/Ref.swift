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

public protocol RefProtocol: class {
    associatedtype Value

    var value: Value { get set }

    init(value: Value)

    subscript<T>(keyPath: KeyPath<Value, T>) -> T { get }
    subscript<T>(keyPath: WritableKeyPath<Value, T>) -> T { get set }
}

public final class Ref<Value>: RefProtocol {
    public var value: Value

    public init(value: Value) {
        self.value = value
    }

    public subscript<T>(keyPath: KeyPath<Value, T>) -> T {
        return value[keyPath: keyPath]
    }

    public subscript<T>(keyPath: WritableKeyPath<Value, T>) -> T {
        get { return value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}

public extension RefProtocol where Value: WeakProtocol {
    var weakValue: Value.StoredObject? {
        get { return value.object }
        set { value.object = newValue }
    }
}

public extension RefProtocol where Value: AtomicProtocol {
    var atomicValue: Value.Value {
        get { return value.value }
        set { value.value = newValue }
    }
}

public extension RefProtocol where Value: WeakProtocol, Value.StoredObject: AtomicProtocol {
    var weakAtomicValue: Value.StoredObject.Value? {
        get { return value.object?.value }
        set { if let val = newValue { value.object?.value = val } }
    }
}

public extension RefProtocol where Value: AtomicProtocol, Value.Value: WeakProtocol {
    var atomicWeakValue: Value.Value.StoredObject? {
        get { return value.value.object }
        set { value.value.object = newValue }
    }
}

//
//  Container.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 03.04.18.
//  Copyright 2018 Florian Friedrich
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

infix operator <-: AssignmentPrecedence

public protocol Container {
    associatedtype Value

    var value: Value { get set }

    init(value: Value)

    subscript<T>(keyPath: KeyPath<Value, T>) -> T { get }
    subscript<T>(keyPath: WritableKeyPath<Value, T>) -> T { get set }

    static func <- (lhs: inout Self, rhs: Value)
}

public protocol NestedContainer: Container where Value: Container {
    associatedtype Nested: Container = Value
    associatedtype NestedValue = Nested.Value

    var nested: Nested { get set }
    var nestedValue: NestedValue { get set }

    init(nested: Nested)
    init(nestedValue: NestedValue)

    subscript<T>(keyPath: KeyPath<NestedValue, T>) -> T { get }
    subscript<T>(keyPath: WritableKeyPath<NestedValue, T>) -> T { get set }

    static func <- (lhs: inout Self, rhs: NestedValue)
}

extension Container {
    public subscript<T>(keyPath: KeyPath<Value, T>) -> T {
        return value[keyPath: keyPath]
    }

    public subscript<T>(keyPath: WritableKeyPath<Value, T>) -> T {
        get { return value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }

    @inlinable
    public static func <- (lhs: inout Self, rhs: Value) {
        lhs.value = rhs
    }
}

extension NestedContainer {
    @inlinable
    public static func <- (lhs: inout Self, rhs: NestedValue) {
        lhs.nestedValue = rhs
    }
}

extension NestedContainer where Nested == Value {
    public var nested: Nested {
        get { return value }
        set { value = newValue }
    }

    public init(nested: Nested) {
        self.init(value: nested)
    }
}

extension NestedContainer where NestedValue == Nested.Value {
    public var nestedValue: NestedValue {
        get { return nested.value }
        set { nested.value = newValue }
    }

    public init(nestedValue: NestedValue) {
        self.init(nested: .init(value: nestedValue))
    }

    public subscript<T>(keyPath: KeyPath<NestedValue, T>) -> T {
        return nestedValue[keyPath: keyPath]
    }

    public subscript<T>(keyPath: WritableKeyPath<NestedValue, T>) -> T {
        get { return nestedValue[keyPath: keyPath] }
        set { nestedValue[keyPath: keyPath] = newValue }
    }
}

extension NestedContainer where Nested: NestedContainer {
    public var deeplyNestedValue: Nested.NestedValue {
        get { return nested.nestedValue }
        set { nested.nestedValue = newValue }
    }
}

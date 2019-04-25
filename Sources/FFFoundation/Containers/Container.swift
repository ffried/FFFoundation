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

    var value: Value { get }

    init(value: Value)

    subscript<T>(keyPath: KeyPath<Value, T>) -> T { get }
}

public protocol MutableContainer: Container {
    var value: Value { get set }

    subscript<T>(keyPath: WritableKeyPath<Value, T>) -> T { get set }

    static func <- (lhs: inout Self, rhs: Value)
}

public protocol ReferenceMutableContainer: AnyObject, Container {
    var value: Value { get set }

    subscript<T>(keyPath: WritableKeyPath<Value, T>) -> T { get set }

    static func <- (lhs: Self, rhs: Value)
}

extension Container {
    @inlinable
    public subscript<T>(keyPath: KeyPath<Value, T>) -> T {
        return value[keyPath: keyPath]
    }
}

extension MutableContainer {
    @inlinable
    public subscript<T>(keyPath: WritableKeyPath<Value, T>) -> T {
        get { return value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }

    @inlinable
    public static func <- (lhs: inout Self, rhs: Value) {
        lhs.value = rhs
    }

    @inlinable
    public static func <- <Val>(lhs: inout Self, rhs: Val) where Value == Optional<Val> {
        lhs.value = rhs
    }
}

extension ReferenceMutableContainer {
    @inlinable
    public subscript<T>(keyPath: WritableKeyPath<Value, T>) -> T {
        get { return value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }

    @inlinable
    public static func <- (lhs: Self, rhs: Value) {
        lhs.value = rhs
    }

    @inlinable
    public static func <- <Val>(lhs: Self, rhs: Val) where Value == Optional<Val> {
        lhs.value = rhs
    }
}

extension MutableContainer where Value: MutableContainer {
    @inlinable
    public static func <- (lhs: inout Self, rhs: Value.Value) {
        lhs.value <- rhs
    }
}

extension MutableContainer where Value: ReferenceMutableContainer {
    @inlinable
    public static func <- (lhs: inout Self, rhs: Value.Value) {
        lhs.value <- rhs
    }
}

extension ReferenceMutableContainer where Value: MutableContainer {
    @inlinable
    public static func <- (lhs: Self, rhs: Value.Value) {
        lhs.value <- rhs
    }
}

extension ReferenceMutableContainer where Value: ReferenceMutableContainer {
    @inlinable
    public static func <- (lhs: Self, rhs: Value.Value) {
        lhs.value <- rhs
    }
}

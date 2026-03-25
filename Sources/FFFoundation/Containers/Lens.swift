//
//  Lens.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 25.07.19.
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

@usableFromInline
protocol LensStorage<Value> {
    associatedtype Value

    func read() -> Value
    func write(_ newValue: Value)

#if arch(arm64) || arch(x86_64)
#if canImport(Combine) && canImport(SwiftUI)
    func makeBinding() -> Binding<Value>
#endif
#endif
}

fileprivate struct ConstantStorage<Value>: LensStorage {
    let value: Value

    func read() -> Value { value }
    func write(_ newValue: Value) { assertionFailure("Setter called on constant \(Lens<Value>.self)") }

#if arch(arm64) || arch(x86_64)
#if canImport(Combine) && canImport(SwiftUI)
    func makeBinding() -> Binding<Value> { .constant(value) }
#endif
#endif
}

extension ConstantStorage: Sendable where Value: Sendable {}

fileprivate struct AccessorsStorage<Value>: LensStorage {
    let getter: @Sendable () -> Value
    let setter: @Sendable (Value) -> ()

    func read() -> Value { getter() }
    func write(_ newValue: Value) { setter(newValue) }

#if arch(arm64) || arch(x86_64)
#if canImport(Combine) && canImport(SwiftUI)
    func makeBinding() -> Binding<Value> { .init(get: getter, set: setter) }
#endif
#endif
}

extension AccessorsStorage: Sendable where Value: Sendable {}

fileprivate protocol KeyPathStorageProtocol: LensStorage {
    associatedtype Parent
    associatedtype Value
    associatedtype KeyPath: Swift.WritableKeyPath<Parent, Value>

    var parent: Lens<Parent> { get }
    var keyPath: KeyPath { get }
}

extension KeyPathStorageProtocol {
    func read() -> Value { parent.wrappedValue[keyPath: keyPath] }

#if arch(arm64) || arch(x86_64)
#if canImport(Combine) && canImport(SwiftUI)
    func makeBinding() -> Binding<Value> {
        parent.storage.makeBinding()[dynamicMember: keyPath]
    }
#endif
#endif
}

fileprivate struct WritableKeyPathStorage<ParentValue, Value>: KeyPathStorageProtocol {
    let parent: Lens<ParentValue>
    let keyPath: WritableKeyPath<ParentValue, Value>

    func write(_ newValue: Value) { parent.wrappedValue[keyPath: keyPath] = newValue }
}

extension WritableKeyPathStorage: @unchecked Sendable where ParentValue: Sendable, Value: Sendable {}

fileprivate struct ReferenceWritableKeyPathStorage<ParentValue, Value>: KeyPathStorageProtocol {
    let parent: Lens<ParentValue>
    let keyPath: ReferenceWritableKeyPath<ParentValue, Value>

    func write(_ newValue: Value) { parent.wrappedValue[keyPath: keyPath] = newValue }
}

extension ReferenceWritableKeyPathStorage: @unchecked Sendable where ParentValue: Sendable, Value: Sendable {}

@propertyWrapper
@dynamicMemberLookup
@frozen
public struct Lens<Value> {
    @usableFromInline
    let storage: any LensStorage<Value>

    @inlinable
    public var wrappedValue: Value {
        get { storage.read() }
        nonmutating set { storage.write(newValue) }
    }

    @inlinable
    internal init(storage: some LensStorage<Value>) {
        self.storage = storage
    }

    internal init<Base>(base: Base, keyPath: ReferenceWritableKeyPath<Base, Value>) {
        self.init(storage: ReferenceWritableKeyPathStorage(parent: .constant(base), keyPath: keyPath))
    }

    @preconcurrency
    public init(getter: @escaping @Sendable () -> Value, setter: @escaping @Sendable (consuming Value) -> ()) {
        self.init(storage: AccessorsStorage(getter: getter, setter: setter))
    }

    @_disfavoredOverload
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> Lens<T> {
        Lens<T>(storage: WritableKeyPathStorage(parent: self, keyPath: keyPath))
    }

    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, T>) -> Lens<T> {
        Lens<T>(storage: ReferenceWritableKeyPathStorage(parent: self, keyPath: keyPath))
    }

    /// Returns a readonly lens. The setter may be called, but has no effect.
    /// - Parameter getter: The getter to use to extract the value.
    @inlinable
    public static func readOnly(getter: @escaping @Sendable () -> Value) -> Lens {
        Lens(getter: getter, setter: { _ in })
    }

    /// Returns a constant value. The setter of the resulting Lens must not be called!
    /// - Parameter value: The constant value to wrap in a Lens.
    public static func constant(_ value: consuming Value) -> Lens {
        Lens(storage: ConstantStorage(value: value))
    }
}

extension Lens: @unchecked Sendable where Value: Sendable {}

#if arch(arm64) || arch(x86_64)
#if canImport(Combine) && canImport(SwiftUI)
import Combine
public import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
extension Lens {
    @inlinable
    public var binding: Binding<Value> { storage.makeBinding() }
}
#endif
#endif

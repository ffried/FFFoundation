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

@propertyWrapper
@dynamicMemberLookup
@frozen
public struct Lens<Value> {
    @usableFromInline
    let getter: () -> Value
    @usableFromInline
    let setter: (Value) -> ()

    @inlinable
    public var wrappedValue: Value {
        get { getter() }
        nonmutating set { setter(newValue) }
    }

    public init(getter: @escaping () -> Value, setter: @escaping (Value) -> ()) {
        self.getter = getter
        self.setter = setter
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> Lens<T> {
        Lens<T>(getter: { self.wrappedValue[keyPath: keyPath] },
                setter: { self.wrappedValue[keyPath: keyPath] = $0 })
    }

    /// Returns a readonly lens. The setter may be called, but has no effect.
    /// - Parameter getter: The getter to use to extract the value.
    @inlinable
    public static func readOnly(getter: @escaping () -> Value) -> Lens {
        Lens(getter: getter, setter: { _ in })
    }

    /// Returns a constant value. The setter of the resulting Lens must not be called!
    /// - Parameter value: The constant value to wrap in a Lens.
    public static func constant(_ value: Value) -> Lens {
        Lens(getter: { value },
             setter: { _ in assertionFailure("Setter called on constant \(Lens<Value>.self)") })
    }
}

#if arch(arm64) || arch(x86_64)
#if canImport(Combine) && canImport(SwiftUI)
import Combine
import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
extension Lens {
    @inlinable
    public var binding: Binding<Value> { .init(get: getter, set: setter) }
}
#endif
#endif

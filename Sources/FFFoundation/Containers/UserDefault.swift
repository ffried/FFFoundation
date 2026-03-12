//
//  UserDefault.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 10.07.19.
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

public import Foundation

@frozen
public struct UserDefaultKey: RawRepresentable, Hashable, Codable, Sendable, CustomStringConvertible, ExpressibleByStringLiteral {
    public typealias RawValue = String
    public typealias StringLiteralType = RawValue

    public let rawValue: RawValue

    @inlinable
    public var description: String { rawValue }

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

@propertyWrapper
public struct UserDefault<Value: PrimitiveUserDefaultStorable> {
    fileprivate enum DefaultValueStorage {
        case factory(() -> Value)
        case value(Value)
    }

    public let userDefaults: UserDefaults
    public let key: UserDefaultKey

    @Synchronized
    private var defaultValueStorage: DefaultValueStorage

    public var defaultValue: Value {
        get {
            if case .value(let value) = defaultValueStorage {
                return value
            }
            return _defaultValueStorage.withValue {
                switch $0 {
                case .factory(let factory):
                    let value = factory()
                    $0 = .value(value)
                    return value
                case .value(let value):
                    return value
                }
            }
        }
        set {
            _defaultValueStorage.exchange(with: .value(newValue))
        }
    }

    public var wrappedValue: Value {
        get { Value.get(from: userDefaults, forKey: key.rawValue) ?? defaultValue }
        nonmutating set { newValue.set(to: userDefaults, forKey: key.rawValue) }
    }

    public var projectedValue: Lens<Value> {
        Lens(base: self, keyPath: \.wrappedValue)
    }

    public init(userDefaults: UserDefaults = .standard,
                key: UserDefaultKey,
                defaultValue: @escaping @autoclosure () -> Value) {
        self.userDefaults = userDefaults
        self.key = key
        self._defaultValueStorage = .init(value: .factory(defaultValue), qos: .default)
    }

    @inlinable
    public init(wrappedValue: @escaping @autoclosure () -> Value,
                userDefaults: UserDefaults = .standard,
                key: UserDefaultKey) {
        self.init(userDefaults: userDefaults, key: key, defaultValue: wrappedValue())
    }

    @inlinable
    public func delete() {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}

// Unchecked because the closure isn't in storage, but is guaranteed through initializers.
extension UserDefault.DefaultValueStorage: @unchecked Sendable where Value: Sendable {}
// UserDefaults isn't Sendable but should be... :/
extension UserDefault: @unchecked Sendable where Value: Sendable {
    public init(userDefaults: UserDefaults = .standard,
                key: UserDefaultKey,
                defaultValue: @escaping @Sendable @autoclosure () -> Value) {
        self.userDefaults = userDefaults
        self.key = key
        self._defaultValueStorage = .init(value: .factory(defaultValue), qos: .default)
    }

    @inlinable
    public init(wrappedValue: @escaping @Sendable @autoclosure () -> Value,
                userDefaults: UserDefaults = .standard,
                key: UserDefaultKey) {
        self.init(userDefaults: userDefaults, key: key, defaultValue: wrappedValue())
    }
}

extension UserDefault where Value: ExpressibleByNilLiteral {
    @inlinable
    public init(userDefaults: UserDefaults = .standard, key: UserDefaultKey) {
        self.init(userDefaults: userDefaults, key: key, defaultValue: nil)
    }
}

extension UserDefault where Value: ExpressibleByIntegerLiteral {
    @inlinable
    public init(userDefaults: UserDefaults = .standard, key: UserDefaultKey) {
        self.init(userDefaults: userDefaults, key: key, defaultValue: 0)
    }
}

extension UserDefault where Value: ExpressibleByBooleanLiteral {
    @inlinable
    public init(userDefaults: UserDefaults = .standard, key: UserDefaultKey) {
        self.init(userDefaults: userDefaults, key: key, defaultValue: false)
    }
}

extension UserDefault where Value: ExpressibleByArrayLiteral {
    @inlinable
    public init(userDefaults: UserDefaults = .standard, key: UserDefaultKey) {
        self.init(userDefaults: userDefaults, key: key, defaultValue: [])
    }
}

extension UserDefault where Value: ExpressibleByDictionaryLiteral {
    @inlinable
    public init(userDefaults: UserDefaults = .standard, key: UserDefaultKey) {
        self.init(userDefaults: userDefaults, key: key, defaultValue: [:])
    }
}

// Compiler check needed to prevent parsing of code in nested compiler checks
#if compiler(>=6.0) && canImport(Darwin)
extension UserDefault {
    private final class KVObserver: NSObject {
        private var context = 0

        private(set) weak var object: NSObject?
        let keyPath: String
        let handler: () -> ()

        init(object: NSObject, keyPath: String, options: NSKeyValueObservingOptions, handler: @escaping () -> ()) {
            self.object = object
            self.keyPath = keyPath
            self.handler = handler
            super.init()
#if compiler(>=6.2)
            context = unsafe unsafeBitCast(self, to: Int.self)
            unsafe object.addObserver(self, forKeyPath: keyPath, options: options, context: &context)
#else
            context = unsafeBitCast(self, to: Int.self)
            object.addObserver(self, forKeyPath: keyPath, options: options, context: &context)
#endif
        }

        deinit {
            deregister()
        }

        func deregister() {
            object?.removeObserver(self, forKeyPath: keyPath)
            object = nil
        }

        override func observeValue(forKeyPath keyPath: String?,
                                   of object: Any?,
                                   change: [NSKeyValueChangeKey: Any]?,
                                   context: UnsafeMutableRawPointer?) {
#if compiler(>=6.2)
            guard object as AnyObject? === self.object, keyPath == self.keyPath, unsafe context == &self.context else {
                unsafe super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                return
            }
#else
            guard object as AnyObject? === self.object, keyPath == self.keyPath, context == &self.context else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                return
            }
#endif
            handler()
        }
    }
}

extension UserDefault where Value: Sendable {
    public struct Values: AsyncSequence {
        @frozen
        public struct AsyncIterator: AsyncIteratorProtocol {
            public typealias Element = Value
            public typealias Failure = Never

            private var underlyingIterator: AsyncStream<Value>.Iterator

            fileprivate init(underlyingIterator: AsyncStream<Value>.Iterator) {
                self.underlyingIterator = underlyingIterator
            }

            public mutating func next() async -> Element? {
                await underlyingIterator.next()
            }

            @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
            public mutating func next(isolation actor: isolated (any Actor)?) async throws(Failure) -> Element? {
                await underlyingIterator.next(isolation: actor)
            }
        }

        private struct ObservationKeeper: @unchecked Sendable {
            private let observation: KVObserver

            init(observation: KVObserver) {
                self.observation = observation
            }

            func deregister() {
                observation.deregister()
            }
        }

        fileprivate let userDefault: UserDefault
        fileprivate let yieldInitial: Bool

        public func makeAsyncIterator() -> AsyncIterator {
            let stream = AsyncStream<Value> { continuation in
                let observation = ObservationKeeper(observation: KVObserver(object: userDefault.userDefaults,
                                                                            keyPath: userDefault.key.rawValue,
                                                                            options: yieldInitial ? .initial : [],
                                                                            handler: { [userDefault] in
                    continuation.yield(userDefault.wrappedValue)
                }))
                continuation.onTermination = { _ in
                    observation.deregister()
                }
            }
            return .init(underlyingIterator: stream.makeAsyncIterator())
        }
    }

    public var values: Values {
        .init(userDefault: self, yieldInitial: false)
    }
}

extension UserDefault.Values: Sendable where Value: Sendable {}
#endif

#if arch(arm64) || arch(x86_64)
#if canImport(Combine)
public import Combine

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension UserDefault {
    public final class Publisher: Combine.Publisher {
        public typealias Output = Value
        public typealias Failure = Never

        private let upstream = PassthroughSubject<Output, Failure>()
        private let observation: KVObserver

        internal init(userDefault: UserDefault) {
            observation = KVObserver(object: userDefault.userDefaults,
                                     keyPath: userDefault.key.rawValue,
                                     options: [],
                                     handler: { [upstream] in upstream.send(userDefault.wrappedValue) })
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            upstream.receive(subscriber: subscriber)
        }
    }

    public var publisher: Publisher { .init(userDefault: self) }
}

#if canImport(SwiftUI)
public import SwiftUI

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
@available(*, deprecated, message: "Use SwiftUI.AppStorage or SwiftUI.SceneStorage instead")
extension UserDefault: DynamicProperty {
    @inlinable
    public var binding: Binding<Value> { projectedValue.binding }
}
#endif
#endif
#endif

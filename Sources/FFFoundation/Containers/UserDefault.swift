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

import Foundation

@frozen
public struct UserDefaultKey: RawRepresentable, Hashable, Codable, CustomStringConvertible, ExpressibleByStringLiteral {
    public typealias RawValue = String
    public typealias StringLiteralType = RawValue

    public let rawValue: RawValue

    @inlinable
    public var description: String { return rawValue }

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
    public let userDefaults: UserDefaults
    public let key: UserDefaultKey
    public let defaultValue: Value

    public var wrappedValue: Value {
        get { return Value.get(from: userDefaults, forKey: key.rawValue) ?? defaultValue }
        nonmutating set { newValue.set(to: userDefaults, forKey: key.rawValue) }
    }

    #if canImport(SwiftUI)
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    @inlinable
    public var wrapperValue: Binding<Value> { return binding }
    #endif

    public init(userDefaults: UserDefaults = .standard, key: UserDefaultKey, defaultValue: Value) {
        self.userDefaults = userDefaults
        self.key = key
        self.defaultValue = defaultValue
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

#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension UserDefault {
    public final class Publisher: Combine.Publisher {
        public typealias Output = Value
        public typealias Failure = Never

        private final class KVObserver: NSObject {
            private lazy var context = withUnsafePointer(to: self, { Int(bitPattern: $0) })

            private(set) weak var object: NSObject?
            let keyPath: String
            var handler: () -> ()

            init(object: NSObject, keyPath: String, options: NSKeyValueObservingOptions, handler: @escaping () -> ()) {
                self.object = object
                self.keyPath = keyPath
                self.handler = handler
                super.init()
                object.addObserver(self, forKeyPath: keyPath, options: options, context: &context)
            }

            deinit {
                object?.removeObserver(self, forKeyPath: keyPath)
            }

            override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                guard object as AnyObject? === self.object, keyPath == self.keyPath, context == &self.context else {
                    super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                    return
                }
                handler()
            }
        }

        private let upstream: PassthroughSubject<Output, Failure> = .init()
        private let observation: KVObserver

        init(userDefault: UserDefault) {
            observation = KVObserver(object: userDefault.userDefaults, keyPath: userDefault.key.rawValue, options: [], handler: {})
            observation.handler = { [weak self] in self?.upstream.send(userDefault.wrappedValue) }
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            upstream.receive(subscriber: subscriber)
        }
    }

    public var publisher: Publisher { return Publisher(userDefault: self) }
}
#endif

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension UserDefault: BindingConvertible {
    @inlinable
    public var binding: Binding<Value> {
        return Binding(getValue: { self.wrappedValue },
                       setValue: { self.wrappedValue = $0 })
    }
}
#endif

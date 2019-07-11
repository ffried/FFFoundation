//
//  UserDefaultsStorable.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 11.07.19.
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
#if canImport(os)
import os
#endif

public protocol PrimitiveUserDefaultStorable {
    static func get(from userDefaults: UserDefaults, forKey key: String) -> Self?
    func set(to userDefaults: UserDefaults, forKey key: String)
}

public protocol CodableUserDefaultsStorable: PrimitiveUserDefaultStorable, Codable {}

extension CodableUserDefaultsStorable {
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        guard let value = userDefaults.object(forKey: key) else { return nil }
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: value, format: .binary, options: 0)
            return try PropertyListDecoder().decode(Self.self, from: data)
        } catch {
            os_log("[UserDefault] Could not decode %@ for key %@ from user defaults %@",
                   log: .ffFoundation, type: .error, String(describing: Self.self), key, userDefaults)
            return nil
        }
    }

    public func set(to userDefaults: UserDefaults, forKey key: String) {
        do {
            let object = try PropertyListSerialization.propertyList(from: PropertyListEncoder().encode(self), options: [], format: nil)
            userDefaults.set(object, forKey: key)
        } catch {
            os_log("[UserDefault] Could not encode %@ for key %@ for user defaults %@",
                   log: .ffFoundation, type: .error, String(describing: Self.self), key, userDefaults)
        }
    }
}

extension Bool: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return userDefaults.bool(forKey: key)
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(self, forKey: key)
    }
}

extension Int: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return userDefaults.integer(forKey: key)
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(self, forKey: key)
    }
}

extension Float: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return userDefaults.float(forKey: key)
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(self, forKey: key)
    }
}

extension Double: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return userDefaults.double(forKey: key)
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(self, forKey: key)
    }
}

extension String: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return userDefaults.string(forKey: key)
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(self, forKey: key)
    }
}

extension Data: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return userDefaults.data(forKey: key)
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(self, forKey: key)
    }
}

extension URL: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return userDefaults.url(forKey: key)
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(self, forKey: key)
    }
}

extension Optional: PrimitiveUserDefaultStorable where Wrapped: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return Wrapped.get(from: userDefaults, forKey: key)
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        switch self {
        case .none: userDefaults.set(nil, forKey: key)
        case .some(let storable): storable.set(to: userDefaults, forKey: key)
        }
    }
}

extension Array: PrimitiveUserDefaultStorable where Element: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return userDefaults.array(forKey: key) as? Self
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(self, forKey: key)
    }
}

extension ContiguousArray: PrimitiveUserDefaultStorable where Element: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return (userDefaults.array(forKey: key) as? Array<Element>).map(Self.init)
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(Array(self), forKey: key)
    }
}

extension Set: PrimitiveUserDefaultStorable where Element: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return (userDefaults.array(forKey: key) as? Array<Element>).map(Self.init)
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(Array(self), forKey: key)
    }
}

extension Dictionary: PrimitiveUserDefaultStorable where Key == String, Value: PrimitiveUserDefaultStorable {
    @inlinable
    public static func get(from userDefaults: UserDefaults, forKey key: String) -> Self? {
        return userDefaults.dictionary(forKey: key) as? Self
    }

    @inlinable
    public func set(to userDefaults: UserDefaults, forKey key: String) {
        userDefaults.set(self, forKey: key)
    }
}

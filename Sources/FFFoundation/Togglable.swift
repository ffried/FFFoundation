//
//  Togglable.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 30/05/16.
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

import struct Foundation.ObjCBool
#if canImport(Darwin)
import struct Darwin.DarwinBoolean
#endif

public protocol Togglable {
    /// A inverted version of `self`.
    var toggled: Self { get }

    /// Toggles `self`.
    mutating func toggle()
}

extension Togglable {
    /// By default, `toggle` just assigns `toggled` to `self`.
    @inlinable
    public mutating func toggle() {
        self = toggled
    }
}

extension Bool: Togglable {
    /// Directly inverts `self` by returning `!self`.
    @inlinable
    public var toggled: Bool { !self }
}

extension ObjCBool: Togglable {
    @inlinable
    public var toggled: ObjCBool { .init(boolValue.toggled) }
}

#if canImport(Darwin)
extension DarwinBoolean: Togglable {
    @inlinable
    public var toggled: DarwinBoolean { .init(boolValue.toggled) }
}
#endif

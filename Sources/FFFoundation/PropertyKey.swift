//
//  PropertyKey.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 23.07.20.
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

@frozen
public struct PropertyKey: RawRepresentable, Hashable, Codable, Sendable, ExpressibleByStringLiteral, CustomStringConvertible {
    public typealias RawValue = String
    public typealias StringLiteralType = RawValue

    public let rawValue: RawValue

    public var description: String { rawValue }

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    @inlinable
    public init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }

    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

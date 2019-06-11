//
//  Size.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 20.08.18.
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

public struct Size<Value: Numeric & Hashable>: Hashable {
    public var width: Value
    public var height: Value

    @inlinable
    public var isSquare: Bool { return width == height }

    public init(width: Value, height: Value) {
        (self.width, self.height) = (width, height)
    }
}

extension Size {
    @inlinable
    public static var zero: Size { return .init(width: 0, height: 0) }
}

extension Size: Encodable where Value: Encodable {}
extension Size: Decodable where Value: Decodable {}

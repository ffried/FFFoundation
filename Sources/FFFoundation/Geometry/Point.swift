//
//  Point.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 11.10.17.
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

@frozen
public struct Point<Value: Numeric & Hashable>: Hashable {
    public var x: Value
    public var y: Value

    public init(x: Value, y: Value) {
        (self.x, self.y) = (x, y)
    }
}

extension Point {
    @inlinable
    public static var zero: Point { .init(x: 0, y: 0) }
}

extension Point: Encodable where Value: Encodable {}
extension Point: Decodable where Value: Decodable {}
extension Point: TriangulatablePoint where Value: GeometricValue {}

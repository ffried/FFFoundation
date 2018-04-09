//
//  Triangulatable.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 18.08.17.
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

import Foundation

public protocol TriangulatableValue: FloatingPoint {
    func sin() -> Self
    func asin() -> Self
    func cos() -> Self
    func acos() -> Self
    func tan() -> Self
    func atan() -> Self
}

public protocol TriangulatablePoint {
    associatedtype Value: TriangulatableValue

    var x: Value { get }
    var y: Value { get }

    init(x: Value, y: Value)
}

extension Double: TriangulatableValue {
    public func sin() -> Double { return Foundation.sin(self) }
    public func asin() -> Double { return Foundation.asin(self) }
    public func cos() -> Double { return Foundation.cos(self) }
    public func acos() -> Double { return Foundation.acos(self) }
    public func tan() -> Double { return Foundation.tan(self) }
    public func atan() -> Double { return Foundation.atan(self) }
}

extension Float: TriangulatableValue {
    public func sin() -> Float { return Foundation.sin(self) }
    public func asin() -> Float { return Foundation.asin(self) }
    public func cos() -> Float { return Foundation.cos(self) }
    public func acos() -> Float { return Foundation.acos(self) }
    public func tan() -> Float { return Foundation.tan(self) }
    public func atan() -> Float { return Foundation.atan(self) }
}

#if canImport(CoreGraphics)
import CoreGraphics

extension CGFloat: TriangulatableValue {
    public func sin() -> CGFloat { return CoreGraphics.sin(self) }
    public func asin() -> CGFloat { return CoreGraphics.asin(self) }
    public func cos() -> CGFloat { return CoreGraphics.cos(self) }
    public func acos() -> CGFloat { return CoreGraphics.acos(self) }
    public func tan() -> CGFloat { return CoreGraphics.tan(self) }
    public func atan() -> CGFloat { return CoreGraphics.atan(self) }
}

extension CGPoint: TriangulatablePoint {
    public typealias Value = CGFloat
}
#endif

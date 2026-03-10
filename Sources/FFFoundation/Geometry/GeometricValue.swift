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

public import Foundation

public protocol GeometricValue: FloatingPoint {
    func sin() -> Self
    func asin() -> Self
    func cos() -> Self
    func acos() -> Self
    func tan() -> Self
    func atan() -> Self
}

extension Double: GeometricValue {
    @inlinable
    public func sin() -> Double { Foundation.sin(self) }
    @inlinable
    public func asin() -> Double { Foundation.asin(self) }
    @inlinable
    public func cos() -> Double { Foundation.cos(self) }
    @inlinable
    public func acos() -> Double { Foundation.acos(self) }
    @inlinable
    public func tan() -> Double { Foundation.tan(self) }
    @inlinable
    public func atan() -> Double { Foundation.atan(self) }
}

extension Float: GeometricValue {
    @inlinable
    public func sin() -> Float { Foundation.sin(self) }
    @inlinable
    public func asin() -> Float { Foundation.asin(self) }
    @inlinable
    public func cos() -> Float { Foundation.cos(self) }
    @inlinable
    public func acos() -> Float { Foundation.acos(self) }
    @inlinable
    public func tan() -> Float { Foundation.tan(self) }
    @inlinable
    public func atan() -> Float { Foundation.atan(self) }
}

#if canImport(CoreGraphics)
public import CoreGraphics

extension CGFloat: GeometricValue {
    @inlinable
    public func sin() -> CGFloat { CoreGraphics.sin(self) }
    @inlinable
    public func asin() -> CGFloat { CoreGraphics.asin(self) }
    @inlinable
    public func cos() -> CGFloat { CoreGraphics.cos(self) }
    @inlinable
    public func acos() -> CGFloat { CoreGraphics.acos(self) }
    @inlinable
    public func tan() -> CGFloat { CoreGraphics.tan(self) }
    @inlinable
    public func atan() -> CGFloat { CoreGraphics.atan(self) }
}
#endif

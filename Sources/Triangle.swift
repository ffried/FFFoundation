//
//  Triangle.swift
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

public struct Triangle<Point: Triangulatable>: Equatable where Point.Value.Stride == Point.Value {
    public typealias Angle = FFFoundation.Angle<Point.Value>
    public typealias Distance = Point.Value
    
    public let points: (a: Point,    b: Point,    c: Point)
    public let angles: (α: Angle,    β: Angle,    γ: Angle)
    public let sides:  (a: Distance, b: Distance, c: Distance)
    
    public static func ==(lhs: Triangle<Point>, rhs: Triangle<Point>) -> Bool {
        return lhs.sides == rhs.sides
    }
}

public extension Triangle {
    public var pointA: Point { return points.a }
    public var pointB: Point { return points.b }
    public var pointC: Point { return points.c }
    
    public var α: Triangle<Point>.Angle { return angles.α }
    public var β: Triangle<Point>.Angle { return angles.β }
    public var γ: Triangle<Point>.Angle { return angles.γ }
    
    public var a: Distance { return sides.a }
    public var b: Distance { return sides.b }
    public var c: Distance { return sides.c }
}

public extension Triangle {
    public init(orthogonallyWithA a: Point, b: Point) {
        points = (a, b, .init(x: a.x, y: b.y))
        let sideA = abs(b.x - a.x)
        let sideB = abs(a.y - b.y)
        let sideC = (sideA * sideA + sideB * sideB).squareRoot()
        sides = (sideA, sideB, sideC)
        let α = Angle.radians((sideA / sideC).asin())
        let γ = Angle.radians(.pi / 2)
        angles = (α, .pi - γ - α, γ)
    }
}

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

public protocol TriangulatablePoint {
    associatedtype Value: GeometricValue

    var x: Value { get }
    var y: Value { get }

    init(x: Value, y: Value)
}

#if canImport(CoreGraphics)
import CoreGraphics

extension CGPoint: TriangulatablePoint {
    public typealias Value = CGFloat
}
#endif

public struct Triangle<Point: TriangulatablePoint>: Hashable where Point.Value.Stride == Point.Value {
    public typealias Angle = FFFoundation.Angle<Point.Value>
    public typealias Distance = Point.Value
    
    public let points: (a: Point,    b: Point,    c: Point)
    public let angles: (α: Angle,    β: Angle,    γ: Angle)
    public let sides:  (a: Distance, b: Distance, c: Distance)

    public func hash(into hasher: inout Hasher) {
        hasher.combine(sides.a)
        hasher.combine(sides.b)
        hasher.combine(sides.c)
    }
    
    public static func ==(lhs: Triangle<Point>, rhs: Triangle<Point>) -> Bool {
        return lhs.sides == rhs.sides
    }
}

public extension Triangle {
    public var pointA: Point { return points.a }
    public var pointB: Point { return points.b }
    public var pointC: Point { return points.c }
    
    public var α: Angle { return angles.α }
    public var β: Angle { return angles.β }
    public var γ: Angle { return angles.γ }
    
    public var a: Distance { return sides.a }
    public var b: Distance { return sides.b }
    public var c: Distance { return sides.c }
}

public extension Triangle {
    /// Calculates a new orthogonal triangle with a given point A and B.
    /// - Note: The triangle is based on C meaning that C == (A.x, B.y).
    ///
    /// - Parameters:
    ///   - a: The point A.
    ///   - b: The point B.
    public init(orthogonallyOnCWithA a: Point, b: Point) {
        points = (a, b, .init(x: a.x, y: b.y))
        let sideA = abs(b.x - a.x)
        let sideB = abs(a.y - b.y)
        let sideC = (sideA * sideA + sideB * sideB).squareRoot()
        sides = (sideA, sideB, sideC)
        let α = Angle.radians((sideA / sideC).asin())
        let γ = Angle.radians(.pi / 2)
        angles = (α, .pi - γ - α, γ)
    }
    
    /// Calculates a new triangle from three given points.
    ///
    /// - Parameters:
    ///   - a: The point A.
    ///   - b: The point B.
    ///   - c: The point C.
    public init(a: Point, b: Point, c: Point) {
        points = (a, b, c)

        let sideACathetusA = abs(b.x - c.x)
        let sideACathetusB = abs(b.y - c.y)
        let sideA = (sideACathetusA * sideACathetusA + sideACathetusB * sideACathetusB).squareRoot()
        let sideBCathetusA = abs(a.x - c.x)
        let sideBCathetusB = abs(a.y - c.y)
        let sideB = (sideBCathetusA * sideBCathetusA + sideBCathetusB * sideBCathetusB).squareRoot()
        let sideCCathetusA = abs(a.x - b.x)
        let sideCCathetusB = abs(a.y - b.y)
        let sideC = (sideCCathetusA * sideCCathetusA + sideCCathetusB * sideCCathetusB).squareRoot()
        sides = (sideA, sideB, sideC)
        
        let sideASquare = sideA * sideA
        let sideBSquare = sideB * sideB
        let sideCSquare = sideC * sideC
        
        // calculate angles with cosinus formular (all sites' lengths are given)
        let cosα = (sideBSquare + sideCSquare - sideASquare) / (2 * sideB * sideC)
        let cosβ = (sideASquare + sideCSquare - sideBSquare) / (2 * sideA * sideC)
        let cosγ = (sideASquare + sideBSquare - sideCSquare) / (2 * sideA * sideB)
        
        let α = Angle.radians(cosα.acos())
        let β = Angle.radians(cosβ.acos())
        let γ = Angle.radians(cosγ.acos())
        angles = (α, β, γ)
    }
}

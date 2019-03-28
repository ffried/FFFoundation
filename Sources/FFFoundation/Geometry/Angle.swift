//
//  Angle.swift
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

public enum Angle<Value: FloatingPoint>: FloatingPoint where Value.Stride == Value {
    public typealias Stride = Angle
    public typealias IntegerLiteralType = Value.IntegerLiteralType
    public typealias Exponent = Value.Exponent
    public typealias Magnitude = Angle

    case radians(Value)
    case degrees(Value)
    
    public private(set) var value: Value {
        get {
            switch self {
            case .radians(let value):
                return value
            case .degrees(let value):
                return value
            }
        }
        set {
            switch self {
            case .radians(_):
                self = .radians(newValue)
            case .degrees(_):
                self = .degrees(newValue)
            }
        }
    }

    public var asRadians: Angle<Value> {
        switch self {
        case .radians(_): return self
        case .degrees(_): return converted()
        }
    }
    
    public var asDegrees: Angle<Value> {
        switch self {
        case .radians(_): return converted()
        case .degrees(_): return self
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(asRadians.value)
    }

    public static var radix: Int { return Value.radix }
    public static var nan: Angle<Value> { return .init(radians: .nan) }
    public static var signalingNaN: Angle<Value> { return .init(radians: .signalingNaN) }
    public static var infinity: Angle<Value> { return .init(radians: .infinity) }
    public static var pi: Angle<Value> { return .init(radians: .pi) }
    public static var greatestFiniteMagnitude: Angle<Value> { return .init(radians: .greatestFiniteMagnitude) }
    public static var leastNonzeroMagnitude: Angle<Value> { return .init(radians: .leastNonzeroMagnitude) }
    public static var leastNormalMagnitude: Angle<Value> { return .init(radians: .leastNormalMagnitude) }
    
    public var exponent: Exponent { return value.exponent }
    public var sign: FloatingPointSign { return value.sign }
    public var isNormal: Bool { return value.isNormal }
    public var isFinite: Bool { return value.isFinite }
    public var isZero: Bool { return value.isZero }
    public var isSubnormal: Bool { return value.isSubnormal }
    public var isInfinite: Bool { return value.isInfinite }
    public var isNaN: Bool { return value.isNaN }
    public var isSignalingNaN: Bool { return value.isSignalingNaN }
    public var isCanonical: Bool { return value.isCanonical }

    public var magnitude: Magnitude {
        switch self {
        case .radians(let val): return .radians(val.magnitude)
        case .degrees(let val): return .degrees(val.magnitude)
        }
    }

    public var ulp: Angle<Value> {
        switch self {
        case .radians(let val): return .radians(val.ulp)
        case .degrees(let val): return .degrees(val.ulp)
        }
    }
    public var significand: Angle<Value> {
        switch self {
        case .radians(let val): return .radians(val.significand)
        case .degrees(let val): return .degrees(val.significand)
        }
    }
    public var nextUp: Angle<Value> {
        switch self {
        case .radians(let val): return .radians(val.nextUp)
        case .degrees(let val): return .degrees(val.nextUp)
        }
    }
    public var nextDown: Angle<Value> {
        switch self {
        case .radians(let val): return .radians(val.nextDown)
        case .degrees(let val): return .degrees(val.nextDown)
        }
    }
    
    // MARK: - Initializers
    private init(radians value: Value) { self = .radians(value) }
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(radians: .init(integerLiteral: value))
    }
    
    public init?<Source>(exactly source: Source) where Source : BinaryInteger {
        guard let value = Value(exactly: source) else { return nil }
        self.init(radians: value)
    }

    public init<Source>(_ value: Source) where Source : BinaryInteger {
        self.init(radians: .init(value))
    }

    public init(signOf: Angle, magnitudeOf: Angle) {
        self.init(radians: .init(signOf: signOf.value, magnitudeOf: magnitudeOf.value))
    }
    
    public init(sign: FloatingPointSign, exponent: Exponent, significand: Angle) {
        self.init(radians: .init(sign: sign, exponent: exponent, significand: significand.value))
    }
    
    // MARK: - Calculation
    public mutating func formRemainder(dividingBy other: Angle<Value>) {
        switch (self, other) {
        case (.radians(_), .radians(_)),
             (.degrees(_), .degrees(_)):
            value.formRemainder(dividingBy: other.value)
        case (.radians(_), .degrees(_)),
             (.degrees(_), .radians(_)):
            formRemainder(dividingBy: other.converted())
        }
    }
    
    public mutating func formTruncatingRemainder(dividingBy other: Angle<Value>) {
        switch (self, other) {
        case (.radians(_), .radians(_)),
             (.degrees(_), .degrees(_)):
            value.formTruncatingRemainder(dividingBy: other.value)
        case (.radians(_), .degrees(_)),
             (.degrees(_), .radians(_)):
            formTruncatingRemainder(dividingBy: other.converted())
        }
    }
    
    public mutating func addProduct(_ lhs: Angle<Value>, _ rhs: Angle<Value>) {
        switch (self, lhs, rhs) {
        case (.radians(_), .radians(let lhsValue), .radians(let rhsValue)):
            value.addProduct(lhsValue, rhsValue)
        case (.degrees(_), .degrees(let lhsValue), .degrees(let rhsValue)):
            value.addProduct(lhsValue, rhsValue)
        case (.radians(_), .radians(_), .degrees(_)),
             (.degrees(_), .degrees(_), .radians(_)):
            addProduct(lhs, rhs.converted())
        case (.radians(_), .degrees(_), .radians(_)),
             (.degrees(_), .radians(_), .degrees(_)):
            addProduct(lhs.converted(), rhs)
        case (.radians(_), .degrees(_), .degrees(_)),
             (.degrees(_), .radians(_), .radians(_)):
            addProduct(lhs.converted(), rhs.converted())
        }
    }
    
    public mutating func formSquareRoot() { value.formSquareRoot() }
    
    public mutating func round(_ rule: FloatingPointRoundingRule) { value.round(rule) }
    
    // MARK: - Conversion
    public mutating func convert() {
        switch self {
        case .radians(let value):
            self = .degrees(value.toDegrees())
        case .degrees(let value):
            self = .radians(value.toRadians())
        }
    }
    
    public func converted() -> Angle<Value> {
        var newAngle = self
        newAngle.convert()
        return newAngle
    }
    
    // MARK: Strideable
    public func distance(to other: Angle<Value>) -> Stride {
        switch (self, other) {
        case (.radians(let lhsValue), .radians(let rhsValue)):
            return .radians(lhsValue.distance(to: rhsValue))
        case (.degrees(let lhsValue), .degrees(let rhsValue)):
            return .degrees(lhsValue.distance(to: rhsValue))
        case (.radians(_), .degrees(_)),
             (.degrees(_), .radians(_)):
            return distance(to: other.converted())
        }
    }
    
    public func advanced(by n: Stride) -> Angle<Value> {
        switch (self, n) {
        case (.radians(let lhsValue), .radians(let rhsValue)):
            return .radians(lhsValue.advanced(by: rhsValue))
        case (.degrees(let lhsValue), .degrees(let rhsValue)):
            return .degrees(lhsValue.advanced(by: rhsValue))
        case (.radians(_), .degrees(_)),
             (.degrees(_), .radians(_)):
            return advanced(by: n.converted())
        }
    }
    
    // MARK: - Comparison
    public func isEqual(to other: Angle<Value>) -> Bool {
        switch (self, other) {
        case (.radians(let lhsValue), .radians(let rhsValue)):
            return lhsValue.isEqual(to: rhsValue)
        case (.degrees(let lhsValue), .degrees(let rhsValue)):
            return lhsValue.isEqual(to: rhsValue)
        case (.radians(_), .degrees(_)):
            return isEqual(to: other.converted())
        case (.degrees(_), .radians(_)):
            return converted().isEqual(to: other)
        }
    }
    
    public func isLess(than other: Angle<Value>) -> Bool {
        switch (self, other) {
        case (.radians(let lhsValue), .radians(let rhsValue)):
            return lhsValue.isLess(than: rhsValue)
        case (.degrees(let lhsValue), .degrees(let rhsValue)):
            return lhsValue.isLess(than: rhsValue)
        case (.radians(_), .degrees(_)):
            return isLess(than: other.converted())
        case (.degrees(_), .radians(_)):
            return converted().isLess(than: other)
        }
    }
    
    public func isLessThanOrEqualTo(_ other: Angle<Value>) -> Bool {
        switch (self, other) {
        case (.radians(let lhsValue), .radians(let rhsValue)):
            return lhsValue.isLessThanOrEqualTo(rhsValue)
        case (.degrees(let lhsValue), .degrees(let rhsValue)):
            return lhsValue.isLessThanOrEqualTo(rhsValue)
        case (.radians(_), .degrees(_)):
            return isLessThanOrEqualTo(other.converted())
        case (.degrees(_), .radians(_)):
            return converted().isLessThanOrEqualTo(other)
        }
    }
    
    public func isTotallyOrdered(belowOrEqualTo other: Angle<Value>) -> Bool {
        switch (self, other) {
        case (.radians(let lhsValue), .radians(let rhsValue)):
            return lhsValue.isTotallyOrdered(belowOrEqualTo: rhsValue)
        case (.degrees(let lhsValue), .degrees(let rhsValue)):
            return lhsValue.isTotallyOrdered(belowOrEqualTo: rhsValue)
        case (.radians(_), .degrees(_)):
            return isTotallyOrdered(belowOrEqualTo: other.converted())
        case (.degrees(_), .radians(_)):
            return converted().isTotallyOrdered(belowOrEqualTo: other)
        }
    }
    
    // MARK: - AbsoluteValuable
    public static func abs(_ x: Angle<Value>) -> Angle<Value> {
        switch x {
        case .radians(let val): return .radians(Swift.abs(val))
        case .degrees(let val): return .degrees(Swift.abs(val))
        }
    }
    
    // MARK: - Operators
    public static func +(lhs: Angle<Value>, rhs: Angle<Value>) -> Angle<Value> {
        switch (lhs, rhs) {
        case (.radians(let lhsValue), .radians(let rhsValue)):
            return .radians(lhsValue + rhsValue)
        case (.degrees(let lhsValue), .degrees(let rhsValue)):
            return .degrees(lhsValue + rhsValue)
        case (.radians(_), .degrees(_)),
             (.degrees(_), .radians(_)):
            return lhs + rhs.converted()
        }
    }
    
    public static func -(lhs: Angle<Value>, rhs: Angle<Value>) -> Angle<Value> {
        switch (lhs, rhs) {
        case (.radians(let lhsValue), .radians(let rhsValue)):
            return .radians(lhsValue - rhsValue)
        case (.degrees(let lhsValue), .degrees(let rhsValue)):
            return .degrees(lhsValue - rhsValue)
        case (.radians(_), .degrees(_)),
             (.degrees(_), .radians(_)):
            return lhs - rhs.converted()
        }
    }
    
    public static func *(lhs: Angle<Value>, rhs: Angle<Value>) -> Angle<Value> {
        switch (lhs, rhs) {
        case (.radians(let lhsValue), .radians(let rhsValue)):
            return .radians(lhsValue * rhsValue)
        case (.degrees(let lhsValue), .degrees(let rhsValue)):
            return .degrees(lhsValue * rhsValue)
        case (.radians(_), .degrees(_)),
             (.degrees(_), .radians(_)):
            return lhs * rhs.converted()
        }
    }
    
    public static func /(lhs: Angle<Value>, rhs: Angle<Value>) -> Angle<Value> {
        switch (lhs, rhs) {
        case (.radians(let lhsValue), .radians(let rhsValue)):
            return .radians(lhsValue / rhsValue)
        case (.degrees(let lhsValue), .degrees(let rhsValue)):
            return .degrees(lhsValue / rhsValue)
        case (.radians(_), .degrees(_)),
             (.degrees(_), .radians(_)):
            return lhs / rhs.converted()
        }
    }
    
    public static func +=(lhs: inout Angle<Value>, rhs: Angle<Value>) {
        lhs = lhs + rhs
    }
    
    public static func -=(lhs: inout Angle<Value>, rhs: Angle<Value>) {
        lhs = lhs - rhs
    }
    
    public static func *=(lhs: inout Angle<Value>, rhs: Angle<Value>) {
        lhs = lhs * rhs
    }
    
    public static func /=(lhs: inout Angle<Value>, rhs: Angle<Value>) {
        lhs = lhs / rhs
    }
}

fileprivate extension Angle {
    enum CodingKeys: String, CodingKey {
        case kind, value
    }
}

extension Angle: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .degrees(let value):
            try container.encode("degrees", forKey: .kind)
            try container.encode(value, forKey: .value)
        case .radians(let value):
            try container.encode("radians", forKey: .kind)
            try container.encode(value, forKey: .value)
        }
    }
}

extension Angle: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .kind) {
        case "degrees":
            self = try .degrees(container.decode(Value.self, forKey: .value))
        case "radians":
            self = try .radians(container.decode(Value.self, forKey: .value))
        case let invalidValue:
            throw DecodingError.dataCorruptedError(forKey: .kind, in: container,
                                                   debugDescription: "Could not convert '\(invalidValue)' to \(Angle.self)")
        }
    }
}

fileprivate extension FloatingPoint {
    @inline(__always)
    func toRadians() -> Self { return self * .pi / 180 }
    @inline(__always)
    func toDegrees() -> Self { return self * 180 / .pi }
}

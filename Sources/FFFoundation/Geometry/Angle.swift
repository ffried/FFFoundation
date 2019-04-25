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

public struct Angle<Value: FloatingPoint>: FloatingPoint, CustomStringConvertible where Value.Stride == Value {
    public typealias Stride = Angle
    public typealias IntegerLiteralType = Value.IntegerLiteralType
    public typealias Exponent = Value.Exponent
    public typealias Magnitude = Angle

    private enum Kind {
        case radians, degrees
    }

    private var kind: Kind
    public private(set) var value: Value

    public var description: String {
        switch kind {
        case .radians: return "\(value) radians"
        case .degrees: return "\(value) degrees"
        }
    }

    private init(kind: Kind, value: Value) {
        (self.kind, self.value) = (kind, value)
    }

    public init(radians: Value) {
        self.init(kind: .radians, value: radians)
    }

    public init(degrees: Value) {
        self.init(kind: .degrees, value: degrees)
    }

    public var asRadians: Angle<Value> {
        switch kind {
        case .radians: return self
        case .degrees: return converted()
        }
    }
    
    public var asDegrees: Angle<Value> {
        switch kind {
        case .radians: return converted()
        case .degrees: return self
        }
    }

    private func value(as newKind: Kind) -> Value {
        return kind == newKind ? value : converted().value
    }

    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(asRadians.value)
    }

    // MARK: - Conversion
    public mutating func convert() {
        switch kind {
        case .radians:
            kind = .degrees
            value *= 180 / .pi
        case .degrees:
            kind = .radians
            value *= .pi / 180
        }
    }

    public func converted() -> Angle<Value> {
        var newAngle = self
        newAngle.convert()
        return newAngle
    }

    // MARK: - FloatingPoint
    public static var radix: Int { return Value.radix }
    public static var nan: Angle<Value> { return .init(kind: .radians, value: .nan) }
    public static var signalingNaN: Angle<Value> { return .init(kind: .radians, value: .signalingNaN) }
    public static var infinity: Angle<Value> { return .init(kind: .radians, value: .infinity) }
    public static var pi: Angle<Value> { return .init(kind: .radians, value: .pi) }
    public static var greatestFiniteMagnitude: Angle<Value> { return .init(kind: .radians, value: .greatestFiniteMagnitude) }
    public static var leastNonzeroMagnitude: Angle<Value> { return .init(kind: .radians, value: .leastNonzeroMagnitude) }
    public static var leastNormalMagnitude: Angle<Value> { return .init(kind: .radians, value: .leastNormalMagnitude) }
    
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

    public var magnitude: Magnitude { return .init(kind: kind, value: value.magnitude) }
    public var ulp: Angle<Value> { return .init(kind: kind, value: value.ulp) }
    public var significand: Angle<Value> { return .init(kind: kind, value: value.significand) }
    public var nextUp: Angle<Value> { return .init(kind: kind, value: value.nextUp) }
    public var nextDown: Angle<Value> { return .init(kind: kind, value: value.nextDown) }
    
    // MARK: Initializers
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(kind: .radians, value: .init(integerLiteral: value))
    }
    
    public init?<Source>(exactly source: Source) where Source : BinaryInteger {
        guard let value = Value(exactly: source) else { return nil }
        self.init(kind: .radians, value: value)
    }

    public init<Source>(_ value: Source) where Source : BinaryInteger {
        self.init(kind: .radians, value: .init(value))
    }

    public init(signOf: Angle, magnitudeOf: Angle) {
        self.init(kind: .radians, value: .init(signOf: signOf.asRadians.value, magnitudeOf: magnitudeOf.asRadians.value))
    }
    
    public init(sign: FloatingPointSign, exponent: Exponent, significand: Angle) {
        self.init(kind: .radians, value: .init(sign: sign, exponent: exponent, significand: significand.asRadians.value))
    }
    
    // MARK: Calculation
    public mutating func formRemainder(dividingBy other: Angle<Value>) {
        value.formRemainder(dividingBy: other.value(as: kind))
    }
    
    public mutating func formTruncatingRemainder(dividingBy other: Angle<Value>) {
        value.formTruncatingRemainder(dividingBy: other.value(as: kind))
    }
    
    public mutating func addProduct(_ lhs: Angle<Value>, _ rhs: Angle<Value>) {
        value.addProduct(lhs.value(as: kind), rhs.value(as: kind))
    }
    
    public mutating func formSquareRoot() { value.formSquareRoot() }
    
    public mutating func round(_ rule: FloatingPointRoundingRule) { value.round(rule) }
    
    // MARK: Comparison
    public func isEqual(to other: Angle<Value>) -> Bool {
        return value.isEqual(to: other.value(as: kind))
    }
    
    public func isLess(than other: Angle<Value>) -> Bool {
        return value.isLess(than: other.value(as: kind))
    }
    
    public func isLessThanOrEqualTo(_ other: Angle<Value>) -> Bool {
        return value.isLessThanOrEqualTo(other.value(as: kind))
    }
    
    public func isTotallyOrdered(belowOrEqualTo other: Angle<Value>) -> Bool {
        return value.isTotallyOrdered(belowOrEqualTo: other.value(as: kind))
    }

    // MARK: - Strideable
    public func distance(to other: Angle<Value>) -> Stride {
        return .init(kind: kind, value: value.distance(to: other.value(as: kind)))
    }

    public func advanced(by n: Stride) -> Angle<Value> {
        return .init(kind: kind, value: value.advanced(by: n.value(as: kind)))
    }
    
    // MARK: - Operators
    public static func +(lhs: Angle<Value>, rhs: Angle<Value>) -> Angle<Value> {
        return .init(kind: lhs.kind, value: lhs.value + rhs.value(as: lhs.kind))
    }
    
    public static func -(lhs: Angle<Value>, rhs: Angle<Value>) -> Angle<Value> {
        return .init(kind: lhs.kind, value: lhs.value - rhs.value(as: lhs.kind))
    }
    
    public static func *(lhs: Angle<Value>, rhs: Angle<Value>) -> Angle<Value> {
        return .init(kind: lhs.kind, value: lhs.value * rhs.value(as: lhs.kind))
    }
    
    public static func /(lhs: Angle<Value>, rhs: Angle<Value>) -> Angle<Value> {
        return .init(kind: lhs.kind, value: lhs.value / rhs.value(as: lhs.kind))
    }
    
    public static func +=(lhs: inout Angle<Value>, rhs: Angle<Value>) {
        lhs.value += rhs.value(as: lhs.kind)
    }
    
    public static func -=(lhs: inout Angle<Value>, rhs: Angle<Value>) {
        lhs.value -= rhs.value(as: lhs.kind)
    }
    
    public static func *=(lhs: inout Angle<Value>, rhs: Angle<Value>) {
        lhs.value *= rhs.value(as: lhs.kind)
    }
    
    public static func /=(lhs: inout Angle<Value>, rhs: Angle<Value>) {
        lhs.value /= rhs.value(as: lhs.kind)
    }
}

// MARK: - Convenience
extension Angle {
    public static func radians(_ value: Value) -> Angle {
        return .init(kind: .radians, value: value)
    }

    public static func degrees(_ value: Value) -> Angle {
        return .init(kind: .degrees, value: value)
    }
}

// MARK: - Conditional Conformances
fileprivate extension Angle {
    enum CodingKeys: String, CodingKey {
        case kind, value
    }
}

extension Angle: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch kind {
        case .degrees: try container.encode("degrees", forKey: .kind)
        case .radians: try container.encode("radians", forKey: .kind)
        }
        try container.encode(value, forKey: .value)
    }
}

extension Angle: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .kind) {
        case "degrees":
            try self.init(kind: .degrees, value: container.decode(Value.self, forKey: .value))
        case "radians":
            try self.init(kind: .radians, value: container.decode(Value.self, forKey: .value))
        case let invalidValue:
            throw DecodingError.dataCorruptedError(forKey: .kind, in: container,
                                                   debugDescription: "Could not convert '\(invalidValue)' to \(Angle.self)")
        }
    }
}

extension Angle: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Value.FloatLiteralType

    public init(floatLiteral value: FloatLiteralType) {
        self.init(radians: Value(floatLiteral: value))
    }
}

extension Angle: BinaryFloatingPoint where Value: BinaryFloatingPoint {
    public typealias RawSignificand = Value.RawSignificand
    public typealias RawExponent = Value.RawExponent

    public static var exponentBitCount: Int { return Value.exponentBitCount }
    public static var significandBitCount: Int { return Value.significandBitCount }

    public var exponentBitPattern: RawExponent { return value.exponentBitPattern }
    public var significandBitPattern: RawSignificand { return value.significandBitPattern }
    public var binade: Angle<Value> { return .init(kind: kind, value: value.binade) }
    public var significandWidth: Int { return value.significandWidth }

    public init(sign: FloatingPointSign, exponentBitPattern: RawExponent, significandBitPattern: RawSignificand) {
        self.init(kind: .radians,
                  value: .init(sign: sign, exponentBitPattern: exponentBitPattern, significandBitPattern: significandBitPattern))
    }
}

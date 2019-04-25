import XCTest
@testable import FFFoundation

final class AngleTests: XCTestCase {
    func testAngleIsCorrectlyExpressibleAsLiterals() {
        let intLiteral: Angle<Double> = 1
        let fltLiteral: Angle<Double> = 1.34

        XCTAssertEqual(intLiteral.value, 1)
        XCTAssertEqual(intLiteral.value, intLiteral.asRadians.value)
        XCTAssertEqual(fltLiteral.value, 1.34)
        XCTAssertEqual(fltLiteral.value, fltLiteral.asRadians.value)
    }

    func testAngleConvertsCorrectly() {
        let degrees = Angle<Double>(degrees: 90)
        let radians = Angle<Double>(radians: .pi / 2)

        XCTAssertEqual(radians.asDegrees.value, 90, accuracy: .ulpOfOne)
        XCTAssertEqual(degrees.asRadians.value, .pi / 2, accuracy: .ulpOfOne)
        XCTAssertEqual(radians.asRadians.value, .pi / 2, accuracy: .ulpOfOne)
        XCTAssertEqual(degrees.asDegrees.value, 90, accuracy: .ulpOfOne)
        XCTAssertEqual(radians.converted().value, 90, accuracy: .ulpOfOne)
        XCTAssertEqual(degrees.converted().value, .pi / 2, accuracy: .ulpOfOne)
    }

    func testAngleComparesCorrectlyBetweenKinds() {
        let degrees = Angle<Double>(degrees: 90)
        let radians = Angle<Double>(radians: .pi / 2)
        XCTAssertEqual(degrees, radians, accuracy: .ulpOfOne)
        XCTAssertEqual(degrees == radians, degrees.isEqual(to: radians))
    }

    func testAngleHashesBasedOnRadians() {
        let degrees = Angle<Double>(degrees: 90)
        let radians = Angle<Double>(radians: .pi / 2)
        XCTAssertEqual(Set([degrees, radians]).count, 1)
    }

    func testAngleSumsCorrectlyBetweenKinds() {
        let base = Angle<Double>(radians: .pi / 2)
        let sum = base + .degrees(1)
        XCTAssertEqual(sum, .radians(base.value + (.pi / 180)), accuracy: .ulpOfOne)
    }

    func testAngleSubtractsCorrectlyBetweenKinds() {
        let base = Angle<Double>(radians: .pi / 2)
        let difference = base - .degrees(1)
        XCTAssertEqual(difference, .radians(base.value - (.pi / 180)), accuracy: .ulpOfOne)
    }

    func testAngleMultipliesCorrectlyBetweenKinds() {
        let base = Angle<Double>(radians: .pi / 2)
        let multiplied = base * .degrees(1)
        XCTAssertEqual(multiplied, .radians(base.value * (.pi / 180)), accuracy: .ulpOfOne)
    }

    func testAngleDividesCorrectlyBetweenKinds() {
        let base = Angle<Double>(radians: .pi / 2)
        let division = base / .degrees(1)
        XCTAssertEqual(division, .radians(base.value / (.pi / 180)), accuracy: .ulpOfOne)
    }

    func testAngleFloatingPointConformance() {
        typealias TestAngle = Angle<Double>
        let testAngle = TestAngle(degrees: 90)
        XCTAssertEqual(TestAngle.radix, Double.radix)
        XCTAssertEqual(TestAngle.nan.isNaN, TestAngle.radians(.nan).isNaN)
        XCTAssertEqual(TestAngle.signalingNaN.isSignalingNaN, TestAngle.radians(.signalingNaN).isSignalingNaN)
        XCTAssertEqual(TestAngle.infinity, .radians(.infinity))
        XCTAssertEqual(TestAngle.pi, .radians(.pi))
        XCTAssertEqual(TestAngle.greatestFiniteMagnitude, .radians(.greatestFiniteMagnitude))
        XCTAssertEqual(TestAngle.leastNonzeroMagnitude, .radians(.leastNonzeroMagnitude))
        XCTAssertEqual(TestAngle.leastNormalMagnitude, .radians(.leastNormalMagnitude))
        XCTAssertEqual(testAngle.exponent, testAngle.value.exponent)
        XCTAssertEqual(testAngle.sign, testAngle.value.sign)
        XCTAssertEqual(testAngle.isNormal, testAngle.value.isNormal)
        XCTAssertEqual(testAngle.isFinite, testAngle.value.isFinite)
        XCTAssertEqual(testAngle.isZero, testAngle.value.isZero)
        XCTAssertEqual(testAngle.isSubnormal, testAngle.value.isSubnormal)
        XCTAssertEqual(testAngle.isInfinite, testAngle.value.isInfinite)
        XCTAssertEqual(testAngle.isNaN, testAngle.value.isNaN)
        XCTAssertEqual(testAngle.isSignalingNaN, testAngle.value.isSignalingNaN)
        XCTAssertEqual(testAngle.isCanonical, testAngle.value.isCanonical)
        XCTAssertEqual(testAngle.magnitude, .degrees(testAngle.value.magnitude))
        XCTAssertEqual(testAngle.ulp, .degrees(testAngle.value.ulp))
        XCTAssertEqual(testAngle.significand, .degrees(testAngle.value.significand))
        XCTAssertEqual(testAngle.nextUp, .degrees(testAngle.value.nextUp))
        XCTAssertEqual(testAngle.nextDown, .degrees(testAngle.value.nextDown))
    }
}

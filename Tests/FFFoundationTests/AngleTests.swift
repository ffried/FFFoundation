import Testing
@testable import FFFoundation

@Suite
struct AngleTests {
    @Test
    func angleIsCorrectlyExpressibleAsLiterals() {
        let intLiteral: Angle<Double> = 1
        let fltLiteral: Angle<Double> = 1.34

        #expect(intLiteral.value == 1)
        #expect(intLiteral.value == intLiteral.asRadians.value)
        #expect(fltLiteral.value == 1.34)
        #expect(fltLiteral.value == fltLiteral.asRadians.value)
    }

    @Test
    func angleConvertsCorrectly() {
        let degrees = Angle<Double>(degrees: 90)
        let radians = Angle<Double>(radians: .pi / 2)

        #expect(abs(radians.asDegrees.value.distance(to: 90)) <= .ulpOfOne)
        #expect(abs(degrees.asRadians.value.distance(to: .pi / 2)) <= .ulpOfOne)
        #expect(abs(radians.asRadians.value.distance(to: .pi / 2)) <= .ulpOfOne)
        #expect(abs(degrees.asDegrees.value.distance(to: 90)) <= .ulpOfOne)
        #expect(abs(radians.converted().value.distance(to: 90)) <= .ulpOfOne)
        #expect(abs(degrees.converted().value.distance(to: .pi / 2)) <= .ulpOfOne)
    }

    @Test
    func angleComparesCorrectlyBetweenKinds() {
        let degrees = Angle<Double>(degrees: 90)
        let radians = Angle<Double>(radians: .pi / 2)
        #expect(abs(degrees.distance(to: radians)) <= .ulpOfOne)
        #expect((degrees == radians) == degrees.isEqual(to: radians))
    }

    @Test
    func angleHashesBasedOnRadians() {
        let degrees = Angle<Double>(degrees: 90)
        let radians = Angle<Double>(radians: .pi / 2)
        #expect(Set([degrees, radians]).count == 1)
    }

    @Test
    func angleSumsCorrectlyBetweenKinds() {
        let base = Angle<Double>(radians: .pi / 2)
        let sum = base + .degrees(1)
        #expect(abs(sum.distance(to: .radians(base.value + (.pi / 180)))) <= .ulpOfOne)
    }

    @Test
    func angleSubtractsCorrectlyBetweenKinds() {
        let base = Angle<Double>(radians: .pi / 2)
        let difference = base - .degrees(1)
        #expect(abs(difference.distance(to: .radians(base.value - (.pi / 180)))) <= .ulpOfOne)
    }

    @Test
    func angleMultipliesCorrectlyBetweenKinds() {
        let base = Angle<Double>(radians: .pi / 2)
        let multiplied = base * .degrees(1)
        #expect(abs(multiplied.distance(to: .radians(base.value * (.pi / 180)))) <= .ulpOfOne)
    }

    @Test
    func angleDividesCorrectlyBetweenKinds() {
        let base = Angle<Double>(radians: .pi / 2)
        let division = base / .degrees(1)
        #expect(abs(division.distance(to: .radians(base.value / (.pi / 180)))) <= .ulpOfOne)
    }

    @Test
    func angleFloatingPointConformance() {
        typealias TestAngle = Angle<Double>
        let testAngle = TestAngle(degrees: 90)
        #expect(TestAngle.radix == Double.radix)
        #expect(TestAngle.nan.isNaN == TestAngle.radians(.nan).isNaN)
        #expect(TestAngle.signalingNaN.isSignalingNaN == TestAngle.radians(.signalingNaN).isSignalingNaN)
        #expect(TestAngle.infinity == .radians(.infinity))
        #expect(TestAngle.pi == .radians(.pi))
        #expect(TestAngle.greatestFiniteMagnitude == .radians(.greatestFiniteMagnitude))
        #expect(TestAngle.leastNonzeroMagnitude == .radians(.leastNonzeroMagnitude))
        #expect(TestAngle.leastNormalMagnitude == .radians(.leastNormalMagnitude))
        #expect(testAngle.exponent == testAngle.value.exponent)
        #expect(testAngle.sign == testAngle.value.sign)
        #expect(testAngle.isNormal == testAngle.value.isNormal)
        #expect(testAngle.isFinite == testAngle.value.isFinite)
        #expect(testAngle.isZero == testAngle.value.isZero)
        #expect(testAngle.isSubnormal == testAngle.value.isSubnormal)
        #expect(testAngle.isInfinite == testAngle.value.isInfinite)
        #expect(testAngle.isNaN == testAngle.value.isNaN)
        #expect(testAngle.isSignalingNaN == testAngle.value.isSignalingNaN)
        #expect(testAngle.isCanonical == testAngle.value.isCanonical)
        #expect(testAngle.magnitude == .degrees(testAngle.value.magnitude))
        #expect(testAngle.ulp == .degrees(testAngle.value.ulp))
        #expect(testAngle.significand == .degrees(testAngle.value.significand))
        #expect(testAngle.nextUp == .degrees(testAngle.value.nextUp))
        #expect(testAngle.nextDown == .degrees(testAngle.value.nextDown))
    }
}

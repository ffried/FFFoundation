import XCTest

extension DiffTests {
    static let __allTests = [
        ("testChangeAnnotation", testChangeAnnotation),
        ("testChangeLignSign", testChangeLignSign),
        ("testMoreAdvancedDiff", testMoreAdvancedDiff),
        ("testSimpleDiff", testSimpleDiff),
    ]
}

extension StringClassesExtensionTests {
    static let __allTests = [
        ("testStringCreatingFromClassRemovingNamespace", testStringCreatingFromClassRemovingNamespace),
        ("testStringCreatingFromClassWithoutRemovingNamespace", testStringCreatingFromClassWithoutRemovingNamespace),
    ]
}

extension TimerTests {
    static let __allTests = [
        ("testRepeatingTimerWithShortIntervalAndTolerance", testRepeatingTimerWithShortIntervalAndTolerance),
        ("testTimerWithShortIntervalAndNoTolerance", testTimerWithShortIntervalAndNoTolerance),
        ("testTimerWithShortIntervalAndTolerance", testTimerWithShortIntervalAndTolerance),
    ]
}

extension TriangleTests {
    static let __allTests = [
        ("testOrthogonalTriangleCalculation", testOrthogonalTriangleCalculation),
        ("testOrthogonalTriangleWithSinglePoint", testOrthogonalTriangleWithSinglePoint),
        ("testTriangleWithAllPointsBeingTheSame", testTriangleWithAllPointsBeingTheSame),
        ("testTriangleWithAllPointsGiven", testTriangleWithAllPointsGiven),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DiffTests.__allTests),
        testCase(StringClassesExtensionTests.__allTests),
        testCase(TimerTests.__allTests),
        testCase(TriangleTests.__allTests),
    ]
}
#endif

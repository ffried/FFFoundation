#if !os(Linux) && !swift(>=5.2)
// Unfortunately, Darwin XCTest does not really support *all* FloatingPoint types before Swift 5.2.
// https://github.com/apple/swift/blob/master/stdlib/public/Darwin/XCTest/XCTest.swift#L379

import XCTest

internal func XCTAssertEqual<T: FloatingPoint>(_ expression1: @autoclosure () throws -> T, _ expression2: @autoclosure () throws -> T, accuracy: T, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssertNoThrow(try {
        let (value1, value2) = (try expression1(), try expression2())
        XCTAssert(!value1.isNaN && !value2.isNaN && abs(value1 - value2) <= accuracy,
                  message().isEmpty ? "(\"\(value1)\") is not equal to (\"\(value2)\") +/- (\"\(accuracy)\")" : message(),
                  file: file, line: line
        )
        }(), file: file, line: line)
}
internal func XCTAssertNotEqual<T: FloatingPoint>(_ expression1: @autoclosure () throws -> T, _ expression2: @autoclosure () throws -> T, accuracy: T, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssertNoThrow(try {
        let (value1, value2) = (try expression1(), try expression2())
        XCTAssert(value1.isNaN || value2.isNaN || abs(value1 - value2) > accuracy,
                  message().isEmpty ? "(\"\(value1)\") is equal to (\"\(value2)\") +/- (\"\(accuracy)\")" : message(),
                  file: file, line: line
        )
        }(), file: file, line: line)
}
#endif

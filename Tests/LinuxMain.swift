import XCTest
@testable import FFFoundationTests

XCTMain([
     testCase(FFFoundationTests.allTests),
     testCase(TimerTests.allTests)
])

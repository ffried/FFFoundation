//
//  TimerTests.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 14/03/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import XCTest
import FFFoundation

class TimerTests: XCTestCase {
    
    var timer: Timer? = nil

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTimerWithShortIntervalAndNoTolerance() {
        let expectation = expectationWithDescription("Timer with short interval and no tolerance")
        var date = NSDate()
        let timerInterval: NSTimeInterval = 2.0
        let isMainThread = NSThread.isMainThread()
        timer = Timer(interval: timerInterval, block: { timer in
            let interval = NSDate().timeIntervalSinceDate(date)
            XCTAssertEqualWithAccuracy(interval, timerInterval, accuracy: 0.02)
            XCTAssertEqual(NSThread.isMainThread(), isMainThread)
            expectation.fulfill()
        })
        date = NSDate()
        timer?.schedule()
        waitForExpectationsWithTimeout(timerInterval * 2, handler: nil)
    }
    
    func testTimerWithShortIntervalAndTolerance() {
        let expectation = expectationWithDescription("Timer with short interval and tolerance")
        var date = NSDate()
        let timerInterval: NSTimeInterval = 2.0
        let tolerance: NSTimeInterval = 0.5
        timer = Timer(interval: timerInterval, block: { timer in
            let interval = NSDate().timeIntervalSinceDate(date)
            XCTAssertEqualWithAccuracy(interval, timerInterval, accuracy: tolerance)
            expectation.fulfill()
        })
        timer?.tolerance = tolerance
        date = NSDate()
        timer?.schedule()
        waitForExpectationsWithTimeout(timerInterval * 2, handler: nil)
    }
    
    func testRepeatingTimerWithShortIntervalAndTolerance() {
        let expectation = expectationWithDescription("Repeating Timer with short interval and tolerance")
        var date = NSDate()
        let timerInterval: NSTimeInterval = 2.0
        let tolerance: NSTimeInterval = 0.5
        let repeats = 5
        var counter = 0
        timer = Timer(interval: timerInterval, repeats: true, block: { timer in
            let interval = NSDate().timeIntervalSinceDate(date)
            XCTAssertEqualWithAccuracy(interval, timerInterval, accuracy: tolerance)
            counter += 1
            date = NSDate()
            if counter == repeats {
                timer.invalidate()
                expectation.fulfill()
            }
        })
        timer?.tolerance = tolerance
        date = NSDate()
        timer?.schedule()
        waitForExpectationsWithTimeout(timerInterval * 2 * NSTimeInterval(repeats), handler: nil)
        XCTAssertEqual(counter, repeats)
    }
}

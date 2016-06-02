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
    
    var timer: AnyTimer? = nil

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTimerWithShortIntervalAndNoTolerance() {
        #if swift(>=3.0)
            let exp = expectation(withDescription: "Timer with short interval and no tolerance")
        #else
            let exp = expectationWithDescription("Timer with short interval and no tolerance")
        #endif
            
        var date = NSDate()
        let timerInterval: NSTimeInterval = 2.0
        let isMainThread = NSThread.isMainThread()
        timer = AnyTimer(interval: timerInterval, block: { timer in
            #if swift(>=3.0)
                let interval = NSDate().timeIntervalSince(date)
            #else
                let interval = NSDate().timeIntervalSinceDate(date)
            #endif
            XCTAssertEqualWithAccuracy(interval, timerInterval, accuracy: 0.02)
            XCTAssertEqual(NSThread.isMainThread(), isMainThread)
            exp.fulfill()
        })
        date = NSDate()
        timer?.schedule()
        #if swift(>=3.0)
            waitForExpectations(withTimeout: timerInterval * 2, handler: nil)
        #else
            waitForExpectationsWithTimeout(timerInterval * 2, handler: nil)
        #endif
    }
    
    func testTimerWithShortIntervalAndTolerance() {
        #if swift(>=3.0)
            let exp = expectation(withDescription: "Timer with short interval and tolerance")
        #else
            let exp = expectationWithDescription("Timer with short interval and tolerance")
        #endif
        
        var date = NSDate()
        let timerInterval: NSTimeInterval = 2.0
        let tolerance: NSTimeInterval = 0.5
        timer = AnyTimer(interval: timerInterval, block: { timer in
            #if swift(>=3.0)
                let interval = NSDate().timeIntervalSince(date)
            #else
                let interval = NSDate().timeIntervalSinceDate(date)
            #endif
            XCTAssertEqualWithAccuracy(interval, timerInterval, accuracy: tolerance)
            exp.fulfill()
        })
        timer?.tolerance = tolerance
        date = NSDate()
        timer?.schedule()
        #if swift(>=3.0)
            waitForExpectations(withTimeout: timerInterval * 2, handler: nil)
        #else
            waitForExpectationsWithTimeout(timerInterval * 2, handler: nil)
        #endif
    }
    
    func testRepeatingTimerWithShortIntervalAndTolerance() {
        #if swift(>=3.0)
            let exp = expectation(withDescription: "Repeating Timer with short interval and tolerance")
        #else
            let exp = expectationWithDescription("Repeating Timer with short interval and tolerance")
        #endif
        
        var date = NSDate()
        let timerInterval: NSTimeInterval = 2.0
        let tolerance: NSTimeInterval = 0.5
        let repeats = 5
        var counter = 0
        timer = AnyTimer(interval: timerInterval, repeats: true, block: { timer in
            #if swift(>=3.0)
                let interval = NSDate().timeIntervalSince(date)
            #else
                let interval = NSDate().timeIntervalSinceDate(date)
            #endif
            XCTAssertEqualWithAccuracy(interval, timerInterval, accuracy: tolerance)
            counter += 1
            date = NSDate()
            if counter == repeats {
                timer.invalidate()
                exp.fulfill()
            }
        })
        timer?.tolerance = tolerance
        date = NSDate()
        timer?.schedule()
        #if swift(>=3.0)
            waitForExpectations(withTimeout: timerInterval * 2, handler: nil)
        #else
            waitForExpectationsWithTimeout(timerInterval * 2, handler: nil)
        #endif
        XCTAssertEqual(counter, repeats)
    }
}

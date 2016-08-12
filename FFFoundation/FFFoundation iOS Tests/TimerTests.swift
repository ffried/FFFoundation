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
            let exp = expectation(description: "Timer with short interval and no tolerance")
            var date = Date()
            let timerInterval: TimeInterval = 2.0
            let isMainThread = Thread.isMainThread
        #else
            let exp = expectationWithDescription("Timer with short interval and no tolerance")
            var date = NSDate()
            let timerInterval: NSTimeInterval = 2.0
            let isMainThread = NSThread.isMainThread()
        #endif
        timer = AnyTimer(interval: timerInterval, block: { timer in
            #if swift(>=3.0)
                let interval = Date().timeIntervalSince(date)
                XCTAssertEqual(Thread.isMainThread, isMainThread)
            #else
                let interval = NSDate().timeIntervalSinceDate(date)
                XCTAssertEqual(NSThread.isMainThread(), isMainThread)
            #endif
            XCTAssertEqualWithAccuracy(interval, timerInterval, accuracy: 0.02)
            
            exp.fulfill()
        })
        
        #if swift(>=3.0)
            date = Date()
            timer?.schedule()
            waitForExpectations(timeout: timerInterval * 2, handler: nil)
        #else
            date = NSDate()
            timer?.schedule()
            waitForExpectationsWithTimeout(timerInterval * 2, handler: nil)
        #endif
    }
    
    func testTimerWithShortIntervalAndTolerance() {
        #if swift(>=3.0)
            let exp = expectation(description: "Timer with short interval and tolerance")
            var date = Date()
            let timerInterval: TimeInterval = 2.0
            let tolerance: TimeInterval = 0.5
        #else
            let exp = expectationWithDescription("Timer with short interval and tolerance")
            var date = NSDate()
            let timerInterval: NSTimeInterval = 2.0
            let tolerance: NSTimeInterval = 0.5
        #endif
        
        
        timer = AnyTimer(interval: timerInterval, block: { timer in
            #if swift(>=3.0)
                let interval = Date().timeIntervalSince(date)
            #else
                let interval = NSDate().timeIntervalSinceDate(date)
            #endif
            XCTAssertEqualWithAccuracy(interval, timerInterval, accuracy: tolerance)
            exp.fulfill()
        })
        timer?.tolerance = tolerance
        #if swift(>=3.0)
            date = Date()
            timer?.schedule()
            waitForExpectations(timeout: timerInterval * 2, handler: nil)
        #else
            date = NSDate()
            timer?.schedule()
            waitForExpectationsWithTimeout(timerInterval * 2, handler: nil)
        #endif
    }
    
    func testRepeatingTimerWithShortIntervalAndTolerance() {
        #if swift(>=3.0)
            let exp = expectation(description: "Repeating Timer with short interval and tolerance")
            var date = Date()
            let timerInterval: TimeInterval = 2.0
            let tolerance: TimeInterval = 0.5
            var accuracies = Array<TimeInterval>()
        #else
            let exp = expectationWithDescription("Repeating Timer with short interval and tolerance")
            var date = NSDate()
            let timerInterval: NSTimeInterval = 2.0
            let tolerance: NSTimeInterval = 0.5
            var accuracies = Array<NSTimeInterval>()
        #endif
        
        
        let repeats = 5
        var counter = 0
        timer = AnyTimer(interval: timerInterval, repeats: true, block: { timer in
            #if swift(>=3.0)
                let interval = Date().timeIntervalSince(date)
                date = Date()
            #else
                let interval = NSDate().timeIntervalSinceDate(date)
                date = NSDate()
            #endif
            accuracies.append(interval)
            counter += 1
            if counter == repeats {
                timer.invalidate()
                exp.fulfill()
            }
        })
        timer?.tolerance = tolerance
        #if swift(>=3.0)
            date = Date()
            timer?.schedule()
            waitForExpectations(timeout: timerInterval * TimeInterval(repeats) * 2, handler: nil)
        #else
            date = NSDate()
            timer?.schedule()
            waitForExpectationsWithTimeout(timerInterval * NSTimeInterval(repeats) * 2, handler: nil)
        #endif
        XCTAssertEqual(counter, repeats)
        XCTAssertEqual(accuracies.count, repeats)
        accuracies.forEach {
            XCTAssertEqualWithAccuracy($0, timerInterval, accuracy: tolerance + 0.09)
        }
    }
}

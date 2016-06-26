//
//  Timer.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 14/03/16.
//  Copyright 2016 Florian Friedrich
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

import Foundation
import libkern
#if !swift(>=3)
public final class Timer<T> {
    public typealias TimerBlock = (Timer) -> Void
    
    #if swift(>=3)
    public let interval: TimeInterval
    #else
    public let interval: NSTimeInterval
    #endif
    public let repeats: Bool
    public let block: TimerBlock
    
    public var userInfo: T?
    
    public private(set) var isValid = true
    
    #if swift(>=3.0)
    public var tolerance: TimeInterval = 0.0 {
        didSet { applyTimerProperties() }
    }
    
    private let queue = DispatchQueue(label: "FFFoundation.Timer.Queue", attributes: [.serial])
    private lazy var timer: DispatchSourceTimer = DispatchSource.timer(flags: [.strict], queue: self.queue)
    #else
    public var tolerance: NSTimeInterval = 0.0 {
        didSet { applyTimerProperties() }
    }
    
    private let queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
    private lazy var timer: dispatch_source_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, DISPATCH_TIMER_STRICT, self.queue)
    #endif
    
    #if swift(>=3)
    public init(interval: TimeInterval, repeats: Bool = false, queue: DispatchQueue = .main, userInfo: T? = nil, block: TimerBlock) {
        self.interval = interval
        self.repeats = repeats
        self.userInfo = userInfo
        self.block = block
        self.queue.setTarget(queue: queue)
    }
    #else
    public init(interval: NSTimeInterval, repeats: Bool = false, queue: dispatch_queue_t = dispatch_get_main_queue(), userInfo: T? = nil, block: TimerBlock) {
        self.interval = interval
        self.repeats = repeats
        self.userInfo = userInfo
        self.block = block
        dispatch_set_target_queue(self.queue, queue)
    }
    #endif
    
    deinit {
        invalidate()
    }
    
    #if swift(>=3)
    private final func applyTimerProperties() {
        let nsInterval = UInt64(interval) * NSEC_PER_SEC
        let nsTolerance = UInt64(tolerance) * NSEC_PER_SEC
        let time = DispatchTime.now() + Double(Int64(nsInterval)) / Double(NSEC_PER_SEC)
//        timer.sched
        timer.setTimer(time, nsInterval, nsTolerance)
//        dispatch_source_set_timer(timer, time, nsInterval, nsTolerance);
    }
    #else
    private final func applyTimerProperties() {
        let nsInterval = UInt64(interval) * NSEC_PER_SEC
        let nsTolerance = UInt64(tolerance) * NSEC_PER_SEC
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(nsInterval))
        dispatch_source_set_timer(timer, time, nsInterval, nsTolerance);
    }
    #endif
    
    public func schedule() {
        applyTimerProperties()
        dispatch_source_set_event_handler(timer) { [weak self] in
            self?.performFire()
        }
        dispatch_resume(timer)
    }
    
    public func invalidate() {
        guard isValid else { return }
        let t = timer
        dispatch_async(queue) { dispatch_source_cancel(t) }
        isValid = false
    }
    
    private final func performFire() {
        guard isValid else { return }
        block(self)
        if !repeats {
            invalidate()
        }
    }
    
    public func fire() {
        performFire()
    }
}

public typealias AnyTimer = Timer<Any>
#endif

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

import typealias Foundation.TimeInterval
import Dispatch

public final class Timer<T> {
    public typealias Block = (Timer) -> ()
    
    public let interval: TimeInterval
    public let repeats: Bool
    public let block: Block
    
    public var userInfo: T?
    
    public private(set) var isValid = true
    
    public var tolerance: TimeInterval = 0.0 {
        didSet { applyTimerProperties() }
    }
    
    private let queue: DispatchQueue
    private lazy var timer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [.strict], queue: self.queue)
    
    public init(interval: TimeInterval, repeats: Bool = false, queue: DispatchQueue = .main, userInfo: T? = nil, block: @escaping Block) {
        self.interval = interval
        self.repeats = repeats
        self.userInfo = userInfo
        self.block = block
        self.queue = DispatchQueue(label: "net.ffried.fffoundation.timer.queue", target: queue)
    }
    
    deinit {
        invalidate()
    }
    
    private final func applyTimerProperties() {
        let nsInterval = Int(interval * TimeInterval(NSEC_PER_SEC))
        let nsTolerance = Int(tolerance * TimeInterval(NSEC_PER_SEC))
        timer.schedule(deadline: .now() + interval, repeating: .nanoseconds(nsInterval), leeway: .nanoseconds(nsTolerance))
    }

    public func schedule() {
        applyTimerProperties()
        timer.setEventHandler { [weak self] in
            self?.performFire()
        }
        timer.resume()
    }
    
    public func invalidate() {
        guard isValid else { return }
        queue.async { [timer] in timer.cancel() }
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

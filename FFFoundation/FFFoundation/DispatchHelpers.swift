//
//  DispatchHelpers.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 30/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import Foundation

/**
 Delay a block by a certain time by using `dispatch_after`.
 
 - parameter delay: The time to delay the execution of `block`. Defaults to `0.0`.
 - parameter block: The block to execute after `delay`.
 - seeAlso: dispatch_after
 */
#if swift(>=3.0)
    public func delay(by delay: Double = 0.0, block: @convention(block) () -> Void) {
        DispatchQueue.main.after(when:
            DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            , execute: block)
    }
#else
    public func delay(delay: Double = 0.0, block: dispatch_block_t) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            block)
    }
#endif

/**
 Runs a block on the main queue.
 
 - parameter sync:  Whether or not `block` should be dispatched synchronously. Defaults to `false`.
 - parameter block: The block to execute on the main queue.
 - seeAlso: dispatch_sync
 - seeAlso: dispatch_async
 - seeAlso: dispatch_get_main_queue
 */
#if swift(>=3.0)
@available(*, deprecated, message: "Use GCD directly.")
public func runOnMainQueue(sync: Bool = false, block: () -> Void) {
    let queue = DispatchQueue.main
    if sync {
        queue.sync(execute: block)
    } else {
        queue.async(execute: block)
    }
}
#else
public func runOnMainQueue(sync: Bool = false, block: dispatch_block_t) {
    let funcToCall = sync ? dispatch_sync : dispatch_async
    funcToCall(dispatch_get_main_queue(), block)
}
#endif

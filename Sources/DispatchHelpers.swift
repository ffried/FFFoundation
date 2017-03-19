//
//  DispatchHelpers.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 30/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import class Dispatch.DispatchQueue

/**
 Delay a block by a certain time by using `dispatch_after`.
 
 - parameter delay: The time to delay the execution of `block`. Defaults to `0.0`.
 - parameter block: The block to execute after `delay` (in seconds).
 - seeAlso: dispatch_after
 */
public func delay(by delay: Double = 0.0, block: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
}

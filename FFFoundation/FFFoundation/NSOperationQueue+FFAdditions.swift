//
//  NSOperationQueue+FFAdditions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 10.12.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

import Foundation

public extension NSOperationQueue {
    public var isMainQueue: Bool {
        return self == NSOperationQueue.mainQueue()
    }
    
    public var isCurrentQueue: Bool {
        if let queue = NSOperationQueue.currentQueue() {
            return self == queue
        }
        return false
    }
    
    public static func isCurrentQueueMainQueue() -> Bool {
        return NSOperationQueue.currentQueue()?.isMainQueue ?? false
    }
    
    public func addOperationWithBlock(block: () -> (), completion: () -> ()) {
        let operation = NSBlockOperation(block: block)
        operation.completionBlock = completion
        addOperation(operation)
    }
    
    public func addOperationWithBlockAndWait(block: () -> ()) {
        let operation = NSBlockOperation(block: block)
        addOperations([operation], waitUntilFinished: true)
    }
    
    public func addOperationWithBlockAndWaitIfNotCurrentQueue(block: () -> ()) {
        let operation = NSBlockOperation(block: block)
        addOperations([operation], waitUntilFinished: !isCurrentQueue)
    }
}

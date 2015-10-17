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
        return self === self.dynamicType.mainQueue()
    }
    
    public var isCurrentQueue: Bool {
        if let queue = self.dynamicType.currentQueue() {
            return self === queue
        }
        return false
    }
    
    public static func isCurrentQueueMainQueue() -> Bool {
        return self.mainQueue().isCurrentQueue
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

//
//  NSOperationQueue+FFAdditions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 10.12.14.
//  Copyright 2014 Florian Friedrich
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

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
        #if swift(>=3.0)
            return self === self.dynamicType.main()
        #else
            return self === self.dynamicType.mainQueue()
        #endif
    }
    
    public var isCurrentQueue: Bool {
        #if swift(>=3.0)
            return self.dynamicType.current().flatMap { $0 === self } ?? false
        #else
            return self.dynamicType.currentQueue().flatMap { $0 === self } ?? false
        #endif
    }
    
    public static var isCurrentQueueMainQueue: Bool {
        #if swift(>=3.0)
            return main().isCurrentQueue
        #else
            return mainQueue().isCurrentQueue
        #endif
    }
    
    #if swift(>=3.0)
    public func addOperation(withBlock block: () -> (), completion: () -> ()) {
        let operation = NSBlockOperation(block: block)
        operation.completionBlock = completion
        addOperation(operation)
    }
    #else
    public func addOperationWithBlock(block: () -> (), completion: () -> ()) {
        let operation = NSBlockOperation(block: block)
        operation.completionBlock = completion
        addOperation(operation)
    }
    #endif
    
    public func addOperationWithBlockAndWait(block: () -> ()) {
        #if swift(>=3.0)
            addOperation(withBlock: block, andWait: true)
        #else
            addOperationWithBlock(block, andWait: true)
        #endif
    }
    
    public func addOperationWithBlockAndWaitIfNotCurrentQueue(block: () -> ()) {
        #if swift(>=3.0)
            addOperation(withBlock: block, andWait: !isCurrentQueue)
        #else
            addOperationWithBlock(block, andWait: true)
        #endif
    }
    
    #if swift(>=3.0)
    private final func addOperation(withBlock block: () -> (), andWait wait: Bool) {
        let operation = NSBlockOperation(block: block)
        addOperations([operation], waitUntilFinished: wait)
    }
    #else
    private final func addOperationWithBlock(block: () -> (), andWait wait: Bool) {
        let operation = NSBlockOperation(block: block)
        addOperations([operation], waitUntilFinished: wait)
    }
    #endif
    
    
}

//
//  NotificationObserver.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 11.2.15.
//  Copyright 2015 Florian Friedrich
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

public class NotificationObserver {
    public typealias ObserverBlock = (NSNotification) -> Void
    
    private let observer: NSObjectProtocol
    public let notificationCenter: NSNotificationCenter
    public let notificationName: String?
    public let object: AnyObject?
    
    public init(center: NSNotificationCenter, name: String? = nil, queue: NSOperationQueue? = nil, object: AnyObject? = nil, block: ObserverBlock) {
        self.notificationCenter = center
        self.notificationName = name
        self.object = object
        #if swift(>=3.0)
            self.observer = center.addObserver(forName: name, object: object, queue: queue, using: block)
        #else
            self.observer = center.addObserverForName(name, object: object, queue: queue, usingBlock: block)
        #endif
    }
    
    deinit {
        notificationCenter.removeObserver(observer, name: notificationName, object: object)
    }
}

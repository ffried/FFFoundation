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

import struct Foundation.Notification
import class Foundation.NotificationCenter
import class Foundation.OperationQueue
import protocol Foundation.NSObjectProtocol

public final class NotificationObserver {
    public typealias ObserverBlock = (Notification) -> Void
    
    private let observer: NSObjectProtocol
    public let notificationCenter: NotificationCenter
    public let notificationName: Notification.Name?
    public let object: Any?
    
    public init(center: NotificationCenter, name: Notification.Name? = nil, queue: OperationQueue? = nil, object: Any? = nil, block: @escaping ObserverBlock) {
        self.notificationCenter = center
        self.notificationName = name
        self.object = object
        self.observer = center.addObserver(forName: name, object: object, queue: queue, using: block)
    }
    
    deinit {
        notificationCenter.removeObserver(observer, name: notificationName, object: object)
    }
}

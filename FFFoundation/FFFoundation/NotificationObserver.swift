//
//  NotificationObserver.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 11.2.15.
//  Copyright (c) 2015 Florian Friedrich. All rights reserved.
//

import Foundation

public class NotificationObserver {
    public typealias ObserverBlock = (NSNotification!) -> Void
    
    private let observer: NSObjectProtocol
    public let notificationCenter: NSNotificationCenter
    public let notificationName: String?
    public let object: AnyObject?
    
    public init(center: NSNotificationCenter, name: String? = nil, queue: NSOperationQueue? = nil, object: AnyObject? = nil, block: ObserverBlock) {
        self.notificationCenter = center
        self.notificationName = name
        self.object = object
        self.observer = center.addObserverForName(name, object: object, queue: queue, usingBlock: block)
    }
    
    deinit {
        notificationCenter.removeObserver(observer, name: notificationName, object: object)
    }
}

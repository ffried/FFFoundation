//
//  FunctionsAndHelpers.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 9.12.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

import Foundation

public func delay(delay: Double, block: () -> ()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        block)
}

public func localizedString(key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: comment)
}

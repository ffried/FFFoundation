//
//  NSDate+Extensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 26/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import Foundation

extension NSDate: Comparable {}

@warn_unused_result
public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return !lhs.isEqualToDate(rhs) && lhs.earlierDate(rhs).isEqualToDate(lhs)
}

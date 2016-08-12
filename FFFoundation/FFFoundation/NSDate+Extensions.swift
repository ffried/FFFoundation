//
//  NSDate+Extensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 26/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

#if !swift(>=3.0)
import Foundation

extension NSDate: Comparable {}

@warn_unused_result
public func <(lhs: NSDate, rhs: NSDate) -> Bool {
//#if swift(>=3.0)
//    return !lhs.isEqual(to: rhs) && (lhs.earlierDate(rhs as Date) as NSDate).isEqual(to: lhs)
//#else
    return !lhs.isEqualToDate(rhs) && lhs.earlierDate(rhs).isEqualToDate(lhs)
//#endif
}
#endif

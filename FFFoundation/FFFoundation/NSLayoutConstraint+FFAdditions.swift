//
//  NSLayoutConstraint+FFAdditions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 12.12.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

import FFFoundation

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

public extension NSLayoutConstraint {
    public class func constraintsWithVisualFormats(formats: [String], metrics: [NSObject: AnyObject]?, views: [NSObject: AnyObject]) -> [AnyObject] {
        return formats.reduce([AnyObject]()) { constraints, format in
            return constraints + self.constraintsWithVisualFormat(format, options: nil, metrics: metrics, views: views)
        }
    }
}

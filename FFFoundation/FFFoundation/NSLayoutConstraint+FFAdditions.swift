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
    #if os(iOS)
    typealias FloatType = CGFloat
    typealias View = UIView
    #else
    typealias FloatType = Float
    typealias View = NSView
    #endif
    
    private static let defaultOptions = NSLayoutFormatOptions.DirectionLeadingToTrailing
    public static func constraintsWithVisualFormats(formats: [String], metrics: [String: FloatType]?, views: [String: View]) -> [NSLayoutConstraint] {
        return formats.reduce([NSLayoutConstraint]()) {
            $0 + constraintsWithVisualFormat($1, options: defaultOptions, metrics: metrics, views: views)
        }
    }
}

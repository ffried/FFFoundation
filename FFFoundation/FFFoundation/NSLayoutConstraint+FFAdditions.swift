//
//  NSLayoutConstraint+FFAdditions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 12.12.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif
import CoreGraphics

public extension NSLayoutConstraint {
#if os(iOS)
    typealias View = UIView
#elseif os(OSX)
    typealias View = NSView
#endif
    typealias MetricValueType = CGFloat
    
    public static func constraintsWithVisualFormats(formats: [String], options: NSLayoutFormatOptions = [], metrics: [String: MetricValueType]? = nil, views: [String: View]) -> [NSLayoutConstraint] {
        return formats.reduce([NSLayoutConstraint]()) {
            $0 + constraintsWithVisualFormat($1, options: options, metrics: metrics, views: views)
        }
    }
}

public extension SequenceType where Generator.Element == NSLayoutConstraint {
    public func activate() {
        NSLayoutConstraint.activateConstraints(Array(self))
    }
    
    public func deactivate() {
        NSLayoutConstraint.deactivateConstraints(Array(self))
    }
}

public extension SequenceType where Generator.Element == String {
    public func constraintsWithViews(views: [String: NSLayoutConstraint.View], options: NSLayoutFormatOptions = [], metrics: [String: NSLayoutConstraint.MetricValueType]? = nil) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormats(Array(self), options: options, metrics: metrics, views: views)
    }
}

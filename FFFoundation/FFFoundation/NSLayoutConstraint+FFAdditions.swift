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
    typealias ViewType = UIView
#elseif os(OSX)
    typealias ViewType = NSView
#endif
    typealias VisualFormatType = String
    typealias MetricValueType = CGFloat
    typealias MetricsDictionary = [String: MetricValueType]
    typealias ViewsDictionary = [String: ViewType]
    
    
    public static func constraintsWithVisualFormats<S: SequenceType where S.Generator.Element == VisualFormatType>(formats: S, options: NSLayoutFormatOptions = [], metrics: MetricsDictionary? = nil, views: ViewsDictionary) -> [NSLayoutConstraint] {
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
    public func constraintsWithViews(views: NSLayoutConstraint.ViewsDictionary, options: NSLayoutFormatOptions = [], metrics: NSLayoutConstraint.MetricsDictionary? = nil) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormats(self, options: options, metrics: metrics, views: views)
    }
}

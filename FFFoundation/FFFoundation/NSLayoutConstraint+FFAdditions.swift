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

public extension NSLayoutConstraint {
#if os(iOS)
    typealias View = UIView
#elseif os(OSX)
    typealias View = NSView
#endif
    
    public static func constraintsWithVisualFormats(formats: [String], metrics: [String: Double]? = nil, views: [String: View]) -> [NSLayoutConstraint] {
        return formats.reduce([NSLayoutConstraint]()) {
            $0 + constraintsWithVisualFormat($1, options: [], metrics: metrics, views: views)
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
    public func constraintsWithViews(views: [String: NSLayoutConstraint.View], metrics: [String: Double]? = nil) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormats(Array(self), metrics: metrics, views: views)
    }
}

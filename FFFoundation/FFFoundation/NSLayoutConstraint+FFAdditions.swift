//
//  NSLayoutConstraint+FFAdditions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 12.12.14.
//  Copyright 2014 Florian Friedrich
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

#if os(iOS) || os(OSX)
    #if os(iOS)
    import UIKit
    #elseif os(OSX)
    import AppKit
    #endif
    @available(OSX 10.7, iOS 6.0, *)
    public extension NSLayoutConstraint {
        #if os(iOS)
        typealias ViewType          = UIView
        #elseif os(OSX)
        typealias ViewType          = NSView
        #endif
        typealias VisualFormatType  = String
        typealias MetricValueType   = CGFloat
        typealias MetricsDictionary = [String: MetricValueType]
        typealias ViewsDictionary   = [String: ViewType]
        
        @warn_unused_result
        public static func constraintsWithVisualFormats<S: SequenceType where S.Generator.Element == VisualFormatType>(formats: S, options: NSLayoutFormatOptions = [], metrics: MetricsDictionary? = nil, views: ViewsDictionary) -> [NSLayoutConstraint] {
            return formats.reduce([NSLayoutConstraint]()) {
                $0 + constraintsWithVisualFormat($1, options: options, metrics: metrics, views: views)
            }
        }
    }
    
    @available(OSX 10.7, iOS 6.0, *)
    public extension SequenceType where Generator.Element == NSLayoutConstraint {
        public final func activate() {
            NSLayoutConstraint.activateConstraints(Array(self))
        }
        
        public final func deactivate() {
            NSLayoutConstraint.deactivateConstraints(Array(self))
        }
    }
    
    @available(OSX 10.7, iOS 6.0, *)
    public extension SequenceType where Generator.Element == String {
        @warn_unused_result
        public final func constraintsWithViews(views: NSLayoutConstraint.ViewsDictionary, options: NSLayoutFormatOptions = [], metrics: NSLayoutConstraint.MetricsDictionary? = nil) -> [NSLayoutConstraint] {
            return NSLayoutConstraint.constraintsWithVisualFormats(self, options: options, metrics: metrics, views: views)
        }
    }
#endif

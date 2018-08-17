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

#if canImport(UIKit) || canImport(AppKit)
    import class Foundation.NSNumber
    #if canImport(UIKit)
    import class UIKit.UIView
    import class UIKit.NSLayoutConstraint
    import struct UIKit.NSLayoutFormatOptions
    import struct UIKit.CGFloat
    #elseif canImport(AppKit)
    import class AppKit.NSView
    import class AppKit.NSLayoutConstraint
    #endif
    
    @available(macOS 10.7, iOS 6.0, tvOS 6.0, *)
    public extension NSLayoutConstraint {
        
        #if canImport(UIKit)
        typealias ViewType          = UIView
        typealias MetricValueType   = CGFloat
        #elseif canImport(AppKit)
        typealias ViewType          = NSView
        typealias MetricValueType   = NSNumber
        #endif
        typealias VisualFormatType  = String
        #if !canImport(AppKit) && !swift(>=4.2)
        typealias FormatOptions = NSLayoutFormatOptions
        #endif
        typealias MetricsDictionary = [String: MetricValueType]
        typealias ViewsDictionary   = [String: ViewType]
        
        public static func constraints<S: Sequence>(withVisualFormats formats: S,
                                                    options: FormatOptions = [],
                                                    metrics: MetricsDictionary? = nil,
                                                    views: ViewsDictionary) -> [NSLayoutConstraint]
            where S.Element == VisualFormatType {
                return formats.flatMap { constraints(withVisualFormat: $0, options: options, metrics: metrics, views: views) }
        }
    }
    
    @available(macOS 10.7, iOS 6.0, tvOS 6.0, *)
    public extension Sequence where Iterator.Element == NSLayoutConstraint {
        public func activate() {
            NSLayoutConstraint.activate(Array(self))
        }
        
        public func deactivate() {
            NSLayoutConstraint.deactivate(Array(self))
        }
    }
    
    @available(macOS 10.7, iOS 6.0, tvOS 6.0, *)
    public extension Sequence where Iterator.Element == NSLayoutConstraint.VisualFormatType {
        public func constraints(with views: NSLayoutConstraint.ViewsDictionary,
                                options: NSLayoutConstraint.FormatOptions = [],
                                metrics: NSLayoutConstraint.MetricsDictionary? = nil) -> [NSLayoutConstraint] {
            return NSLayoutConstraint.constraints(withVisualFormats: self, options: options, metrics: metrics, views: views)
        }
    }
#endif

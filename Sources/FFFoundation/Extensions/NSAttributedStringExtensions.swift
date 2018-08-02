//
//  NSAttributedStringExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 24/11/15.
//  Copyright 2015 Florian Friedrich
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

#if canImport(CoreGraphics)
    import class Foundation.NSAttributedString
    import struct CoreGraphics.CGFloat
    import struct CoreGraphics.CGSize
    import struct CoreGraphics.CGRect
    import func CoreGraphics.ceil

    #if !swift(>=4.2)
    import struct Foundation.NSAttributedStringKey
    #endif

    #if canImport(UIKit)
        import struct UIKit.NSStringDrawingOptions
    #else
        import class Foundation.NSString
    #endif
    
    public extension NSAttributedString {
        #if !swift(>=4.2)
        public typealias Key = NSAttributedStringKey
        #endif
        public typealias AttributesDictionary = [Key: Any]
        
        public final func size(forWidth width: CGFloat) -> CGSize {
            let boundingSize = CGSize(width: width, height: .greatestFiniteMagnitude)
            #if canImport(UIKit)
                let options: NSStringDrawingOptions
            #else
                let options: NSString.DrawingOptions
            #endif
            options = .usesLineFragmentOrigin
            let rawSize: CGRect
            #if canImport(UIKit)
                rawSize = boundingRect(with: boundingSize, options: options, context: nil)
            #elseif canImport(AppKit)
                if #available(macOS 10.11, *) {
                    rawSize = boundingRect(with: boundingSize, options: options, context: nil)
                } else {
                    rawSize = boundingRect(with: boundingSize, options: options)
                }
            #endif
            return CGSize(width: ceil(rawSize.width), height: ceil(rawSize.height))
        }
        
        public final func height(forWidth width: CGFloat) -> CGFloat {
            return size(forWidth: width).height
        }
    }
#endif

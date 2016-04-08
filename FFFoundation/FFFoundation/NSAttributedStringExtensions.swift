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

import Foundation
#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

public extension NSAttributedString {
    public typealias AttributesDictionary = [String: AnyObject]
    
    public final func sizeForWidth(width: CGFloat) -> CGSize {
        let boundingSize = CGSize(width: width, height: CGFloat.max)
        let options: NSStringDrawingOptions = [.UsesLineFragmentOrigin]
        let rawSize: CGRect
        #if os(iOS)
            rawSize = boundingRectWithSize(boundingSize, options: options, context: nil)
        #endif
        #if os(OSX)
            if #available(OSX 10.11, *) {
                rawSize = boundingRectWithSize(boundingSize, options: options, context: nil)
            } else {
                rawSize = boundingRectWithSize(boundingSize, options: options)
            }
        #endif
        return CGSize(width: ceil(rawSize.width), height: ceil(rawSize.height))
    }
    
    public final func heightForWidth(width: CGFloat) -> CGFloat {
        return sizeForWidth(width).height
    }
}

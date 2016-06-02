//
//  StringExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 20/11/15.
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
import CoreGraphics

public extension String {
    #if swift(>=3.0)
    public mutating func append(pathComponent comp: String) {
        self += hasSuffix("/") ? comp : ("/" + comp)
    }
    
    @warn_unused_result
    public func stringByAppending(pathComponent comp: String) -> String {
        var newString = self
        newString.append(pathComponent: comp)
        return newString
    }
    
    @warn_unused_result
    public func size(forWidth width: CGFloat, attributes: NSAttributedString.AttributesDictionary? = nil) -> CGSize {
        return NSAttributedString(string: self, attributes: attributes).size(forWidth: width)
    }
    
    @warn_unused_result
    public func height(forWidth width: CGFloat, attributes: NSAttributedString.AttributesDictionary? = nil) -> CGFloat {
        return size(forWidth: width, attributes: attributes).height
    }
    #else
    public mutating func appendPathComponent(comp: String) {
        self += hasSuffix("/") ? comp : ("/" + comp)
    }
    
    @warn_unused_result
    public func stringByAppendingPathComponent(comp: String) -> String {
        var newString = self
        newString.appendPathComponent(comp)
        return newString
    }
    
    @warn_unused_result
    public func sizeForWidth(width: CGFloat, attributes: NSAttributedString.AttributesDictionary? = nil) -> CGSize {
        return NSAttributedString(string: self, attributes: attributes).sizeForWidth(width)
    }
    
    @warn_unused_result
    public func heightForWidth(width: CGFloat, attributes: NSAttributedString.AttributesDictionary? = nil) -> CGFloat {
        return sizeForWidth(width, attributes: attributes).height
    }
    #endif
}

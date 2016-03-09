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

extension String {
    public mutating func appendPathComponent(comp: String) {
        self += hasSuffix("/") ? comp : ("/" + comp)
    }
    
    public func stringByAppendingPathComponent(comp: String) -> String {
        var newString = self
        newString.appendPathComponent(comp)
        return newString
    }
    
    public func sizeForWidth(width: CGFloat, attributes: Dictionary<String, AnyObject>? = nil) -> CGSize {
        return NSAttributedString(string: self, attributes: attributes).sizeForWidth(width)
    }
    
    public func heightForWidth(width: CGFloat, attributes: Dictionary<String, AnyObject>? = nil) -> CGFloat {
        return sizeForWidth(width, attributes: attributes).height
    }
}

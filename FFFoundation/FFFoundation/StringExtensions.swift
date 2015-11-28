//
//  StringExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 20/11/15.
//  Copyright © 2015 Florian Friedrich. All rights reserved.
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

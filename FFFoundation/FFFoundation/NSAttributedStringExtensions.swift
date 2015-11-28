//
//  NSAttributedStringExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 24/11/15.
//  Copyright © 2015 Florian Friedrich. All rights reserved.
//

import Foundation
import CoreGraphics

public extension NSAttributedString {
    public func sizeForWidth(width: CGFloat) -> CGSize {
        let boundingSize = CGSize(width: width, height: CGFloat.max)
        let rawSize = boundingRectWithSize(boundingSize, options: [.UsesLineFragmentOrigin], context: nil)
        return CGSize(width: ceil(rawSize.width), height: ceil(rawSize.height))
    }
    
    public func heightForWidth(width: CGFloat) -> CGFloat {
        return sizeForWidth(width).height
    }
}

//
//  StringExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 20/11/15.
//  Copyright © 2015 Florian Friedrich. All rights reserved.
//

extension String {
    public mutating func appendPathComponent(comp: String) {
        self += hasSuffix("/") ? comp : ("/" + comp)
    }
    
    public func stringByAppendingPathComponent(comp: String) -> String {
        var newString = self
        newString.appendPathComponent(comp)
        return newString
    }
}

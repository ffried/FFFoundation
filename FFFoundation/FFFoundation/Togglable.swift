//
//  Bool+Toggle.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 30/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import Foundation

public protocol Togglable {
    /// A inverted version of `self`.
    var toggled: Self { get }

    /**
     Toggles `self`.
     */
    mutating func toggle()
}

extension Togglable {
    /**
     By default, `toggle` just assigns `toggled` to `self`.
     */
    public mutating func toggle() {
        self = toggled
    }
}

#if swift(>=3.0)
    extension Togglable where Self: Boolean, Self: BooleanLiteralConvertible, Self.BooleanLiteralType == Bool {
        /// Calls `init(booleanLiteral:_)` with `!self`.
        public var toggled: Self {
            return self.dynamicType.init(booleanLiteral: !self)
        }
    }
#else
    extension Togglable where Self: BooleanType, Self: BooleanLiteralConvertible, Self.BooleanLiteralType == Bool {
    /// Calls `init(booleanLiteral:_)` with `!self`.
    public var toggled: Self {
    return self.dynamicType.init(booleanLiteral: !self)
    }
    }
#endif

extension Bool: Togglable {
    /// Directly inverts `self` by returning `!self`.
    public var toggled: Bool {
        return !self
    }
}

extension ObjCBool: Togglable {}
extension DarwinBoolean: Togglable {}

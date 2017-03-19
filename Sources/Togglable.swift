//
//  Bool+Toggle.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 30/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import struct ObjectiveC.ObjCBool
import struct Darwin.DarwinBoolean

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

extension Bool: Togglable {
    /// Directly inverts `self` by returning `!self`.
    public var toggled: Bool {
        return !self
    }
}

extension ObjCBool: Togglable {
    public var toggled: ObjCBool {
        return type(of: self).init(booleanLiteral: boolValue.toggled)
    }
}

extension DarwinBoolean: Togglable {
    public var toggled: DarwinBoolean {
        return type(of: self).init(booleanLiteral: boolValue.toggled)
    }
}

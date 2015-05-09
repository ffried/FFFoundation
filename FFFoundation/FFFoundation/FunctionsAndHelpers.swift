//
//  FunctionsAndHelpers.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 9.12.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

import FFFoundation

public func delay(delay: Double, block: () -> ()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        block)
}

public func localizedString(key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: comment)
}

public func +=<K, V> (inout left: [K: V], right: [K: V]) -> [K: V] {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
    return left
}

public func +<K, V> (left: [K: V], right: [K: V]) -> [K: V] {
    var newDict = left
    for (k, v) in right {
        newDict.updateValue(v, forKey: k)
    }
//    newDict += right
    return newDict
}

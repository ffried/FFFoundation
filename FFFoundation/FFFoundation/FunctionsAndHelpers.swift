//
//  FunctionsAndHelpers.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 9.12.14.
//  Copyright 2014 Florian Friedrich
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

public func delay(delay: Double = 0.0, block: dispatch_block_t) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        block)
}

public func runOnMainQueue(sync: Bool = false, block: dispatch_block_t) {
    if sync {
        dispatch_sync(dispatch_get_main_queue(), block)
    } else {
        dispatch_async(dispatch_get_main_queue(), block)
    }
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
//    for (k, v) in right {
//        newDict.updateValue(v, forKey: k)
//    }
    newDict += right
    return newDict
}

/// Swift-aware NSStringFromClass
public func StringFromClass(aClass: AnyClass) -> String {
    var className = NSStringFromClass(aClass)
    if let range = className.rangeOfString(".", options: .BackwardsSearch) {
        className = className.substringFromIndex(range.endIndex)
    }
    return className
}

//
//  DictionaryHelpers.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 30/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import Foundation

/**
 Merge a dictionary into an existing one. Values will be replaced in the left dictionary.
 
 - parameter left:  The dictionary in which to merge the `right` dictionary.
 - parameter right: The dictionary to merge into `left`.
 */
#if swift(>=3.0)
    public func +=<K, V> (lhs: inout [K: V], rhs: [K: V]) {
        rhs.forEach { lhs.updateValue($1, forKey: $0) }
    }
#else
    public func +=<K, V> (inout lhs: [K: V], rhs: [K: V]) {
        rhs.forEach { lhs.updateValue($1, forKey: $0) }
    }
#endif

/**
 Merges two dictionary into a new one. Values in `left` will be replaced by values in `right` for equal keys.
 
 - parameter left:  The first dictionary to merge.
 - parameter right: The second dicitonary to merge.
 
 - returns: A new dictionary containing all keys and values of `left` and `right`.
 */
#if swift(>=3.0)
    public func +<K, V> (left: [K: V], right: [K: V]) -> [K: V] {
        var newDict = left
        newDict += right
        return newDict
    }
#else
    @warn_unused_result
    public func +<K, V> (left: [K: V], right: [K: V]) -> [K: V] {
        var newDict = left
        newDict += right
        return newDict
    }
#endif

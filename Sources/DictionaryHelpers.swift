//
//  DictionaryHelpers.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 30/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

//public extension Dictionary {
    /**
     Merge a dictionary into an existing one. Values will be replaced in the left dictionary.
     
     - parameter lhs:  The dictionary in which to merge the `rhs` dictionary.
     - parameter rhs:  The dictionary to merge into `lhs`.
     */
    public /*static*/ func +=<Key: Hashable, Value>(lhs: inout Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) {
        rhs.forEach { lhs.updateValue($1, forKey: $0) }
    }
    
    /**
     Merges two dictionary into a new one. Values in `lhs` will be replaced by values in `rhs` for equal keys.
     
     - parameter lhs:  The first dictionary to merge.
     - parameter rhs:  The second dicitonary to merge.
     
     - returns: A new dictionary containing all keys and values of `lhs` and `rhs`.
     */
    public /*static*/ func +<Key: Hashable, Value>(lhs: Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
        var newDict = lhs
        rhs.forEach { newDict.updateValue($1, forKey: $0) }
        return newDict
    }
//}

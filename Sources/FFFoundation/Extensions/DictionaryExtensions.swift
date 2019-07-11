//
//  DictionaryExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 30/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
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

extension Dictionary {
    /**
     Merge a dictionary into an existing one. Values will be replaced in the left dictionary.
     
     - parameter lhs:  The dictionary in which to merge the `rhs` dictionary.
     - parameter rhs:  The dictionary to merge into `lhs`.
     */
    @inlinable
    public static func +=(lhs: inout Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) {
        lhs.merge(rhs, uniquingKeysWith: { $1 })
    }
    
    /**
     Merges two dictionary into a new one. Values in `lhs` will be replaced by values in `rhs` for equal keys.
     
     - parameter lhs:  The first dictionary to merge.
     - parameter rhs:  The second dicitonary to merge.
     
     - returns: A new dictionary containing all keys and values of `lhs` and `rhs`.
     */
    @inlinable
    public static func +(lhs: Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
        return lhs.merging(rhs, uniquingKeysWith: { $1 })
    }
}

//
//  SequenceExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 02/09/15.
//  Copyright 2015 Florian Friedrich
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

public extension Sequence {
    @available(*, deprecated: 2.0, message: "Use new Dictionary initializer: Dictionary(grouping:by:)")
    public func group<Key: Hashable>(by keyGen: (Iterator.Element) throws -> Key) rethrows -> [Key: [Element]] {
        return try Dictionary(grouping: self, by: keyGen)
    }
    
    public func last(where: (Iterator.Element) throws -> Bool) rethrows -> Element? {
        return try reversed().first(where: `where`)
    }
    
    @available(*, deprecated, message: "Was replaced by first(where:_) natively in Swift 3.0", renamed: "first")
    public func findFirst(predicate: (Iterator.Element) throws -> Bool) rethrows -> Element? {
        return try first(where: predicate)
    }
    
    @available(*, deprecated, message: "Was replaced by last(where:_)", renamed: "last")
    public func findLast(predicate: (Iterator.Element) throws -> Bool) rethrows -> Element? {
        return try last(where: predicate)
    }
}


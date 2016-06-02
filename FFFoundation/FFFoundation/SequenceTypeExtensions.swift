//
//  SequenceTypeExtensions.swift
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

import Foundation

#if swift(>=3.0)
    public extension Sequence {
        @warn_unused_result
        public func group<Key: Hashable>(by keyGen: @noescape(Iterator.Element) throws -> Key) rethrows -> [Key: [Iterator.Element]] {
            var grouped = Dictionary<Key, Array<Iterator.Element>>()
            try forEach { elem in
                let key = try keyGen(elem)
                var group = grouped[key] ?? Array<Iterator.Element>()
                group.append(elem)
                grouped[key] = group
            }
            return grouped
        }
        
        @warn_unused_result
        public func last(where: @noescape(Iterator.Element) throws -> Bool) rethrows -> Iterator.Element? {
            return try reversed().first(where: `where`)
        }
        
        @warn_unused_result
        @available(*, deprecated, message:"Was replaced by first(where:_) natively in Swift 3.0", renamed:"first")
        public func findFirst(predicate: @noescape(Iterator.Element) throws -> Bool) rethrows -> Iterator.Element? {
            return try first(where: predicate)
        }
        
        @warn_unused_result
        @available(*, deprecated, message:"Was replaced by last(where:_)", renamed:"last")
        public func findLast(predicate: @noescape(Iterator.Element) throws -> Bool) rethrows -> Iterator.Element? {
            return try last(where: predicate)
        }
    }
#else
    public extension SequenceType {
        @warn_unused_result
        public func groupBy<Key: Hashable>(@noescape keyGen: Generator.Element throws -> Key) rethrows -> [Key: [Generator.Element]] {
            var grouped = Dictionary<Key, Array<Generator.Element>>()
            try forEach { elem in
                let key = try keyGen(elem)
                var group = grouped[key] ?? Array<Generator.Element>()
                group.append(elem)
                grouped[key] = group
            }
            return grouped
        }
        
        @warn_unused_result
        public func findFirst(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Generator.Element? {
            for obj in self {
                if try predicate(obj) {
                    return obj
                }
            }
            return nil
        }
        
        @warn_unused_result
        public func findLast(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Generator.Element? {
            for obj in reverse() {
                if try predicate(obj) {
                    return obj
                }
            }
            return nil
        }
    }
#endif
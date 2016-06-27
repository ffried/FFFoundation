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
        for obj in self where try predicate(obj) {
            return obj
        }
        return nil
    }
    
    @warn_unused_result
    public func findLast(@noescape predicate: Generator.Element throws -> Bool) rethrows -> Generator.Element? {
        for obj in reverse() where try predicate(obj) {
            return obj
        }
        return nil
    }
}

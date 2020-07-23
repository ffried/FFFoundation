//
//  SortDescriptor+Operators.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 23.07.20.
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

prefix operator ^
prefix operator !^

// KVC is only available on Darwin platforms
#if canImport(ObjectiveC)
public prefix func ^ (lhs: NSSortDescriptor.Key) -> NSSortDescriptor {
    .init(key: lhs.rawValue, ascending: true)
}

public prefix func !^ (lhs: NSSortDescriptor.Key) -> NSSortDescriptor {
    .init(key: lhs.rawValue, ascending: false)
}
#endif

public prefix func ^ <Root, Value: Comparable>(lhs: KeyPath<Root, Value>) -> NSSortDescriptor {
    .init(keyPath: lhs, ascending: true)
}

public prefix func !^ <Root, Value: Comparable>(lhs: KeyPath<Root, Value>) -> NSSortDescriptor {
    .init(keyPath: lhs, ascending: false)
}

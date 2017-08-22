//
//  Weak.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 22.08.17.
//  Copyright 2017 Florian Friedrich
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

#if swift(>=3.2)
public protocol WeakProtocol {
    associatedtype StoredObject: AnyObject
    
    weak var object: StoredObject? { get set }
    
    var wasReleased: Bool { get }
    
    init(object: StoredObject)
}

public extension WeakProtocol {
    public var wasReleased: Bool { return object == nil }
}

public struct Weak<T: AnyObject>: WeakProtocol {
    public typealias StoredObject = T
    
    public weak var object: StoredObject?
    
    public init(object: StoredObject) {
        self.object = object
    }
}

public extension Sequence where Element: WeakProtocol {
    public var objects: [Element.StoredObject] {
        return flatMap { $0.object }
    }
}

public extension RangeReplaceableCollection where Element: WeakProtocol {
    public mutating func removeReleasedObjects() {
        while let index = index(where: { $0.wasReleased }) {
            remove(at: index)
        }
    }
    
    public mutating func appendWeakly(_ object: Element.StoredObject) {
        append(.init(object: object))
    }
}
#endif


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

public protocol WeakProtocol {
    associatedtype StoredObject: AnyObject
    
    weak var object: StoredObject? { get set }
    
    var wasReleased: Bool { get }
    
    init(object: StoredObject)

    subscript<T>(keyPath: KeyPath<StoredObject, T>) -> T? { get }
    subscript<T>(keyPath: ReferenceWritableKeyPath<StoredObject, T>) -> T? { get set }
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

    public subscript<T>(keyPath: KeyPath<StoredObject, T>) -> T? {
        return object?[keyPath: keyPath]
    }
    
    public subscript<T>(keyPath: ReferenceWritableKeyPath<StoredObject, T>) -> T? {
        get { return object?[keyPath: keyPath] }
        set { if let val = newValue { object?[keyPath: keyPath] = val } }
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

public extension WeakProtocol where StoredObject: RefProtocol {
    public var refObject: StoredObject.Value? {
        get { return object?.value }
        set { if let val = newValue { object?.value = val } }
    }
}

public extension WeakProtocol where StoredObject: AtomicProtocol {
    public var atomicObject: StoredObject.Value? {
        get { return object?.value }
        set { if let val = newValue { object?.value = val } }
    }
}

public extension WeakProtocol where StoredObject: RefProtocol, StoredObject.Value: AtomicProtocol {
    public var refAtomicObject: StoredObject.Value.Value? {
        get { return object?.value.value }
        set { if let val = newValue { object?.value.value = val } }
    }
}

public extension WeakProtocol where StoredObject: AtomicProtocol, StoredObject.Value: RefProtocol {
    public var atomicRefObject: StoredObject.Value.Value? {
        get { return object?.value.value }
        set { if let val = newValue { object?.value.value = val } }
    }
}

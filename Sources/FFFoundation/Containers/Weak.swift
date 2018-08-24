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

public protocol WeakProtocol: Container where Value == Object? {
    associatedtype Object: AnyObject

    var wasReleased: Bool { get }

    init(object: Object)
}

public extension WeakProtocol {
    public var wasReleased: Bool { return value == nil }

    public var object: Object? { return value }

    public init(object: Object) {
        self.init(value: object)
    }
}

public struct Weak<Object: AnyObject>: WeakProtocol {
    public weak var value: Object?

    public init(value: Value) {
        self.value = value
    }
}

public extension Sequence where Element: WeakProtocol {
    public var objects: [Element.Object] {
        return compactMap { $0.object }
    }
}

public extension MutableCollection where Self: RangeReplaceableCollection, Element: WeakProtocol {
    public mutating func removeReleasedObjects() {
        removeAll(where: { $0.wasReleased })
    }
    
    public mutating func appendWeakly(_ object: Element.Object) {
        append(.init(object: object))
    }
}

extension Weak: Equatable where Object: Equatable {}
extension Weak: Hashable where Object: Hashable {}
extension Weak: Encodable where Object: Encodable {}
extension Weak: Decodable where Object: Decodable {}
extension Weak: ExpressibleByNilLiteral where Object: ExpressibleByNilLiteral {}
//extension Weak: ExpressibleByBooleanLiteral where Object: ExpressibleByBooleanLiteral {}
//extension Weak: ExpressibleByIntegerLiteral where Object: ExpressibleByIntegerLiteral {}
//extension Weak: ExpressibleByFloatLiteral where Object: ExpressibleByFloatLiteral {}
//extension Weak: ExpressibleByUnicodeScalarLiteral where Object: ExpressibleByUnicodeScalarLiteral {}
//extension Weak: ExpressibleByExtendedGraphemeClusterLiteral where Object: ExpressibleByExtendedGraphemeClusterLiteral {}
//extension Weak: ExpressibleByStringLiteral where Object: ExpressibleByStringLiteral {}

extension Weak: NestedContainer where Object: Container {
    public typealias NestedValue = Value.Value
}

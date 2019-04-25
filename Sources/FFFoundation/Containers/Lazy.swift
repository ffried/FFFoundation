//
//  Lazy.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 26/05/16.
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

public protocol LazyProtocol: MutableContainer {
    typealias Constructor = () -> Value

    var value: Value { mutating get set }

    init(_ constructor: @escaping Constructor)

    mutating func reset()
}

public struct Lazy<Deferred>: LazyProtocol {
    public typealias Value = Deferred
    
    private let constructor: Constructor

    private var _valueStorage: Ref<Deferred?>
    private var _value: Deferred? {
        get { return _valueStorage.value }
        set {
            if !isKnownUniquelyReferenced(&_valueStorage) {
                _valueStorage = .init(value: newValue)
            } else {
                _valueStorage <- newValue
            }
        }
    }
    public var value: Deferred {
        get {
            if let val = _value { return val }
            _valueStorage <- constructor()
            return self.value
        }
        set { _value = newValue }
    }
    
    public init(_ constructor: @escaping Constructor) {
        self.constructor = constructor
        _valueStorage = nil
    }

    public init(value: Value) {
        constructor = { value }
        _valueStorage = .init(value: value)
    }
    
    public init(other: Lazy) {
        self.init(other.constructor)
    }
    
    public mutating func reset() {
        _value = nil
    }
}

extension Lazy: Equatable where Deferred: Equatable {}
extension Lazy: Hashable where Deferred: Hashable {}
extension Lazy: Comparable where Deferred: Comparable {}
extension Lazy: Encodable where Deferred: Encodable {}
extension Lazy: Decodable where Deferred: Decodable {}
extension Lazy: ExpressibleByNilLiteral where Deferred: ExpressibleByNilLiteral {}
extension Lazy: ExpressibleByBooleanLiteral where Deferred: ExpressibleByBooleanLiteral {}
extension Lazy: ExpressibleByIntegerLiteral where Deferred: ExpressibleByIntegerLiteral {}
extension Lazy: ExpressibleByFloatLiteral where Deferred: ExpressibleByFloatLiteral {}
extension Lazy: ExpressibleByUnicodeScalarLiteral where Deferred: ExpressibleByUnicodeScalarLiteral {}
extension Lazy: ExpressibleByExtendedGraphemeClusterLiteral where Deferred: ExpressibleByExtendedGraphemeClusterLiteral {}
extension Lazy: ExpressibleByStringLiteral where Deferred: ExpressibleByStringLiteral {}

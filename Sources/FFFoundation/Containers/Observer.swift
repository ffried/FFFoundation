//
//  Observer.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 23.11.18.
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

import struct Foundation.UUID

public struct Observation<Observed> {
    let oldValue: Observed
    let newValue: Observed
}

public struct ObserverRegistration: Hashable {
    private let uuid = UUID().uuidString
}

public protocol ObserverProtocol: Container {
    typealias ChangeHandler = (Observation<Value>) -> ()

    mutating func register(handler: @escaping ChangeHandler) -> ObserverRegistration
    mutating func registerHandler(on queue: DispatchQueue?, handler: @escaping ChangeHandler) -> ObserverRegistration
    mutating func remove(registration: ObserverRegistration)
}

public extension ObserverProtocol {
    @inlinable
    public mutating func register(handler: @escaping ChangeHandler) -> ObserverRegistration {
        return registerHandler(on: nil, handler: handler)
    }
}

public struct Observer<Observed>: ObserverProtocol {
    public typealias Value = Observed
    private typealias Registration = (queue: DispatchQueue?, handler: ChangeHandler)

    private var changeHandlers: Dictionary<ObserverRegistration, Registration> = [:]

    public var value: Observed {
        didSet {
            changeHandlers.values.forEach { [observation = Observation(oldValue: oldValue, newValue: value)] registration in
                registration.queue?.async { registration.handler(observation) } ?? registration.handler(observation)
            }
        }
    }

    public init(value: Observed) {
        self.value = value
    }

    public mutating func registerHandler(on queue: DispatchQueue?, handler: @escaping ChangeHandler) -> ObserverRegistration {
        let registration = ObserverRegistration()
        changeHandlers[registration] = (queue, handler)
        return registration
    }

    public mutating func remove(registration: ObserverRegistration) {
        changeHandlers[registration] = nil
    }
}

extension Observer: Equatable where Observed: Equatable {}
extension Observer: Hashable where Observed: Hashable {}
extension Observer: Comparable where Observed: Comparable {}
extension Observer: Encodable where Observed: Encodable {}
extension Observer: Decodable where Observed: Decodable {}
extension Observer: ExpressibleByNilLiteral where Observed: ExpressibleByNilLiteral {}
extension Observer: ExpressibleByBooleanLiteral where Observed: ExpressibleByBooleanLiteral {}
extension Observer: ExpressibleByIntegerLiteral where Observed: ExpressibleByIntegerLiteral {}
extension Observer: ExpressibleByFloatLiteral where Observed: ExpressibleByFloatLiteral {}
extension Observer: ExpressibleByUnicodeScalarLiteral where Observed: ExpressibleByUnicodeScalarLiteral {}
extension Observer: ExpressibleByExtendedGraphemeClusterLiteral where Observed: ExpressibleByExtendedGraphemeClusterLiteral {}
extension Observer: ExpressibleByStringLiteral where Observed: ExpressibleByStringLiteral {}

extension Observer: NestedContainer where Observed: Container {
    public typealias NestedValue = Observed.Value
}

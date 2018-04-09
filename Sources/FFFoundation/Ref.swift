//
//  Ref.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 09.10.17.
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

public protocol RefProtocol: class, Container {}

public final class Ref<Referenced>: RefProtocol {
    public typealias Value = Referenced

    public var value: Value

    public init(value: Value) {
        self.value = value
    }
}

extension Ref: Equatable where Referenced: Equatable {}
extension Ref: Hashable where Referenced: Hashable {}

extension Ref: NestedContainer where Referenced: Container {
    public typealias NestedValue = Referenced.Value
}

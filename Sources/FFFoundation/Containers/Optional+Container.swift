//
//  Optional+Container.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 24.08.18.
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

extension Optional: MutableContainer {
    public typealias Value = Wrapped?

    public var value: Value {
        get { return self }
        set { self = newValue }
    }

    public init(value: Value) {
        self = value
    }
}

//
//  AnyBindableObject.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 23.07.19.
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

/*
#if canImport(SwiftUI) && canImport(Combine)
import Foundation
import Combine
import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
@propertyWrapper
public final class AnyBindableObject<Value>: ObservableObject {
    private var assigner: AnyCancellable?

    @Published public var wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public init<ValuePublisher>(wrappedValue: Value, publisher: ValuePublisher) where ValuePublisher: Publisher, ValuePublisher.Output == Value, ValuePublisher.Failure == Never {
        self.wrappedValue = wrappedValue
        assigner = publisher.assign(to: \.wrappedValue, on: self)
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
extension AnyBindableObject where Value: ExpressibleByNilLiteral  {
    public convenience init() {
        self.init(wrappedValue: nil)
    }

    public convenience init<ValuePublisher>(publisher: ValuePublisher) where ValuePublisher: Publisher, ValuePublisher.Output == Value, ValuePublisher.Failure == Never {
        self.init(wrappedValue: nil, publisher: publisher)
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
extension AnyBindableObject where Value: ExpressibleByArrayLiteral  {
    public convenience init() {
        self.init(wrappedValue: [])
    }

    public convenience init<ValuePublisher>(publisher: ValuePublisher) where ValuePublisher: Publisher, ValuePublisher.Output == Value, ValuePublisher.Failure == Never {
        self.init(wrappedValue: [], publisher: publisher)
    }
}
#endif
*/

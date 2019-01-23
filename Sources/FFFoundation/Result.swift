//
//  Result.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 23.01.19.
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

public enum Result<Value> {
    case value(Value)
    case error(Error)

    public init(_ work: () throws -> Value) {
        do {
            self = try .value(work())
        } catch {
            self = .error(error)
        }
    }

    public func unwrap() throws -> Value {
        switch self {
        case .value(let val): return val
        case .error(let err): throw err
        }
    }

    public func map<T>(_ transformer: (Value) throws -> T) -> Result<T> {
        return Result<T> { try transformer(unwrap()) }
    }

    public func flatMap<T>(_ transformer: (Value) throws -> Result<T>) -> Result<T> {
        return Result<T> { try transformer(unwrap()).unwrap() }
    }
}

//
//  Future.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 22.01.19.
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

import class Dispatch.DispatchQueue
import class Dispatch.DispatchSemaphore

public final class Future<Value> {
    public typealias Handler = (Value) -> ()
    private enum State {
        case unfinished(Array<Handler>)
        case finished(Value)
    }

    private let state: Atomic<State>
    private let workerQueue: DispatchQueue

    private init(workerQueue: DispatchQueue?, state: State) {
        self.state = Atomic(value: state)
        self.workerQueue = workerQueue ?? DispatchQueue(label: "net.ffried.Future<\(Value.self)>.workerQueue", qos: .default, attributes: .concurrent)
    }

    convenience init(queue: DispatchQueue?, value: Value? = nil) {
        self.init(workerQueue: queue, state: value.map { .finished($0) } ?? .unfinished([]))
    }

    public convenience init(value: Value) {
        self.init(queue: nil, value: value)
    }

    public convenience init() {
        self.init(queue: nil)
    }

    public func complete(with value: Value) {
        let handlers: Array<Handler> = state.withValue {
            guard case .unfinished(let handlers) = $0 else {
                preconditionFailure("\(type(of: self)) is being completed more than once!")
            }
            $0 = .finished(value)
            return handlers
        }
        workerQueue.async { handlers.forEach { $0(value) } }
    }

    public func whenDone(do work: @escaping Handler) {
        let value: Value? = state.withValue {
            switch $0 {
            case .unfinished(let handlers):
                $0 = .unfinished(handlers + CollectionOfOne(work))
                return nil
            case .finished(let val): return val
            }
        }
        value.map { val in workerQueue.async { work(val) } }
    }

    public func cascade(other: Future<Value>) {
        whenDone(do: other.complete)
    }

    public func map<T>(_ transformer: @escaping (Value) -> T) -> Future<T> {
        let future = Future<T>(queue: workerQueue)
        whenDone { future.complete(with: transformer($0)) }
        return future
    }

    @inlinable
    public func map<T>(_ transformer: @escaping (Value) throws -> T) -> FutureResult<T> {
        return map { val in Result { try transformer(val) } }
    }

    public func flatMap<T>(_ transformer: @escaping (Value) -> Future<T>) -> Future<T> {
        let future = Future<T>(queue: workerQueue)
        whenDone { transformer($0).cascade(other: future) }
        return future
    }

    public func flatMap<T>(_ transformer: @escaping (Value) throws -> Future<T>) -> FutureResult<T> {
        return flatMap { [workerQueue] in
            do { return try transformer($0).map { .value($0) } }
            catch { return FutureResult<T>(queue: workerQueue, value: .error(error)) }
        }
    }

    public func await() -> Value {
        let semaphore = DispatchSemaphore(value: 0)
        var value: Value!
        whenDone {
            value = $0
            semaphore.signal()
        }
        semaphore.wait()
        return value
    }
}

public typealias FutureResult<Value> = Future<Result<Value>>

public extension FutureResult {
    @inlinable
    public convenience init<Val>(value: Val) where Value == Result<Val> {
        self.init(value: .value(value))
    }

    @inlinable
    public convenience init<Val>(error: Error) where Value == Result<Val> {
        self.init(value: .error(error))
    }

    public func succeed<Val>(with value: Val) where Value == Result<Val> {
        complete(with: .value(value))
    }

    public func fail<Val>(with error: Error) where Value == Result<Val> {
        complete(with: .error(error))
    }

    public func cascade(other: FutureResult<Value>) {
        whenDone(do: other.succeed)
    }

    public func onSuccess<Val>(do work: @escaping (Val) -> ()) where Value == Result<Val> {
        whenDone { _ = $0.map(work) }
    }

    public func onError<Val>(do work: @escaping(Error) -> ()) where Value == Result<Val> {
        whenDone {
            do { _ = try $0.unwrap() }
            catch { work(error) }
        }
    }

    @inlinable
    public func map<Val, T>(_ transformer: @escaping (Val) throws -> T) -> FutureResult<T> where Value == Result<Val> {
        return map { val in try transformer(val.unwrap()) }
    }

    public func flatMap<Val, T>(_ transformer: @escaping (Val) throws -> FutureResult<T>) -> FutureResult<T> where Value == Result<Val> {
        let future = FutureResult<T>(queue: workerQueue)
        whenDone {
            do {
                try transformer($0.unwrap()).cascade(other: future)
            } catch {
                future.complete(with: .error(error))
            }
        }
        return future
    }

    @inlinable
    public func await<Val>() throws -> Val where Value == Result<Val> {
        return try await().unwrap()
    }
}

public extension DispatchQueue {
    public final func async<T>(do work: @escaping () -> T) -> Future<T> {
        let future = Future<T>(queue: self)
        async { future.complete(with: work()) }
        return future
    }

    public final func async<T>(do work: @escaping () throws -> T) -> FutureResult<T> {
        let future = FutureResult<T>(queue: self)
        async { future.complete(with: Result { try work() }) }
        return future
    }
}

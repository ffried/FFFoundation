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
    public func map<T>(_ transformer: @escaping (Value) throws -> T) -> FutureResult<T, Error> {
        return map { val in Result { try transformer(val) } }
    }

    public func flatMap<T>(_ transformer: @escaping (Value) -> Future<T>) -> Future<T> {
        let future = Future<T>(queue: workerQueue)
        whenDone { transformer($0).cascade(other: future) }
        return future
    }

    public func flatMap<T>(_ transformer: @escaping (Value) throws -> Future<T>) -> FutureResult<T, Error> {
        return flatMap { [workerQueue] in
            do { return try transformer($0).map { .success($0) } }
            catch { return FutureResult<T, Error>(queue: workerQueue, value: .failure(error)) }
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

public typealias FutureResult<Value, Error: Error> = Future<Result<Value, Error>>

extension FutureResult {
    @inlinable
    public convenience init<Success, Failure: Error>(value: Success) where Value == Result<Success, Failure> {
        self.init(value: .success(value))
    }

    @inlinable
    public convenience init<Success, Failure: Error>(error: Failure) where Value == Result<Success, Failure> {
        self.init(value: .failure(error))
    }

    public func succeed<Success, Failure: Error>(with value: Success) where Value == Result<Success, Failure> {
        complete(with: .success(value))
    }

    public func fail<Success, Failure: Error>(with error: Failure) where Value == Result<Success, Failure> {
        complete(with: .failure(error))
    }

    public func cascade<Success, Failure: Error>(other: FutureResult<Success, Failure>) where Value == Result<Success, Failure> {
        whenDone(do: other.complete)
    }

    public func onSuccess<Success, Failure: Error>(do work: @escaping (Success) -> ()) where Value == Result<Success, Failure> {
        whenDone { _ = $0.map(work) }
    }

    public func onError<Success, Failure: Error>(do work: @escaping (Failure) -> ()) where Value == Result<Success, Failure> {
        whenDone {
            switch $0 {
            case .success(_): break
            case .failure(let error): work(error)
            }
        }
    }

    @inlinable
    public func map<Success, Failure: Error, T>(_ transformer: @escaping (Success) throws -> T) -> FutureResult<T, Error> where Value == Result<Success, Failure> {
        return map { val in try transformer(val.get()) }
    }

    public func flatMap<Success, T>(_ transformer: @escaping (Success) throws -> FutureResult<T, Error>) -> FutureResult<T, Error> where Value == Result<Success, Error> {
        let future = FutureResult<T, Error>(queue: workerQueue)
        whenDone {
            do {
                try transformer($0.get()).cascade(other: future)
            } catch {
                future.complete(with: .failure(error))
            }
        }
        return future
    }

    @inlinable
    public func await<Success, Failure: Error>() throws -> Success where Value == Result<Success, Failure> {
        return try await().get()
    }
}

extension DispatchQueue {
    public final func async<T>(do work: @escaping () -> T) -> Future<T> {
        let future = Future<T>(queue: self)
        async { future.complete(with: work()) }
        return future
    }

    public final func async<T>(do work: @escaping () throws -> T) -> FutureResult<T, Error> {
        let future = FutureResult<T, Error>(queue: self)
        async { future.complete(with: Result { try work() }) }
        return future
    }
}

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

public final class GCDFuture<Value>: @unchecked Sendable {
    public typealias Handler = (Value) -> ()
    private enum State {
        case unfinished(Array<Handler>)
        case finished(Value)
    }

    @Synchronized
    private var state: State
    private let workerQueue: DispatchQueue

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    var value: Value {
        get async {
            await withUnsafeContinuation { cont in
                whenDone { cont.resume(returning: $0) }
            }
        }
    }

    private init(workerQueue: DispatchQueue?, state: State) {
        _state = .init(wrappedValue: state)
        self.workerQueue = workerQueue ?? DispatchQueue(label: "net.ffried.GCDFuture<\(Value.self)>.workerQueue",
                                                        attributes: .concurrent)
    }

    convenience init(queue: DispatchQueue?, value: Value? = nil) {
        self.init(workerQueue: queue,
                  state: value.map { .finished($0) } ?? .unfinished([]))
    }

    public convenience init(value: Value) {
        self.init(queue: nil, value: value)
    }

    public convenience init() {
        self.init(queue: nil)
    }

    public func complete(with value: Value) {
        let handlers: Array<Handler> = _state.withValue {
            guard case .unfinished(let handlers) = $0 else {
                preconditionFailure("\(type(of: self)) is being completed more than once!")
            }
            $0 = .finished(value)
            return handlers
        }
        workerQueue.async { handlers.forEach { $0(value) } }
    }

    @discardableResult
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func complete(with task: @escaping @Sendable () async -> Value) -> Task<Void, Never> {
        Task {
            await self.complete(with: task())
        }
    }

    public func whenDone(do work: @escaping Handler) {
        let value: Value? = _state.withValue {
            switch $0 {
            case .unfinished(let handlers):
                $0 = .unfinished(handlers + CollectionOfOne(work))
                return nil
            case .finished(let val): return val
            }
        }
        value.map { val in workerQueue.async { work(val) } }
    }

    public func cascade(other: GCDFuture<Value>) {
        whenDone(do: other.complete)
    }

    public func map<T>(_ transformer: @escaping (Value) -> T) -> GCDFuture<T> {
        let future = GCDFuture<T>(queue: workerQueue)
        whenDone { future.complete(with: transformer($0)) }
        return future
    }

    @inlinable
    public func map<T>(_ transformer: @escaping (Value) throws -> T) -> GCDFutureResult<T, any Error> {
        map { val in Result { try transformer(val) } }
    }

    public func flatMap<T>(_ transformer: @escaping (Value) -> GCDFuture<T>) -> GCDFuture<T> {
        let future = GCDFuture<T>(queue: workerQueue)
        whenDone { transformer($0).cascade(other: future) }
        return future
    }

    public func flatMap<T>(_ transformer: @escaping (Value) throws -> GCDFuture<T>) -> GCDFutureResult<T, any Error> {
        flatMap { [workerQueue] in
            do { return try transformer($0).map { .success($0) } }
            catch { return GCDFutureResult<T, any Error>(queue: workerQueue, value: .failure(error)) }
        }
    }

    public func wait() -> Value {
        let semaphore = DispatchSemaphore(value: 0)
        var value: Value!
        whenDone {
            value = $0
            semaphore.signal()
        }
        semaphore.wait()
        return value
    }

    @available(*, deprecated, message: "Use 'wait'", renamed: "wait")
    public func await() -> Value {
        wait()
    }
}

public typealias GCDFutureResult<Value, Failure: Error> = GCDFuture<Result<Value, Failure>>

extension GCDFutureResult {
    @inlinable
    public convenience init<Success, Failure: Error>(value: Success)
    where Value == Result<Success, Failure>
    {
        self.init(value: .success(value))
    }

    @inlinable
    public convenience init<Success, Failure: Error>(error: Failure)
    where Value == Result<Success, Failure>
    {
        self.init(value: .failure(error))
    }

    public func succeed<Success, Failure: Error>(with value: Success)
    where Value == Result<Success, Failure>
    {
        complete(with: .success(value))
    }

    public func fail<Success, Failure: Error>(with error: Failure)
    where Value == Result<Success, Failure>
    {
        complete(with: .failure(error))
    }

    @discardableResult
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func complete<Success>(with task: @escaping @Sendable () async throws -> Success) -> Task<Void, Never>
    where Value == Result<Success, any Error>
    {
        Task {
            do {
                try await self.succeed(with: task())
            } catch {
                self.fail(with: error)
            }
        }
    }

    public func cascade<Success, Failure: Error>(other: GCDFutureResult<Success, Failure>)
    where Value == Result<Success, Failure>
    {
        whenDone(do: other.complete)
    }

    public func onSuccess<Success, Failure: Error>(do work: @escaping (Success) -> ())
    where Value == Result<Success, Failure>
    {
        whenDone { _ = $0.map(work) }
    }

    public func onError<Success, Failure: Error>(do work: @escaping (Failure) -> ())
    where Value == Result<Success, Failure>
    {
        whenDone {
            switch $0 {
            case .success(_): break
            case .failure(let error): work(error)
            }
        }
    }

    @inlinable
    public func map<Success, Failure: Error, T>(_ transformer: @escaping (Success) throws -> T) -> GCDFutureResult<T, any Error>
    where Value == Result<Success, Failure>
    {
        map { val in try transformer(val.get()) }
    }

    public func flatMap<Success, T>(_ transformer: @escaping (Success) throws -> GCDFutureResult<T, any Error>) -> GCDFutureResult<T, any Error>
    where Value == Result<Success, any Error>
    {
        let future = GCDFutureResult<T, any Error>(queue: workerQueue)
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
    public func wait<Success, Failure: Error>() throws -> Success
    where Value == Result<Success, Failure>
    {
        try wait().get()
    }

    @inlinable
    @available(*, deprecated, message: "Use 'wait'", renamed: "wait")
    public func await<Success, Failure: Error>() throws -> Success
    where Value == Result<Success, Failure>
    {
        try wait()
    }
}

extension DispatchQueue {
    public final func asFuture<T>(do work: @escaping () -> T) -> GCDFuture<T> {
        let future = GCDFuture<T>(queue: self)
        self.async { future.complete(with: work()) }
        return future
    }

    public final func asFuture<T>(do work: @escaping () throws -> T) -> GCDFutureResult<T, any Error> {
        let future = GCDFutureResult<T, any Error>(queue: self)
        self.async { future.complete(with: Result { try work() }) }
        return future
    }
}

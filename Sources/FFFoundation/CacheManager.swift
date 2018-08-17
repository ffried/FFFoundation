//
//  CacheManager.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 11.10.17.
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

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public protocol Cachable {
    static func fromCache(data: Data) throws -> Self

    func cacheData() throws -> Data
}

// TODO: Implement expiration attributes
public final class CacheManager<Object: Cachable> {
    public typealias ObjectIdentification = String

    private let fileManager: FileManager
    // TODO: Use queue also for user operations
    private let queue: DispatchQueue = .init(label: "net.ffried.fffoundation.cachemanager", attributes: .concurrent)
    private let folder: URL
    public let name: Name

    private var timer: AnyTimer?

    public var clearsMemoryCachePeriodically: Bool = false {
        didSet {
            guard clearsMemoryCachePeriodically != oldValue else { return }
            if clearsMemoryCachePeriodically {
                timer = AnyTimer(interval: 30, repeats: true, queue: queue) { [weak self] _ in self?.clearMemoryCache() }
                timer?.tolerance = 10
                timer?.schedule()
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }

    private var memoryCache: Atomic<[ObjectIdentification: Object]> = .init(value: [:])

    public init(name: Name = .default) throws {
        self.name = name
        let fileManager = FileManager()
        self.fileManager = fileManager
        let cacheSubfolder = name.rawValue + "\(Object.self)"
        let folder = try CacheManager.cacheFolder(in: fileManager).appendingPathComponent(cacheSubfolder)
        try fileManager.createDirectoryIfNeeded(at: folder)
        self.folder = folder
        registerForMemoryWarnings()
    }

    // MARK: - Memory warnings
    private var memoryWarningsObserver: NSObjectProtocol?
    private func registerForMemoryWarnings() {
        #if canImport(UIKit)
            let opQueue = OperationQueue()
            opQueue.underlyingQueue = queue
            let name: Notification.Name
            #if swift(>=4.2)
                name = UIApplication.didReceiveMemoryWarningNotification
            #else
                name = .UIApplicationDidReceiveMemoryWarning
            #endif
            memoryWarningsObserver = NotificationCenter.default.addObserver(forName: name, object: nil, queue: opQueue) { [weak self] _ in
                self?.clearMemoryCache()
            }
        #endif
    }

    // MARK: - Private helpers
    private func cacheURL(for identification: ObjectIdentification) -> URL {
        return folder.appendingPathComponent(identification)
    }

    private func objectExists(at url: URL) -> Bool {
        return fileManager.fileExists(at: url)
    }

    private func object(at url: URL) throws -> Object? {
        guard fileManager.fileExists(at: url) else { return nil }
        let data = try Data(contentsOf: url)
        return try .fromCache(data: data)
    }

    private func cache(object: Object, at url: URL) throws {
        let data = try object.cacheData()
        try data.write(to: url, options: .atomic)
    }

    private func removeObject(at url: URL) throws {
        guard fileManager.fileExists(at: url) else { return }
        try fileManager.removeItem(at: url)
    }

    // MARK: - Public interface
    public func objectExists(for identification: ObjectIdentification) -> Bool {
        return objectExists(at: cacheURL(for: identification))
    }

    public func object(for identification: ObjectIdentification) throws -> Object? {
        return try memoryCache.value[identification] ?? object(at: cacheURL(for: identification))
    }

    public func cache(object: Object, for identification: ObjectIdentification) throws {
        try cache(object: object, at: cacheURL(for: identification))
        memoryCache.value[identification] = object
    }

    public func removeObject(for identification: ObjectIdentification) throws {
        try removeObject(at: cacheURL(for: identification))
    }

    public func urlOfObject(with identificiation: ObjectIdentification) throws -> URL? {
        let url = cacheURL(for: identificiation)
        guard objectExists(at: url) else { return nil }
        return url
    }

    public func clearMemoryCache() { memoryCache.value.removeAll() }
    public func clearCache() throws {
        clearMemoryCache()
        guard fileManager.fileExists(at: folder) else { return }
        try fileManager.removeItem(at: folder)
        try fileManager.createDirectoryIfNeeded(at: folder)
    }
}

public extension CacheManager {
    public static func cacheFolder(in fileManager: FileManager = .default) throws -> URL {
        return try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}

public extension CacheManager {
    public struct Name: RawRepresentable {
        public typealias RawValue = String

        public let rawValue: RawValue
        public init(rawValue: RawValue) { self.rawValue = rawValue }
    }
}

public enum CachingError: Error, CustomStringConvertible {
    case couldNotSerialize(underlyingError: Error?)
    case couldNotDeserialize(underlyingError: Error?)

    public var description: String {
        switch self {
        case .couldNotSerialize(let underlyingError):
            return "Could not serialize!\nUnderlying error: \(underlyingError.map { "\($0)" } ?? "nil")"
        case .couldNotDeserialize(let underlyingError):
            return "Could not de-serialize!\nUnderlying error: \(underlyingError.map { "\($0)" } ?? "nil")"
        }
    }
}

public extension CacheManager.Name {
    public static var `default`: CacheManager.Name { return .init(rawValue: "Default") }
}

extension Data: Cachable {
    public func cacheData() throws -> Data { return self }
    public static func fromCache(data: Data) throws -> Data { return data }
}

extension String: Cachable {
    public func cacheData() throws -> Data { return Data(utf8) }
    public static func fromCache(data: Data) throws -> String { return String(decoding: data, as: UTF8.self) }
}

#if canImport(UIKit)
    extension UIImage: Cachable {
        public func cacheData() throws -> Data {
            #if swift(>=4.2)
            guard let data = jpegData(compressionQuality: 0.95) else { throw CachingError.couldNotSerialize(underlyingError: nil) }
            #else
            guard let data = UIImageJPEGRepresentation(self, 0.95) else { throw CachingError.couldNotSerialize(underlyingError: nil) }
            #endif
            return data
        }

        public static func fromCache(data: Data) throws -> Self {
            guard let img = self.init(data: data) else { throw CachingError.couldNotDeserialize(underlyingError: nil) }
            return img
        }
    }
#endif

#if canImport(AppKit)
    import AppKit
    extension NSImage: Cachable {
        public func cacheData() throws -> Data {
            guard let data = tiffRepresentation else { throw CachingError.couldNotSerialize(underlyingError: nil) }
            return data
        }

        public static func fromCache(data: Data) throws -> Self {
            guard let img = self.init(data: data) else { throw CachingError.couldNotDeserialize(underlyingError: nil) }
            return img
        }
    }
#endif

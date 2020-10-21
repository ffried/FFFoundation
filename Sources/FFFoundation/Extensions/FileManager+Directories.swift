//
//  FileManager+Directories.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 18/09/2016.
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

import class Foundation.FileManager
import struct Foundation.FileAttributeKey
import struct Foundation.URL
#if os(Linux)
import struct Foundation.ObjCBool
#else
import struct ObjectiveC.ObjCBool
#endif

extension FileManager {
    @inlinable
    public func fileExists(at url: URL) -> Bool { fileExists(atPath: url.path) }

    @inlinable
    public func fileExists(at url: URL, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        fileExists(atPath: url.path, isDirectory: isDirectory)
    }

    @inlinable
    public func directoryExists(at url: URL) -> Bool {
        var isDir: ObjCBool = false
        return fileExists(at: url, isDirectory: &isDir) && isDir.boolValue
    }

    @inlinable
    public func createDirectoryIfNeeded(at url: URL, withIntermediateDirectories: Bool = true, attributes: [FileAttributeKey: Any]? = nil) throws {
        guard !directoryExists(at: url) else { return }
        try createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
    }
}

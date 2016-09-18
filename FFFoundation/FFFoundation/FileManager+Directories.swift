//
//  FileManager+Directories.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 18/09/2016.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import Foundation

#if swift(>=3)
public extension FileManager {
    public func createDirectoryIfNeeded(at url: URL, attributes: [String: Any]? = nil) throws {
        var isDir: ObjCBool = false
        let exists = fileExists(atPath: url.path, isDirectory: &isDir)
        if !exists || (exists && !isDir.boolValue) {
            try createDirectory(at: url, withIntermediateDirectories: true, attributes: attributes)
        }
    }
}
#else
public extension NSFileManager {
    public func createDirectoryAtURLIfNeeded(url: URL, attributes: [String: Any]? = nil) throws {
        var isDir: ObjCBool = false
        let exists = fileExistsAtPath(url.path, isDirectory: &isDir)
        if !exists || (exists && !isDir.boolValue) {
            try createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: attributes)
        }
    }
}
#endif

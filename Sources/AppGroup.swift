//
//  AppGroup.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 18/09/2016.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import class Foundation.FileManager
import class Foundation.UserDefaults
import struct Foundation.URL

public struct AppGroup: Hashable {
    public let identifier: String
    
    public var hashValue: Int { return identifier.hashValue }
    
    public static func ==(lhs: AppGroup, rhs: AppGroup) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public init(identifier: String) {
        self.identifier = identifier
    }
}

public extension AppGroup {
    public var dataURL: URL? {
        let fileManager = FileManager.default
        return fileManager.containerURL(forSecurityApplicationGroupIdentifier: identifier)
    }
    
    public var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: identifier)
    }
}

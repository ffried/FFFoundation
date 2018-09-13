//
//  AppGroup.swift
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
import class Foundation.UserDefaults
import struct Foundation.URL

public struct AppGroup: RawRepresentable, Hashable, Codable {

    public let identifier: String
    public var rawValue: String { return identifier }
    
    public init(identifier: String) {
        self.identifier = identifier
    }

    public init(rawValue: String) { self.init(identifier: rawValue) }
}

public extension AppGroup {
    public var dataURL: URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)
    }
    
    public var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: identifier)
    }
}

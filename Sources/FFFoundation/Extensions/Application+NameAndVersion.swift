//
//  Application+NameAndVersion.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 08/04/16.
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

#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
    import class Foundation.Bundle
    #if os(iOS) || os(tvOS)
        import class UIKit.UIApplication
        public typealias Application = UIApplication
    #elseif os(watchOS)
        import class WatchKit.WKExtension
        public typealias Application = WKExtension
    #elseif os(macOS)
        import class AppKit.NSApplication
        public typealias Application = NSApplication
    #endif

    extension Application {
        @inline(__always)
        private var bundle: Bundle { .main }
        
        public var identifier: String? {
            bundle.infoDictionary?["CFBundleIdentifier"] as? String
        }
        
        public var name: String? {
            bundle.infoDictionary?["CFBundleName"] as? String
        }
        
        public var localizedName: String? {
            bundle.localizedInfoDictionary?["CFBundleDisplayName"] as? String
                ?? bundle.infoDictionary?["CFBundleDisplayName"] as? String
        }
        
        public var version: String? {
            bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        }
        
        public var build: String? {
            bundle.infoDictionary?["CFBundleVersion"] as? String
        }
        
        public var fullVersion: String? {
            guard let version = version, let build = build else { return nil }
            return "\(version) (\(build))"
        }
        
        public var nameAndFullVersion: String? {
            guard let name = name else { return nil }
            let version = fullVersion ?? ""
            return "\(name) \(version)"
        }

        public var localizedNameAndFullVersion: String? {
            guard let name = localizedName else { return nil }
            let version = fullVersion ?? ""
            return "\(name) \(version)"
        }
    }
#endif

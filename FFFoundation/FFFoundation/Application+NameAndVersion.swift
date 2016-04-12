//
//  Application+NameAndVersion.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 08/04/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

#if os(iOS) || os(OSX)
    import Foundation
    #if os(iOS)
        import UIKit
        public typealias Application = UIApplication
    #elseif os(OSX)
        import AppKit
        public typealias Application = NSApplication
    #endif
    
    public let App = Application.sharedApplication()

    public extension Application {
        private var bundle: NSBundle { return NSBundle.mainBundle() }
        
        public var identifier: String? {
            return bundle.infoDictionary?["CFBundleIdentifier"] as? String
        }
        
        public var name: String? {
            return bundle.infoDictionary?["CFBundleName"] as? String
        }
        
        public var localizedName: String? {
            return bundle.localizedInfoDictionary?["CFBundleDisplayName"] as? String
        }
        
        public var version: String? {
            return bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        }
        
        public var build: String? {
            return bundle.infoDictionary?["CFBundleVersion"] as? String
        }
        
        public var fullVersion: String? {
            guard let version = version, build = build else { return nil }
            return "\(version) (\(build))"
        }
        
        public var nameAndFullVersion: String? {
            guard let name = name else { return nil }
            let version = fullVersion ?? ""
            return "\(name) \(version)"
        }
    }
#endif

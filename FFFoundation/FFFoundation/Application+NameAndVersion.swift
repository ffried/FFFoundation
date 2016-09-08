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
    
#if swift(>=3.0)
    #if os(iOS)
        public let App = Application.shared
    #elseif os(OSX)
        public let App = Application.shared()
    #endif
#else
    public let App = Application.sharedApplication()
#endif

    public extension Application {
        #if swift(>=3.0)
        private var bundle: Bundle { return .main }
        #else
        private var bundle: NSBundle { return NSBundle.mainBundle() }
        #endif
        
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
            guard let version = version, let build = build else { return nil }
            return "\(version) (\(build))"
        }
        
        public var nameAndFullVersion: String? {
            guard let name = name else { return nil }
            let version = fullVersion ?? ""
            return "\(name) \(version)"
        }
    }
#endif

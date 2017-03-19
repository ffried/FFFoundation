//
//  Application+NameAndVersion.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 08/04/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

#if os(iOS) || os(macOS)
    import class Foundation.Bundle
    #if os(iOS)
        import class UIKit.UIApplication
        public typealias Application = UIApplication
    #elseif os(macOS)
        import class AppKit.NSApplication
        public typealias Application = NSApplication
    #endif

    public extension Application {
        private var bundle: Bundle { return .main }
        
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

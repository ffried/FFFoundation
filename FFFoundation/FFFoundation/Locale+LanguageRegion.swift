//
//  Locale+LanguageRegion.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 29/03/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import struct Foundation.Locale
import class Foundation.NSLocale

public extension Locale {
    public static var localizedDeviceLanguage: String? {
        if let prefLanguageCode = preferredLanguages.first {
            let locale = self.init(identifier: prefLanguageCode)
            return (locale as NSLocale).displayName(forKey: .identifier, value: prefLanguageCode)
        }
        return nil
    }
    
    public static var localizedDeviceRegion: String? {
        return (current as NSLocale).displayName(forKey: .identifier, value: current.identifier)
    }
}

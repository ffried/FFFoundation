//
//  NSLocale+LanguageRegion.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 29/03/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import Foundation

#if swift(>=3.0)
public extension Locale {
    public static var localizedDeviceLanguage: String? {
        if let prefLanguageCode = preferredLanguages.first {
            let locale = self.init(identifier: prefLanguageCode)
            return (locale as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: prefLanguageCode)
        }
        return nil
    }
    
    public static var localizedDeviceRegion: String? {
        let locale = current
        return (locale as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: locale.identifier)
    }
}
#else
public extension NSLocale {
    public static var localizedDeviceLanguage: String? {
        if let prefLanguageCode = preferredLanguages().first {
            let locale = self.init(localeIdentifier: prefLanguageCode)
            return locale.displayNameForKey(NSLocaleIdentifier, value: prefLanguageCode)
        }
        return nil
    }
    
    public static var localizedDeviceRegion: String? {
        let locale = currentLocale()
        return locale.displayNameForKey(NSLocaleIdentifier, value: locale.localeIdentifier)
    }
}
#endif

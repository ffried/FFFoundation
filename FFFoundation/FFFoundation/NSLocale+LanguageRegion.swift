//
//  NSLocale+LanguageRegion.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 29/03/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import Foundation

public extension NSLocale {
    public static var localizedDeviceLanguage: String? {
        if let prefLanguageCode = preferredLanguages().first {
            let locale = self.init(localeIdentifier: prefLanguageCode)
            #if swift(>=3.0)
                return locale.displayName(forKey: NSLocaleIdentifier, value: prefLanguageCode)
            #else
                return locale.displayNameForKey(NSLocaleIdentifier, value: prefLanguageCode)
            #endif
        }
        return nil
    }
    
    public static var localizedDeviceRegion: String? {
        #if swift(>=3.0)
            let locale = current()
            return locale.displayName(forKey: NSLocaleIdentifier, value: locale.localeIdentifier)
        #else
            let locale = currentLocale()
            return locale.displayNameForKey(NSLocaleIdentifier, value: locale.localeIdentifier)
        #endif
    }
}

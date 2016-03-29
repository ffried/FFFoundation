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
            return locale.displayNameForKey(NSLocaleIdentifier, value: prefLanguageCode)
        }
        return nil
    }
    
    public static var localizedDeviceRegion: String? {
        let locale = currentLocale()
        return locale.displayNameForKey(NSLocaleIdentifier, value: locale.localeIdentifier)
    }
}

//
//  Locale+LanguageRegion.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 29/03/16.
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

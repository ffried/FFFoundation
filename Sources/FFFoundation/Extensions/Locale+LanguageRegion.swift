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

public extension Locale {
    public static var localizedDeviceLanguage: String? {
        return preferredLanguages.first.map(self.init).flatMap {
            $0.languageCode.flatMap($0.localizedString(forLanguageCode:))
        }
    }
    
    public static var localizedDeviceRegion: String? {
        return current.regionCode.flatMap(current.localizedString(forRegionCode:))
    }
}

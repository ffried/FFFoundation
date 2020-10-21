//
//  DispatchHelpers.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 30/05/16.
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

import Dispatch

extension DispatchQoS: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.qosClass < rhs.qosClass
    }
}

extension DispatchQoS.QoSClass: Comparable {
    private var sortValue: UInt32 {
        #if !os(Linux)
        return rawValue.rawValue
        #else
        switch self {
        case .background: return 0x09
//        case .maintenance: return 0x05
        case .utility: return 0x11
        case .default: return 0x15
        case .userInitiated: return 0x19
        case .userInteractive: return 0x21
        case .unspecified: return 0x00
        }
        #endif
    }

    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.sortValue < rhs.sortValue
    }
}

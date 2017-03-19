//
//  DateFormatters.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 12/06/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import Foundation

extension DateFormatter {
    internal static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
}

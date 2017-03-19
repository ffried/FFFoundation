//
//  JSONExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 12/06/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import Foundation

extension Date: JSONStaticCreatable, JSONRepresentable {
    public typealias JSONType = String
    
    public static var jsonDateFormatter: DateFormatter = .iso8601Formatter
    
    public static func from(json: JSONType) -> Date? {
        return jsonDateFormatter.date(from: json)
            .map { $0.timeIntervalSinceReferenceDate }
            .map { self.init(timeIntervalSinceReferenceDate: $0) }
    }
    
    public var json: JSONType {
        return type(of: self).jsonDateFormatter.string(from: self)
    }
}

extension URL: JSONStaticCreatable, JSONRepresentable {
    public typealias JSONType = String
    
    public static func from(json: JSONType) -> URL? {
        return self.init(string: json)
    }
    
    public var json: JSONType { return absoluteString }
}
    
extension Locale: JSONStaticCreatable, JSONRepresentable {
    public typealias JSONType = String
    
    public static func from(json: JSONType) -> Locale? {
        return self.init(identifier: json)
    }
    
    public var json: JSONType { return identifier }
}

extension TimeZone: JSONStaticCreatable, JSONRepresentable {
    public typealias JSONType = String
    
    public static func from(json: JSONType) -> TimeZone? {
        return self.init(identifier: json)// ?? self.init(abbreviation: json)
    }
    
    public var json: JSONType { return identifier }
}

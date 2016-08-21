//
//  JSONExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 12/06/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

import Foundation

#if swift(>=3.0)
extension Date: JSONStaticCreatable, JSONRepresentable {
    public typealias JSONType = String
    
    public static func from(json: JSONType) -> Date? {
        return ISO8601Formatter.date(from: json)
            .map { $0.timeIntervalSinceReferenceDate }
            .map { self.init(timeIntervalSinceReferenceDate: $0) }
    }
    
    public var json: JSONType {
        return ISO8601Formatter.string(from: self)
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
#else
extension NSDate: JSONStaticCreatable, JSONRepresentable {
    public typealias JSONType = String

    public static func from(json json: JSONType) -> Self? {
        return ISO8601Formatter.dateFromString(json)
        .map { $0.timeIntervalSinceReferenceDate }
        .map { self.init(timeIntervalSinceReferenceDate: $0) }
    }

    public var json: JSONType {
        return ISO8601Formatter.stringFromDate(self)
    }
}

extension NSURL: JSONStaticCreatable, JSONRepresentable {
    public typealias JSONType = String
    
    public static func from(json json: JSONType) -> Self? {
        return self.init(string: json)
    }
    
    public var json: JSONType { return absoluteString }
}

extension NSLocale: JSONStaticCreatable, JSONRepresentable {
    public typealias JSONType = String
    
    public static func from(json json: JSONType) -> Self? {
        return self.init(localeIdentifier: json)
    }
    
    public var json: JSONType { return localeIdentifier }
}

extension NSTimeZone: JSONStaticCreatable, JSONRepresentable {
    public typealias JSONType = String
    
    public static func from(json json: JSONType) -> Self? {
        return self.init(abbreviation: json) ?? self.init(name: json)
    }
    
    public var json: JSONType { return abbreviation ?? name }
}
#endif

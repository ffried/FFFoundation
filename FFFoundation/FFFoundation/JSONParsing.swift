//
//  JSONParsing.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 12/06/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

#if swift(>=3.0)
//    precedencegroup JSONPrecedence {
//        associativity: right
//        higherThan: AssignmentPrecedence
//        assignment: true
//    }
  
prefix operator <|
infix operator =<| : AssignmentPrecedence
#else
prefix operator <| {}

infix operator =<| {
    associativity left
    precedence 75
    assignment
}
#endif

public prefix func <|<T>(value: JSONObject?) -> T? {
    return value as? T
}
//
//public prefix func <|<T: JSONCreatable>(value: JSONDictionary.Value?) -> T? {
//    return (value as? T.JSONType).map(T.init)
//}
//
//public prefix func <|<T: JSONStaticCreatable>(value: JSONDictionary.Value?) -> T? {
//    return (value as? T.JSONType).flatMap(T.from)
//}

public prefix func <|<T: JSONCreatable>(value: T.JSONType) -> T {
    return T(json: value)
}

public prefix func <|<T: JSONCreatable>(value: T.JSONType?) -> T? {
    return value.map(T.init)
}

public prefix func <|<T: JSONStaticCreatable>(value: T.JSONType?) -> T? {
    return value.flatMap(T.from)
}

#if swift(>=3.0)
public prefix func <|<T: JSONCreatable>(value: JSONArray<T.JSONType>) -> [T] {
    return value.map(T.init)
}

//public prefix func <|<T: JSONCreatable>(value: JSONArray<T.JSONType>?) -> [T]? {
//    return value.map { $0.map(T.init) }
//}

public prefix func <|<T: JSONStaticCreatable>(value: JSONArray<T.JSONType>) -> [T] {
    return value.flatMap(T.from)
}
    
public func =<|<T>(lhs: inout T, value: JSONObject?) {
    if let v: T = <|value { lhs = v }
}

public func =<|<T: JSONCreatable>(lhs: inout T, value: JSONObject?) {
    if let val: T = <|value { lhs = val }
}

public func =<|<T: JSONStaticCreatable>(lhs: inout T, value: JSONObject?) {
    if let val: T = <|value { lhs = val }
}

public func =<|<T: JSONCreatable>(lhs: inout T?, value: JSONObject?) {
    lhs = <|value
}

public func =<|<T: JSONStaticCreatable>(lhs: inout T?, value: JSONObject?) {
    lhs = <|value
}
    
public func =<|<T: JSONCreatable>(lhs: inout [T]?, value: JSONObject?) {
    if let val: JSONArray<T.JSONType> = <|value { lhs = <|val }
}

public func =<|<T: JSONStaticCreatable>(lhs: inout [T]?, value: JSONObject?) {
    if let val: JSONArray<T.JSONType> = <|value  { lhs = <|val }
}

//public func =<|<T: JSONCreatable>(lhs: inout [T]?, value: JSONObject?) {
//    if let val = value { lhs =<| val }
//}

//public func =<|<T: JSONStaticCreatable>(lhs: inout [T]?, value: JSONObject?) {
//    if let val = value { lhs =<| val }
//}

public func =<|<T: JSONCreatable>(lhs: inout T, value: T.JSONType) {
    lhs = <|value
}

public func =<|<T: JSONStaticCreatable>(lhs: inout T, value: T.JSONType) {
    if let val: T = <|value { lhs = val }
}

public func =<|<T: JSONCreatable>(lhs: inout T?, value: T.JSONType?) {
    lhs = <|value
}

public func =<|<T: JSONStaticCreatable>(lhs: inout T?, value: T.JSONType?) {
    lhs = <|value
}
    
public func =<|<T: JSONCreatable>(lhs: inout [T], value: [T.JSONType]) {
    lhs = <|value
}

public func =<|<T: JSONStaticCreatable>(lhs: inout [T], value: [T.JSONType]) {
    lhs = <|value
}

public func =<|<T: JSONCreatable>(lhs: inout [T]?, value: [T.JSONType]?) {
    lhs = <|value
}

public func =<|<T: JSONStaticCreatable>(lhs: inout [T]?, value: [T.JSONType]?) {
    lhs = <|value
}
#else
public prefix func <|<T: JSONCreatable>(value: Array<T.JSONType>) -> [T] {
    return value.map(T.init)
}
    
public prefix func <|<T: JSONCreatable>(value: Array<T.JSONType>?) -> [T]? {
    return value.map { $0.map(T.init) }
}
    
public prefix func <|<T: JSONStaticCreatable>(value: Array<T.JSONType>?) -> [T]? {
    return value.map { $0.flatMap(T.from) }
}
    
public func =<|<T>(inout lhs: T, value: JSONDictionary.Value?) {
    if let v: T = <|value { lhs = v }
}

public func =<|<T: JSONCreatable>(inout lhs: T, value: JSONDictionary.Value?) {
    if let val: T = <|value { lhs = val }
}

public func =<|<T: JSONStaticCreatable>(inout lhs: T, value: JSONDictionary.Value?) {
    if let val: T = <|value { lhs = val }
}

public func =<|<T: JSONCreatable>(inout lhs: T?, value: JSONDictionary.Value?) {
    lhs = <|value
}

public func =<|<T: JSONStaticCreatable>(inout lhs: T?, value: JSONDictionary.Value?) {
    lhs = <|value
}
    
public func =<|<T: JSONCreatable>(inout lhs: [T], value: JSONDictionary.Value?) {
    if let val: Array<T.JSONType> = <|value { lhs = <|val }
}

public func =<|<T: JSONStaticCreatable>(inout lhs: [T], value: JSONDictionary.Value?) {
    if let val: Array<T.JSONType> = <|value,
        let arr: Array<T> = <|val { lhs = arr }
}

public func =<|<T: JSONCreatable>(inout lhs: [T]?, value: JSONDictionary.Value?) {
    if let val = value { lhs =<| val }
}

public func =<|<T: JSONStaticCreatable>(inout lhs: [T]?, value: JSONDictionary.Value?) {
    if let val = value { lhs =<| val }
}

public func =<|<T: JSONCreatable>(inout lhs: T, value: T.JSONType) {
    lhs = <|value
}

public func =<|<T: JSONStaticCreatable>(inout lhs: T, value: T.JSONType) {
    if let val: T = <|value { lhs = val }
}

public func =<|<T: JSONCreatable>(inout lhs: T?, value: T.JSONType?) {
    lhs = <|value
}

public func =<|<T: JSONStaticCreatable>(inout lhs: T?, value: T.JSONType?) {
    lhs = <|value
}
    
public func =<|<T: JSONCreatable>(inout lhs: [T], value: [T.JSONType]) {
    lhs = <|value
}

public func =<|<T: JSONStaticCreatable>(inout lhs: [T], value: [T.JSONType]) {
    if let val: [T] = <|value { lhs = val }
}

public func =<|<T: JSONCreatable>(inout lhs: [T]?, value: [T.JSONType]?) {
    lhs = <|value
}

public func =<|<T: JSONStaticCreatable>(inout lhs: [T]?, value: [T.JSONType]?) {
    lhs = <|value
}
#endif

public struct JSON {
    private init() { }
    
    public static func convert<T>(value: JSONObject?) -> T? {
        return <|value
    }
    
    public static func convert<T: JSONCreatable>(value: JSONObject?) -> T? {
        return <|value
    }
    
    public static func convert<T: JSONStaticCreatable>(value: JSONObject?) -> T? {
        return <|value
    }
    
    public static func convert<T: JSONCreatable>(value: T.JSONType) -> T {
        return <|value
    }
    
    public static func convert<T: JSONStaticCreatable>(value: T.JSONType) -> T? {
        return <|value
    }
    
    #if swift(>=3.0)
    public static func convert<T: JSONCreatable>(value: JSONArray<T.JSONType>) -> [T] {
        return <|value
    }
    
    public static func convert<T: JSONCreatable>(value: JSONArray<T.JSONType>?) -> [T]? {
        return <|value
    }
    
    public static func convert<T: JSONStaticCreatable>(value: JSONArray<T.JSONType>?) -> [T]? {
        return <|value
    }
    
    public static func map<T>(value: JSONObject?, to output: inout T) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: JSONObject?, to output: inout T) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: JSONObject?, to output: inout T) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: JSONObject?, to output: inout T?) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: JSONObject?, to output: inout T?) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: JSONObject?, to output: inout [T]) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: JSONObject?, to output: inout [T]) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: JSONObject?, to output: inout [T]?) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: JSONObject?, to output: inout [T]?) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: T.JSONType, to output: inout T) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: T.JSONType, to output: inout T) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: T.JSONType?, to output: inout T?) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: T.JSONType?, to output: inout T?) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: [T.JSONType], to output: inout [T]) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: [T.JSONType], to output: inout [T]) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: [T.JSONType]?, to output: inout [T]?) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: [T.JSONType]?, to output: inout [T]?) {
        output =<| value
    }
    #else
    public static func convert<T: JSONCreatable>(value: Array<T.JSONType>) -> [T] {
        return <|value
    }
    
    public static func convert<T: JSONCreatable>(value: Array<T.JSONType>?) -> [T]? {
        return <|value
    }
    
    public static func convert<T: JSONStaticCreatable>(value: Array<T.JSONType>?) -> [T]? {
        return <|value
    }
    
    public static func map<T>(value: JSONDictionary.Value?, inout to output: T) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: JSONDictionary.Value?, inout to output: T) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: JSONDictionary.Value?, inout to output: T) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: JSONDictionary.Value?, inout to output: T?) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: JSONDictionary.Value?, inout to output: T?) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: JSONObject?, inout to output: [T]) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: JSONObject?, inout to output: [T]) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: JSONObject?, inout to output: [T]?) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: JSONObject?, inout to output: [T]?) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: T.JSONType, inout to output: T) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: T.JSONType, inout to output: T) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: T.JSONType?, inout to output: T?) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: T.JSONType?, inout to output: T?) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: [T.JSONType], inout to output: [T]) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: [T.JSONType], inout to output: [T]) {
        output =<| value
    }
    
    public static func map<T: JSONCreatable>(value: [T.JSONType]?, inout to output: [T]?) {
        output =<| value
    }
    
    public static func map<T: JSONStaticCreatable>(value: [T.JSONType]?, inout to output: [T]?) {
        output =<| value
    }
    #endif
}

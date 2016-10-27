//
//  JSONTypes.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 12/06/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

#if swift(>=3.0)
    public typealias JSONObject = Any
    public typealias JSONDictionary<Value: JSONObject> = Dictionary<String, Value>
    public typealias JSONArray<Value: JSONObject> = Array<Value>
#else
    public typealias JSONObject = AnyObject
    public typealias JSONDictionary = Dictionary<String, JSONObject>
    public typealias JSONArray = Array<JSONObject>
#endif

public protocol JSONType {
    associatedtype JSONType = JSONObject
}

public protocol JSONCreatable: JSONType {
    init(json: JSONType)
}

public protocol JSONUpdatable: JSONType {
    mutating func update(fromJSON json: JSONType)
}

public protocol JSONRepresentable: JSONType {
    var json: JSONType { get }
}

public protocol JSONTransformable: JSONCreatable, JSONRepresentable, JSONUpdatable {}

public protocol JSONStaticCreatable: JSONType {
    #if swift(>=3.0)
    static func from(json: JSONType) -> Self?
    #else
    static func from(json json: JSONType) -> Self?
    #endif
}

public extension JSONCreatable where Self: JSONStaticCreatable {
    #if swift(>=3.0)
    public static func from(json: JSONType) -> Self? {
        return self.init(json: json)
    }
    #else
    public static func from(json json: JSONType) -> Self? {
        return self.init(json: json)
    }
    #endif
}

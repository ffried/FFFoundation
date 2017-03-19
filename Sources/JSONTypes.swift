//
//  JSONTypes.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 12/06/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

public typealias JSONObject = Any
public typealias JSONDictionary<Value: JSONObject> = Dictionary<String, Value>
public typealias JSONArray<Value: JSONObject> = Array<Value>

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
    static func from(json: JSONType) -> Self?
}

public extension JSONCreatable where Self: JSONStaticCreatable {
    public static func from(json: JSONType) -> Self? {
        return self.init(json: json)
    }
}

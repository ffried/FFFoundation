//
//  Lazy.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 26/05/16.
//  Copyright © 2016 Florian Friedrich. All rights reserved.
//

public struct Lazy<T> {
    public typealias Constructor = () -> T
    
    private let constructor: Constructor
    
    public private(set) lazy var value: T = self.constructor()
    
    #if swift(>=3.0)
    public init(_ constructor: @escaping Constructor) {
        self.constructor = constructor
    }
    #else
    public init(_ constructor: Constructor) {
        self.constructor = constructor
    }
    #endif
}

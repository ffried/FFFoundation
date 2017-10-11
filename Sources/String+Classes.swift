//
//  String+Classes.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 9.12.14.
//  Copyright 2014 Florian Friedrich
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

import func Foundation.NSStringFromClass

public extension String {
    /**
     Swift-aware NSStringFromClass. Removes '.' in Swift class names if `removeNamespace` is `true`.
     
     - parameter aClass:          The class to convert to a string.
     - parameter removeNamespace: If `true`, Dots (and the preceding namespace) gets removed from the name. Defaults to `true`.
     
     - returns: The name of the class as string. Dots are removed if `removeNamespace` was `true`.
     
     - note: If `removeNamespace` is `false`, this behaves just like `NSSStringFromClass`.
     */
    public init(class aClass: AnyClass, removeNamespace: Bool = true) {
        var className = NSStringFromClass(aClass)
        
        if removeNamespace, let range = className.range(of: ".", options: .backwards) {
            className = String(className[range.upperBound...])
        }
        
        self = className
    }
}

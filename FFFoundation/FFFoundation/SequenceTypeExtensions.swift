//
//  SequenceTypeExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 02/09/15.
//  Copyright © 2015 Florian Friedrich. All rights reserved.
//

import Foundation

public extension SequenceType {
    @warn_unused_result
    public func groupBy<Key: Hashable>(@noescape keyGen: Generator.Element throws -> Key) rethrows -> [Key: [Generator.Element]] {
        var grouped = Dictionary<Key, Array<Generator.Element>>()
        try forEach { elem in
            let key = try keyGen(elem)
            var group = grouped[key] ?? Array<Generator.Element>()
            group.append(elem)
            grouped[key] = group
        }
        return grouped
    }
}

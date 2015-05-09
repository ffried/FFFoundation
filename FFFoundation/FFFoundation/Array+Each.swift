//
//  Array+Each.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 09/05/15.
//  Copyright (c) 2015 Florian Friedrich. All rights reserved.
//

import FFFoundation

extension Array {
    func each(block: (Element) -> ()) {
        for obj in self { block(obj) }
    }
}

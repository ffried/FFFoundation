//
//  Predicate+Operators.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 23.07.20.
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

// KVC is only available on Darwin platforms
#if canImport(ObjectiveC)
import Foundation

// MARK: - Equatable
// MARK: KeyPath (left)
public func == <Root>(lhs: KeyPath<Root, Bool>, rhs: Bool?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root>(lhs: KeyPath<Root, Bool>, rhs: Bool?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root, Value: Equatable>(lhs: KeyPath<Root, Value>, rhs: Value?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root, Value: Equatable>(lhs: KeyPath<Root, Value>, rhs: Value?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root, Value: Equatable & ReferenceConvertible>(lhs: KeyPath<Root, Value>, rhs: Value?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root, Value: Equatable & ReferenceConvertible>(lhs: KeyPath<Root, Value>, rhs: Value?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root, Value: Equatable & SignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root, Value: Equatable & SignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root, Value: Equatable & UnsignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root, Value: Equatable & UnsignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root, Value: Equatable & FloatingPoint>(lhs: KeyPath<Root, Value>, rhs: Value?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root, Value: Equatable & FloatingPoint>(lhs: KeyPath<Root, Value>, rhs: Value?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root>(lhs: KeyPath<Root, NSNumber>, rhs: NSNumber?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root>(lhs: KeyPath<Root, NSNumber>, rhs: NSNumber?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

// MARK: KeyPath (right)
public func == <Root>(lhs: Bool?, rhs: KeyPath<Root, Bool>) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root>(lhs: Bool?, rhs: KeyPath<Root, Bool>) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root, Value: Equatable>(lhs: Value?, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root, Value: Equatable>(lhs: Value?, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root, Value: Equatable & ReferenceConvertible>(lhs: Value?, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root, Value: Equatable & ReferenceConvertible>(lhs: Value?, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root, Value: Equatable & SignedInteger>(lhs: Value?, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root, Value: Equatable & SignedInteger>(lhs: Value?, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root, Value: Equatable & UnsignedInteger>(lhs: Value?, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root, Value: Equatable & UnsignedInteger>(lhs: Value?, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root, Value: Equatable & FloatingPoint>(lhs: Value?, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root, Value: Equatable & FloatingPoint>(lhs: Value?, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Root>(lhs: NSNumber?, rhs: KeyPath<Root, NSNumber>) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Root>(lhs: NSNumber?, rhs: KeyPath<Root, NSNumber>) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

// MARK: Key (left)
public func == (lhs: NSPredicate.Key, rhs: Bool?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != (lhs: NSPredicate.Key, rhs: Bool?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Value: Equatable>(lhs: NSPredicate.Key, rhs: Value?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Value: Equatable>(lhs: NSPredicate.Key, rhs: Value?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Value: Equatable & ReferenceConvertible>(lhs: NSPredicate.Key, rhs: Value?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Value: Equatable & ReferenceConvertible>(lhs: NSPredicate.Key, rhs: Value?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Value: Equatable & SignedInteger>(lhs: NSPredicate.Key, rhs: Value?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Value: Equatable & SignedInteger>(lhs: NSPredicate.Key, rhs: Value?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Value: Equatable & UnsignedInteger>(lhs: NSPredicate.Key, rhs: Value?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Value: Equatable & UnsignedInteger>(lhs: NSPredicate.Key, rhs: Value?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Value: Equatable & FloatingPoint>(lhs: NSPredicate.Key, rhs: Value?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Value: Equatable & FloatingPoint>(lhs: NSPredicate.Key, rhs: Value?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == (lhs: NSPredicate.Key, rhs: NSNumber?) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != (lhs: NSPredicate.Key, rhs: NSNumber?) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

// MARK: Key (right)
public func == (lhs: Bool?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != (lhs: Bool?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Value: Equatable>(lhs: Value?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Value: Equatable>(lhs: Value?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Value: Equatable & ReferenceConvertible>(lhs: Value?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Value: Equatable & ReferenceConvertible>(lhs: Value?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Value: Equatable & SignedInteger>(lhs: Value?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Value: Equatable & SignedInteger>(lhs: Value?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Value: Equatable & UnsignedInteger>(lhs: Value?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Value: Equatable & UnsignedInteger>(lhs: Value?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == <Value: Equatable & FloatingPoint>(lhs: Value?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != <Value: Equatable & FloatingPoint>(lhs: Value?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}

public func == (lhs: NSNumber?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) == \(rhs)")
}

public func != (lhs: NSNumber?, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) != \(rhs)")
}


// MARK: - Comparable
// MARK: KeyPath (left)
public func < <Root, Value: Comparable>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root, Value: Comparable>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root, Value: Comparable>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root, Value: Comparable>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Root, Value: Comparable & ReferenceConvertible>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root, Value: Comparable & ReferenceConvertible>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root, Value: Comparable & ReferenceConvertible>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root, Value: Comparable & ReferenceConvertible>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Root, Value: Comparable & SignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root, Value: Comparable & SignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root, Value: Comparable & SignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root, Value: Comparable & SignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Root, Value: Comparable & UnsignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root, Value: Comparable & UnsignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root, Value: Comparable & UnsignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root, Value: Comparable & UnsignedInteger>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Root, Value: Comparable & FloatingPoint>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root, Value: Comparable & FloatingPoint>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root, Value: Comparable & FloatingPoint>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root, Value: Comparable & FloatingPoint>(lhs: KeyPath<Root, Value>, rhs: Value) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Root>(lhs: KeyPath<Root, NSNumber>, rhs: NSNumber) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root>(lhs: KeyPath<Root, NSNumber>, rhs: NSNumber) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root>(lhs: KeyPath<Root, NSNumber>, rhs: NSNumber) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root>(lhs: KeyPath<Root, NSNumber>, rhs: NSNumber) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

// MARK: KeyPath (right)
public func < <Root, Value: Comparable>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root, Value: Comparable>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root, Value: Comparable>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root, Value: Comparable>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Root, Value: Comparable & ReferenceConvertible>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root, Value: Comparable & ReferenceConvertible>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root, Value: Comparable & ReferenceConvertible>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root, Value: Comparable & ReferenceConvertible>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Root, Value: Comparable & SignedInteger>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root, Value: Comparable & SignedInteger>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root, Value: Comparable & SignedInteger>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root, Value: Comparable & SignedInteger>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Root, Value: Comparable & UnsignedInteger>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root, Value: Comparable & UnsignedInteger>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root, Value: Comparable & UnsignedInteger>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root, Value: Comparable & UnsignedInteger>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Root, Value: Comparable & FloatingPoint>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root, Value: Comparable & FloatingPoint>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root, Value: Comparable & FloatingPoint>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root, Value: Comparable & FloatingPoint>(lhs: Value, rhs: KeyPath<Root, Value>) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Root>(lhs: NSNumber, rhs: KeyPath<Root, NSNumber>) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Root>(lhs: NSNumber, rhs: KeyPath<Root, NSNumber>) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Root>(lhs: NSNumber, rhs: KeyPath<Root, NSNumber>) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Root>(lhs: NSNumber, rhs: KeyPath<Root, NSNumber>) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

// MARK: Key (left)
public func < <Value: Comparable>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Value: Comparable>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Value: Comparable>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Value: Comparable>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Value: Comparable & ReferenceConvertible>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Value: Comparable & ReferenceConvertible>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Value: Comparable & ReferenceConvertible>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Value: Comparable & ReferenceConvertible>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Value: Comparable & SignedInteger>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Value: Comparable & SignedInteger>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Value: Comparable & SignedInteger>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Value: Comparable & SignedInteger>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Value: Comparable & UnsignedInteger>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Value: Comparable & UnsignedInteger>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Value: Comparable & UnsignedInteger>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Value: Comparable & UnsignedInteger>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Value: Comparable & FloatingPoint>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Value: Comparable & FloatingPoint>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Value: Comparable & FloatingPoint>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Value: Comparable & FloatingPoint>(lhs: NSPredicate.Key, rhs: Value) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < (lhs: NSPredicate.Key, rhs: NSNumber) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > (lhs: NSPredicate.Key, rhs: NSNumber) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= (lhs: NSPredicate.Key, rhs: NSNumber) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= (lhs: NSPredicate.Key, rhs: NSNumber) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

// MARK: Key (right)
public func < <Value: Comparable>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Value: Comparable>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Value: Comparable>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Value: Comparable>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Value: Comparable & ReferenceConvertible>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Value: Comparable & ReferenceConvertible>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Value: Comparable & ReferenceConvertible>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Value: Comparable & ReferenceConvertible>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Value: Comparable & SignedInteger>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Value: Comparable & SignedInteger>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Value: Comparable & SignedInteger>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Value: Comparable & SignedInteger>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Value: Comparable & UnsignedInteger>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Value: Comparable & UnsignedInteger>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Value: Comparable & UnsignedInteger>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Value: Comparable & UnsignedInteger>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < <Value: Comparable & FloatingPoint>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > <Value: Comparable & FloatingPoint>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= <Value: Comparable & FloatingPoint>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= <Value: Comparable & FloatingPoint>(lhs: Value, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

public func < (lhs: NSNumber, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) < \(rhs)")
}

public func > (lhs: NSNumber, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) > \(rhs)")
}

public func <= (lhs: NSNumber, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) <= \(rhs)")
}

public func >= (lhs: NSNumber, rhs: NSPredicate.Key) -> NSPredicate {
    .init("\(lhs) >= \(rhs)")
}

// MARK: - Negation
@inlinable
public prefix func ! <Root>(lhs: KeyPath<Root, Bool>) -> NSPredicate { lhs != true }

@inlinable
public prefix func ! (lhs: NSPredicate.Key) -> NSPredicate { lhs != true }

public prefix func ! (lhs: NSPredicate) -> NSPredicate {
    NSCompoundPredicate(notPredicateWithSubpredicate: lhs)
}

// MARK: - Combination
public func && (lhs: NSPredicate, rhs: NSPredicate) -> NSPredicate {
    NSCompoundPredicate(andPredicateWithSubpredicates: [lhs, rhs])
}

public func || (lhs: NSPredicate, rhs: NSPredicate) -> NSPredicate {
    NSCompoundPredicate(orPredicateWithSubpredicates: [lhs, rhs])
}
#endif

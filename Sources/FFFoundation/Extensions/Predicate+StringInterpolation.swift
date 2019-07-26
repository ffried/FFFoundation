//
//  Predicate+StringInterpolation.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 25.07.19.
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

import Foundation

extension NSPredicate {
    public struct Format: ExpressibleByStringInterpolation {
        public typealias StringLiteralType = String

        let format: String
        let args: [Any]?

        public init(stringLiteral value: StringLiteralType) {
            format = value
            args = nil
        }

        public init(stringInterpolation: StringInterpolation) {
            format = stringInterpolation.format
            args = stringInterpolation.args
        }
    }

    public convenience init(_ format: Format) {
        self.init(format: format.format, argumentArray: format.args)
    }
}

extension NSPredicate.Format {
    public struct StringInterpolation: StringInterpolationProtocol {
        public typealias StringLiteralType = NSPredicate.Format.StringLiteralType

        private enum ValueKind: String {
            case key = "K"
            case object = "@"
            case string = "s"
            case bool = "u"
            case signedInteger = "ld"
            case unsingedInteger = "lu"
            case float = "f"

            var formatSpecifier: String {
                return "%" + rawValue
            }
        }

        fileprivate private(set) var format: String
        fileprivate private(set) var args: [Any]

        public init(literalCapacity: Int, interpolationCount: Int) {
            format = ""
            args = []
            format.reserveCapacity(literalCapacity + interpolationCount * 2)
            args.reserveCapacity(interpolationCount)
        }

        public mutating func appendLiteral(_ literal: StringLiteralType) {
            format.append(literal)
        }

        private mutating func addNull() {
            format.append("NULL")
        }

        private mutating func add(arg: Any?, as valueKind: ValueKind) {
            if let arg = arg {
                format.append(valueKind.formatSpecifier)
                args.append(arg)
            } else {
                addNull()
            }
        }

        // MARK: Keys
        public mutating func appendInterpolation(key: String) {
            add(arg: key, as: .key)
        }

        #if canImport(ObjectiveC)
        public mutating func appendInterpolation(_ key: AnyKeyPath) {
            guard let kvcString = key._kvcKeyPathString else { fatalError("Cannot get key value coding string from \(key)!") }
            add(arg: kvcString, as: .key)
        }
        #endif

        // MARK: Values
        public mutating func appendInterpolation(_ any: Any?) {
            add(arg: any, as: .object)
        }

        public mutating func appendInterpolation(_ bool: Bool?) {
            add(arg: bool, as: .bool)
        }

        public mutating func appendInterpolation<Bridged: ReferenceConvertible>(_ bridgeable: Bridged?) {
            add(arg: bridgeable.map { $0 as! Bridged.ReferenceType }, as: .object)
        }

        public mutating func appendInterpolation<Integer: SignedInteger>(_ integer: Integer?) {
            add(arg: integer, as: .signedInteger)
        }

        public mutating func appendInterpolation<Integer: UnsignedInteger>(_ integer: Integer?) {
            add(arg: integer, as: .unsingedInteger)
        }

        public mutating func appendInterpolation<Float: FloatingPoint>(_ float: Float?) {
            add(arg: float, as: .float)
        }

        public mutating func appendInterpolation(_ number: NSNumber?) {
            add(arg: number, as: .object)
        }
    }
}

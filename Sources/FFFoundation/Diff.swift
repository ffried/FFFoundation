//
//  Diff.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 04.10.17.
//  Copyright 2017 Florian Friedrich
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

public protocol Diffable: Equatable {
    func contains(_ other: Self) -> Bool
}
extension String: Diffable {}
extension Substring: Diffable {}

public struct Diff<Subject: Collection, Element: Diffable> {
    public typealias Changes = [(Element, Change)]

    public let base: Subject
    public let head: Subject
    public let changes: Changes

    private init(base: Subject, head: Subject, changes: Changes) {
        self.base = base
        self.head = head
        self.changes = changes
    }
}
public typealias SimpleDiff<Subject: Collection & Diffable> = Diff<Subject, Subject>
public typealias ElementDiff<Subject: Collection> = Diff<Subject, Subject.SubSequence> where Subject.SubSequence: Diffable

extension Diff where Subject.Element: Equatable, Element == Subject.SubSequence {
    public init(base: Subject, comparedTo head: Subject, splitBy separator: Subject.Element) {
        let baseSplit = base.split(separator: separator, omittingEmptySubsequences: false)
        let headSplit = head.split(separator: separator, omittingEmptySubsequences: false)
        self.init(base: base, head: head, changes: baseSplit.changes(comparedTo: headSplit))
    }
}

extension Diff where Subject: RangeReplaceableCollection, Subject.Element: Equatable, Element == Subject {
    public init(base: Subject, comparedTo head: Subject, splitBy separator: Subject.Element) {
        let baseSplit = base.split(separator: separator, omittingEmptySubsequences: false).map(Subject.init)
        let headSplit = head.split(separator: separator, omittingEmptySubsequences: false).map(Subject.init)
        self.init(base: base, head: head, changes: baseSplit.changes(comparedTo: headSplit))
    }
}

extension Diff where Subject == String, Element == String.SubSequence {
    public init(base: String, comparedTo head: String) {
        self.init(base: base, comparedTo: head, splitBy: "\n")
    }
}

extension Diff where Subject == String, Element == Subject {
    public init(base: String, comparedTo head: String) {
        self.init(base: base, comparedTo: head, splitBy: "\n")
    }
}

fileprivate extension Diff {
    enum CodingKeys: String, CodingKey {
        case base, head, changes
    }
    enum ChangeCodingKeys: String, CodingKey {
        case change, element
    }
}

extension Diff: Encodable where Subject: Encodable, Element: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(base, forKey: .base)
        try container.encode(head, forKey: .head)
        var changesContainer = container.nestedUnkeyedContainer(forKey: .changes)
        for (elem, change) in changes {
            var changeContainer = changesContainer.nestedContainer(keyedBy: ChangeCodingKeys.self)
            try changeContainer.encode(change, forKey: .change)
            try changeContainer.encode(elem, forKey: .element)
        }
    }
}

extension Diff: Decodable where Subject: Decodable, Element: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        base = try container.decode(Subject.self, forKey: .base)
        head = try container.decode(Subject.self, forKey: .head)
        var changesContainer = try container.nestedUnkeyedContainer(forKey: .changes)
        var decodedChanges: Changes = []
        changesContainer.count.map { decodedChanges.reserveCapacity($0) }
        while !changesContainer.isAtEnd {
            let changeContainer = try changesContainer.nestedContainer(keyedBy: ChangeCodingKeys.self)
            decodedChanges.append((
                try changeContainer.decode(Element.self, forKey: .element),
                try changeContainer.decode(Change.self, forKey: .change)
            ))
        }
        changes = decodedChanges
    }
}

extension Diff {
    public enum Change: Hashable, CustomStringConvertible, Codable {
        case unchanged, added, removed

        public var description: String {
            switch self {
            case .unchanged: return "Unchanged"
            case .added: return "Added"
            case .removed: return "Removed"
            }
        }

        public var lineSign: String {
            switch self {
            case .unchanged: return ""
            case .added: return "+"
            case .removed: return "-"
            }
        }

        public func annotatedLine(for element: Element) -> String {
            return "\(lineSign)\(element)\n"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "unchanged": self = .unchanged
            case "added": self = .added
            case "removed": self = .removed
            case let invalidValue:
                throw DecodingError.dataCorruptedError(in: container,
                                                       debugDescription: "Could not convert '\(invalidValue)' to \(Change.self)")
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .unchanged: try container.encode("unchanged")
            case .added: try container.encode("added")
            case .removed: try container.encode("removed")
            }
        }
    }
}

fileprivate extension RangeReplaceableCollection where Self: MutableCollection, Element: Diffable, SubSequence: RangeReplaceableCollection & ExpressibleByArrayLiteral, SubSequence.ArrayLiteralElement == Element {
    func changes<C: Collection>(comparedTo head: Self) -> Diff<C, Element>.Changes {
        var (arr1, arr2) = (self, head)
        var result: Diff<C, Element>.Changes = []
        func apply(isAdded: Bool, at idx: Index, unchangedElement: Element) {
            let lines: SubSequence
            if isAdded {
                lines = arr2[..<idx]
                arr2.removeSubrange(..<idx)
            } else {
                lines = arr1[..<idx]
                arr1.removeSubrange(..<idx)
            }
            result.append(contentsOf: zip(lines, repeatElement(isAdded ? .added : .removed, count: lines.count)))
            result.append((unchangedElement, .unchanged))
        }
        while let a = arr1.first, let b = arr2.first {
            defer {
                arr1.removeFirst()
                arr2.removeFirst()
            }
            if a == b {
                result.append((a, .unchanged))
            } else if a.contains(b) || b.contains(a) {
                result.append(contentsOf: [(a, .removed), (b, .added)])
            } else if let idxA = arr2.dropFirst().firstIndex(of: a), let idxB = arr1.dropFirst().firstIndex(of: b) {
                let isAdded = idxA < idxB
                apply(isAdded: isAdded, at: Swift.min(idxA, idxB), unchangedElement: isAdded ? a : b)
            } else if let idx = arr2.dropFirst().firstIndex(of: a) {
                apply(isAdded: true, at: idx, unchangedElement: a)
            } else if let idx = arr1.dropFirst().firstIndex(of: b) {
                apply(isAdded: false, at: idx, unchangedElement: b)
            } else {
                result.append(contentsOf: [(a, .removed), (b, .added)])
            }
        }
        if !arr1.isEmpty || !arr2.isEmpty {
            result.append(contentsOf: zip(arr1, repeatElement(.removed, count: arr1.count)))
            result.append(contentsOf: zip(arr2, repeatElement(.added, count: arr2.count)))
        }
        return result
    }
}

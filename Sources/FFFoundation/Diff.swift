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

public extension Diff where Subject.Element: Equatable, Element == Subject.SubSequence {
    public init(base: Subject, comparedTo head: Subject, splitBy separator: Subject.Element) {
        let baseSplit = base.split(separator: separator, omittingEmptySubsequences: false)
        let headSplit = head.split(separator: separator, omittingEmptySubsequences: false)
        self.init(base: base, head: head, changes: baseSplit.changes(comparedTo: headSplit))
    }
}

public extension Diff where Subject: RangeReplaceableCollection, Subject.Element: Equatable, Element == Subject {
    public init(base: Subject, comparedTo head: Subject, splitBy separator: Subject.Element) {
        let baseSplit = base.split(separator: separator, omittingEmptySubsequences: false).map(Subject.init)
        let headSplit = head.split(separator: separator, omittingEmptySubsequences: false).map(Subject.init)
        self.init(base: base, head: head, changes: baseSplit.changes(comparedTo: headSplit))
    }
}

public extension Diff where Subject == String, Element == String.SubSequence {
    public init(base: String, comparedTo head: String) {
        self.init(base: base, comparedTo: head, splitBy: "\n")
    }
}

public extension Diff where Subject == String, Element == Subject {
    public init(base: String, comparedTo head: String) {
        self.init(base: base, comparedTo: head, splitBy: "\n")
    }
}

public extension Diff {
    public enum Change: Equatable, CustomStringConvertible {
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
            result.append(contentsOf: zip(lines, repeatElement(isAdded ? .added : .removed, count: Int(lines.count))))
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
            } else if let idxA = arr2.dropFirst().index(of: a), let idxB = arr1.dropFirst().index(of: b) {
                let isAdded = idxA < idxB
                apply(isAdded: isAdded, at: Swift.min(idxA, idxB), unchangedElement: isAdded ? a : b)
            } else if let idx = arr2.dropFirst().index(of: a) {
                apply(isAdded: true, at: idx, unchangedElement: a)
            } else if let idx = arr1.dropFirst().index(of: b) {
                apply(isAdded: false, at: idx, unchangedElement: b)
            } else {
                result.append(contentsOf: [(a, .removed), (b, .added)])
            }
        }
        if !arr1.isEmpty || !arr2.isEmpty {
            result.append(contentsOf: zip(arr1, repeatElement(.removed, count: Int(arr1.count))))
            result.append(contentsOf: zip(arr2, repeatElement(.added, count: Int(arr2.count))))
        }
        return result
    }
}

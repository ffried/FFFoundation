//
//  DiffTests.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 05.10.17.
//

import XCTest
@testable import FFFoundation

final class DiffTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testChangeLignSign() {
        let change1: SimpleDiff<String>.Change = .unchanged
        let change2: SimpleDiff<String>.Change = .added
        let change3: SimpleDiff<String>.Change = .removed

        let change1Sign = change1.lineSign
        let change2Sign = change2.lineSign
        let change3Sign = change3.lineSign

        XCTAssertEqual(change1Sign, "")
        XCTAssertEqual(change2Sign, "+")
        XCTAssertEqual(change3Sign, "-")
    }

    func testChangeAnnotation() {
        let change1: SimpleDiff<String>.Change = .unchanged
        let change2: SimpleDiff<String>.Change = .added
        let change3: SimpleDiff<String>.Change = .removed

        let change1Annotated = change1.annotatedLine(for: "Test")
        let change2Annotated = change2.annotatedLine(for: "Test")
        let change3Annotated = change3.annotatedLine(for: "Test")

        XCTAssertEqual(change1Annotated, "Test\n")
        XCTAssertEqual(change2Annotated, "+Test\n")
        XCTAssertEqual(change3Annotated, "-Test\n")
    }

    func testSimpleDiff() {
        let baseString = "abcdef".map(String.init).joined(separator: "\n")
        let headString = "adbcdegh".map(String.init).joined(separator: "\n")

        let simpleDiff = SimpleDiff<String>(base: baseString, comparedTo: headString)

        let expectedChanges: SimpleDiff<String>.Changes = [
            ("a", .unchanged),
            ("d", .added),
            ("b", .unchanged),
            ("c", .unchanged),
            ("d", .unchanged),
            ("e", .unchanged),
            ("f", .removed),
            ("g", .added),
            ("h", .added)
        ]
        XCTAssertEqual(expectedChanges.count, simpleDiff.changes.count)
        for (idx, ((expectedStr, expectedChange), (actualStr, actualChange))) in zip(expectedChanges, simpleDiff.changes).enumerated() {
            XCTAssertEqual(expectedStr, actualStr, "Strings not equal at \(idx)")
            XCTAssertEqual(expectedChange, actualChange, "Change not equal at \(idx)")
        }
    }

    func testMoreAdvancedDiff() {
        let baseJSON = """
        {
          "_id": "59d5e2154ed8569da4294fc7",
          "index": 0,
          "guid": "f99ff538-57fc-4af4-8e2b-58dda2f9f33a",
          "isActive": false,
          "balance": "$3,827.76",
          "picture": "http://placehold.it/32x32",
          "age": 30,
          "email": "christianwatson@translink.com",
          "phone": "+1 (929) 546-2753",
          "address": "814 Forbell Street, Gorham, Kentucky, 8965",
          "about": "Est duis voluptate nisi enim eu ea irure occaecat adipisicing exercitation. Ex mollit mollit minim qui laborum sunt. Commodo sit ad amet labore exercitation anim do ipsum aute.",
          "registered": "2016-03-26T05:41:57 -01:00",
          "latitude": 5.251403,
          "longitude": -140.742785,
          "tags": [
            "ex",
            "aliqua",
            "elit",
            "anim",
            "labore"
          ],
          "friends": [
            {
              "id": 0,
              "name": "Mariana Klein"
            },
            {
              "id": 1,
              "name": "Roach Chaney"
            },
            {
              "id": 2,
              "name": "Mayra Hawkins"
            }
          ],
          "greeting": "Hello, Christian Watson! You have 9 unread messages.",
          "favoriteFruit": "banana"
        }
        """
        let headJSON = """
        {
          "_id": "59c5e2154ed8569da4294fc7",
          "index": 5,
          "guid": "f99ff538-abcd-4af4-8e2b-58dda2f9f33a",
          "isActive": true,
          "balance": "$3,827.76",
          "picture": "http://placehold.it/32x32",
          "age": 30,
          "email": "other_guy@translink.com",
          "phone": "+31 (229) 546-3753",
          "address": "814 Forbell Road, Gorham, Kentucky, 8966",
          "about": "Est duis voluptate nisi enim eu ea irure occaecat adipisicing exercitation. Ex mollit mollit minim qui laborum sunt. Commodo sit ad amet labore exercitation do ipsum aute.",
          "registered": "2016-03-26T05:41:57 -01:00",
          "latitude": 5.251403,
          "longitude": -140.742785,
          "sub_object": {
            "with": "keys",
            "and": 1234.56
          }
          "tags": [
            "ex",
            "elit",
            "anim",
            "yes",
            "labore"
          ],
          "friends": [
            {
              "id": 0,
              "name": "Mariana Klein"
            },
            {
              "id": 2,
              "name": "Mayra Hawkins"
            }
          ],
          "greeting": "Hello, Christian Watson! You have 9 unread messages.",
          "whatever": "this is",
          "favoriteFruit": "banana"
        }
        """

        let expectedAnnotatedDiff = """
        {
        -  "_id": "59d5e2154ed8569da4294fc7",
        +  "_id": "59c5e2154ed8569da4294fc7",
        -  "index": 0,
        +  "index": 5,
        -  "guid": "f99ff538-57fc-4af4-8e2b-58dda2f9f33a",
        +  "guid": "f99ff538-abcd-4af4-8e2b-58dda2f9f33a",
        -  "isActive": false,
        +  "isActive": true,
          "balance": "$3,827.76",
          "picture": "http://placehold.it/32x32",
          "age": 30,
        -  "email": "christianwatson@translink.com",
        +  "email": "other_guy@translink.com",
        -  "phone": "+1 (929) 546-2753",
        +  "phone": "+31 (229) 546-3753",
        -  "address": "814 Forbell Street, Gorham, Kentucky, 8965",
        +  "address": "814 Forbell Road, Gorham, Kentucky, 8966",
        -  "about": "Est duis voluptate nisi enim eu ea irure occaecat adipisicing exercitation. Ex mollit mollit minim qui laborum sunt. Commodo sit ad amet labore exercitation anim do ipsum aute.",
        +  "about": "Est duis voluptate nisi enim eu ea irure occaecat adipisicing exercitation. Ex mollit mollit minim qui laborum sunt. Commodo sit ad amet labore exercitation do ipsum aute.",
          "registered": "2016-03-26T05:41:57 -01:00",
          "latitude": 5.251403,
          "longitude": -140.742785,
        +  "sub_object": {
        +    "with": "keys",
        +    "and": 1234.56
        +  }
          "tags": [
            "ex",
        -    "aliqua",
            "elit",
            "anim",
        +    "yes",
            "labore"
          ],
          "friends": [
            {
              "id": 0,
              "name": "Mariana Klein"
            },
            {
        -      "id": 1,
        -      "name": "Roach Chaney"
        -    },
        -    {
              "id": 2,
              "name": "Mayra Hawkins"
            }
          ],
          "greeting": "Hello, Christian Watson! You have 9 unread messages.",
        +  "whatever": "this is",
          "favoriteFruit": "banana"
        }\n
        """

        let diff = SimpleDiff<String>(base: baseJSON, comparedTo: headJSON)

        let annotatedDiff = diff.changes.reduce(into: "") { $0 += $1.1.annotatedLine(for: $1.0) }
        XCTAssertEqual(annotatedDiff, expectedAnnotatedDiff)
    }
}

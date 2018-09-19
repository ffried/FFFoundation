//
//  StringClassesExtensionTests.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 18.09.18.
//

import XCTest
import Foundation
@testable import FFFoundation

#if os(Linux)
final class StringClassesExtensionTestClass: NSObject {}
#else
@objc
final class StringClassesExtensionTestClass: NSObject {}
#endif

final class StringClassesExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStringCreatingFromClassRemovingNamespace() {
        let str = String(class: StringClassesExtensionTestClass.self, removeNamespace: true)
        XCTAssertEqual(str, "StringClassesExtensionTestClass")
    }

    func testStringCreatingFromClassWithoutRemovingNamespace() {
        let str = String(class: StringClassesExtensionTestClass.self, removeNamespace: false)
        XCTAssertEqual(str, NSStringFromClass(StringClassesExtensionTestClass.self))
    }
}

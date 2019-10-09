#if canImport(ObjectiveC)
import XCTest
import Foundation
@testable import FFFoundation

final class PredicateInterpolationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPredicateCreationFromString() {
        let predicate = NSPredicate("this = that")
        XCTAssertEqual(predicate.predicateFormat, "this == that")
    }

    func testPredicateCreationFromStringInterpolationWithStringKeyAndStringValue() {
        let predicate = NSPredicate("\(key: "some_key") = \("string_value")")
        XCTAssertEqual(predicate.predicateFormat, #"some_key == "string_value""#)
    }

    func testPredicateCreationFromStringInterpolationWithStringKeyAndBoolValue() {
        let predicate = NSPredicate("\(key: "bool_key") = \(true)")
        XCTAssertEqual(predicate.predicateFormat, "bool_key == 1")
    }

    func testPredicateCreationFromStringInterpolationWithStringKeyAndSignedIntValue() {
        let predicate = NSPredicate("\(key: "int_key") = \(-42 as Int16)")
        XCTAssertEqual(predicate.predicateFormat, "int_key == -42")
    }

    func testPredicateCreationFromStringInterpolationWithStringKeyAndUnsignedIntValue() {
        let predicate = NSPredicate("\(key: "uint_key") = \(42 as UInt16)")
        XCTAssertEqual(predicate.predicateFormat, "uint_key == 42")
    }

    func testPredicateCreationFromStringInterpolationWithStringKeyAndDoubleValue() {
        let predicate = NSPredicate("\(key: "double_key") = \(42.42)")
        XCTAssertEqual(predicate.predicateFormat, "double_key == 42.42")
    }

    func testPredicateCreationFromStringInterpolationWithStringKeyAndNumberValue() {
        let predicate = NSPredicate("\(key: "number_key") = \(NSNumber(value: false))")
        XCTAssertEqual(predicate.predicateFormat, "number_key == 0")
    }

    func testPredicateCreationFromStringInterpolationWithStringKeyAndOptionalValue() {
        let optional: Int? = nil
        let predicate = NSPredicate("\(key: "optional_int_key") = \(optional)")
        XCTAssertEqual(predicate.predicateFormat, "optional_int_key == nil")
    }

    func testPredicateCreationFromStringInterpolationWithStringKeyAndNilValue() {
        let predicate = NSPredicate("\(key: "null_key") = \(nil as Any?)")
        XCTAssertEqual(predicate.predicateFormat, "null_key == nil")
    }

    func testPredicateCreationFromStringInterpolationWithStringKeyAndBridgeableValue() {
        let value = Date(timeIntervalSinceReferenceDate: 592299475.57712)
        let predicate = NSPredicate("\(key: "bridgeable_key") = \(value)")
        XCTAssertEqual(predicate.predicateFormat, #"bridgeable_key == CAST(592299475.577120, "NSDate")"#)
    }

    func testPredicateCreationFromStringInterpolationWithStringKeyAndNilBridgeableValue() {
        let value: Date? = nil
        let predicate = NSPredicate("\(key: "optional_bridgeable_key") = \(value)")
        XCTAssertEqual(predicate.predicateFormat, #"optional_bridgeable_key == nil"#)
    }

    #if canImport(ObjectiveC)
    fileprivate final class TestObject: NSObject {
        @objc dynamic var string: String = "test"
    }

    func testPredicateCreationFromStringInterpolationWithKeyPathKeyAndStringValue() {
        let predicate = NSPredicate("\(\TestObject.string) = \("string_value")")
        XCTAssertEqual(predicate.predicateFormat, #"string == "string_value""#)
    }
    #endif
}
#endif


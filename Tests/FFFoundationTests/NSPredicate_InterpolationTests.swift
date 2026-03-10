import Testing
import Foundation
@testable import FFFoundation

@Suite
struct PredicateInterpolationTests {
    @Test
    func predicateCreationFromString() {
#if canImport(ObjectiveC)
        let predicate = NSPredicate("this = that")
        #expect(predicate.predicateFormat == "this == that")
#endif
    }

    @Test
    func predicateCreationFromStringInterpolationWithStringKeyAndStringValue() {
#if canImport(ObjectiveC)
        let predicate = NSPredicate("\(key: "some_key") = \("string_value")")
        #expect(predicate.predicateFormat == #"some_key == "string_value""#)
#endif
    }

    @Test
    func predicateCreationFromStringInterpolationWithStringKeyAndBoolValue() {
#if canImport(ObjectiveC)
        let predicate = NSPredicate("\(key: "bool_key") = \(true)")
        #expect(predicate.predicateFormat == "bool_key == 1")
#endif
    }

    @Test
    func predicateCreationFromStringInterpolationWithStringKeyAndSignedIntValue() {
#if canImport(ObjectiveC)
        let predicate = NSPredicate("\(key: "int_key") = \(-42 as Int16)")
        #expect(predicate.predicateFormat == "int_key == -42")
#endif
    }

    @Test
    func predicateCreationFromStringInterpolationWithStringKeyAndUnsignedIntValue() {
#if canImport(ObjectiveC)
        let predicate = NSPredicate("\(key: "uint_key") = \(42 as UInt16)")
        #expect(predicate.predicateFormat == "uint_key == 42")
#endif
    }

    @Test
    func predicateCreationFromStringInterpolationWithStringKeyAndDoubleValue() {
#if canImport(ObjectiveC)
        let predicate = NSPredicate("\(key: "double_key") = \(42.42)")
        #expect(predicate.predicateFormat == "double_key == 42.42")
#endif
    }

    @Test
    func predicateCreationFromStringInterpolationWithStringKeyAndNumberValue() {
#if canImport(ObjectiveC)
        let predicate = NSPredicate("\(key: "number_key") = \(NSNumber(value: false))")
        #expect(predicate.predicateFormat == "number_key == 0")
#endif
    }

    @Test
    func predicateCreationFromStringInterpolationWithStringKeyAndOptionalValue() {
#if canImport(ObjectiveC)
        let optional: Int? = nil
        let predicate = NSPredicate("\(key: "optional_int_key") = \(optional)")
        #expect(predicate.predicateFormat == "optional_int_key == nil")
#endif
    }

    @Test
    func predicateCreationFromStringInterpolationWithStringKeyAndNilValue() {
#if canImport(ObjectiveC)
        let predicate = NSPredicate("\(key: "null_key") = \(nil as Any?)")
        #expect(predicate.predicateFormat == "null_key == nil")
#endif
    }

    @Test
    func predicateCreationFromStringInterpolationWithStringKeyAndBridgeableValue() {
#if canImport(ObjectiveC)
        let value = Date(timeIntervalSinceReferenceDate: 592299475.57712)
        let predicate = NSPredicate("\(key: "bridgeable_key") = \(value)")
        #expect(predicate.predicateFormat == #"bridgeable_key == CAST(592299475.577120, "NSDate")"#)
#endif
    }

    @Test
    func predicateCreationFromStringInterpolationWithStringKeyAndNilBridgeableValue() {
#if canImport(ObjectiveC)
        let value: Date? = nil
        let predicate = NSPredicate("\(key: "optional_bridgeable_key") = \(value)")
        #expect(predicate.predicateFormat == #"optional_bridgeable_key == nil"#)
#endif
    }

#if canImport(ObjectiveC)
    fileprivate final class TestObject: NSObject {
        @objc dynamic var string: String = "test"
    }
#endif

    @Test
    func predicateCreationFromStringInterpolationWithKeyPathKeyAndStringValue() {
#if canImport(ObjectiveC)
        let predicate = NSPredicate("\(\TestObject.string) = \("string_value")")
        #expect(predicate.predicateFormat == #"string == "string_value""#)
#endif
    }
}

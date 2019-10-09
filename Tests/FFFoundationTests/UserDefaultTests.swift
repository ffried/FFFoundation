import XCTest
@testable import FFFoundation

fileprivate extension UserDefaultKey {
    static let boolKey = UserDefaultKey(rawValue: "test_bool")
    static let intKey = UserDefaultKey(rawValue: "test_int")
    static let floatKey = UserDefaultKey(rawValue: "test_float")
    static let doubleKey = UserDefaultKey(rawValue: "test_double")
    static let stringKey = UserDefaultKey(rawValue: "test_string")
    static let dataKey = UserDefaultKey(rawValue: "test_data")
    static let urlKey = UserDefaultKey(rawValue: "test_url")
    static let optionalIntKey = UserDefaultKey(rawValue: "test_optional_int")
    static let doubleArrayKey = UserDefaultKey(rawValue: "test_double_array")
    static let doubleContArrayKey = UserDefaultKey(rawValue: "test_double_cont_array")
    static let intSetKey = UserDefaultKey(rawValue: "test_int_set")
    static let boolDictKey = UserDefaultKey(rawValue: "test_bool_dict")

    static let codableObject = UserDefaultKey(rawValue: "text_codable_object")

    static let inexisting = UserDefaultKey(rawValue: "text_inexisting")

    static var random: UserDefaultKey { .init(rawValue: UUID().uuidString) }

    static let allTestKeys: Set = [
        boolKey,
        intKey,
        floatKey,
        doubleKey,
        stringKey,
        dataKey,
        urlKey,
        optionalIntKey,
        doubleArrayKey,
        doubleContArrayKey,
        intSetKey,
        boolDictKey,

        codableObject,
    ]
}

final class UserDefaultTests: XCTestCase {

    struct TestObject: CodableUserDefaultsStorable, Equatable {
        let string: String
        let dict: [String: String]
        let range: Range<Int>
    }

    var userDefaults: UserDefaults { return .standard }

    private func castedPrimitive<T: PrimitiveUserDefaultStorable>(for key: UserDefaultKey) -> T? {
        return userDefaults.object(forKey: key.rawValue) as? T
    }

    private func resetDefaults() {
        UserDefaultKey.allTestKeys.forEach {
            userDefaults.removeObject(forKey: $0.rawValue)
        }
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        resetDefaults()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        resetDefaults()
        super.tearDown()
    }

    func testPrimitiveUserDefaultKeyDescription() {
        XCTAssertEqual(String(describing: UserDefaultKey.inexisting), UserDefaultKey.inexisting.rawValue)
    }

    func testPrimitiveUserDefaultReadingUsingInexistingKey() {
        #if !os(Linux)
        XCTAssertNil(UserDefault<Data?>(userDefaults: userDefaults, key: .inexisting).wrappedValue)
        #else
        XCTAssertEqual(UserDefault(userDefaults: userDefaults, key: .inexisting, defaultValue: "test_default").wrappedValue,
                       "test_default")
        #endif
    }

    func testPrimitiveUserDefaultReadingUsingDefaults() {
        let bool = UserDefault<Bool>(userDefaults: userDefaults, key: .random)
        let int = UserDefault<Int>(userDefaults: userDefaults, key: .random)
        let float = UserDefault<Float>(userDefaults: userDefaults, key: .random)
        let double = UserDefault<Double>(userDefaults: userDefaults, key: .random)
        let string = UserDefault<String>(userDefaults: userDefaults, key: .random, defaultValue: "")
        let data = UserDefault<Data>(userDefaults: userDefaults, key: .random, defaultValue: Data())
        let url = UserDefault<URL>(userDefaults: userDefaults, key: .random, defaultValue: URL(fileURLWithPath: "/path/to/nowhere"))
        #if !os(Linux)
        let optionalInt = UserDefault<Int?>(userDefaults: userDefaults, key: .random)
        #endif
        let doubleArray = UserDefault<Array<Double>>(userDefaults: userDefaults, key: .random)
        let doubleContArray = UserDefault<ContiguousArray<Double>>(userDefaults: userDefaults, key: .random)
        let intSet = UserDefault<Set<Int>>(userDefaults: userDefaults, key: .random)
        let boolDict = UserDefault<Dictionary<String, Bool>>(userDefaults: userDefaults, key: .random)

        XCTAssertEqual(bool.wrappedValue, bool.defaultValue)
        XCTAssertEqual(int.wrappedValue, int.defaultValue)
        XCTAssertEqual(float.wrappedValue, float.defaultValue)
        XCTAssertEqual(double.wrappedValue, double.defaultValue)
        XCTAssertEqual(string.wrappedValue, string.defaultValue)
        XCTAssertEqual(data.wrappedValue, data.defaultValue)
        XCTAssertEqual(url.wrappedValue, url.defaultValue)
        #if !os(Linux)
        XCTAssertEqual(optionalInt.wrappedValue, 0)
        #endif
        XCTAssertEqual(doubleArray.wrappedValue, doubleArray.defaultValue)
        XCTAssertEqual(doubleContArray.wrappedValue, doubleContArray.defaultValue)
        XCTAssertEqual(intSet.wrappedValue, intSet.defaultValue)
        XCTAssertEqual(boolDict.wrappedValue, boolDict.defaultValue)
    }

    func testPrimitiveUserDefaultReading() {
        let bool = UserDefault<Bool>(userDefaults: userDefaults, key: .boolKey)
        let int = UserDefault<Int>(userDefaults: userDefaults, key: .intKey)
        let float = UserDefault<Float>(userDefaults: userDefaults, key: .floatKey)
        let double = UserDefault<Double>(userDefaults: userDefaults, key: .doubleKey)
        let string = UserDefault<String>(userDefaults: userDefaults, key: .stringKey, defaultValue: "")
        let data = UserDefault<Data>(userDefaults: userDefaults, key: .dataKey, defaultValue: Data())
        let url = UserDefault<URL>(userDefaults: userDefaults, key: .urlKey, defaultValue: URL(fileURLWithPath: "/path/to/nowhere"))
        #if !os(Linux)
        let optionalInt = UserDefault<Int?>(userDefaults: userDefaults, key: .optionalIntKey)
        #endif
        let doubleArray = UserDefault<Array<Double>>(userDefaults: userDefaults, key: .doubleArrayKey)
        let doubleContArray = UserDefault<ContiguousArray<Double>>(userDefaults: userDefaults, key: .doubleContArrayKey)
        let intSet = UserDefault<Set<Int>>(userDefaults: userDefaults, key: .intSetKey)
        let boolDict = UserDefault<Dictionary<String, Bool>>(userDefaults: userDefaults, key: .boolDictKey)

        bool.wrappedValue = true
        int.wrappedValue = 42
        float.wrappedValue = 42.42
        double.wrappedValue = 42.4242
        string.wrappedValue = "Testing"
        data.wrappedValue = Data(1...8)
        url.wrappedValue = URL(fileURLWithPath: "/path/to/somewhere")
        #if !os(Linux)
        optionalInt.wrappedValue = 42
        #endif
        doubleArray.wrappedValue = [42.42, 42.4242]
        doubleContArray.wrappedValue = [42.42, 42.4242]
        intSet.wrappedValue = [42, 43, 44]
        boolDict.wrappedValue = ["true": true, "false": false]

        XCTAssertTrue(bool.wrappedValue)
        XCTAssertEqual(castedPrimitive(for: bool.key), true)
        XCTAssertEqual(int.wrappedValue, 42)
        XCTAssertEqual(castedPrimitive(for: int.key), 42)
        XCTAssertEqual(float.wrappedValue, 42.42)
        XCTAssertEqual(castedPrimitive(for: float.key), 42.42 as Float)
        XCTAssertEqual(double.wrappedValue, 42.4242)
        XCTAssertEqual(castedPrimitive(for: double.key), 42.4242)
        XCTAssertEqual(string.wrappedValue, "Testing")
        XCTAssertEqual(castedPrimitive(for: string.key), "Testing")
        XCTAssertEqual(data.wrappedValue, Data(1...8))
        XCTAssertEqual(castedPrimitive(for: data.key), Data(1...8))
        XCTAssertEqual(url.wrappedValue, URL(fileURLWithPath: "/path/to/somewhere"))
        XCTAssertEqual(userDefaults.url(forKey: url.key.rawValue), URL(fileURLWithPath: "/path/to/somewhere"))
        #if !os(Linux)
        XCTAssertEqual(optionalInt.wrappedValue, 42)
        XCTAssertEqual(castedPrimitive(for: optionalInt.key), 42)
        #endif
        XCTAssertEqual(doubleArray.wrappedValue, [42.42, 42.4242])
        XCTAssertEqual(castedPrimitive(for: doubleArray.key), [42.42, 42.4242])
        XCTAssertEqual(doubleContArray.wrappedValue, [42.42, 42.4242])
        XCTAssertEqual(castedPrimitive(for: doubleContArray.key), [42.42, 42.4242] as Array)
        XCTAssertEqual(intSet.wrappedValue, [42, 43, 44])
        XCTAssertEqual((castedPrimitive(for: intSet.key) as Array<Int>?)?.sorted(), [42, 43, 44])
        XCTAssertEqual(boolDict.wrappedValue, ["true": true, "false": false])
        XCTAssertEqual(castedPrimitive(for: boolDict.key), ["true": true, "false": false])
    }

    func testCodableUserDefaultReading() {
        #if !os(Linux)
        let object = UserDefault<TestObject?>(userDefaults: userDefaults, key: .codableObject)
        XCTAssertNil(object.wrappedValue)
        #else
        let object = UserDefault<TestObject>(userDefaults: userDefaults, key: .codableObject,
                                             defaultValue: TestObject(string: "DEFAULT", dict: [:], range: 1..<2))
        #endif
        let objValue = TestObject(string: "Test", dict: ["key1": "value1", "key2": "value2"], range: 2..<42)
        object.wrappedValue = objValue
        XCTAssertEqual(object.wrappedValue, objValue)
        let dict = userDefaults.object(forKey: object.key.rawValue) as? [String: Any]
        XCTAssertNotNil(dict)
        XCTAssertEqual(dict?["string"] as? String, objValue.string)
        XCTAssertEqual(dict?["dict"] as? [String: String], objValue.dict)
        XCTAssertEqual(dict?["range"] as? [Int], [objValue.range.lowerBound, objValue.range.upperBound])
    }
}

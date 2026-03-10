#if compiler(>=6.1)
import Testing
import Foundation
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

@Suite
struct UserDefaultTests: ~Swift.Copyable {
    struct TestObject: CodableUserDefaultsStorable, Equatable {
        let string: String
        let dict: Dictionary<String, String>
        let range: Range<Int>
    }

    let userDefaults: UserDefaults

    init() throws {
        userDefaults = try #require(.init(suiteName: UUID().uuidString))
    }

    deinit {
        UserDefaultKey.allTestKeys.forEach {
            userDefaults.removeObject(forKey: $0.rawValue)
        }
    }

    private func castedPrimitive<T: PrimitiveUserDefaultStorable>(for key: UserDefaultKey) -> T? {
        userDefaults.object(forKey: key.rawValue) as? T
    }

    @Test
    func primitiveUserDefaultKeyDescription() {
        #expect(String(describing: UserDefaultKey.inexisting) == UserDefaultKey.inexisting.rawValue)
    }

    @Test
    func primitiveUserDefaultReadingUsingInexistingKey() {
        #expect(UserDefault<Data?>(userDefaults: userDefaults, key: .inexisting).wrappedValue == nil)
        #expect(UserDefault<Bool?>(userDefaults: userDefaults, key: .inexisting).wrappedValue == nil)
    }

    @Test
    func primitiveUserDefaultReadingUsingDefaults() {
        let bool = UserDefault<Bool>(userDefaults: userDefaults, key: .random)
        let int = UserDefault<Int>(userDefaults: userDefaults, key: .random)
        let float = UserDefault<Float>(userDefaults: userDefaults, key: .random)
        let double = UserDefault<Double>(userDefaults: userDefaults, key: .random)
        let string = UserDefault<String>(userDefaults: userDefaults, key: .random, defaultValue: "")
        let data = UserDefault<Data>(userDefaults: userDefaults, key: .random, defaultValue: Data())
        let url = UserDefault<URL>(userDefaults: userDefaults, key: .random, defaultValue: URL(fileURLWithPath: "/path/to/nowhere"))
        let optionalInt = UserDefault<Int?>(userDefaults: userDefaults, key: .random)
        let doubleArray = UserDefault<Array<Double>>(userDefaults: userDefaults, key: .random)
        let doubleContArray = UserDefault<ContiguousArray<Double>>(userDefaults: userDefaults, key: .random)
        let intSet = UserDefault<Set<Int>>(userDefaults: userDefaults, key: .random)
        let boolDict = UserDefault<Dictionary<String, Bool>>(userDefaults: userDefaults, key: .random)

        #expect(bool.wrappedValue == bool.defaultValue)
        #expect(int.wrappedValue == int.defaultValue)
        #expect(float.wrappedValue == float.defaultValue)
        #expect(double.wrappedValue == double.defaultValue)
        #expect(string.wrappedValue == string.defaultValue)
        #expect(data.wrappedValue == data.defaultValue)
        #expect(url.wrappedValue == url.defaultValue)
        #expect(optionalInt.wrappedValue == optionalInt.defaultValue)
        #expect(doubleArray.wrappedValue == doubleArray.defaultValue)
        #expect(doubleContArray.wrappedValue == doubleContArray.defaultValue)
        #expect(intSet.wrappedValue == intSet.defaultValue)
        #expect(boolDict.wrappedValue == boolDict.defaultValue)
    }

    @Test
    func primitiveUserDefaultReading() {
        let bool = UserDefault<Bool>(userDefaults: userDefaults, key: .boolKey)
        let int = UserDefault<Int>(userDefaults: userDefaults, key: .intKey)
        let float = UserDefault<Float>(userDefaults: userDefaults, key: .floatKey)
        let double = UserDefault<Double>(userDefaults: userDefaults, key: .doubleKey)
        let string = UserDefault<String>(userDefaults: userDefaults, key: .stringKey, defaultValue: "")
        let data = UserDefault<Data>(userDefaults: userDefaults, key: .dataKey, defaultValue: Data())
        let url = UserDefault<URL>(userDefaults: userDefaults, key: .urlKey, defaultValue: URL(fileURLWithPath: "/path/to/nowhere"))
        let optionalInt = UserDefault<Int?>(userDefaults: userDefaults, key: .optionalIntKey)
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
        optionalInt.wrappedValue = 42
        doubleArray.wrappedValue = [42.42, 42.4242]
        doubleContArray.wrappedValue = [42.42, 42.4242]
        intSet.wrappedValue = [42, 43, 44]
        boolDict.wrappedValue = ["true": true, "false": false]

        #expect(bool.wrappedValue)
        #expect(castedPrimitive(for: bool.key) == true)
        #expect(int.wrappedValue == 42)
        #expect(castedPrimitive(for: int.key) == 42)
        #expect(float.wrappedValue == 42.42)
        #expect(castedPrimitive(for: float.key) == 42.42 as Float)
        #expect(double.wrappedValue == 42.4242)
        #expect(castedPrimitive(for: double.key) == 42.4242)
        #expect(string.wrappedValue == "Testing")
        #expect(castedPrimitive(for: string.key) == "Testing")
        #expect(data.wrappedValue == Data(1...8))
        #expect(castedPrimitive(for: data.key) == Data(1...8))
        #expect(url.wrappedValue == URL(fileURLWithPath: "/path/to/somewhere"))
        #expect(userDefaults.url(forKey: url.key.rawValue) == URL(fileURLWithPath: "/path/to/somewhere"))
        #expect(optionalInt.wrappedValue == 42)
        #expect(castedPrimitive(for: optionalInt.key) == 42)
        #expect(doubleArray.wrappedValue == [42.42, 42.4242])
        #expect(castedPrimitive(for: doubleArray.key) == [42.42, 42.4242])
        #expect(doubleContArray.wrappedValue == [42.42, 42.4242])
        #expect(castedPrimitive(for: doubleContArray.key) == [42.42, 42.4242])
        #expect(intSet.wrappedValue == [42, 43, 44])
        #expect((castedPrimitive(for: intSet.key) as Array<Int>?)?.sorted() == [42, 43, 44])
        #expect(boolDict.wrappedValue == ["true": true, "false": false])
        #expect(castedPrimitive(for: boolDict.key) == ["true": true, "false": false])
    }

    @Test
    func codableUserDefaultReading() {
        let object = UserDefault<TestObject?>(userDefaults: userDefaults, key: .codableObject)
        #expect(object.wrappedValue == nil)
        let objValue = TestObject(string: "Test", dict: ["key1": "value1", "key2": "value2"], range: 2..<42)
        object.wrappedValue = objValue
        #expect(object.wrappedValue == objValue)
        let dict = userDefaults.object(forKey: object.key.rawValue) as? [String: Any]
        #expect(dict != nil)
        #expect(dict?["string"] as? String == objValue.string)
        #expect(dict?["dict"] as? [String: String] == objValue.dict)
        #expect(dict?["range"] as? [Int] == [objValue.range.lowerBound, objValue.range.upperBound])
    }
}
#endif

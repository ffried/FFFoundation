import XCTest
@testable import FFFoundation

protocol GenericTestType {
    static var typeName: String { get }
    static var genericParams: [GenericTestType.Type] { get }
}

fileprivate extension GenericTestType {
    static var typeNameWithoutModule: String {
        return typeName.firstIndex(of: ".").map { String(typeName[typeName.index(after: $0)...]) } ?? typeName
    }

    static func fullTypeName(basedOn namePath: (GenericTestType.Type) -> String) -> String {
        return namePath(self) + (genericParams.isEmpty ? "" : "<" + genericParams.map { $0.fullTypeName(basedOn: namePath) }.joined(separator: ", ") + ">")
    }
}

private func _XCTAssertEqual<TestType: GenericTestType>(_ desc: TypeDescription, _ testType: TestType.Type, _ message: @autoclosure () -> String, file: StaticString, line: UInt) {
    func assertEqual(_ desc: TypeDescription, _ testType: GenericTestType.Type, _ message: @autoclosure () -> String, recursionIndexPath: IndexPath) {
        func extendedMessage(for message: @autoclosure () -> String) -> String {
            return recursionIndexPath.isEmpty
                ? message()
                : "Paramaters not equal at \(recursionIndexPath.lazy.map { String($0) }.joined(separator: ".")) \({ [msg = message()] in msg.isEmpty ? "" : ": \(msg)" }())"
        }
        XCTAssertEqual(desc.name, testType.typeName, extendedMessage(for: message()), file: file, line: line)
        XCTAssertEqual(desc.genericParameters.count, testType.genericParams.count, extendedMessage(for: message()), file: file, line: line)
        if desc.genericParameters.count == testType.genericParams.count {
            for (idx, types) in zip(desc.genericParameters, testType.genericParams).enumerated() {
                assertEqual(types.0, types.1, message(), recursionIndexPath: recursionIndexPath.appending(idx))
            }
        }
    }
    assertEqual(desc, testType, message(), recursionIndexPath: [])
}

#if swift(>=5.3)
func XCTAssertEqual<TestType: GenericTestType>(_ desc: TypeDescription, _ testType: TestType.Type, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    _XCTAssertEqual(desc, testType, message(), file: file, line: line)
}
#else
func XCTAssertEqual<TestType: GenericTestType>(_ desc: TypeDescription, _ testType: TestType.Type, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    _XCTAssertEqual(desc, testType, message(), file: file, line: line)
}
#endif

extension String: GenericTestType {
    static let typeName = "Swift.String"
    static let genericParams: [GenericTestType.Type] = []
}

final class TypeDescriptionTests: XCTestCase {

    fileprivate static let moduleName = "FFFoundationTests"
    fileprivate static let typePrefix = "\(moduleName).TypeDescriptionTests"

    struct NonGeneric: GenericTestType {
        static let typeName = "\(TypeDescriptionTests.typePrefix).NonGeneric"
        static let genericParams: [GenericTestType.Type] = []
    }
    struct OneGeneric<T: GenericTestType>: GenericTestType {
        static var typeName: String { return "\(TypeDescriptionTests.typePrefix).OneGeneric" }
        static var genericParams: [GenericTestType.Type] { return [T.self] }
    }
    struct TwoGeneric<T: GenericTestType, U: GenericTestType>: GenericTestType {
        static var typeName: String { return "\(TypeDescriptionTests.typePrefix).TwoGeneric" }
        static var genericParams: [GenericTestType.Type] { return [T.self, U.self] }
    }
    struct ThreeGeneric<T: GenericTestType, U: GenericTestType, V: GenericTestType>: GenericTestType {
        static var typeName: String { return "\(TypeDescriptionTests.typePrefix).ThreeGeneric" }
        static var genericParams: [GenericTestType.Type] { return [T.self, U.self, V.self] }
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTypeDescriptionWithNonGenericType() {
        let type = NonGeneric.self
        let desc = TypeDescription(type)
        let anyDesc = TypeDescription(any: type)
        XCTAssertEqual(desc, type)
        XCTAssertEqual(anyDesc, type)
    }

    func testTypeDescriptionWithOneGenericType() {
        let type = OneGeneric<NonGeneric>.self
        let desc = TypeDescription(type)
        let anyDesc = TypeDescription(any: type)
        XCTAssertEqual(desc, type)
        XCTAssertEqual(anyDesc, type)
    }

    func testTypeDescriptionWithTwoGenericType() {
        let type = TwoGeneric<NonGeneric, NonGeneric>.self
        let desc = TypeDescription(type)
        let anyDesc = TypeDescription(any: type)
        XCTAssertEqual(desc, type)
        XCTAssertEqual(anyDesc, type)
    }

    func testTypeDescriptionWithThreeGenericType() {
        let type = ThreeGeneric<NonGeneric, NonGeneric, NonGeneric>.self
        let desc = TypeDescription(type)
        let anyDesc = TypeDescription(any: type)
        XCTAssertEqual(desc, type)
        XCTAssertEqual(anyDesc, type)
    }

    func testTypeDescriptionWithNestedGenericTypes() {
        let type = ThreeGeneric<OneGeneric<NonGeneric>, TwoGeneric<OneGeneric<NonGeneric>, NonGeneric>, TwoGeneric<NonGeneric, OneGeneric<NonGeneric>>>.self
        let desc = TypeDescription(type)
        let anyDesc = TypeDescription(any: type)
        XCTAssertEqual(desc, type)
        XCTAssertEqual(anyDesc, type)
    }

    func testTypeDescriptionIsGeneric() {
        let nonGenericDesc = TypeDescription(NonGeneric.self)
        let genericDesc = TypeDescription(OneGeneric<NonGeneric>.self)
        XCTAssertFalse(nonGenericDesc.isGeneric)
        XCTAssertTrue(genericDesc.isGeneric)
    }

    func testTypeDescriptionCustomStringConvertible() {
        let desc = TypeDescription(ThreeGeneric<OneGeneric<NonGeneric>, TwoGeneric<OneGeneric<NonGeneric>, NonGeneric>, TwoGeneric<NonGeneric, OneGeneric<NonGeneric>>>.self)
        XCTAssertEqual(String(describing: desc), desc.typeName(includingModule: true))
    }

    func testTypeDescriptionTypeName() {
        let simpleType = NonGeneric.self
        let simpleDesc = TypeDescription(simpleType)
        let complexType = ThreeGeneric<OneGeneric<NonGeneric>, TwoGeneric<OneGeneric<NonGeneric>, NonGeneric>, TwoGeneric<NonGeneric, OneGeneric<NonGeneric>>>.self
        let complexDesc = TypeDescription(complexType)
        XCTAssertEqual(simpleDesc.typeName(includingModule: true), simpleType.fullTypeName(basedOn: { $0.typeName }))
        XCTAssertEqual(simpleDesc.typeName(includingModule: false), simpleType.fullTypeName(basedOn: { $0.typeNameWithoutModule }))
        XCTAssertEqual(complexDesc.typeName(includingModule: true), complexType.fullTypeName(basedOn: { $0.typeName }))
        XCTAssertEqual(complexDesc.typeName(includingModule: false), complexType.fullTypeName(basedOn: { $0.typeNameWithoutModule }))
    }
}

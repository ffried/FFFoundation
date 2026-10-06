import Testing
import Foundation
@testable import FFFoundation

protocol GenericTestType: SendableMetatype {
    static var typeName: String { get }
    static var genericParams: Array<any GenericTestType.Type> { get }
}

fileprivate extension GenericTestType {
    static var typeNameWithoutModule: String {
        return typeName.firstIndex(of: ".").map { String(typeName[typeName.index(after: $0)...]) } ?? typeName
    }

    static func fullTypeName(basedOn namePath: (any GenericTestType.Type) -> String) -> String {
        return namePath(self) + (genericParams.isEmpty ? "" : "<" + genericParams.map { $0.fullTypeName(basedOn: namePath) }.joined(separator: ", ") + ">")
    }
}

func expectEqual<TestType: GenericTestType>(
    _ desc: TypeDescription,
    _ testType: TestType.Type,
    _ message: @autoclosure () -> Comment? = nil,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    func assertEqual(_ desc: TypeDescription, _ testType: any GenericTestType.Type, _ message: @autoclosure () -> Comment?, recursionIndexPath: IndexPath) {
        func extendedMessage(for message: @autoclosure () -> Comment?) -> Comment? {
            recursionIndexPath.isEmpty
            ? message()
            : "Paramaters not equal at \(recursionIndexPath.lazy.map { String($0) }.joined(separator: ".")) \(message().map { ": \($0)" } ?? "")"
        }
        #expect(desc.name == testType.typeName, extendedMessage(for: message()), sourceLocation: sourceLocation)
        #expect(desc.genericParameters.count == testType.genericParams.count, extendedMessage(for: message()), sourceLocation: sourceLocation)
        if desc.genericParameters.count == testType.genericParams.count {
            for (idx, types) in zip(desc.genericParameters, testType.genericParams).enumerated() {
                assertEqual(types.0, types.1, message(), recursionIndexPath: recursionIndexPath.appending(idx))
            }
        }
    }
    assertEqual(desc, testType, message(), recursionIndexPath: [])
}

extension String: GenericTestType {
    static let typeName = "Swift.String"
    static let genericParams: Array<any GenericTestType.Type> = []
}

@Suite
struct TypeDescriptionTests {
    fileprivate static let moduleName = "FFFoundationTests"
    fileprivate static let typePrefix = "\(moduleName).TypeDescriptionTests"

    struct NonGeneric: GenericTestType {
        static let typeName = "\(TypeDescriptionTests.typePrefix).NonGeneric"
        static let genericParams: Array<any GenericTestType.Type> = []
    }
    struct OneGeneric<T: GenericTestType>: GenericTestType {
        static var typeName: String { "\(TypeDescriptionTests.typePrefix).OneGeneric" }
        static var genericParams: Array<any GenericTestType.Type> { [T.self] }
    }
    struct TwoGeneric<T: GenericTestType, U: GenericTestType>: GenericTestType {
        static var typeName: String { "\(TypeDescriptionTests.typePrefix).TwoGeneric" }
        static var genericParams: Array<any GenericTestType.Type> { [T.self, U.self] }
    }
    struct ThreeGeneric<T: GenericTestType, U: GenericTestType, V: GenericTestType>: GenericTestType {
        static var typeName: String { "\(TypeDescriptionTests.typePrefix).ThreeGeneric" }
        static var genericParams: Array<any GenericTestType.Type> { [T.self, U.self, V.self] }
    }

    @Test
    func typeDescriptionWithNonGenericType() {
        let type = NonGeneric.self
        let desc = TypeDescription(type)
        let anyDesc = TypeDescription(any: type)
        expectEqual(desc, type)
        expectEqual(anyDesc, type)
    }

    @Test
    func typeDescriptionWithOneGenericType() {
        let type = OneGeneric<NonGeneric>.self
        let desc = TypeDescription(type)
        let anyDesc = TypeDescription(any: type)
        expectEqual(desc, type)
        expectEqual(anyDesc, type)
    }

    @Test
    func typeDescriptionWithTwoGenericType() {
        let type = TwoGeneric<NonGeneric, NonGeneric>.self
        let desc = TypeDescription(type)
        let anyDesc = TypeDescription(any: type)
        expectEqual(desc, type)
        expectEqual(anyDesc, type)
    }

    @Test
    func typeDescriptionWithThreeGenericType() {
        let type = ThreeGeneric<NonGeneric, NonGeneric, NonGeneric>.self
        let desc = TypeDescription(type)
        let anyDesc = TypeDescription(any: type)
        expectEqual(desc, type)
        expectEqual(anyDesc, type)
    }

    @Test
    func typeDescriptionWithNestedGenericTypes() {
        let type = ThreeGeneric<OneGeneric<NonGeneric>, TwoGeneric<OneGeneric<NonGeneric>, NonGeneric>, TwoGeneric<NonGeneric, OneGeneric<NonGeneric>>>.self
        let desc = TypeDescription(type)
        let anyDesc = TypeDescription(any: type)
        expectEqual(desc, type)
        expectEqual(anyDesc, type)
    }

    @Test
    func typeDescriptionIsGeneric() {
        let nonGenericDesc = TypeDescription(NonGeneric.self)
        let genericDesc = TypeDescription(OneGeneric<NonGeneric>.self)
        #expect(!nonGenericDesc.isGeneric)
        #expect(genericDesc.isGeneric)
    }

    @Test
    func typeDescriptionCustomStringConvertible() {
        let desc = TypeDescription(ThreeGeneric<OneGeneric<NonGeneric>, TwoGeneric<OneGeneric<NonGeneric>, NonGeneric>, TwoGeneric<NonGeneric, OneGeneric<NonGeneric>>>.self)
        #expect(String(describing: desc) == desc.typeName(includingModule: true))
    }

    @Test
    func typeDescriptionTypeName() {
        let simpleType = NonGeneric.self
        let simpleDesc = TypeDescription(simpleType)
        let complexType = ThreeGeneric<OneGeneric<NonGeneric>, TwoGeneric<OneGeneric<NonGeneric>, NonGeneric>, TwoGeneric<NonGeneric, OneGeneric<NonGeneric>>>.self
        let complexDesc = TypeDescription(complexType)
        #expect(simpleDesc.typeName(includingModule: true) == simpleType.fullTypeName(basedOn: { $0.typeName }))
        #expect(simpleDesc.typeName(includingModule: false) == simpleType.fullTypeName(basedOn: { $0.typeNameWithoutModule }))
        #expect(complexDesc.typeName(includingModule: true) == complexType.fullTypeName(basedOn: { $0.typeName }))
        #expect(complexDesc.typeName(includingModule: false) == complexType.fullTypeName(basedOn: { $0.typeNameWithoutModule }))
    }
}

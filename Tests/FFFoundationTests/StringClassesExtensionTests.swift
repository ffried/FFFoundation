import Testing
import Foundation
@testable import FFFoundation

#if os(Linux)
final class StringClassesExtensionTestClass: NSObject {}
#else
@objc final class StringClassesExtensionTestClass: NSObject {}
#endif

@Suite
struct StringClassesExtensionTests {
    @Test
    func stringCreatingFromClassRemovingNamespace() {
        let str = String(class: StringClassesExtensionTestClass.self, removeNamespace: true)
        #expect(str == "StringClassesExtensionTestClass")
    }

    @Test
    func stringCreatingFromClassWithoutRemovingNamespace() {
        let str = String(class: StringClassesExtensionTestClass.self, removeNamespace: false)
        #expect(str == NSStringFromClass(StringClassesExtensionTestClass.self))
    }
}

public struct TypeDescription: Equatable, Hashable, Codable, Sendable, CustomStringConvertible {
    private enum CodingKeys: String, CodingKey {
        case name
        case genericParameters = "generic_parameters"
    }

    public let name: String
    public fileprivate(set) var genericParameters: Array<TypeDescription>

    @inlinable
    public var isGeneric: Bool { !genericParameters.isEmpty }

    @inlinable
    public var description: String { typeName(includingModule: true) }

    fileprivate init(name: String, genericParameters: Array<TypeDescription> = []) {
        self.name = name
        self.genericParameters = genericParameters
    }

    public init<T>(_ type: T.Type) {
        self = String(reflecting: type).parseType()
    }

    public init(any type: Any.Type) {
        self = String(reflecting: type).parseType()
    }

    public func typeName(includingModule: Bool = true) -> String {
        (
            includingModule ? name : name.cleanedModuleName()
        ) + (
            genericParameters.isEmpty
                ? ""
                : "<\(genericParameters.lazy.map { $0.typeName(includingModule: includingModule) }.joined(separator: ", "))>"
        )
    }
}

extension StringProtocol {
    private func parseNextTypes(currentIndex: inout Index) -> Array<TypeDescription> {
        let separatorIndex = firstIndex(where: "<,>".contains) ?? endIndex
        var result = separatorIndex > startIndex ? [TypeDescription(name: String(self[..<separatorIndex]))] : []
        guard separatorIndex != endIndex else { return result }
        currentIndex = index(after: separatorIndex)
        switch self[separatorIndex] {
        case "<": result[0].genericParameters += self[currentIndex...].parseNextTypes(currentIndex: &currentIndex)
        case "," where self[currentIndex] == " ": currentIndex = index(after: currentIndex)
        case ">": return result
        default: break
        }
        return result + self[currentIndex...].parseNextTypes(currentIndex: &currentIndex)
    }

    fileprivate func parseType() -> TypeDescription {
        var currentIndex = startIndex
        return parseNextTypes(currentIndex: &currentIndex)[0]
    }

    fileprivate func cleanedModuleName() -> String {
        split(separator: ".").dropFirst().joined(separator: ".")
    }
}

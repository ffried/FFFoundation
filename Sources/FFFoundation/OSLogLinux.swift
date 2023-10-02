//
//  OSLogLinux.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 27.07.18.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if !canImport(os)
import Foundation

@frozen
public struct OSLogType: RawRepresentable, Hashable {
    public typealias RawValue = UInt8

    public let rawValue: RawValue
    public init(rawValue: RawValue) { self.rawValue = rawValue }
    @inlinable
    public init(_ rawValue: RawValue) { self.init(rawValue: rawValue) }

    public static let `default` = OSLogType(rawValue: 0)
    public static let info = OSLogType(rawValue: 1)
    public static let debug = OSLogType(rawValue: 2)
    public static let error = OSLogType(rawValue: 16)
    public static let fault = OSLogType(rawValue: 17)

    fileprivate var logString: String {
        switch self {
        case .`default`: return "DEFAULT"
        case .info: return "INFO"
        case .debug: return "DEBUG"
        case .error: return "ERROR"
        case .fault: return "FAULT"
        default: return "OTHER<\(rawValue)>"
        }
    }
}

public final class OSLog: NSObject {
    private enum Kind: Equatable {
        case `default`
        case `disabled`
        case custom(subsystem: String, category: Category)

        var logString: String {
            switch self {
            case .`default`: return "Default"
            case .disabled: return "Disabled" // Shouldn't really happen
            case .custom(let subsystem, let category):
                return "\(subsystem){\(category)}"
            }
        }
    }
    private let kind: Kind

    public var signpostsEnabled: Bool { kind != .disabled } // TODO: check with real os implementation

    private init(kind: Kind) {
        self.kind = kind
    }

    public convenience init(subsystem: String, category: Category) {
        self.init(kind: .custom(subsystem: subsystem, category: category))
    }

    public convenience init(subsystem: String, category: String) {
        self.init(subsystem: subsystem, category: Category(rawValue: category))
    }

    public func isEnabled(type: OSLogType) -> Bool {
        switch kind {
        case .default: return true
        case .disabled: return false
        case .custom(_, _): return true
        }
    }

    fileprivate func write(message: StaticString, dso _: UnsafeRawPointer?, type: OSLogType, args: Array<any CVarArg>) {
        guard isEnabled(type: type) else { return }
        print("\(kind.logString) - [\(type.logString)]: \(String(format: String(describing: message), arguments: args))")
    }
}

extension OSLog {
    public static let `default` = OSLog(kind: .default)
    public static let disabled = OSLog(kind: .disabled)
}

extension OSLog {
    @frozen
    public struct Category: RawRepresentable, Hashable {
        public typealias RawValue = String

        public let rawValue: RawValue
        public init(rawValue: RawValue) { self.rawValue = rawValue }

        public static let pointsOfInterest = Category(rawValue: "points-of-interest")
    }
}

public func os_log(_ msg: StaticString, dso: UnsafeRawPointer? = #dsohandle, log: OSLog = .default, type: OSLogType = .default, _ args: any CVarArg...) {
    log.write(message: msg, dso: dso, type: type, args: args)
}
#endif

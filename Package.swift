// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: Array<SwiftSetting> = [
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("AccessLevelOnImport"),
    //    .enableExperimentalFeature("VariadicGenerics"),
    //    .unsafeFlags(["-warn-concurrency"], .when(configuration: .debug)),
]

let package = Package(
    name: "FFFoundation",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "FFFoundation",
                 targets: ["FFFoundation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "FFFoundation",
            swiftSettings: swiftSettings),
        .testTarget(
            name: "FFFoundationTests",
            dependencies: ["FFFoundation"],
            swiftSettings: swiftSettings),
    ]
)

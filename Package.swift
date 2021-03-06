// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FFFoundation",
    platforms: [
       .macOS(.v10_12),
       .iOS(.v10),
       .tvOS(.v10),
       .watchOS(.v3),
    ],
    products: [
      // Products define the executables and libraries produced by a package, and make them visible to other packages.
      .library(name: "FFFoundation", targets: ["FFFoundation"]),
   ],
   targets: [
      .target(name: "FFFoundation"),
      .testTarget(
        name: "FFFoundationTests",
        dependencies: ["FFFoundation"]),
   ]
)

// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FFFoundation",
    products: [
      // Products define the executables and libraries produced by a package, and make them visible to other packages.
      .library(name: "FFFoundation", targets: ["FFFoundation"]),
   ],
   targets: [
      .target(name: "FFFoundation", dependencies: [], exclude: ["AttributedString.swift"]),
      .testTarget(name: "FFFoundationTests", dependencies: ["FFFoundation"])
   ]
)

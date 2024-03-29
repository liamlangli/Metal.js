// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "metalscript",
    platforms: [
        .macOS(.v11),
        .iOS(.v15)
    ],
    products: [
        .library(name: "metalscript", targets: ["metalscript"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "metalscript"),
        .executableTarget(
            name: "metalscriptclient",
            dependencies: ["metalscript", .product(name: "ArgumentParser", package: "swift-argument-parser")])]
)

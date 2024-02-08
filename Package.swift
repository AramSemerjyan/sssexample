// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sssexample",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.3.0"
        ),
        .package(
            url: "https://github.com/apple/swift-nio.git",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/ASTRO-POLIS/swift-polis.git",
            branch: "dev"
        ),
        .package(
            url: "https://github.com/Swinject/SwinjectAutoregistration.git",
            from: "2.8.3"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "sssexample",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
                .product(
                    name: "NIOCore",
                    package: "swift-nio"
                ),
                .product(
                    name: "NIOPosix",
                    package: "swift-nio"
                ),
                .product(
                    name: "NIOHTTP1",
                    package: "swift-nio"
                ),
                .product(
                    name: "swift-polis",
                    package: "swift-polis"
                ),
                "SwinjectAutoregistration"
            ]
        ),
    ]
)

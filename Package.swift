// swift-tools-version:5.5
import Foundation
import PackageDescription

let package = Package(
    name: "bord",
    platforms: [
        .macOS(.v12),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.1")
    ],    targets: [
        .target(
            name: "swift-tools-version",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
    ]
)

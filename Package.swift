// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BrushCore",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "BrushCore",
            targets: ["BrushCore"]
        )
    ],
    targets: [
        .target(
            name: "BrushCore",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "BrushCoreTests",
            dependencies: ["BrushCore"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        )
    ]
)

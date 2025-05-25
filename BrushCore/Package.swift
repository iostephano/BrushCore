// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BrushCore",
    platforms: [
        .iOS(.v13)
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
            dependencies: []
        )
    ]
)

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "QuickPanel",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "QuickPanel",
            resources: [.copy("Assets.xcassets")]
        )
    ]
)

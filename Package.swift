// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "PAYJP",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "PAYJP", targets: ["PAYJP"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PAYJP-ObjC",
            dependencies: [],
            path: "Sources/ObjC",
            publicHeadersPath: "Public"
        ),
        .target(
            name: "PAYJP",
            dependencies: ["PAYJP-ObjC"],
            path: "Sources",
            exclude: [
                "ObjC",
                "Info.plist"
            ],
            resources: [
                .process("Resources/Views"),
                .process("Resources/Resource.bundle"),
                .copy("Resources/Assets.xcassets")
            ]
        )
    ]
)

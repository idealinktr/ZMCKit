// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZMCKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ZMCKit",
            type: .dynamic,
            targets: ["ZMCKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ZMCKit",
            dependencies: [
                "SCSDKCameraKit",
                "SCSDKCoreKit",
                "SCSDKCreativeKit"
            ]
        ),
        .binaryTarget(
            name: "SCSDKCameraKit",
            path: "XCFrameworks/SCSDKCameraKit.xcframework"
        ),
        .binaryTarget(
            name: "SCSDKCoreKit",
            path: "XCFrameworks/SCSDKCoreKit.xcframework"
        ),
        .binaryTarget(
            name: "SCSDKCreativeKit",
            path: "XCFrameworks/SCSDKCreativeKit.xcframework"
        )
    ]
)

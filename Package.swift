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
            type: .static,  // Change back to static (default)
            targets: ["ZMCKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ZMCKit",
            dependencies: [
                "SCSDKCameraKit",
                "SCSDKCameraKitReferenceUI",
                "SCSDKCoreKit",
                "SCSDKCreativeKit"
            ],
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("UIKit")
            ]
        ),
        .binaryTarget(
            name: "SCSDKCameraKit",
            path: "XCFrameworks/SCSDKCameraKit.xcframework"
        ),
        .binaryTarget(
            name: "SCSDKCameraKitReferenceUI",
            path: "XCFrameworks/SCSDKCameraKitReferenceUI.xcframework"
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

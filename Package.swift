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
            targets: ["ZMCKit"]),
        // Expose the Camera Kit frameworks as products
        .library(
            name: "SCSDKCameraKit",
            targets: ["SCSDKCameraKit"]),
        .library(
            name: "SCSDKCameraKitReferenceUI",
            targets: ["SCSDKCameraKitReferenceUI"]),
        .library(
            name: "SCSDKCoreKit",
            targets: ["SCSDKCoreKit"]),
        .library(
            name: "SCSDKCreativeKit",
            targets: ["SCSDKCreativeKit"])
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

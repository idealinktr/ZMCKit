import Foundation
import UIKit

@_exported import SCSDKCameraKitReferenceUI
@_exported import SCSDKCameraKit
@_exported import SCSDKCoreKit
@_exported import SCSDKCreativeKit

enum ZMCKitError: Error {
    case invalidPreviewView
}

@MainActor
public struct ZMCKit {
    private static var _currentLensId: String?
    private static var lensChangeCallback: ((String?) -> Void)?
    
    public static var currentLensId: String? {
        get { _currentLensId }
    }
    
    public static func onLensChange(callback: @escaping (String?) -> Void) {
        lensChangeCallback = callback
    }
    
    internal static func updateCurrentLensId(_ lensId: String?) {
        _currentLensId = lensId
        lensChangeCallback?(lensId)
    }
    
    public static func initialize() {
        print("ZMCKit initialized")
    }
    
    @available(iOS 13.0, *)
    public static func createSingleProductView(
        snapAPIToken: String,
        partnerGroupId: String,
        lensId: String,
        bundleIdentifier: String = Bundle.main.bundleIdentifier ?? ""
    ) -> UIView {
        return ZMSingleCameraView(
            snapAPIToken: snapAPIToken,
            partnerGroupId: partnerGroupId,
            lensId: lensId,
            bundleIdentifier: bundleIdentifier
        )
    }
    
    @available(iOS 13.0, *)
    public static func createMultiProductView(
        snapAPIToken: String,
        partnerGroupId: String
    ) -> UIView {
        return ZMMultiLensCameraView(
            snapAPIToken: snapAPIToken,
            partnerGroupId: partnerGroupId
        )
    }
}

import Foundation
import UIKit

@_exported import SCSDKCameraKitReferenceUI
@_exported import SCSDKCameraKit
@_exported import SCSDKCoreKit
@_exported import SCSDKCreativeKit

@MainActor
public struct ZMCKit {
    public static func initialize() {
        print("ZMCKit initialized")
    }
    
    public static func presentSplashExperience(from viewController: UIViewController,
                                                  snapAPIToken: String,
                                                  partnerGroupId: String) {
           let zMCameraVC = ZMCameraVC(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId)
           viewController.present(zMCameraVC, animated: true, completion: nil)
       }
}

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
    
    public static func presentGroupProducts(from viewController: UIViewController,
                                                  snapAPIToken: String,
                                                  partnerGroupId: String) {
       let zmCameraVC = ZMCameraVC(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId)
        //viewController.present(zmCameraVC, animated: true, completion: nil)
    }
    
    public static func presentSingleProduct (from viewController: UIViewController,
                                             snapAPIToken: String,
                                             partnerGroupId: String,
                                             lensId: String) {
        let zmSingleCameraVC = ZMSingleCameraVC(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId, lensId: lensId, bundleIdentifier: Bundle.main.bundleIdentifier ?? "com.idealink.ziylanmedya.portakal")
        viewController.present(zmSingleCameraVC, animated: true, completion: nil)
    }
}

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
    
    public static func presentGroupProducts(
        from viewController: UIViewController,
        snapAPIToken: String,
        partnerGroupId: String,
        completion: ((Error?) -> Void)? = nil
    ) {
        let zmCameraVC = ZMCameraVC(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId)
        zmCameraVC.modalPresentationStyle = .fullScreen
        viewController.present(zmCameraVC, animated: true) {
            completion?(nil)
        }
    }
    
    public static func presentSingleProduct(
        from viewController: UIViewController,
        snapAPIToken: String,
        partnerGroupId: String,
        lensId: String,
        completion: ((Error?) -> Void)? = nil
    ) {
        let zmSingleCameraVC = ZMSingleCameraVC(
            snapAPIToken: snapAPIToken,
            partnerGroupId: partnerGroupId,
            lensId: lensId,
            bundleIdentifier: Bundle.main.bundleIdentifier ?? "com.idealink.ziylanmedya.portakal"
        )
        viewController.present(zmSingleCameraVC, animated: true) {
            completion?(nil)
        }
    }
    
    public static func presentMultipleProducts(
        from viewController: UIViewController,
        snapAPIToken: String,
        partnerGroupId: String,
        completion: ((Error?) -> Void)? = nil
    ) {
        let zmCameraVC = ZMMultiLensCameraVC(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId)
        zmCameraVC.modalPresentationStyle = .fullScreen
        viewController.present(zmCameraVC, animated: true) {
            completion?(nil)
        }
    }
}

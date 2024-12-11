//
//  ZMCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 26.11.2024.
//


import UIKit
import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

@available(iOS 13.0, *)
public class ZMCameraView: UIView {
    internal let snapAPIToken: String
    internal let partnerGroupId: String
    
    private var cameraController: CustomizedCameraController!
    private var cameraViewController: CustomizedCameraViewController!
    
    // Callback handlers for capture/recording
    public var onPhotoCapture: ((UIImage?) -> Void)?
    public var onVideoRecorded: ((URL?) -> Void)?
    
    public init(snapAPIToken: String, partnerGroupId: String, frame: CGRect = .zero) {
        self.snapAPIToken = snapAPIToken
        self.partnerGroupId = partnerGroupId
        super.init(frame: frame)
        setupCamera()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupCamera() {
        // Initialize camera controller with session config
        cameraController = CustomizedCameraController(
            sessionConfig: SessionConfig(apiToken: snapAPIToken)
        )
        
        // Set group IDs for lenses
        cameraController.groupIDs = [SCCameraKitLensRepositoryBundledGroup, partnerGroupId]
        
        // Create camera view controller with the controller
        cameraViewController = CustomizedCameraViewController(
            cameraController: cameraController,
            debugStore: nil
        )
        
        // Add camera view controller as child
        if let parentVC = findViewController() {
            parentVC.addChild(cameraViewController)
            addSubview(cameraViewController.view)
            cameraViewController.view.frame = bounds
            cameraViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cameraViewController.didMove(toParent: parentVC)
        }
        
        // Set delegates
        cameraController.delegate = self
        cameraController.snapchatDelegate = self
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    public func cleanup() {
        cameraViewController.willMove(toParent: nil)
        cameraViewController.view.removeFromSuperview()
        cameraViewController.removeFromParent()
    }
    
    public override func removeFromSuperview() {
        cleanup()
        super.removeFromSuperview()
    }
}

// MARK: - CameraControllerDelegate
@available(iOS 13.0, *)
extension ZMCameraView: CameraControllerDelegate {
    public func cameraController(_ controller: CameraController, didCapturePhoto photo: UIImage) {
        onPhotoCapture?(photo)
    }
    
    public func cameraController(_ controller: CameraController, didFinishRecordingVideo url: URL) {
        onVideoRecorded?(url)
    }
    
    public func cameraController(_ controller: CameraController, didFailWithError error: Error) {
        print("Camera controller error: \(error)")
    }
}

// MARK: - SnapchatDelegate
@available(iOS 13.0, *)
extension ZMCameraView: SnapchatDelegate {
    public func cameraKitViewController(_ viewController: UIViewController, openSnapchat screen: SnapchatScreen) {
        switch screen {
        case .photo(let image):
            onPhotoCapture?(image)
        case .video(let url):
            onVideoRecorded?(url)
        default:
            break
        }
    }
} 

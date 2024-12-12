//
//  ZMSingleCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 26.11.2024.
//

import UIKit
import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

@available(iOS 13.0, *)
public class ZMSingleCameraView: ZMCameraView {
    private let lensId: String
    private let bundleIdentifier: String
    private var cameraViewController: CameraViewController!
    
    public init(snapAPIToken: String,
                partnerGroupId: String,
                lensId: String,
                bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "",
                frame: CGRect = .zero) {
        self.lensId = lensId
        self.bundleIdentifier = bundleIdentifier
        super.init(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId, frame: frame)
        setupLens()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLens() {
        // Hide carousel since this is single lens view
        cameraView.carouselView.isHidden = true
        
        // Make camera button visible and configure it
        cameraView.cameraButton.isHidden = false
        cameraView.cameraButton.isEnabled = true
        
        // Add camera button delegate to handle capture/record
        cameraView.cameraButton.delegate = self
        
        // Setup lens repository observer for specific lens
        cameraKit.lenses.repository.addObserver(self,
                                              specificLensID: self.lensId,
                                              inGroupID: self.partnerGroupId)
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
    
    override public func cleanup() {
        // Remove lens observer
        cameraKit.lenses.repository.removeObserver(self,
                                                 specificLensID: lensId,
                                                 inGroupID: partnerGroupId)
        
        // Cleanup view controller
        cameraViewController?.willMove(toParent: nil)
        cameraViewController?.view.removeFromSuperview()
        cameraViewController?.removeFromParent()
        super.cleanup()
    }
}

// MARK: - Lens Repository Observer
@available(iOS 13.0, *)
extension ZMSingleCameraView: LensRepositorySpecificObserver {
    public func repository(_ repository: any LensRepository, didUpdate lens: any Lens, forGroupID groupID: String) {
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { [weak self] success in
            if success {
                print("Successfully applied lens: \(lens.id)")
                ZMCKit.updateCurrentLensId(lens.id)
            } else {
                print("Failed to apply lens: \(lens.id)")
            }
        }
    }
    
    public func repository(_ repository: any LensRepository, didFailToUpdateLensID lensID: String, forGroupID groupID: String, error: (any Error)?) {
        print("Did fail to update lens")
    }
}

// MARK: - Snapchat Delegate for Capture/Record
@available(iOS 13.0, *)
extension ZMSingleCameraView: SnapchatDelegate {
    public func cameraKitViewController(_ viewController: UIViewController, openSnapchat screen: SnapchatScreen) {
        switch screen {
        case .photo(let image):
            delegate?.cameraDidCapture(image: image)
        case .video(let url):
            delegate?.cameraDidFinishRecording(videoURL: url)
        default:
            break
        }
    }
}

// MARK: - Camera Button Delegate
@available(iOS 13.0, *)
extension ZMSingleCameraView: CameraButtonDelegate {
    public func cameraButtonDidTap(_ button: CameraButton) {
        // Handle photo capture
        cameraKit.output?.capturePhoto { [weak self] image in
            self?.delegate?.cameraDidCapture(image: image)
        }
    }
    
    public func cameraButtonDidBeginLongPress(_ button: CameraButton) {
        // Start video recording
        cameraKit.output?.startRecording()
    }
    
    public func cameraButtonDidEndLongPress(_ button: CameraButton) {
        // Stop video recording
        cameraKit.output?.stopRecording { [weak self] url in
            self?.delegate?.cameraDidFinishRecording(videoURL: url)
        }
    }
}

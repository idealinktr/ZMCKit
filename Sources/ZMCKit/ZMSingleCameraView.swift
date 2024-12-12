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
        
        // Setup lens repository observer
        cameraKit.lenses.repository.addObserver(self,
                                              specificLensID: self.lensId,
                                              inGroupID: self.partnerGroupId)
        
        // Add camera view controller for capture/record UI
        if let parentVC = findViewController() {
            cameraViewController = CameraViewController(
                cameraKit: cameraKit,
                captureSession: captureSession,
                repoGroups: [partnerGroupId]
            )
            
            parentVC.addChild(cameraViewController)
            addSubview(cameraViewController.view)
            cameraViewController.view.frame = bounds
            cameraViewController.didMove(toParent: parentVC)
            
            // Setup autolayout
            cameraViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cameraViewController.view.topAnchor.constraint(equalTo: topAnchor),
                cameraViewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
                cameraViewController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
                cameraViewController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            // Hide lens carousel
            cameraViewController.cameraView.carouselView.isHidden = true
            
            // Setup delegate for capture/record callbacks
            cameraViewController.cameraController.snapchatDelegate = self
        }
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
        // Remove lens observer with specific lens ID and group ID
        cameraKit.lenses.repository.removeObserver(self,
                                                 specificLensID: lensId,
                                                 inGroupID: partnerGroupId)
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

//
//  ZMMultiLensCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 27.11.2024.
//

import UIKit
@preconcurrency import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

@available(iOS 13.0, *)
public class ZMMultiLensCameraView: ZMCameraView {
    private var lenses: [Lens] = []
    private var currentLensIndex: Int = 0
    private var cameraViewController: CameraViewController!
    
    public override init(snapAPIToken: String,
                partnerGroupId: String,
                frame: CGRect = .zero) {
        super.init(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId, frame: frame)
        setupMultiLens()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMultiLens() {
        // Create CameraViewController with partner group
        // Configure session with API token
            let sessionConfig = SessionConfig(apiToken: snapAPIToken)
            
            // Create CameraViewController with configuration
            cameraViewController = CameraViewController(
                repoGroups: [partnerGroupId],
                sessionConfig: sessionConfig
            )
        
        // Add as child view
        if let parentVC = findViewController() {
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
        }
        
        // Setup delegates
        cameraViewController.cameraController.snapchatDelegate = self
    }
    
    // Helper method to find parent view controller
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
}

// Add SnapchatDelegate to handle camera events
@available(iOS 13.0, *)
extension ZMMultiLensCameraView: SnapchatDelegate {
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

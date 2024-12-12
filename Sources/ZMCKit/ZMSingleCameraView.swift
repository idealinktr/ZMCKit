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
        // Create CameraViewController with single lens
        cameraViewController = CameraViewController(repoGroups: [lensId])
        
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
        
        // Hide carousel since this is single lens view
        cameraViewController.cameraView.carouselView.isHidden = true
        
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

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
    private let photoOutput = AVCapturePhotoOutput()
    
    private lazy var processingLabel: UILabel = {
        let label = UILabel()
        label.text = "Lütfen Bekleyiniz..."
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
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
    
    override internal func setupBaseCamera() {
        super.setupBaseCamera()
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        // Setup lens observation
        cameraKit.lenses.repository.addObserver(self, groupID: partnerGroupId)
        
        // Set camera button delegate
        cameraView.cameraButton.delegate = self
        
        // Add processing label
        addSubview(processingLabel)
        processingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            processingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            processingLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func showProcessing() {
        UIView.animate(withDuration: 0.3) {
            self.processingLabel.alpha = 1
        }
    }
    
    private func hideProcessing() {
        UIView.animate(withDuration: 0.3) {
            self.processingLabel.alpha = 0
        }
    }
    
    @objc private func handleTap() {
        showProcessing()
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
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

// MARK: - Lens Repository Observer
@available(iOS 13.0, *)
extension ZMMultiLensCameraView: LensRepositoryGroupObserver {
    public func repository(_ repository: any LensRepository, didUpdateLenses lenses: [any Lens], forGroupID groupID: String) {
        self.lenses = lenses as? [Lens] ?? []
        
        // Apply first lens if available
        if let firstLens = self.lenses.first {
            cameraKit.lenses.processor?.apply(lens: firstLens, launchData: nil) { success in
                if success {
                    print("Successfully applied lens: \(firstLens.id)")
                } else {
                    print("Failed to apply lens: \(firstLens.id)")
                }
            }
        }
    }
    
    public func repository(_ repository: any LensRepository, didFailToUpdateLensesForGroupID groupID: String, error: Error?) {
        print("Failed to update lenses for group: \(error?.localizedDescription ?? "")")
    }
}

// MARK: - Photo Capture Delegate
@available(iOS 13.0, *)
extension ZMMultiLensCameraView: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let renderer = UIGraphicsImageRenderer(bounds: self.previewView.bounds)
            let image = renderer.image { ctx in
                self.previewView.drawHierarchy(in: self.previewView.bounds, afterScreenUpdates: true)
            }
            
            // Notify delegate about the captured image
            self.delegate?.cameraDidCapture(image: image)
            self.delegate?.willShowPreview(image: image)
            
            // Check if we should show default preview
            if self.delegate?.shouldShowDefaultPreview() ?? true {
                if let viewController = self.findViewController() {
                    let previewVC = ZMCapturePreviewViewController(image: image)
                    previewVC.modalPresentationStyle = .fullScreen
                    viewController.present(previewVC, animated: true) {
                        self.hideProcessing()
                    }
                }
            } else {
                self.hideProcessing()
            }
        }
    }
}


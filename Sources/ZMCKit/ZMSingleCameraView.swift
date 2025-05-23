//
//  ZMSingleCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 26.11.2024.
//

import UIKit
import SCSDKCameraKit
import AVFoundation

@available(iOS 13.0, *)
public class ZMSingleCameraView: ZMCameraView {
    
    private let lensId: String
    private let bundleIdentifier: String
    private let photoOutput = AVCapturePhotoOutput()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        button.backgroundColor = .white
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.gray.cgColor
        return button
    }()
    
    private lazy var processingLabel: UILabel = {
        let label = UILabel()
        label.text = "Lütfen Bekleyiniz..."
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    public init(snapAPIToken: String,
                partnerGroupId: String,
                lensId: String,
                bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "",
                cameraPosition: ZMCameraPosition = .back,
                frame: CGRect = .zero) {
        self.lensId = lensId
        self.bundleIdentifier = bundleIdentifier
        super.init(snapAPIToken: snapAPIToken,
                   partnerGroupId: partnerGroupId,
                   cameraPosition: cameraPosition,
                   frame: frame) 
        setupLens()
        setupCustomCameraButton()
        setupCaptureOutputs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLens() {
        //cameraView.carouselView.isHidden = true
        cameraKit.lenses.repository.addObserver(self,
                                              specificLensID: self.lensId,
                                              inGroupID: self.partnerGroupId)
    }
    
    private func setupCaptureOutputs() {
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
    }
    
    private func setupCustomCameraButton() {        
        addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            cameraButton.widthAnchor.constraint(equalToConstant: 70),
            cameraButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        cameraButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
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
        UIView.animate(withDuration: 0.1, animations: {
            self.cameraButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.cameraButton.transform = .identity
            }
        }
        
        showProcessing()
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupCameraAngle()
    }
    
    private func setupCameraAngle() {
        // Set initial camera position based on the cameraPosition property
        let position = cameraPosition
        
        // Configure camera device for optimal angle
        do {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                      for: .video, 
                                                      position: position == .front ? .front : .back) else {
                print("Failed to get camera device")
                return
            }
            
            try device.lockForConfiguration()
            
            // Set zoom factor to 1.0 to match Snapchat's default appearance
            // The previous value of 1.2 was making lenses appear bigger/closer
            let initialZoomFactor: CGFloat = 1.0
            
            // Ensure zoom factor is within device limits
            let minZoom = device.minAvailableVideoZoomFactor
            let maxZoom = device.maxAvailableVideoZoomFactor
            let zoomToUse = max(minZoom, min(initialZoomFactor, maxZoom))
            
            device.videoZoomFactor = zoomToUse
            
            // Set focus mode if needed
            if device.isFocusModeSupported(.continuousAutoFocus) {
                device.focusMode = .continuousAutoFocus
            }
            
            // Set exposure mode if needed
            if device.isExposureModeSupported(.continuousAutoExposure) {
                device.exposureMode = .continuousAutoExposure
            }
            
            device.unlockForConfiguration()
            
            print("Camera angle configured with zoom factor: \(zoomToUse)")
        } catch {
            print("Error configuring camera device: \(error.localizedDescription)")
        }
    }
    
    public func setCameraZoom(_ zoomFactor: CGFloat) {
        do {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                      for: .video, 
                                                      position: cameraPosition == .front ? .front : .back) else {
                return
            }
            
            try device.lockForConfiguration()
            
            // Ensure zoom factor is within device limits
            let minZoom = device.minAvailableVideoZoomFactor
            let maxZoom = device.maxAvailableVideoZoomFactor
            let zoomToUse = max(minZoom, min(zoomFactor, maxZoom))
            
            device.videoZoomFactor = zoomToUse
            device.unlockForConfiguration()
            
            print("Camera zoom set to: \(zoomToUse)")
        } catch {
            print("Error setting camera zoom: \(error.localizedDescription)")
        }
    }
}

// MARK: - Photo Capture Delegate
@available(iOS 13.0, *)
extension ZMSingleCameraView: AVCapturePhotoCaptureDelegate {
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

// MARK: - Lens Repository Observer
@available(iOS 13.0, *)
extension ZMSingleCameraView: LensRepositorySpecificObserver {
    public func repository(_ repository: LensRepository, didUpdate lens: Lens, forGroupID groupID: String) {
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { [weak self] success in
            if success {
                print("Successfully applied lens: \(lens.id)")
                ZMCKit.updateCurrentLensId(lens.id)
            } else {
                print("Failed to apply lens: \(lens.id)")
            }
        }
    }
    
    public func repository(_ repository: LensRepository, didFailToUpdateLensID lensID: String, forGroupID groupID: String, error: Error?) {
        print("Failed to update lens: \(error?.localizedDescription ?? "")")
    }
}

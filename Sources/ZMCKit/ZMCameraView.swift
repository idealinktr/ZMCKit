//
//  ZMCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 26.11.2024.
//


import UIKit
import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

public protocol ZMCameraDelegate: AnyObject {
    func cameraDidCapture(image: UIImage?)
    func cameraDidFinishRecording(videoURL: URL?)
    func cameraDidCancel()
    
    // Add default implementation so these are optional
    func willShowPreview(image: UIImage?) // New method
    func shouldShowDefaultPreview() -> Bool // New method
}

// Default implementations
public extension ZMCameraDelegate {
    func willShowPreview(image: UIImage?) {}
    func shouldShowDefaultPreview() -> Bool { return true }
}

@available(iOS 13.0, *)
public class ZMCameraView: UIView {
    internal let snapAPIToken: String
    internal let partnerGroupId: String
    
    public let captureSession = AVCaptureSession()
    public var cameraKit: CameraKitProtocol!
    
    public let previewView = PreviewView()
    public let cameraView = CameraView()
    
    public weak var delegate: ZMCameraDelegate?
    
    public init(snapAPIToken: String, partnerGroupId: String, frame: CGRect = .zero) {
        self.snapAPIToken = snapAPIToken
        self.partnerGroupId = partnerGroupId
        super.init(frame: frame)
        setupBaseCamera()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupBaseCamera() {
        cameraKit = Session(
            sessionConfig: SessionConfig(apiToken: snapAPIToken),
            lensesConfig: LensesConfig(
                cacheConfig: CacheConfig(lensContentMaxSize: 150 * 1024 * 1024)
            ),
            errorHandler: nil
        )
        
        addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: topAnchor),
            previewView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        cameraKit.add(output: previewView)
        
        let input = AVSessionInput(session: captureSession)
        let arInput = ARSessionInput()
        
        previewView.automaticallyConfiguresTouchHandler = true
        cameraKit.start(input: input, arInput: arInput)
        
        Task { @MainActor in
            await startCamera(input)
        }
    }

    private func startCamera(_ input: AVSessionInput) async {
        input.position = .back
        
        input.startRunning()
    }

    public func cleanup() {
        cameraKit.remove(output: previewView)
        captureSession.stopRunning()
        cameraKit = nil
    }

    public override func removeFromSuperview() {
        cleanup()
        super.removeFromSuperview()
    }

    // Helper method to find parent view controller
    internal func findViewController() -> UIViewController? {
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

// MARK: - Camera Button Delegate
@available(iOS 13.0, *)
extension ZMCameraView: CameraButtonDelegate {
    public func cameraButtonTapped(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
        print("debug 1")
    }
    
    public func cameraButtonHoldBegan(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
        print("debug 2")
    }
    
    public func cameraButtonHoldCancelled(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
        print("debug 3")
    }
    
    public func cameraButtonHoldEnded(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
        print("debug 4")
    }
    
}

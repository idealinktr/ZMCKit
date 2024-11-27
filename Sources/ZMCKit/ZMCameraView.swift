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
    
    public let captureSession = AVCaptureSession()
    public var cameraKit: CameraKitProtocol!
    
    public let previewView = PreviewView()
    public let cameraView = CameraView()
    
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
    }

    public override func removeFromSuperview() {
        cleanup()
        super.removeFromSuperview()
    }
} 

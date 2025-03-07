//
//  ZMCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 26.11.2024.
//


import UIKit
import SCSDKCameraKit

public protocol ZMCameraDelegate: AnyObject {
    func cameraDidCapture(image: UIImage?)
    
    func willShowPreview(image: UIImage?)
    func shouldShowDefaultPreview() -> Bool
}

public extension ZMCameraDelegate {
    func willShowPreview(image: UIImage?) {}
    func shouldShowDefaultPreview() -> Bool { return true }
}

@available(iOS 13.0, *)
public class ZMCameraView: UIView {
    internal let snapAPIToken: String
    internal let partnerGroupId: String
    internal let cameraPosition: ZMCameraPosition
    
    public let captureSession = AVCaptureSession()
    public var cameraKit: CameraKitProtocol!
    public let previewView = {
        let preview = PreviewView()
        preview.contentMode = .aspectFill
        preview.automaticallyConfiguresTouchHandler = true
        return preview
    }()
    
    public weak var delegate: ZMCameraDelegate?
    public weak var lensStatusDelegate: ZMLensStatusDelegate?
    
    public init(snapAPIToken: String,
                partnerGroupId: String,
                cameraPosition: ZMCameraPosition = .back,
                frame: CGRect = .zero) {
        self.snapAPIToken = snapAPIToken
        self.partnerGroupId = partnerGroupId
        self.cameraPosition = cameraPosition
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
        input.position = cameraPosition.avPosition
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
    
    @objc public func processor(_ processor: LensProcessor, didApplyLens lens: Lens) {
        DispatchQueue.main.async { [weak self] in
            self?.lensStatusDelegate?.lensDidStartApplying(lens: lens)
        }
    }
    
    @objc public func processorDidIdle(_ processor: LensProcessor) {
        DispatchQueue.main.async { [weak self] in
            self?.lensStatusDelegate?.lensDidBecomeIdle()
        }
    }
    
    @objc public func processor(_ processor: LensProcessor, firstFrameDidBecomeReadyFor lens: Lens) {
        DispatchQueue.main.async { [weak self] in
            self?.lensStatusDelegate?.lensDidBecomeReady(lens: lens)
        }
    }
    
    internal func handleLensApplicationFailure(lens: Lens?, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.lensStatusDelegate?.lensDidFail(lens: lens, error: error)
        }
    }
}

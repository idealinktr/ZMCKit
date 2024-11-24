//
//  ZMSingleCameraVC.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 25.11.2024.
//

import UIKit
@preconcurrency import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

class ZMSingleCameraVC: UIViewController {
    private let snapAPIToken: String
    private let partnerGroupId: String
    private let lensId: String
    private let bundleIdentifier: String
    
    public let captureSession = AVCaptureSession()
    public var cameraKit: CameraKitProtocol!
    
    public let previewView = PreviewView()
    public let cameraView = CameraView()
        
    public init(snapAPIToken: String, partnerGroupId: String, lensId: String, bundleIdentifier: String) {
        self.snapAPIToken = snapAPIToken
        self.partnerGroupId = partnerGroupId
        self.lensId = lensId
        self.bundleIdentifier = bundleIdentifier
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCameraKit()
    }
    
    public func setupCameraKit() {
        self.cameraKit = Session(sessionConfig: SessionConfig(apiToken: self.snapAPIToken),
                                 lensesConfig: LensesConfig(cacheConfig: CacheConfig(lensContentMaxSize: 150 * 1024 * 1024)),
                                 errorHandler: nil)
        
        cameraKit.add(output: previewView)
        
        let input = AVSessionInput(session: self.captureSession)
        let arInput = ARSessionInput()
        
        previewView.automaticallyConfiguresTouchHandler = true
        cameraKit.start(input: input, arInput: arInput)
        
        
        DispatchQueue.global(qos: .background).async {
            input.position = .back
            input.startRunning()
        }
    }
    
    private func fetchLens() {
        cameraKit.lenses.repository.addObserver(self,
                                                specificLensID: self.lensId,
                                                inGroupID: self.partnerGroupId)
    }
    
    private func applyLens(lens: Lens) {
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { success in
            if success {
                print("Lens Applied")
            } else {
                print("Did fail to apply lens")
            }
        }
    }
}

extension ZMSingleCameraVC: @preconcurrency LensRepositorySpecificObserver {
    func repository(_ repository: LensRepository,
                    didUpdate lens: Lens,
                    forGroupID groupID: String) {
        applyLens(lens: lens)

    }

    func repository(_ repository: LensRepository,
                    didFailToUpdateLensID lensID: String,
                    forGroupID groupID: String,
                    error: Error?) {
        print("Did fail to update lens")
    }
}

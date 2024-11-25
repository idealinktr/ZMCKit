//
//  ZMMultiLensCameraVC.swift
//  ZMCKit
//
//  Created by Claude AI on 7.10.2024.
//

import UIKit
@preconcurrency import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

public class ZMMultiLensCameraVC: UIViewController {
    private let snapAPIToken: String
    private let partnerGroupId: String
    private let lensIds: [String]
    
    public let captureSession = AVCaptureSession()
    public var cameraKit: CameraKitProtocol!
    public let previewView = PreviewView()
    
    private var currentLensIndex: Int = 0
    private var lenses: [Lens] = []
    
    // MARK: - Initialization
    
    public init(snapAPIToken: String, partnerGroupId: String) {
        self.snapAPIToken = snapAPIToken
        self.partnerGroupId = partnerGroupId
        self.lensIds = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view = previewView
        setupCameraKit()
        fetchLenses()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Add switch lens button
        let switchButton = UIButton(type: .system)
        switchButton.setTitle("Switch Lens", for: .normal)
        switchButton.addTarget(self, action: #selector(switchLensButtonTapped), for: .touchUpInside)
        
        view.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            switchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            switchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupCameraKit() {
        self.cameraKit = Session(
            sessionConfig: SessionConfig(apiToken: self.snapAPIToken),
            lensesConfig: LensesConfig(
                cacheConfig: CacheConfig(lensContentMaxSize: 150 * 1024 * 1024)
            ),
            errorHandler: nil
        )
        
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
    
    // MARK: - Lens Management
    
    private func fetchLenses() {
        cameraKit.lenses.repository.addObserver(
            self,
            groupID: self.partnerGroupId
        )
    }
    
    private func applyLens(lens: Lens) {
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { success in
            if success {
                print("Successfully applied lens: \(lens.id)")
            } else {
                print("Failed to apply lens: \(lens.id)")
            }
        }
    }
    
    @objc private func switchLensButtonTapped() {
        guard !lenses.isEmpty else { return }
        
        currentLensIndex = (currentLensIndex + 1) % lenses.count
        applyLens(lens: lenses[currentLensIndex])
    }	
}

// MARK: - LensRepositoryGroupObserver
extension ZMMultiLensCameraVC: @preconcurrency LensRepositoryGroupObserver {
    public func repository(_ repository: LensRepository, didUpdateLenses lenses: [Lens], forGroupID groupID: String) {
        self.lenses = lenses
        
        // Apply first lens when lenses become available
        if !lenses.isEmpty && currentLensIndex == 0 {
            applyLens(lens: lenses[0])
        }
    }
    
    nonisolated public func repository(_ repository: LensRepository, didFailToUpdateLensesForGroupID groupID: String, error: Error?) {
        print("Failed to load lenses for group: \(groupID), error: \(String(describing: error))")
    }
} 

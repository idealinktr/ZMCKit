//
//  ZMMultiLensCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 27.11.2024.
//

import UIKit
import SCSDKCameraKit
import ARKit

@available(iOS 13.0, *)
public protocol ZMLensStatusDelegate: AnyObject {
    func lensDidStartApplying(lens: Lens)
    func lensDidBecomeReady(lens: Lens)
    func lensDidBecomeIdle()
    func lensDidFail(lens: Lens?, error: Error?)
}

@available(iOS 13.0, *)
public extension ZMLensStatusDelegate {
    func lensDidStartApplying(lens: Lens) {}
    func lensDidBecomeReady(lens: Lens) {}
    func lensDidBecomeIdle() {}
    func lensDidFail(lens: Lens?, error: Error?) {}
}

@available(iOS 13.0, *)
public class ZMMultiLensCameraView: ZMCameraView {
    private var lenses: [Lens] = []
    private let photoOutput = AVCapturePhotoOutput()
    
    private var currentLensIndex: Int = 0
    
    private var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    
    private lazy var processingLabel: UILabel = {
        let label = UILabel()
        label.text = "Lütfen Bekleyiniz..."
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LensCell.self, forCellWithReuseIdentifier: "LensCell")
        return collectionView
    }()
    
    private lazy var captureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        button.backgroundColor = .white
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(handleCapture), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    public override init(snapAPIToken: String,
                         partnerGroupId: String,
                         cameraPosition: ZMCameraPosition = .back,
                         frame: CGRect = .zero) {
        super.init(snapAPIToken: snapAPIToken,
                          partnerGroupId: partnerGroupId,
                          cameraPosition: cameraPosition,
                          frame: frame)
        setupUI()
        setupLenses()
        setupCaptureOutputs()
        setStandardCameraConfiguration()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        addSubview(captureButton)
        addSubview(processingLabel)
        addSubview(loadingIndicator)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        processingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 80),
            
            processingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            processingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        collectionView.backgroundColor = .clear
        bringSubviewToFront(collectionView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(collectionView)
    }
    
    private func setupLenses() {
        // Ensure we're using a standard camera configuration
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Always reset to standard camera for lens initialization
            self.resetToStandardCamera()
            
            // Wait for camera configuration to complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Now add the lens repository observer
                self.cameraKit.lenses.repository.addObserver(self, groupID: self.partnerGroupId)
                
                // Refresh the UI
                self.collectionView.reloadData()
                
                print("Lens repository observer added")
            }
        }
    }
    
    private func setupCaptureOutputs() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canAddOutput(self.photoOutput) {
                self.captureSession.addOutput(self.photoOutput)
            }
            
            self.captureSession.commitConfiguration()
        }
    }
    
    private func setStandardCameraConfiguration() {
        // Set camera position based on the cameraPosition property
        let position = cameraPosition
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                // Get the appropriate camera device based on position
                guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                         for: .video, 
                                                         position: position == .front ? .front : .back) else {
                    print("Failed to get camera device")
                    return
                }
                
                try device.lockForConfiguration()
                
                // Always set zoom to 1.0x (standard)
                device.videoZoomFactor = 1.0
                device.unlockForConfiguration()
                
                print("Set standard camera configuration with 1.0x zoom")
            } catch {
                print("Error setting camera configuration: \(error.localizedDescription)")
            }
        }
    }
    
    private func reconnectCameraKit() {
        // Re-create the AVSessionInput with our newly configured capture session
        let input = AVSessionInput(session: captureSession)
        
        // Create a proper AR input using Snapchat's built-in ARSessionInput class
        let arInput = ARSessionInput()
        
        // Get the current device position for CameraKit
        let devicePosition: AVCaptureDevice.Position = cameraPosition == .front ? .front : .back
        
        // Get the correct video orientation
        let videoOrientation: AVCaptureVideoOrientation = {
            switch UIDevice.current.orientation {
            case .portrait:
                return .portrait
            case .portraitUpsideDown:
                return .portraitUpsideDown
            case .landscapeLeft:
                return .landscapeRight // Note: Camera orientation is opposite to device orientation
            case .landscapeRight:
                return .landscapeLeft // Note: Camera orientation is opposite to device orientation
            default:
                return .portrait // Default to portrait for face-up, face-down, or unknown
            }
        }()
        
        // Set a flag to track successful reconnection
        var reconnectionSuccessful = false
        
        // Restart CameraKit with the new input and all required parameters
        cameraKit.stop()
        
        // Set a timeout to ensure we don't get stuck if Camera Kit fails to initialize
        let timeout = DispatchWorkItem { [weak self] in
            guard let self = self, !reconnectionSuccessful else { return }
            
            print("Camera Kit reconnection timed out - falling back to standard camera configuration")
            
            // Fallback to standard camera configuration
            DispatchQueue.global(qos: .userInitiated).async {
                // Reset to standard camera configuration
                self.resetToStandardCamera()
            }
        }
        
        // Schedule timeout after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: timeout)
        
        // Use the full start method with all required parameters
        cameraKit.start(
            input: input,
            arInput: arInput,
            cameraPosition: devicePosition,
            videoOrientation: videoOrientation,
            dataProvider: nil,
            hintDelegate: nil,
            textInputContextProvider: nil,
            agreementsPresentationContextProvider: nil
        )
        
        // Re-add our preview view as an output
        cameraKit.add(output: previewView)
        
        // Mark reconnection as successful
        reconnectionSuccessful = true
        
        // Cancel the timeout since reconnection was successful
        timeout.cancel()
        
        // Apply current lens again if needed, but with a slight delay
        // to ensure Camera Kit is fully initialized
        if let lens = lenses.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.applyLens(lens: lens)
            }
        }
    }
    
    // Reset to standard camera configuration
    private func resetToStandardCamera() {
        // This method provides a clean reset to standard camera when needed
        self.captureSession.stopRunning()
        
        self.captureSession.beginConfiguration()
        
        // Remove all inputs
        for input in self.captureSession.inputs {
            self.captureSession.removeInput(input)
        }
        
        // Use standard wide angle camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: self.cameraPosition == .front ? .front : .back),
           let deviceInput = try? AVCaptureDeviceInput(device: device),
           self.captureSession.canAddInput(deviceInput) {
            
            self.captureSession.addInput(deviceInput)
            
            try? device.lockForConfiguration()
            // Always use standard zoom (1.0x)
            device.videoZoomFactor = 1.0
            device.unlockForConfiguration()
        }
        
        // Re-add the photo output if needed
        if !self.captureSession.outputs.contains(where: { $0 === self.photoOutput }) {
            if self.captureSession.canAddOutput(self.photoOutput) {
                self.captureSession.addOutput(self.photoOutput)
            }
        }
        
        self.captureSession.commitConfiguration()
        self.captureSession.startRunning()
        
        // Create new inputs for Camera Kit with standard camera
        let input = AVSessionInput(session: self.captureSession)
        let arInput = ARSessionInput()
        
        // Restart Camera Kit on the main thread
        DispatchQueue.main.async {
            self.cameraKit.stop()
            self.cameraKit.start(input: input, arInput: arInput)
            self.cameraKit.add(output: self.previewView)
        }
    }
    
    private func applyLens(lens: Lens) {
        // Start a loading indicator
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }
        
        print("Applying lens: \(lens.id)")
        
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { [weak self] success in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
            }
            
            if success {
                print("Successfully applied lens: \(lens.id)")
                ZMCKit.updateCurrentLensId(lens.id)
            } else {
                print("Failed to apply lens: \(lens.id)")
                self.handleLensApplicationFailure(lens: lens, error: nil)
            }
        }
    }
    
    // Add this new method to troubleshoot potential lens issues
    internal override func handleLensApplicationFailure(lens: Lens?, error: Error?) {
        print("Lens application failed for lens ID: \(lens?.id ?? "unknown")")
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        
        // First, try to reset the camera configuration
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Reset to standard camera configuration
            self.resetToStandardCamera()
        }
        
        // Show an alert or recovery UI
        DispatchQueue.main.async { [weak self] in
            if let topVC = self?.findViewController() {
                let alert = UIAlertController(
                    title: "Lens Application Issue",
                    message: "There was a problem applying the lens. The camera has been reset.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                topVC.present(alert, animated: true)
            }
        }
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
    
    private func capturePhoto() {
        showProcessing()
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func handleCapture() {
        UIView.animate(withDuration: 0.1, animations: {
            self.captureButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.captureButton.transform = .identity
            }
        }
        capturePhoto()
    }
}

// MARK: - UICollectionView DataSource & Delegate
@available(iOS 13.0, *)
extension ZMMultiLensCameraView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lenses.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LensCell", for: indexPath) as! LensCell
        let lens = lenses[indexPath.item]
        cell.configure(with: lens, cache: imageCache)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentLensIndex = indexPath.item
        let lens = lenses[currentLensIndex]
        applyLens(lens: lens)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

// MARK: - Lens Repository Observer
@available(iOS 13.0, *)
extension ZMMultiLensCameraView: LensRepositoryGroupObserver {
    public func repository(_ repository: LensRepository, didUpdateLenses lenses: [Lens], forGroupID groupID: String) {
        print("Repository updated with \(lenses.count) lenses for group ID: \(groupID)")
        self.lenses = lenses
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
            // Apply first lens if available, but with a slight delay to ensure
            // camera configuration has settled
            if let firstLens = self.lenses.first {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    guard let self = self else { return }
                    print("Applying first lens: \(firstLens.id)")
                    self.applyLens(lens: firstLens)
                }
            }
        }
    }
    
    public func repository(_ repository: LensRepository, didFailToUpdateLensesForGroupID groupID: String, error: Error?) {
        print("Failed to update lenses for group: \(error?.localizedDescription ?? "")")
    }
}

// MARK: - Photo Capture Delegate
@available(iOS 13.0, *)
extension ZMMultiLensCameraView: AVCapturePhotoCaptureDelegate {
    open override func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
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


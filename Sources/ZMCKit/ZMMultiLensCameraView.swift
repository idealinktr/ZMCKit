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
    
    private let initialZoomFactor: CGFloat = 0.6
    
    private var currentZoomFactor: CGFloat = 1.0
    private lazy var zoomLevelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.text = "1.0x"
        label.isHidden = false
        label.alpha = 0.7
        return label
    }()
    
    private lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        return gesture
    }()
    
    private lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()
    
    private lazy var zoomInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleZoomIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var zoomOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("−", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleZoomOut), for: .touchUpInside)
        return button
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
        setInitialZoom()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        addSubview(captureButton)
        addSubview(processingLabel)
        addSubview(loadingIndicator)
        addSubview(zoomLevelLabel)
        addSubview(zoomInButton)
        addSubview(zoomOutButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        processingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        zoomLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            zoomLevelLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            zoomLevelLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            zoomLevelLabel.widthAnchor.constraint(equalToConstant: 60),
            zoomLevelLabel.heightAnchor.constraint(equalToConstant: 30),
            
            zoomInButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            zoomInButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            zoomInButton.widthAnchor.constraint(equalToConstant: 40),
            zoomInButton.heightAnchor.constraint(equalToConstant: 40),
            
            zoomOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            zoomOutButton.topAnchor.constraint(equalTo: zoomInButton.bottomAnchor, constant: 10),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 40),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        collectionView.backgroundColor = .clear
        bringSubviewToFront(collectionView)
        
        // Add pinch gesture recognizer for zoom
        addGestureRecognizer(pinchGestureRecognizer)
        addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(collectionView)
    }
    
    private func setupLenses() {
        cameraKit.lenses.repository.addObserver(self, groupID: self.partnerGroupId)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
    
    private func setInitialZoom() {
        // Set initial camera position based on the cameraPosition property
        let position = cameraPosition
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                // First, check if the device has an ultra-wide camera
                // This is available on iPhone 11 and newer models
                var hasUltraWideCamera = false
                var ultraWideDevice: AVCaptureDevice?
                
                if #available(iOS 13.0, *) {
                    if let ultraWide = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: position == .front ? .front : .back) {
                        hasUltraWideCamera = true
                        ultraWideDevice = ultraWide
                        print("Ultra-wide camera detected!")
                    }
                }
                
                // Get the appropriate camera device based on position
                guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                         for: .video, 
                                                         position: position == .front ? .front : .back) else {
                    print("Failed to get camera device")
                    return
                }
                
                try device.lockForConfiguration()
                
                // The target zoom factor for shoe lenses (0.6x)
                let targetZoom: CGFloat = 0.6
                
                // If ultra-wide camera is available, we need to reconfigure the capture session
                if hasUltraWideCamera && ultraWideDevice != nil {
                    // Defer to the setup method that can properly switch cameras
                    device.unlockForConfiguration()
                    
                    DispatchQueue.main.async {
                        self.configureForWideZoom(targetZoom: targetZoom)
                    }
                    return
                }
                
                // If no ultra-wide camera, try to find the best format for wide zoom
                var bestFormat: AVCaptureDevice.Format?
                var lowestZoomFactor: CGFloat = 1.0
                
                if #available(iOS 13.0, *) {
                    // Get all available formats for this device
                    for format in device.formats {
                        let formatDescription = CMFormatDescriptionGetMediaSubType(format.formatDescription)
                        let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
                        
                        // Get the zoom factor range for this format
                        let minZoom = format.videoZoomFactorUpscaleThreshold
                        
                        // Check if this format supports zoom factors below 1.0
                        if minZoom < lowestZoomFactor {
                            bestFormat = format
                            lowestZoomFactor = minZoom
                            print("Found better format: min zoom \(minZoom), resolution \(dimensions.width)x\(dimensions.height), type \(formatDescription)")
                        }
                    }
                    
                    // If we found a better format, use it
                    if let bestFormat = bestFormat, lowestZoomFactor < 1.0 {
                        device.activeFormat = bestFormat
                        print("Using format with minimum zoom factor: \(lowestZoomFactor)")
                    } else {
                        print("No formats with zoom factor < 1.0 found, device min: \(device.minAvailableVideoZoomFactor)")
                    }
                }
                
                // Set a wider initial zoom factor (0.6x) for shoe lenses
                // First, find the actual lowest available zoom factor for this device
                let deviceMinZoom = device.minAvailableVideoZoomFactor
                
                // Target is 0.6 but constrain to what device supports
                let zoomToUse = max(deviceMinZoom, min(targetZoom, device.maxAvailableVideoZoomFactor))
                
                device.videoZoomFactor = zoomToUse
                device.unlockForConfiguration()
                
                // Update current zoom factor and UI
                DispatchQueue.main.async {
                    self.currentZoomFactor = zoomToUse
                    self.updateZoomLevelUI()
                }
                
                print("Set initial zoom factor to: \(zoomToUse) (device min: \(deviceMinZoom))")
            } catch {
                print("Error setting initial zoom: \(error.localizedDescription)")
            }
        }
    }
    
    private func configureForWideZoom(targetZoom: CGFloat) {
        // Temporarily pause session
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.captureSession.stopRunning()
            
            // Begin configuration
            self.captureSession.beginConfiguration()
            
            // Remove existing inputs
            self.captureSession.inputs.forEach { self.captureSession.removeInput($0) }
            
            // Create and add input for ultra-wide camera if available
            if #available(iOS 13.0, *) {
                // First try to get the ultra-wide camera
                if let ultraWideDevice = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: self.cameraPosition == .front ? .front : .back),
                   let ultraWideInput = try? AVCaptureDeviceInput(device: ultraWideDevice),
                   self.captureSession.canAddInput(ultraWideInput) {
                    
                    // Add ultra-wide camera input
                    self.captureSession.addInput(ultraWideInput)
                    print("Successfully configured ultra-wide camera input")
                    
                    try? ultraWideDevice.lockForConfiguration()
                    ultraWideDevice.videoZoomFactor = 1.0 // 1.0 on ultra-wide is effectively 0.5x on a standard camera
                    ultraWideDevice.unlockForConfiguration()
                    
                    // Update current zoom factor and UI
                    DispatchQueue.main.async {
                        self.currentZoomFactor = 0.5
                        self.updateZoomLevelUI()
                    }
                    
                    // Commit configuration and restart session
                    self.captureSession.commitConfiguration()
                    self.captureSession.startRunning()
                    
                    // Reconnect CameraKit to the new capture session
                    DispatchQueue.main.async {
                        self.reconnectCameraKit()
                    }
                    return
                }
            }
            
            // If ultra-wide camera isn't available, fall back to standard camera
            if let wideDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: self.cameraPosition == .front ? .front : .back),
               let wideInput = try? AVCaptureDeviceInput(device: wideDevice),
               self.captureSession.canAddInput(wideInput) {
                
                // Add wide-angle camera input
                self.captureSession.addInput(wideInput)
                print("Falling back to standard wide-angle camera input")
                
                try? wideDevice.lockForConfiguration()
                
                // Try to find a format that supports wide zoom
                if #available(iOS 13.0, *) {
                    var bestFormat: AVCaptureDevice.Format?
                    var lowestZoomFactor: CGFloat = 1.0
                    
                    for format in wideDevice.formats {
                        let minZoom = format.videoZoomFactorUpscaleThreshold
                        if minZoom < lowestZoomFactor {
                            bestFormat = format
                            lowestZoomFactor = minZoom
                        }
                    }
                    
                    if let bestFormat = bestFormat, lowestZoomFactor < 1.0 {
                        wideDevice.activeFormat = bestFormat
                        print("Using format with minimum zoom factor: \(lowestZoomFactor)")
                    }
                }
                
                // Set zoom factor (constrained to device capabilities)
                let deviceMinZoom = wideDevice.minAvailableVideoZoomFactor
                let zoomToUse = max(deviceMinZoom, min(targetZoom, wideDevice.maxAvailableVideoZoomFactor))
                wideDevice.videoZoomFactor = zoomToUse
                wideDevice.unlockForConfiguration()
                
                // Update current zoom factor and UI
                DispatchQueue.main.async {
                    self.currentZoomFactor = zoomToUse
                    self.updateZoomLevelUI()
                }
                
                print("Set initial zoom factor to: \(zoomToUse) (device min: \(deviceMinZoom))")
            }
            
            // Commit configuration and restart session
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
            
            // Reconnect CameraKit to the new capture session
            DispatchQueue.main.async {
                self.reconnectCameraKit()
            }
        }
    }
    
    private func reconnectCameraKit() {
        // Re-create the AVSessionInput with our newly configured capture session
        let input = AVSessionInput(session: captureSession)
        
        // Create a proper AR input using Snapchat's built-in ARSessionInput class
        // This is more reliable than our custom implementation
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
        
        // Restart CameraKit with the new input and all required parameters
        cameraKit.stop()
        
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
        
        // Apply current lens again if needed
        if let lens = lenses.first {
            applyLens(lens: lens)
        }
    }
    
    private func adjustZoomForShoeLens(lens: Lens) {
        // Check if this is a shoe lens based on lens ID or other criteria
        // let isShoeLens = lens.id.lowercased().contains("shoe") || lens.name?.lowercased().contains("shoe") == true
        let isShoeLens = true
        
        if isShoeLens {
            let shoeZoomFactor: CGFloat = 0.6
            
            // Log more details about available cameras
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                
                if #available(iOS 13.0, *) {
                    // Check if ultra-wide camera is available
                    if let _ = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: self.cameraPosition == .front ? .front : .back) {
                        // For devices with ultra-wide camera, we need to reconfigure the capture session
                        // This will ensure we get the 0.5x or 0.6x zoom factor we need
                        DispatchQueue.main.async {
                            self.configureForWideZoom(targetZoom: shoeZoomFactor)
                        }
                    } else {
                        // For devices without ultra-wide camera, try standard approach
                        self.setZoomFactor(shoeZoomFactor)
                    }
                } else {
                    // For older iOS versions
                    self.setZoomFactor(shoeZoomFactor)
                }
            }
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
                
                // Wait a short moment to ensure lens is fully loaded before adjusting zoom
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    guard let self = self else { return }
                    
                    // Check current camera configuration
                    if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: self.cameraPosition == .front ? .front : .back) {
                        print("Current zoom factor after lens applied: \(device.videoZoomFactor)")
                        print("Device min zoom: \(device.minAvailableVideoZoomFactor), max zoom: \(device.maxAvailableVideoZoomFactor)")
                    }
                    
                    // Adjust zoom for shoe lenses - needed since lens application might reset camera settings
                    self.adjustZoomForShoeLens(lens: lens)
                }
            } else {
                print("Failed to apply lens: \(lens.id)")
                self.handleLensApplicationFailure(lens: lens, error: nil)
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
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                 for: .video, 
                                                 position: cameraPosition == .front ? .front : .back) else {
            return
        }
        
        // Get initial state when gesture begins
        if gesture.state == .began {
            gesture.scale = currentZoomFactor
        }
        
        // Only change zoom when gesture state is changed or ended
        if gesture.state == .changed || gesture.state == .ended {
            do {
                try device.lockForConfiguration()
                
                // Check if trying to zoom below 1.0 and reconfigure if needed
                let wantedZoom = gesture.scale
                let wideZoomSupported = device.minAvailableVideoZoomFactor < 1.0
                
                // If we're trying to use wide zoom but device doesn't support it,
                // try to find a format that does
                if wantedZoom < 1.0, !wideZoomSupported, #available(iOS 13.0, *) {
                    for format in device.formats {
                        if format.videoZoomFactorUpscaleThreshold < 1.0 {
                            // Switch to a format that supports wide zoom
                            device.activeFormat = format
                            break
                        }
                    }
                }
                
                // Get the updated min/max zoom factors
                let minZoom = device.minAvailableVideoZoomFactor
                let maxZoom = min(device.maxAvailableVideoZoomFactor, 10.0) // Cap at 10x for usability
                
                // Set the new zoom factor, clamped to valid range
                let newZoomFactor = max(minZoom, min(wantedZoom, maxZoom))
                device.videoZoomFactor = newZoomFactor
                
                // Update current zoom factor and UI
                currentZoomFactor = newZoomFactor
                updateZoomLevelUI()
                
                device.unlockForConfiguration()
            } catch {
                print("Error adjusting zoom: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func handleDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        // Preset zoom levels to cycle through, including ultra-wide (0.5x)
        let zoomLevels: [CGFloat] = [0.5, 0.6, 1.0, 2.0, 5.0]
        
        // Find the next zoom level in the cycle
        var nextZoomIndex = 0
        for (index, zoom) in zoomLevels.enumerated() {
            if currentZoomFactor < zoom {
                nextZoomIndex = index
                break
            }
        }
        
        // If we're already at or past the last zoom level, cycle back to the first
        if nextZoomIndex == 0 && currentZoomFactor >= zoomLevels.last! {
            nextZoomIndex = 0
        }
        
        // Apply the new zoom level
        let newZoom = zoomLevels[nextZoomIndex]
        setZoomFactor(newZoom)
        
        // Provide haptic feedback
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
    }
    
    private func updateZoomLevelUI() {
        let formattedZoom = String(format: "%.1fx", currentZoomFactor)
        DispatchQueue.main.async {
            self.zoomLevelLabel.text = formattedZoom
            
            // Show label with animation when zoom changes
            UIView.animate(withDuration: 0.2) {
                self.zoomLevelLabel.alpha = 1.0
            }
            
            // Hide label after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 0.5) {
                    // Don't fully hide it, just make it semi-transparent
                    self.zoomLevelLabel.alpha = 0.7
                }
            }
        }
    }
    
    public func setZoomFactor(_ zoomFactor: CGFloat) {
        // For ultra-low zoom factors (< 0.5), we need to switch to the ultra-wide camera
        if zoomFactor <= 0.5 {
            configureForWideZoom(targetZoom: zoomFactor)
            return
        }
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                 for: .video, 
                                                 position: cameraPosition == .front ? .front : .back) else {
            return
        }
        
        do {
            try device.lockForConfiguration()
            
            // Get the device's actual zoom capabilities
            let minZoom = device.minAvailableVideoZoomFactor
            let maxZoom = min(device.maxAvailableVideoZoomFactor, 10.0) // Cap at 10x for usability
            
            // Try to find a better format for wide zoom if needed
            if zoomFactor < 1.0, minZoom >= 1.0, #available(iOS 13.0, *) {
                var bestFormat: AVCaptureDevice.Format?
                var lowestZoomFactor: CGFloat = 1.0
                
                for format in device.formats {
                    let minZoomForFormat = format.videoZoomFactorUpscaleThreshold
                    if minZoomForFormat < lowestZoomFactor {
                        bestFormat = format
                        lowestZoomFactor = minZoomForFormat
                    }
                }
                
                if let bestFormat = bestFormat, lowestZoomFactor < 1.0 {
                    device.activeFormat = bestFormat
                    print("Switched to format with minimum zoom factor: \(lowestZoomFactor)")
                } else {
                    print("Device does not support zoom factors below 1.0")
                }
            }
            
            // Recalculate min/max zoom after potentially changing format
            let updatedMinZoom = device.minAvailableVideoZoomFactor
            let updatedMaxZoom = min(device.maxAvailableVideoZoomFactor, 10.0)
            
            // Safely clamp the zoom factor to supported values
            let newZoomFactor = max(updatedMinZoom, min(zoomFactor, updatedMaxZoom))
            
            // Set the new zoom factor
            device.videoZoomFactor = newZoomFactor
            
            // Update current zoom factor and UI
            currentZoomFactor = newZoomFactor
            updateZoomLevelUI()
            
            device.unlockForConfiguration()
            
            print("Set zoom to: \(newZoomFactor) (requested: \(zoomFactor), device min: \(updatedMinZoom))")
        } catch {
            print("Error setting zoom factor: \(error.localizedDescription)")
        }
    }
    
    public func getCurrentZoomFactor() -> CGFloat {
        return currentZoomFactor
    }
    
    @objc private func handleZoomIn() {
        // Increase zoom by 25%
        let newZoom = currentZoomFactor * 1.25
        setZoomFactor(newZoom)
        
        // Provide haptic feedback
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
    }
    
    @objc private func handleZoomOut() {
        // Decrease zoom by 20%
        var newZoom = currentZoomFactor * 0.8
        
        // If we're close to the ultra-wide threshold, snap to it
        if newZoom < 0.55 && newZoom > 0.45 {
            newZoom = 0.5
        }
        
        setZoomFactor(newZoom)
        
        // Provide haptic feedback
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
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
        self.lenses = lenses
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
            // Apply first lens if available
            if let firstLens = self.lenses.first {
                self.applyLens(lens: firstLens)
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


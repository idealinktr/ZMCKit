//
//  ZMMultiLensCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 27.11.2024.
//

import UIKit
import SCSDKCameraKit

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
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
    }
    
    private func setInitialZoom() {
        // Set initial camera position based on the cameraPosition property
        let position = cameraPosition
        
        do {
            // Get the appropriate camera device based on position
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                     for: .video, 
                                                     position: position == .front ? .front : .back) else {
                print("Failed to get camera device")
                return
            }
            
            try device.lockForConfiguration()
            
            // Set a wider initial zoom factor (0.6x) for shoe lenses
            let initialZoomFactor: CGFloat = 0.6
            
            // Ensure zoom factor is within device limits
            let minZoom = device.minAvailableVideoZoomFactor
            let maxZoom = device.maxAvailableVideoZoomFactor
            
            let zoomToUse = max(minZoom, min(initialZoomFactor, maxZoom))
            
            device.videoZoomFactor = zoomToUse
            device.unlockForConfiguration()
            
            // Update current zoom factor and UI
            self.currentZoomFactor = zoomToUse
            updateZoomLevelUI()
            
            print("Set initial zoom factor to: \(zoomToUse)")
        } catch {
            print("Error setting initial zoom: \(error.localizedDescription)")
        }
    }
    
    private func adjustZoomForShoeLens(lens: Lens) {
        // Check if this is a shoe lens based on lens ID or other criteria
        // let isShoeLens = lens.id.lowercased().contains("shoe") || lens.name?.lowercased().contains("shoe") == true
        let isShoeLens = true
        
        if isShoeLens {
            let shoeZoomFactor: CGFloat = 0.6
            setZoomFactor(shoeZoomFactor)
        }
    }
    
    private func applyLens(lens: Lens) {
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { [weak self] success in
            guard let self = self else { return }
            
            if success {
                print("Successfully applied lens: \(lens.id)")
                ZMCKit.updateCurrentLensId(lens.id)
                
                // Adjust zoom for shoe lenses
                self.adjustZoomForShoeLens(lens: lens)
            } else {
                print("Failed to apply lens: \(lens.id)")
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.handleLensApplicationFailure(lens: lens, error: nil)
                }
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
                
                // Calculate new zoom factor
                let minZoom = device.minAvailableVideoZoomFactor
                let maxZoom = min(device.maxAvailableVideoZoomFactor, 10.0) // Cap at 10x for usability
                let newZoomFactor = max(minZoom, min(gesture.scale, maxZoom))
                
                // Set the new zoom factor
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
        // Preset zoom levels to cycle through
        let zoomLevels: [CGFloat] = [0.6, 1.0, 2.0, 5.0]
        
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
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                 for: .video, 
                                                 position: cameraPosition == .front ? .front : .back) else {
            return
        }
        
        do {
            try device.lockForConfiguration()
            
            // Calculate new zoom factor
            let minZoom = device.minAvailableVideoZoomFactor
            let maxZoom = min(device.maxAvailableVideoZoomFactor, 10.0) // Cap at 10x for usability
            let newZoomFactor = max(minZoom, min(zoomFactor, maxZoom))
            
            // Set the new zoom factor
            device.videoZoomFactor = newZoomFactor
            
            // Update current zoom factor and UI
            currentZoomFactor = newZoomFactor
            updateZoomLevelUI()
            
            device.unlockForConfiguration()
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
        let newZoom = currentZoomFactor * 0.8
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


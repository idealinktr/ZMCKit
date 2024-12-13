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
    private let photoOutput = AVCapturePhotoOutput()
    
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
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LensCell.self, forCellWithReuseIdentifier: "LensCell")
        return collectionView
    }()
    
    public override init(snapAPIToken: String, partnerGroupId: String, frame: CGRect = .zero) {
        super.init(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId, frame: frame)
        setupUI()
        setupLenses()
        setupCaptureOutputs()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Hide default camera button
        cameraView.cameraButton.isHidden = true
        
        // Setup collection view
        addSubview(collectionView)
        addSubview(processingLabel)
        
        // Make sure collection view is on top
        bringSubviewToFront(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        processingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50), // Adjusted bottom margin
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            
            processingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            processingLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Update collection view layout
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 70, height: 70)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        // Add debug background color to check visibility
        collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(collectionView)
    }
    
    private func setupLenses() {
        cameraKit.lenses.repository.addObserver(self, groupID: self.partnerGroupId)
    }
    
    private func setupCaptureOutputs() {
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
    }
    
    private func applyLens(lens: Lens) {
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { [weak self] success in
            if success {
                print("Successfully applied lens: \(lens.id)")
                ZMCKit.updateCurrentLensId(lens.id)
            } else {
                print("Failed to apply lens: \(lens.id)")
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
        
        // Animate the selected cell
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                }
            }
        }
    }
    
    // Add long press gesture for capture
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        // Capture photo when cell is held
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if let cell = collectionView.cellForItem(at: indexPath),
               cell.isHighlighted {
                self?.capturePhoto()
            }
        }
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


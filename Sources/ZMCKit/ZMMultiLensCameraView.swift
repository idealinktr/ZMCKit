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
    private var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Setup collection view with proper layout
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Make sure collection view is on top
        bringSubviewToFront(collectionView)
        
        // Update collection view layout
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 70, height: 70)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    private func setupLenses() {
        cameraKit.lenses.repository.addObserver(self, groupID: self.partnerGroupId)
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
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentLensIndex = indexPath.item
        applyLens(lens: lenses[currentLensIndex])
    }
}

// MARK: - LensRepositoryGroupObserver
@available(iOS 13.0, *)
extension ZMMultiLensCameraView: LensRepositoryGroupObserver {
    public func repository(_ repository: any LensRepository, didUpdateLenses lenses: [any Lens], forGroupID groupID: String) {
        self.lenses = lenses as? [Lens] ?? []
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            
            if !self!.lenses.isEmpty && self!.currentLensIndex == 0 {
                self?.applyLens(lens: self!.lenses[0])
            }
        }
    }
    
    public func repository(_ repository: any LensRepository, didFailToUpdateLensesForGroupID groupID: String, error: (any Error)?) {
        print("Failed to update lenses for group")
    }
} 

//
//  ZMMultiLensCameraVC.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 7.10.2024.
//

import UIKit
@preconcurrency import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

public class ZMMultiLensCameraVC: UIViewController {
    private let snapAPIToken: String
    private let partnerGroupId: String
    private let lensIds: [String]
    private var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100 // Set a reasonable limit
        return cache
    }()
    
    public let captureSession = AVCaptureSession()
    public var cameraKit: CameraKitProtocol!
    public let previewView = PreviewView()
    
    private var currentLensIndex: Int = 0
    private var lenses: [Lens] = []
    
    private let selectedLensLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
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
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let goToProductButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ürüne Git", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()
    
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
        setupCameraKit()
        fetchLenses()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Setup preview view
        view.addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Setup selected lens label
        view.addSubview(selectedLensLabel)
        selectedLensLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedLensLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectedLensLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectedLensLabel.heightAnchor.constraint(equalToConstant: 32),
            selectedLensLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        // Setup collection view with center alignment
        let collectionViewWidth: CGFloat = view.bounds.width * 0.7 // Changed from 0.5 to 0.7
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            collectionView.widthAnchor.constraint(equalToConstant: collectionViewWidth),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Update go to product button position
        view.addSubview(goToProductButton)
        goToProductButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goToProductButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            goToProductButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            goToProductButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Setup close button
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        goToProductButton.addTarget(self, action: #selector(goToProductTapped), for: .touchUpInside)
    }
    
    private func setupCameraKit() {
        do {
            self.cameraKit = Session(
                sessionConfig: SessionConfig(apiToken: self.snapAPIToken),
                lensesConfig: LensesConfig(
                    cacheConfig: CacheConfig(lensContentMaxSize: 150 * 1024 * 1024)
                ), errorHandler: nil
            )
            
            cameraKit.add(output: previewView)
            
            let input = AVSessionInput(session: self.captureSession)
            let arInput = ARSessionInput()
            
            previewView.automaticallyConfiguresTouchHandler = true
            cameraKit.start(input: input, arInput: arInput)
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                input.position = .back
                input.startRunning()
            }
        } catch {
            print("Failed to setup CameraKit: \(error)")
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
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { [weak self] success in
            if success {
                print("Successfully applied lens: \(lens.id)")
                DispatchQueue.main.async {
                    self?.selectedLensLabel.text = "  \(lens.name ?? "Untitled Lens")  "
                }
            } else {
                print("Failed to apply lens: \(lens.id)")
            }
        }
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func goToProductTapped() {
        // Handle product navigation
        print("Go to product tapped")
    }
    
    // Add memory management
    deinit {
        // Clean up resources
        cameraKit.remove(output: previewView)
        captureSession.stopRunning()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension ZMMultiLensCameraVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
extension ZMMultiLensCameraVC: @preconcurrency LensRepositoryGroupObserver {
    public func repository(_ repository: LensRepository, didUpdateLenses lenses: [Lens], forGroupID groupID: String) {
        self.lenses = lenses
        
        // Debug logging
        for lens in lenses {
            print("Lens: \(lens.name)")
            print("Icon URL: \(String(describing: lens.iconUrl))")
            print("Preview URL: \(String(describing: lens.preview.imageUrl))")
            print("Snapcode URL: \(String(describing: lens.snapcodes.imageUrl))")
            print("--------------------")
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
            // Apply first lens when lenses become available
            if !lenses.isEmpty && self.currentLensIndex == 0 {
                self.applyLens(lens: lenses[0])
            }
        }
    }
    
    nonisolated public func repository(_ repository: LensRepository, didFailToUpdateLensesForGroupID groupID: String, error: Error?) {
        print("Failed to load lenses for group: \(groupID), error: \(String(describing: error))")
    }
}

// MARK: - LensCell
private class LensCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 35
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        
        // Add placeholder image or text
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        imageView.image = UIImage(systemName: "camera.filters", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        return imageView
    }()
    
    private var imageCache: NSCache<NSString, UIImage>
    
    override var isSelected: Bool {
        didSet {
            imageView.layer.borderColor = isSelected ? 
                UIColor.systemBlue.cgColor : 
                UIColor.white.withAlphaComponent(0.5).cgColor
            imageView.layer.borderWidth = isSelected ? 4 : 2
            imageView.backgroundColor = isSelected ? 
                UIColor.systemBlue.withAlphaComponent(0.3) : 
                UIColor.white.withAlphaComponent(0.2)
            
            // Add subtle scale animation
            if isSelected {
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        self.imageCache = NSCache()
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with lens: Lens, cache: NSCache<NSString, UIImage>) {
        self.imageCache = cache
        let cacheKey = lens.id // Use String instead of NSString
        
        // Check cache first
        if let cachedImage = cache.object(forKey: cacheKey as NSString) {
            imageView.image = cachedImage
            return
        }
        
        // Try different image URLs in order of preference
        let imageURL = lens.iconUrl ?? lens.preview.imageUrl ?? lens.snapcodes.imageUrl
        
        if let imageURL = imageURL {
            URLSession.shared.dataTask(with: imageURL) { [weak self, cacheKey] data, response, error in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // Convert String to NSString when accessing the cache
                        self?.imageCache.setObject(image, forKey: cacheKey as NSString)
                        self?.imageView.image = image
                    }
                }
            }.resume()
        }
    }
} 

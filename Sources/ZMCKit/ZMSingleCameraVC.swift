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
        
    private let lensIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private let lensNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        return label
    }()
    
    private let showAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hepsini Gör", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
        
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        return indicator
    }()
        
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Add preview view first
        view.addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupCameraKit()
        fetchLens()
        setupUI()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        activityIndicator.startAnimating()
        cameraKit.lenses.repository.addObserver(self,
                                                specificLensID: self.lensId,
                                                inGroupID: self.partnerGroupId)
    }
    
    private func setupUI() {
        view.addSubview(lensIconView)
        view.addSubview(lensNameLabel)
        view.addSubview(showAllButton)
        view.addSubview(closeButton)
        view.addSubview(activityIndicator)
        
        lensIconView.translatesAutoresizingMaskIntoConstraints = false
        lensNameLabel.translatesAutoresizingMaskIntoConstraints = false
        showAllButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lensNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            lensNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lensNameLabel.heightAnchor.constraint(equalToConstant: 32),
            
            lensIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lensIconView.bottomAnchor.constraint(equalTo: showAllButton.topAnchor, constant: -20),
            lensIconView.widthAnchor.constraint(equalToConstant: 70),
            lensIconView.heightAnchor.constraint(equalToConstant: 70),
            
            showAllButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            showAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showAllButton.heightAnchor.constraint(equalToConstant: 40),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        showAllButton.addTarget(self, action: #selector(showAllLenses), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    @objc private func showAllLenses() {
        let multiLensVC = ZMMultiLensCameraVC(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId)
        multiLensVC.modalPresentationStyle = .fullScreen
        present(multiLensVC, animated: true)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    private func applyLens(lens: Lens) {
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { [weak self] success in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                if success {
                    self?.lensNameLabel.text = "  \(lens.name ?? "Untitled Lens")  "
                    if let iconURL = lens.iconUrl ?? lens.preview.imageUrl ?? lens.snapcodes.imageUrl {
                        URLSession.shared.dataTask(with: iconURL) { data, _, _ in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self?.lensIconView.image = image
                                }
                            }
                        }.resume()
                    }
                }
            }
        }
    }
    
    deinit {
        cameraKit.remove(output: previewView)
        captureSession.stopRunning()
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

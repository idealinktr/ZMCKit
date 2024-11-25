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
        imageView.layer.cornerRadius = 25
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
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
        view = previewView
        setupCameraKit()
        fetchLens()
        setupUI()
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
    
    private func setupUI() {
        view.addSubview(lensIconView)
        view.addSubview(lensNameLabel)
        view.addSubview(showAllButton)
        
        lensIconView.translatesAutoresizingMaskIntoConstraints = false
        lensNameLabel.translatesAutoresizingMaskIntoConstraints = false
        showAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lensIconView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            lensIconView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lensIconView.widthAnchor.constraint(equalToConstant: 50),
            lensIconView.heightAnchor.constraint(equalToConstant: 50),
            
            lensNameLabel.centerYAnchor.constraint(equalTo: lensIconView.centerYAnchor),
            lensNameLabel.leadingAnchor.constraint(equalTo: lensIconView.trailingAnchor, constant: 12),
            lensNameLabel.heightAnchor.constraint(equalToConstant: 32),
            
            showAllButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            showAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showAllButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        showAllButton.addTarget(self, action: #selector(showAllLenses), for: .touchUpInside)
    }
    
    @objc private func showAllLenses() {
        let multiLensVC = ZMMultiLensCameraVC(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId)
        multiLensVC.modalPresentationStyle = .fullScreen
        present(multiLensVC, animated: true)
    }
    
    private func applyLens(lens: Lens) {
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { [weak self] success in
            if success {
                DispatchQueue.main.async {
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

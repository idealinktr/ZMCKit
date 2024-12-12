//
//  ZMSingleCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 26.11.2024.
//

import UIKit
import SCSDKCameraKit
import SCSDKCameraKitReferenceUI
import AVFoundation
import ReplayKit

@available(iOS 13.0, *)
public class ZMSingleCameraView: ZMCameraView {
    private let lensId: String
    private let bundleIdentifier: String
    private let photoOutput = AVCapturePhotoOutput()
    private let movieOutput = AVCaptureMovieFileOutput()
    private var isRecording = false
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        button.backgroundColor = .white
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.gray.cgColor
        return button
    }()
    
    private var assetWriter: AVAssetWriter?
    private var assetWriterInput: AVAssetWriterInput?
    private var recordingURL: URL?
    
    private lazy var processingLabel: UILabel = {
        let label = UILabel()
        label.text = "Lütfen Bekleyiniz..."
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    public init(snapAPIToken: String,
                partnerGroupId: String,
                lensId: String,
                bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "",
                frame: CGRect = .zero) {
        self.lensId = lensId
        self.bundleIdentifier = bundleIdentifier
        super.init(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId, frame: frame)
        setupLens()
        setupCustomCameraButton()
        setupCaptureOutputs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLens() {
        cameraView.carouselView.isHidden = true
        cameraKit.lenses.repository.addObserver(self,
                                              specificLensID: self.lensId,
                                              inGroupID: self.partnerGroupId)
    }
    
    private func setupCaptureOutputs() {
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
    }
    
    private func setupCustomCameraButton() {
        // Hide default camera button
        cameraView.cameraButton.isHidden = true
        
        // Add custom button
        addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            cameraButton.widthAnchor.constraint(equalToConstant: 70),
            cameraButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // Add tap gesture
        cameraButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        // Add long press gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.5
        cameraButton.addGestureRecognizer(longPress)
        
        // Add processing label
        addSubview(processingLabel)
        processingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            processingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            processingLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
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
    
    @objc private func handleTap() {
        // Add tap animation
        UIView.animate(withDuration: 0.1, animations: {
            self.cameraButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.cameraButton.transform = .identity
            }
        }
        
        showProcessing()
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            // Start recording animation
            UIView.animate(withDuration: 0.2) {
                self.cameraButton.backgroundColor = .red
                self.cameraButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            startRecordingWithLens()
            
        case .ended, .cancelled:
            // End recording animation
            UIView.animate(withDuration: 0.2) {
                self.cameraButton.backgroundColor = .white
                self.cameraButton.transform = .identity
            }
            stopRecordingWithLens()
            
        default:
            break
        }
    }
    
    private func startRecordingWithLens() {
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("recording_\(Date().timeIntervalSince1970).mp4")
        recordingURL = outputURL
        
        do {
            assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
            
            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: previewView.bounds.width,
                AVVideoHeightKey: previewView.bounds.height
            ]
            
            assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            assetWriterInput?.expectsMediaDataInRealTime = true
            
            if let assetWriter = assetWriter, let assetWriterInput = assetWriterInput {
                assetWriter.add(assetWriterInput)
                assetWriter.startWriting()
                assetWriter.startSession(atSourceTime: .zero)
            }
            
            let recorder = RPScreenRecorder.shared()
            recorder.isMicrophoneEnabled = false // Set to true if you want audio
            
            recorder.startCapture(handler: { [weak self] (sampleBuffer, bufferType, error) in
                guard let self = self,
                      error == nil,
                      bufferType == .video,
                      let input = self.assetWriterInput,
                      input.isReadyForMoreMediaData else { return }
                
                input.append(sampleBuffer)
                
            }) { [weak self] error in
                if let error = error {
                    print("Failed to start recording: \(error)")
                    self?.isRecording = false
                    return
                }
                self?.isRecording = true
            }
            
        } catch {
            print("Failed to setup recording: \(error)")
        }
    }
    
    private func stopRecordingWithLens() {
        guard isRecording else { return }
        isRecording = false
        
        showProcessing()
        
        RPScreenRecorder.shared().stopCapture { [weak self] error in
            if let error = error {
                print("Failed to stop recording: \(error)")
                self?.hideProcessing()
                return
            }
            
            self?.assetWriterInput?.markAsFinished()
            self?.assetWriter?.finishWriting { [weak self] in
                guard let self = self,
                      let outputURL = self.recordingURL else { return }
                
                DispatchQueue.main.async {
                    if let viewController = self.findViewController() {
                        let previewVC = ZMCapturePreviewViewController(videoURL: outputURL)
                        previewVC.modalPresentationStyle = .fullScreen
                        viewController.present(previewVC, animated: true) {
                            self.hideProcessing()
                        }
                    }
                }
                
                // Clean up
                self.assetWriter = nil
                self.assetWriterInput = nil
                self.recordingURL = nil
            }
        }
    }
    
    override public func cleanup() {
        if isRecording {
            stopRecordingWithLens()
        }
        captureSession.removeOutput(photoOutput)
        captureSession.removeOutput(movieOutput)
        super.cleanup()
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}

@available(iOS 13.0, *)
extension ZMSingleCameraView: LensRepositorySpecificObserver {
    public func repository(_ repository: any LensRepository, didUpdate lens: any Lens, forGroupID groupID: String) {
        cameraKit.lenses.processor?.apply(lens: lens, launchData: nil) { [weak self] success in
            if success {
                print("Successfully applied lens: \(lens.id)")
                ZMCKit.updateCurrentLensId(lens.id)
            } else {
                print("Failed to apply lens: \(lens.id)")
            }
        }
    }
    
    public func repository(_ repository: any LensRepository, didFailToUpdateLensID lensID: String, forGroupID groupID: String, error: (any Error)?) {
        print("Did fail to update lens")
    }
}

// MARK: - Photo Capture Delegate
@available(iOS 13.0, *)
extension ZMSingleCameraView: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Render the view hierarchy including lens effects but without camera button
            let renderer = UIGraphicsImageRenderer(bounds: self.previewView.bounds)
            let image = renderer.image { ctx in
                self.previewView.drawHierarchy(in: self.previewView.bounds, afterScreenUpdates: true)
            }
            
            // Present preview
            if let viewController = self.findViewController() {
                let previewVC = ZMCapturePreviewViewController(image: image)
                previewVC.modalPresentationStyle = .fullScreen
                viewController.present(previewVC, animated: true) {
                    self.hideProcessing()
                }
            }
        }
    }
}

// MARK: - Video Recording Delegate
@available(iOS 13.0, *)
extension ZMSingleCameraView: AVCaptureFileOutputRecordingDelegate {
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Failed to record video: \(error)")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.showProcessing()
            
            // Present preview
            if let viewController = self.findViewController() {
                let previewVC = ZMCapturePreviewViewController(videoURL: outputFileURL)
                previewVC.modalPresentationStyle = .fullScreen
                viewController.present(previewVC, animated: true) {
                    self.hideProcessing()
                }
            }
        }
    }
}

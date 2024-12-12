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
    }
    
    @objc private func handleTap() {
        // Hide button before capture
        cameraButton.isHidden = true
        
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            startRecording()
        case .ended, .cancelled:
            stopRecording()
        default:
            break
        }
    }
    
    private func startRecording() {
        guard !isRecording else { return }
        
        // Hide button before recording
        cameraButton.isHidden = true
        
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("recording_\(Date().timeIntervalSince1970).mp4")
        
        movieOutput.startRecording(to: outputURL, recordingDelegate: self)
        isRecording = true
    }
    
    private func stopRecording() {
        guard isRecording else { return }
        
        movieOutput.stopRecording()
        isRecording = false
        
        // Show button after recording stops
        cameraButton.isHidden = false
    }
    
    override public func cleanup() {
        if isRecording {
            stopRecording()
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
            
            let renderer = UIGraphicsImageRenderer(bounds: self.previewView.bounds)
            let image = renderer.image { ctx in
                self.previewView.drawHierarchy(in: self.previewView.bounds, afterScreenUpdates: true)
            }
            
            // Show camera button again
            self.cameraButton.isHidden = false
            
            // Present preview
            if let viewController = self.findViewController() {
                let previewVC = ZMCapturePreviewViewController(image: image)
                previewVC.modalPresentationStyle = .fullScreen
                viewController.present(previewVC, animated: true)
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
        
        // Create a video writer
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let videoURL = documentsPath.appendingPathComponent("screen_recording_\(Date().timeIntervalSince1970).mp4")
        
        guard let videoWriter = try? AVAssetWriter(outputURL: videoURL, fileType: .mp4) else {
            print("Failed to create video writer")
            return
        }
        
        // Configure video settings
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: previewView.bounds.width,
            AVVideoHeightKey: previewView.bounds.height
        ]
        
        let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoWriter.add(videoWriterInput)
        
        // Start screen recording
        let recorder = RPScreenRecorder.shared()
        recorder.startCapture(handler: { [weak self] (sampleBuffer, bufferType, error) in
            guard error == nil else {
                print("Failed to capture: \(error!)")
                return
            }
            
            switch bufferType {
            case .video:
                if videoWriter.status == .unknown {
                    videoWriter.startWriting()
                    videoWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                }
                
                if videoWriterInput.isReadyForMoreMediaData {
                    videoWriterInput.append(sampleBuffer)
                }
            default:
                break
            }
            
        }) { [weak self] error in
            if let error = error {
                print("Failed to start capture: \(error)")
                return
            }
            
            // Stop recording after a delay (e.g., 5 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                recorder.stopCapture { error in
                    if let error = error {
                        print("Failed to stop capture: \(error)")
                        return
                    }
                    
                    videoWriterInput.markAsFinished()
                    videoWriter.finishWriting {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            
                            // Show camera button again
                            self.cameraButton.isHidden = false
                            
                            // Present preview
                            if let viewController = self.findViewController() {
                                let previewVC = ZMCapturePreviewViewController(videoURL: videoURL)
                                previewVC.modalPresentationStyle = .fullScreen
                                viewController.present(previewVC, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

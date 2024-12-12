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
    private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    
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
        // Add tap animation
        UIView.animate(withDuration: 0.1, animations: {
            self.cameraButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.cameraButton.transform = .identity
            }
        }
        
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
            
            let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("recording_\(Date().timeIntervalSince1970).mp4")
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
        case .ended, .cancelled:
            // End recording animation
            UIView.animate(withDuration: 0.2) {
                self.cameraButton.backgroundColor = .white
                self.cameraButton.transform = .identity
            }
            movieOutput.stopRecording()
            
        default:
            break
        }
    }
    
    private func startRecording() {
        guard !isRecording else { return }
        
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("recording_\(Date().timeIntervalSince1970).mp4")
        
        do {
            assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
            
            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: previewView.bounds.width,
                AVVideoHeightKey: previewView.bounds.height
            ]
            
            assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            assetWriterInput?.expectsMediaDataInRealTime = true
            
            // Create pixel buffer adaptor
            let sourcePixelBufferAttributes: [String: Any] = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
                kCVPixelBufferWidthKey as String: previewView.bounds.width,
                kCVPixelBufferHeightKey as String: previewView.bounds.height
            ]
            
            pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
                assetWriterInput: assetWriterInput!,
                sourcePixelBufferAttributes: sourcePixelBufferAttributes
            )
            
            if let assetWriter = assetWriter, let assetWriterInput = assetWriterInput {
                assetWriter.add(assetWriterInput)
                assetWriter.startWriting()
                assetWriter.startSession(atSourceTime: CMTime.zero)
                isRecording = true
                
                // Start capturing frames
                captureFrames()
            }
        } catch {
            print("Failed to create asset writer: \(error)")
        }
    }
    
    private var frameCount: Int64 = 0
    private var displayLink: CADisplayLink?
    
    private func captureFrames() {
        displayLink = CADisplayLink(target: self, selector: #selector(captureFrame))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func captureFrame() {
        guard isRecording,
              let adaptor = pixelBufferAdaptor,
              let assetWriterInput = assetWriterInput,
              assetWriterInput.isReadyForMoreMediaData else { return }
        
        let renderer = UIGraphicsImageRenderer(bounds: previewView.bounds)
        let image = renderer.image { ctx in
            previewView.drawHierarchy(in: previewView.bounds, afterScreenUpdates: true)
        }
        
        if let pixelBuffer = image.pixelBuffer() {
            // Use frame count for timing (assuming 60fps)
            let frameTime = CMTime(value: frameCount, timescale: 60)
            adaptor.append(pixelBuffer, withPresentationTime: frameTime)
            frameCount += 1
        }
    }
    
    private func stopRecording() {
        guard isRecording else { return }
        
        isRecording = false
        displayLink?.invalidate()
        displayLink = nil
        frameCount = 0
        
        assetWriterInput?.markAsFinished()
        
        assetWriter?.finishWriting { [weak self] in
            DispatchQueue.main.async {
                if let outputURL = self?.assetWriter?.outputURL {
                    if let viewController = self?.findViewController() {
                        let previewVC = ZMCapturePreviewViewController(videoURL: outputURL)
                        previewVC.modalPresentationStyle = .fullScreen
                        viewController.present(previewVC, animated: true)
                    }
                }
                
                // Clean up
                self?.assetWriter = nil
                self?.assetWriterInput = nil
                self?.pixelBufferAdaptor = nil
            }
        }
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
            
            // Render the view hierarchy including lens effects but without camera button
            let renderer = UIGraphicsImageRenderer(bounds: self.previewView.bounds)
            let image = renderer.image { ctx in
                self.previewView.drawHierarchy(in: self.previewView.bounds, afterScreenUpdates: true)
            }
            
            // Show camera button
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
        
        // Create an asset writer for the final video with lens effects
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let finalVideoURL = documentsPath.appendingPathComponent("final_recording_\(Date().timeIntervalSince1970).mp4")
        
        guard let assetWriter = try? AVAssetWriter(outputURL: finalVideoURL, fileType: .mp4) else {
            print("Failed to create asset writer")
            return
        }
        
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: previewView.bounds.width,
            AVVideoHeightKey: previewView.bounds.height
        ]
        
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        assetWriter.add(writerInput)
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: .zero)
        
        // Read frames from preview view and write to new video
        let displayLink = CADisplayLink(target: self, selector: #selector(captureVideoFrame))
        displayLink.add(to: .main, forMode: .common)
        
        // Stop recording after original video duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {  // Adjust duration as needed
            displayLink.invalidate()
            writerInput.markAsFinished()
            assetWriter.finishWriting { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if let viewController = self.findViewController() {
                        let previewVC = ZMCapturePreviewViewController(videoURL: finalVideoURL)
                        previewVC.modalPresentationStyle = .fullScreen
                        viewController.present(previewVC, animated: true)
                    }
                }
            }
        }
    }
    
    @objc private func captureVideoFrame() {
        let renderer = UIGraphicsImageRenderer(bounds: previewView.bounds)
        let image = renderer.image { ctx in
            previewView.drawHierarchy(in: previewView.bounds, afterScreenUpdates: true)
        }
        // Convert image to video frame and write to asset writer
    }
}

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

@available(iOS 13.0, *)
public class ZMSingleCameraView: ZMCameraView {
    private let lensId: String
    private let bundleIdentifier: String
    private let photoOutput = AVCapturePhotoOutput()
    private var videoOutput: AVCaptureMovieFileOutput?
    
    public init(snapAPIToken: String,
                partnerGroupId: String,
                lensId: String,
                bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "",
                frame: CGRect = .zero) {
        self.lensId = lensId
        self.bundleIdentifier = bundleIdentifier
        super.init(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId, frame: frame)
        setupLens()
        setupCapture()
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
    
    private func setupCapture() {
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.addOutput(photoOutput)
        
        let videoOutput = AVCaptureMovieFileOutput()
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
            self.videoOutput = videoOutput
        }
        
        // Setup camera button
        cameraView.cameraButton.isHidden = false
        cameraView.cameraButton.delegate = self
    }
    
    private func createVideoURL() -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent("recording_\(Date().timeIntervalSince1970).mp4")
    }
    
    override public func cleanup() {
        if let videoOutput = videoOutput {
            captureSession.removeOutput(videoOutput)
        }
        captureSession.removeOutput(photoOutput)
        super.cleanup()
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

// MARK: - Camera Button Delegate
@available(iOS 13.0, *)
extension ZMSingleCameraView: CameraButtonDelegate {
    public func cameraButtonTapped(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    public func cameraButtonHoldBegan(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
        cameraButton.startRecordingAnimation()
        let outputURL = createVideoURL()
        videoOutput?.startRecording(to: outputURL, recordingDelegate: self)
    }
    
    public func cameraButtonHoldCancelled(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
        cameraButton.stopRecordingAnimation()
        videoOutput?.stopRecording()
    }
    
    public func cameraButtonHoldEnded(_ cameraButton: SCSDKCameraKitReferenceUI.CameraButton) {
        cameraButton.stopRecordingAnimation()
        videoOutput?.stopRecording()
    }
}

// MARK: - Photo Capture Delegate
@available(iOS 13.0, *)
extension ZMSingleCameraView: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Failed to capture photo")
            return
        }
        delegate?.cameraDidCapture(image: image)
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
        delegate?.cameraDidFinishRecording(videoURL: outputFileURL)
    }
}

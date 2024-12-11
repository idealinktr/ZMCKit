//
//  ZMCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 26.11.2024.
//


import UIKit
import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

@available(iOS 13.0, *)
public class ZMCameraView: UIView {
    internal let snapAPIToken: String
    internal let partnerGroupId: String
    
    public let captureSession = AVCaptureSession()
    public var cameraKit: CameraKitProtocol!
    
    public let previewView = PreviewView()
    public let cameraView = CameraView()
    
    private var videoRecorder: Recorder?
    private var isRecording = false
    private var recordingURL: URL?
    
    public init(snapAPIToken: String, partnerGroupId: String, frame: CGRect = .zero) {
        self.snapAPIToken = snapAPIToken
        self.partnerGroupId = partnerGroupId
        super.init(frame: frame)
        setupBaseCamera()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupBaseCamera() {
        cameraKit = Session(
            sessionConfig: SessionConfig(apiToken: snapAPIToken),
            lensesConfig: LensesConfig(
                cacheConfig: CacheConfig(lensContentMaxSize: 150 * 1024 * 1024)
            ),
            errorHandler: nil
        )
        
        addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: topAnchor),
            previewView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        cameraKit.add(output: previewView)
        
        let input = AVSessionInput(session: captureSession)
        let arInput = ARSessionInput()
        
        previewView.automaticallyConfiguresTouchHandler = true
        cameraKit.start(input: input, arInput: arInput)
        
        Task { @MainActor in
            await startCamera(input)
        }
    }

    private func startCamera(_ input: AVSessionInput) async {
        input.position = .back
        input.startRunning()
    }

    public func startRecording() {
        guard !isRecording else { return }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let videoURL = documentsPath.appendingPathComponent("recording_\(Date().timeIntervalSince1970).mp4")
        
        do {
            let recorder = try Recorder(
                url: videoURL,
                orientation: previewView.videoOrientation,
                size: previewView.bounds.size
            )
            
            cameraKit.add(output: recorder.output)
            
            recorder.startRecording()
            
            self.videoRecorder = recorder
            self.recordingURL = videoURL
            self.isRecording = true
            
        } catch {
            print("Failed to start recording: \(error)")
        }
    }
    
    public func stopRecording(completion: @escaping (URL?) -> Void) {
        guard isRecording, let recorder = videoRecorder else {
            completion(nil)
            return
        }
        
        recorder.finishRecording { [weak self] url, error in
            guard let self = self else { return }
            
            if let output = self.videoRecorder?.output {
                self.cameraKit.remove(output: output)
            }
            
            self.videoRecorder = nil
            self.isRecording = false
            
            if let error = error {
                print("Failed to finish recording: \(error)")
                completion(nil)
            } else {
                completion(url)
            }
        }
    }

    public func cleanup() {
        if isRecording {
            stopRecording { _ in }
        }
        cameraKit.remove(output: previewView)
        captureSession.stopRunning()
    }

    public override func removeFromSuperview() {
        cleanup()
        super.removeFromSuperview()
    }
} 

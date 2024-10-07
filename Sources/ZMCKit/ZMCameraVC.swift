//
//  ZMCameraVC.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 7.10.2024.
//import Foundation
import SCSDKCreativeKit
import SCSDKCameraKit
import SCSDKCameraKitReferenceUI
import UIKit

public class ZMCameraVC: UIViewController, @preconcurrency SnapchatDelegate {
    
    private let snapAPI = SCSDKSnapAPI()
    private let snapAPIToken: String
    private let partnerGroupId: String
    
    public init(snapAPIToken: String, partnerGroupId: String) {
        self.snapAPIToken = snapAPIToken
        self.partnerGroupId = partnerGroupId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          startExperience()
      }
    
    private func startExperience() {
        let cameraController = CameraController(sessionConfig: SessionConfig(apiToken: snapAPIToken))
        
        cameraController.groupIDs = [SCCameraKitLensRepositoryBundledGroup, partnerGroupId]
        cameraController.snapchatDelegate = self
        let cameraViewController = CameraViewController(cameraController: cameraController)
        
        self.present(cameraViewController, animated: true, completion: nil)
    }
    
    public func cameraKitViewController(_ viewController: UIViewController, openSnapchat screen: SnapchatScreen) {
        switch screen {
        case .profile, .lens(_):
            break
        case .photo(let image):
            let photo = SCSDKSnapPhoto(image: image)
            let content = SCSDKPhotoSnapContent(snapPhoto: photo)
            sendSnapContent(content, viewController: viewController)
        case .video(let url):
            let video = SCSDKSnapVideo(videoUrl: url)
            let content = SCSDKVideoSnapContent(snapVideo: video)
            sendSnapContent(content, viewController: viewController)
        @unknown default:
            break
        }
    }

    private func sendSnapContent(_ content: SCSDKSnapContent, viewController: UIViewController) {
        viewController.view.isUserInteractionEnabled = false
        snapAPI.startSending(content) { error in
            DispatchQueue.main.async {
                viewController.view.isUserInteractionEnabled = true
            }
            if let error = error {
                print("Failed to send content to Snapchat with error: \(error.localizedDescription)")
                return
            }
        }
    }
}

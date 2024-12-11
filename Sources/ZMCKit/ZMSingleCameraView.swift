//
//  ZMSingleCameraView.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 26.11.2024.
//

import UIKit
import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

@available(iOS 13.0, *)
public class ZMSingleCameraView: ZMCameraView {
    private let lensId: String
    private let bundleIdentifier: String
    
    public init(snapAPIToken: String,
                partnerGroupId: String,
                lensId: String,
                bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "",
                frame: CGRect = .zero) {
        self.lensId = lensId
        self.bundleIdentifier = bundleIdentifier
        super.init(snapAPIToken: snapAPIToken, partnerGroupId: partnerGroupId, frame: frame)
        setupLens()
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

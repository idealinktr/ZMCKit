//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AgreementSet)
/// Protocol to interface with agreements by CameraKit
/// This interface should not be used directly.
@protocol SCCameraKitAgreementSet <NSObject>

/// A URL to the terms of service agreement for CameraKit.
@property (strong, nonatomic, readonly) NSURL *termsOfServiceURL;
/// A URL to the privacy policy for CameraKit.
@property (strong, nonatomic, readonly) NSURL *privacyPolicyURL;
/// A URL to the learn more page for CameraKit.
@property (strong, nonatomic, readonly) NSURL *learnMoreURL;

@end

NS_ASSUME_NONNULL_END

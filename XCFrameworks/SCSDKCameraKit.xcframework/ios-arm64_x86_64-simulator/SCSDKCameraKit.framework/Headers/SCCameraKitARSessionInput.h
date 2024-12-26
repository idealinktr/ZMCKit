//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitARInput.h>

#import <Foundation/Foundation.h>

@class ARSession;
@class ARConfiguration;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ARSessionInput)
/// ARSessionInput is a CameraKit provided wrapper for ARSession.
@interface SCCameraKitARSessionInput : NSObject <SCCameraKitARInput>

/// Create an AR Session input.
/// Inits with a managed ARSession
- (instancetype)init;

/// Create an AR Session input with a preexisting session.
/// @param session the ARSession to use.
/// @note the input will overwrite the preexisting settings for delegate and delegateQueue
- (instancetype)initWithSession:(ARSession *)session;

/// Create an AR Session input with a preexisting session.
/// @param session the ARSession to use.
/// @param frontCameraConfiguration The ARConfiguration to use when using the front
/// @note the input will overwrite the preexisting settings for delegate and delegateQueue
/// @warning if your app supports lenses with true sizing, you MUST set this to be an instance of
/// ARFaceTrackingConfiguration (additionally, we recommend setting the number of tracked faces to 0)
/// @warning using an instance of ARFaceTrackingConfiguration in this method will subject your app to additional app
/// review, concerning your usage of the TrueDepth camera.
- (instancetype)initWithSession:(ARSession *)session
       frontCameraConfiguration:(nullable ARConfiguration *)frontCameraConfiguration;

@end

NS_ASSUME_NONNULL_END

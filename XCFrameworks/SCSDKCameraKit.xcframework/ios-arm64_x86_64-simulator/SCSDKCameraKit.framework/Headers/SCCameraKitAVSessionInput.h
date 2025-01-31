//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitInput.h>

#import <Foundation/Foundation.h>

@class AVCaptureSession;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AVSessionInput)
/// AVSessionInput is a CameraKit provided wrapper for AVCaptureSession. It may make adjustments to things like color
/// formats in order to process frames. You are still responsible for doing the general configuration of the capture
/// session, such as adding devices.
@interface SCCameraKitAVSessionInput : NSObject <SCCameraKitInput>

/// Describes whether the current video frames are mirrored
@property (nonatomic, assign) BOOL videoMirrored;

/// Describes whether it should automatically configure outputted video frames to be mirrored.
/// If set to YES - it will update the `videoMirrored` property based on input device position (front is mirrored, back
/// is not)
/// @note By default this property is set to YES, you can change it while the session is running and it will update the
/// future video frames
/// @note If you change this property to NO, make sure you also change `videoMirrored` property as well
/// @see `videoMirrored`
@property (nonatomic, assign) BOOL automaticallyConfiguresVideoMirrored;

/// Determines whether or not this input will capture audio and pass audio buffer data to CameraKit.
/// If YES then it will automatically configure a capture session, audio input device, etc. and start capturing data.
/// If NO then no audio data will be captured.
@property (nonatomic, assign) BOOL audioEnabled;

/// Create an AV Session input.
/// @param session the AVCaptureSession to use.
- (instancetype)initWithSession:(AVCaptureSession *)session;

/// Create an AV Session input.
/// @param session The AVCaptureSession to use.
/// @param audioEnabled Determines whether or not this input will capture audio and pass audio buffer data to CameraKit.
/// Default is YES.
- (instancetype)initWithSession:(AVCaptureSession *)session audioEnabled:(BOOL)audioEnabled;

@end

NS_ASSUME_NONNULL_END

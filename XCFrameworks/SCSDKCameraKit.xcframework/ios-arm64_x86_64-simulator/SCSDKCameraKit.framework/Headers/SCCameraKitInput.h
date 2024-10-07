//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCCameraKitInput;

NS_SWIFT_NAME(InputDestination)
/// The  input destination is an intermediary for frame data.
@protocol SCCameraKitInputDestination

/// Pass new video frame data into CameraKit. Call this every time your input generates new video frames.
/// @param input the input providing data.
/// @param sampleBuffer a sample buffer containing new video frame data.
- (void)input:(id<SCCameraKitInput>)input receivedVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/// Pass new audio frame data into CameraKit. Call this every time your input generates new audio frames.
/// @param input the input providing data.
/// @param sampleBuffer a sample buffer containing new audio frame data.
- (void)input:(id<SCCameraKitInput>)input receivedAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/// Indicates that the input has changed some attribute and that CameraKit should reconfigure itself accordingly.
/// @param input the input that changed.
- (void)inputChangedAttributes:(id<SCCameraKitInput>)input;

@end

NS_SWIFT_NAME(Input)
/// Describes a source of frames for CameraKit. Can be a camera, file, etc.
@protocol SCCameraKitInput

/// The intermediate destination for frame data. See the protocol definition for more details.
/// This property should _NOT_ be set directly. CameraKit will assign this as appropriate.
@property (nonatomic, weak) id<SCCameraKitInputDestination> destination;

/// The horizontal field of view for the input.
@property (nonatomic, assign, readonly) CGFloat horizontalFieldOfView;

/// The size for input frame
@property (nonatomic, assign, readonly) CGSize frameSize;

/// The orientation of frame data for the input.
@property (nonatomic, assign, readonly) AVCaptureVideoOrientation frameOrientation;

/// The camera position that the frames are sourced from.
@property (nonatomic, assign) AVCaptureDevicePosition position;

/// Whether or not the session is currently running.
@property (nonatomic, assign, readonly) BOOL isRunning;

/// Indiciates that the input should begin running if it is not currently. If the input is aleady running, this should
/// be a noop.
/// @warning: This method is SYNCHRONOUS and should not be called on the main thread.
- (void)startRunning;

/// Indiciates that the input should MUST stop running if it currently is running. If the input is not already running,
/// this should be a noop.
/// @warning: This method is SYNCHRONOUS and should not be called on the main thread.
- (void)stopRunning;

/// Set the orientation for the outputted video buffers
/// @param videoOrientation orientation for the outputted video buffers
/// @note this may be different than the actual frame data orientation
/// since inputs may map frame data orientation to video orientation differently
- (void)setVideoOrientation:(AVCaptureVideoOrientation)videoOrientation;

/// Determines whether or not this input will capture audio and pass audio buffer data to CameraKit.
/// If YES then it will automatically configure a capture session, audio input device, etc. and start capturing data.
/// If NO then no audio data will be captured.
@optional
@property (nonatomic, assign, readonly) BOOL audioEnabled;

@end

NS_ASSUME_NONNULL_END

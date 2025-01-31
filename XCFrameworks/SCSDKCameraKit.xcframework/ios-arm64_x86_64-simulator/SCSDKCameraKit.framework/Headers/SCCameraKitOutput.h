//#!announcer.rb
//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>

@protocol SCCameraKitProtocol;
@protocol SCCameraKitTexture;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Output)
/// Allows conformers to be notified of new frame data from CameraKit.
@protocol SCCameraKitOutput <NSObject>

/// Notifies that a new frame is available.
/// @param cameraKit the CameraKit responsible for the frame.
/// @param texture a texture describing processed input. SCCameraKitPreviewView is able to render this, and future
/// classes will be provided for additional functionality (eg, video recording).
/// @warning DO NOT stop or start CameraKit in this output method. This method doesn't guarantee that CamearKit has
/// finished processing the current frame, so stopping or starting in this method is undefined behavior, which can lead
/// to other outputs getting invalid textures that may crash when drawing the frame or deadlocking the current thread.
- (void)cameraKit:(id<SCCameraKitProtocol>)cameraKit didOutputTexture:(id<SCCameraKitTexture>)texture;

/// Notifies that a new video frame is available.
/// @param cameraKit the CameraKit responsible for the frame.
/// @param sampleBuffer a CMSampleBuffer describing the video output.
/// @note This method _WILL NOT BE CALLED_ unless you have indicated you need sample buffer output (for situations like
/// recording). This incurs performance overhead, so do not use it unless you require it.
/// @see SCCameraKitOutputRequiringPixelBuffer
/// @warning DO NOT stop or start CameraKit in this output method. This method doesn't guarantee that CamearKit has
/// finished processing the current frame, so stopping or starting in this method is undefined behavior, which can lead
/// to other outputs getting invalid/released video buffers or deadlocking the current thread.
- (void)cameraKit:(id<SCCameraKitProtocol>)cameraKit didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/// Notifies that a new audio buffer is available
/// @param cameraKit the CameraKit responsible for the audio buffer
/// @param sampleBuffer a CMSampleBuffer describing the audio output
/// @warning DO NOT stop or start CameraKit in this output method. This method doesn't guarantee that CamearKit has
/// finished processing the current frame, so stopping or starting in this method is undefined behavior, which can lead
/// to other outputs getting invalid/released audio buffers or deadlocking the current thread.
- (void)cameraKit:(id<SCCameraKitProtocol>)cameraKit didOutputAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

NS_ASSUME_NONNULL_END

@end

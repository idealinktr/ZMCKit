//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitOutput.h>
#import <SCSDKCameraKit/SCCameraKitOutputRequiringPixelBuffer.h>

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AVWriterOutput)
/// AVWriterOutput is a CameraKit provided wrapper for AVAssetWriter. You are still responsible for the configuration of
/// the writer.
@interface SCCameraKitAVWriterOutput : NSObject <SCCameraKitOutput, SCCameraKitOutputRequiringPixelBuffer>

/// Date and time of first video buffer recorded (ie. start recording time)
@property (nonatomic, strong, readonly, nullable) NSDate *startDate;

/// Create an AVWriterOutput
/// @param assetWriter the configured AVAssetWRiter
/// @param pixelBufferInput the configured AVAssetWriterInputPixelBufferAdaptor to write video to.
/// @param audioInput the configured AVAssetWriterInput to write audio to. May be nullable if the video does not contain
/// audio.
/// @note: audioInput is currently unused. This will change in a future build.
- (instancetype)initWithAVAssetWriter:(AVAssetWriter *)assetWriter
                     pixelBufferInput:(AVAssetWriterInputPixelBufferAdaptor *)pixelBufferInput
                           audioInput:(nullable AVAssetWriterInput *)audioInput;

/// Use designated init or convenience init to pass in required writer and inputs
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// Call this after you start recording on the AVAssetWriter. This will indicate that the output should start recording
/// data it receives from CameraKit.
/// @note DO NOT call `startSession` on the asset writer, this output class will do so when it receives the first video
/// frame. This is to ensure that there are no empty frames from the time the session is started and the first video
/// buffer is written
- (void)startRecording;

/// Call this before you stop recording on the AVAssetWriter. This will cause the output to stop recording data from
/// CameraKit.
/// @note DO NOT call `endSession` on the asset writer, this output class will do so with the timestamp of the last
/// video frame This is to ensure that there are no empty frames from the time the last video buffer is written to the
/// end of the session
- (void)stopRecording;

@end

NS_ASSUME_NONNULL_END

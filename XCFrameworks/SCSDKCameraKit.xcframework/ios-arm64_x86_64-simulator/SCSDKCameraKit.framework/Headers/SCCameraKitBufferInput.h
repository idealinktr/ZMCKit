//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitInput.h>

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(BufferInput)
/// `BufferInput` is a Camera Kit provided input that uses a single pre-allocated black pixel buffer as a source for
/// generating sample buffers at a configurable frame rate.
@interface SCCameraKitBufferInput : NSObject <SCCameraKitInput>

/// Creates a `BufferInput` instance.
/// - Parameters:
///   - frameSize: The resolution of the generated frames (e.g., 1920x1080).
///   - framesPerSecond: The number of frames to emit per second (e.g., 60).
- (instancetype)initWithFrameSize:(CGSize)frameSize
                  framesPerSecond:(NSInteger)framesPerSecond NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// The horizontal field of view for the input. Default is 70.0f.
@property (nonatomic, assign) CGFloat horizontalFieldOfView;

@end

NS_ASSUME_NONNULL_END

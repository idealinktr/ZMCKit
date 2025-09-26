//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitInput.h>

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class UIImage;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(StaticImageInput)
/// `StaticImageInput` is a Camera Kit provided input that uses a single static image as a source for generating sample buffers.
@interface SCCameraKitStaticImageInput : NSObject <SCCameraKitInput>

/// Creates a `StaticImageInput` instance.
/// - Parameters:
///   - image: The image to be used for video frame generation.
///   - frameDuration: Specifies how often a new frame should be emitted.
- (instancetype)initWithImage:(UIImage *)image frameDuration:(CMTime)frameDuration NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// The horizontal field of view for the input. Default is 70.0f.
@property (nonatomic, assign) CGFloat horizontalFieldOfView;

@end

NS_ASSUME_NONNULL_END

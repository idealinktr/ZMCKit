//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitInput.h>

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class UIImage;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(VideoAssetInput)
/// `VideoAssetInput` is a Camera Kit provided input that uses a video asset as a source for generating audio/video sample buffers by playing it in a loop.
@interface SCCameraKitVideoAssetInput : NSObject <SCCameraKitInput>

/// Creates a `VideoAssetInput` instance.
/// - Parameters:
///   - asset: The asset to be used for video frame generation.
///   - audioEnabled: Specifies whether audio sample buffers should be generated.
- (instancetype)initWithAsset:(AVAsset *)asset audioEnabled:(BOOL)audioEnabled NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// The horizontal field of view for the input. Default is 70.0f.
@property (nonatomic, assign) CGFloat horizontalFieldOfView;

@end

NS_ASSUME_NONNULL_END

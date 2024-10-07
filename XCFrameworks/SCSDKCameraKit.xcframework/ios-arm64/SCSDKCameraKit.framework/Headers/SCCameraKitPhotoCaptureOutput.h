//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitOutput.h>
#import <SCSDKCameraKit/SCCameraKitOutputRequiringPixelBuffer.h>

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(PhotoCaptureOutput)
/// An output that will capture photos. You should add this as an output for your CameraKit instance.
@interface SCCameraKitPhotoCaptureOutput : NSObject <SCCameraKitOutput, SCCameraKitOutputRequiringPixelBuffer>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// Instantiates a capturer with the specified AVCapturePhotoOutput and capture settings.
/// @param output the photo output to be used if possible. May be nil (in which case a frame from the video stream will
/// be captured).
- (instancetype)initWithCapturePhotoOutput:(nullable AVCapturePhotoOutput *)output NS_DESIGNATED_INITIALIZER;

/// Capture a photo and call a completion with the resulting image when done.
/// @param settings the photo capture settings to be used. If nil, the default settings will be used.
/// @param outputSize the size of the captured photo that should be outputted. Defaults to CGSizeZero which means
/// default system size.
/// @param completion the completion block called with the captured image.
- (void)capturePhotoWithCaptureSettings:(nullable AVCapturePhotoSettings *)settings
                             outputSize:(CGSize)outputSize
                             completion:(void (^)(UIImage *_Nullable image, NSError *_Nullable error))completion
    NS_SWIFT_NAME(capture(with:outputSize:completion:));

/// Capture a photo and call a completion with the resulting image when done.
/// @param settings the photo capture settings to be used. If nil, the default settings will be used.
/// @param completion the completion block called with the captured image.
- (void)capturePhotoWithCaptureSettings:(nullable AVCapturePhotoSettings *)settings
                             completion:(void (^)(UIImage *_Nullable image, NSError *_Nullable error))completion
    NS_SWIFT_NAME(capture(with:completion:));

NS_ASSUME_NONNULL_END

@end

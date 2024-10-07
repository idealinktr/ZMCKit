//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(__Adjustment) NS_REFINED_FOR_SWIFT
    /// Protocol describing the Objective-C interface to an Adjustment.
    @protocol SCCameraKitAdjustment<NSObject>

@end

NS_SWIFT_NAME(AdjustmentController)
/// Protocol describing the Objective-C interface to an Adjustment Controller.
@protocol SCCameraKitAdjustmentController <NSObject>

@end

NS_SWIFT_NAME(ToneMapAdjustment)
/// An adjustment which allows users to more accurately represent the color of their skin when captured by the camera.
@interface SCCameraKitToneMapAdjustment : NSObject <SCCameraKitAdjustment>

@end

NS_SWIFT_NAME(ToneMapAdjustmentController)
/// A controller to control the tone map adjustment.
@protocol SCCameraKitToneMapAdjustmentController <SCCameraKitAdjustmentController>

/// The "amount" of adjustment applied to the tone mapping algorithm. Ranges from 0.0 to 1.0.  A value of 0.5 is the
/// "best guess" of the tone mapping algorithm. Users may wish to adjust this amount up or down to reflect their true
/// skin tone.
@property (assign, nonatomic) CGFloat amount;

@end

NS_SWIFT_NAME(PortraitAdjustment)
/// An adjustment which allows users to blur the background on their input.
@interface SCCameraKitPortraitAdjustment : NSObject <SCCameraKitAdjustment>

@end

NS_SWIFT_NAME(PortraitAdjustmentController)
/// A controller to control the portrait adjustment.
@protocol SCCameraKitPortraitAdjustmentController <SCCameraKitAdjustmentController>

/// How blurred the background is. Ranges from 0.0 to 1.0. A value of 0.0 is "not blurred at all" while 1.0 is
/// "extremely blurred."
@property (assign, nonatomic) CGFloat blur;

@end

NS_ASSUME_NONNULL_END

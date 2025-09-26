//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitLens;
@protocol SCCameraKitLensProcessor;

NS_ASSUME_NONNULL_BEGIN

/// The types of haptic feedback to trigger
typedef NS_ENUM(NSInteger, SCCameraKitHapticFeedbackType) {
    SCCameraKitHapticFeedbackTypeTapticEngine,  /// Haptic feedback using the Taptic Engine
    SCCameraKitHapticFeedbackTypeVibration  // Haptic feedback using vibration
} NS_SWIFT_NAME(HapticFeedbackType);

NS_SWIFT_NAME(LensUIEventsDelegate)
/// The delegate to handle UI events from the lens processor. At the moment, this is used to trigger haptic feedback.
@protocol SCCameraKitLensUIEventsDelegate <NSObject>

@optional

/// Trigger haptic feedback for a lens
/// @param lensProcessor The lens processor that triggered the haptic feedback
/// @param type The type of haptic feedback to trigger
/// @param lens The lens that triggered the haptic feedback
- (void)lensProcessor:(id<SCCameraKitLensProcessor>)lensProcessor
triggerHapticFeedbackWithType:(SCCameraKitHapticFeedbackType)type
              forLens:(id<SCCameraKitLens>)lens;

@end

NS_ASSUME_NONNULL_END

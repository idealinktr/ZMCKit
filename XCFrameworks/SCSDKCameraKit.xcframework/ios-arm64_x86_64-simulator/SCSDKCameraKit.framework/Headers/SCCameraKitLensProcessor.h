//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>

@class AVCaptureSession;
@class LSATexture;
@protocol SCCameraKitLens;
@protocol SCCameraKitOutput;
@protocol SCCameraKitLensLaunchData;
@protocol SCCameraKitLensHintDelegate;
@protocol SCCameraKitLensProcessorObserver;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LensProcessor)
/// The lens processor handles transforming camera frames and adding effects to them.
@protocol SCCameraKitLensProcessor <NSObject>

/// Lens hint delegate to show/hide hints for applied lenses
@property (nonatomic, weak) id<SCCameraKitLensHintDelegate> hintDelegate;

/// Specifies whether lenses will have their audio muted. NO by default.
/// @note: Does NOT mute the device microphone, only prevents lenses from producing audio output.
@property (readonly, nonatomic, assign) BOOL audioMuted;

/// Applies a specified lens.
/// @param lens the lens to apply. This should be a lens provided by the repository.
/// @param launchData launch data to pass to lens.
/// @param completion a completion handler called once the operation finishes.
/// @note Launch data for a specific lens gets persisted automatically so passing nil will reuse the launch data passed
/// to the lens from the previous time applied.
/// @note To reset launch data passed to the lens from the previous time applied pass in `EmptyLensLaunchData` instance.
/// @warning If the lens provided is NOT provided by the repository, and simply conforms to the protocol, a runtime
/// error will occur.
- (void)applyLens:(id<SCCameraKitLens>)lens
       launchData:(nullable id<SCCameraKitLensLaunchData>)launchData
       completion:(nullable void (^)(BOOL success))completion NS_SWIFT_NAME(apply(lens:launchData:completion:));

/// Removes any applied lenses.
/// @param completion a completion handler called once the operation finishes.
- (void)clearWithCompletion:(nullable void (^)(BOOL success))completion NS_SWIFT_NAME(clear(completion:));

/// Configures touch handling for a given view.
/// @param view the view to configure.
/// @param gestureRecognizerDelegate an optional gesture recognizer delegate.
/// @note: this method modifies the UIView so it must be called on the main thread
- (void)configureTouchHandlingInView:(UIView *)view
           gestureRecognizerDelegate:(nullable id<UIGestureRecognizerDelegate>)gestureRecognizerDelegate
    NS_SWIFT_NAME(configureTouchHandling(in:gestureRecognizerDelegate:));

/// Clears all touch handling for a given view
/// @param view the view to configure
/// @note: this method modifies the UIView so it must be called on the main thread
- (void)removeTouchHandlingInView:(UIView *)view;

/// Mutes or unmutes audio.
/// @note: Does NOT mute the device microphone, only prevents lenses from producing audio output.
/// @note: Muting/unmuting is async. The audioMuted property may not immediately reflect your change, but will once
/// completion is called.
/// @param audioMuted whether audio should be muted or not.
/// @param completion an optional completion block to be called when the mute/unmute has taken effect.
- (void)setAudioMuted:(BOOL)audioMuted completion:(nullable void (^)(void))completion;

/// Process image with lens effect using current camera session configuration
/// @param image image to process with current lens
/// @note because this uses current session configuration this should mainly be used to process captured photos
- (nullable UIImage *)processImage:(UIImage *)image;

/// Adds observer to receive notifications of changes to lens processor state.
/// Returns if observer got successfully added
/// @param observer the observer who wishes to receive callbacks.
- (BOOL)addObserver:(id<SCCameraKitLensProcessorObserver>)observer NS_SWIFT_NAME(addObserver(_:));

/// Removes observer from receiving notifications of changes to lens availability.
/// @param observer the observer who wishes to stop receiving callbacks.
- (void)removeObserver:(id<SCCameraKitLensProcessorObserver>)observer NS_SWIFT_NAME(removeObserver(_:));

@end

NS_ASSUME_NONNULL_END

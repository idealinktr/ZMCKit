//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitOutputViewportProviding.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ExplicitViewportProvider)
/// Enables the configuration of a custom viewport for SCCameraKitPreviewView.
@interface SCCameraKitExplicitViewportProvider : NSObject <SCCameraKitOutputViewportProviding>

/// Initializes the ExplicitViewportProvider with the specified viewportSize, outputResolution, and safeArea.
/// @param viewportSize Output viewport frame size.
/// @param outputResolution Output resolution size in _pixels_, not points (i.e. 1125x2436 not 375x812).
/// @param safeArea A CGRect describing an area that the host app will not draw on top of.
/// @note The delegate will be set automatically when this class is used to configure SCCameraKitPreviewView
/// so that any change to `viewportSize`, `outputResolution`, and `safeArea` is propagated.
- (instancetype)initWithViewportSize:(CGSize)viewportSize
                    outputResolution:(CGSize)outputResolution
                            safeArea:(CGRect)safeArea NS_DESIGNATED_INITIALIZER;

/// Sets the output viewport size and propagates the change to SCCameraKitPreviewView.
/// @param viewportSize Output viewport frame size.
- (void)setViewportSize:(CGSize)viewportSize;

/// Sets the output resolution and propagates the change to SCCameraKitPreviewView.
/// @param outputResolution Output resolution size in _pixels_, not points (i.e. 1125x2436 not 375x812).
- (void)setOutputResolution:(CGSize)outputResolution;

/// Sets the safe area and propagates the change to SCCameraKitPreviewView.
/// @param safeArea A CGRect describing an area that the host app will not draw on top of.
- (void)setSafeArea:(CGRect)safeArea;

/// Use the designated initializer to pass in the required properties.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

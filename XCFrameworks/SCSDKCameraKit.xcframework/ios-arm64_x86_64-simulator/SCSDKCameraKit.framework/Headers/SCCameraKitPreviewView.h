//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitExplicitViewportProvider.h>
#import <SCSDKCameraKit/SCCameraKitOutput.h>
#import <SCSDKCameraKit/SCCameraKitOutputViewportProviding.h>

@class SCCameraKitSession;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SCCameraKitPreviewViewContentMode) {
    SCCameraKitPreviewViewContentModeScaleToFill,
    SCCameraKitPreviewViewContentModeAspectFill,
    SCCameraKitPreviewViewContentModeAspectFit
};

NS_SWIFT_NAME(PreviewView)
/// A UIView which is capable of rendering SCCameraKitTextures. You should add this as an output for your CameraKit
/// instance.
@interface SCCameraKitPreviewView
    : UIView <SCCameraKitOutput, SCCameraKitOutputViewportProviding, SCCameraKitOutputViewportProvidingDelegate>

/// Configures the neccessary gesture recognizers for handling touch input in lenses.
/// If set to YES, will automatically add gesture reconizers and configure them to pass events to lenses.
/// @note by default, this is NO. You may change this to YES while cameraKit is running, and it will be configured on
/// the next frame.
@property (assign, nonatomic) BOOL automaticallyConfiguresTouchHandler;

/// Configures the viewport upon changes to the view's frame.
/// If set to YES, this will automatically adjust `viewportSize`, `outputResolution`, and `safeArea` according to the
/// view's frame.
/// @note By default, this is YES. If the viewport is explicitly defined via explicitViewportProvider, this will be set
/// to NO.
/// @note If you change this property without setting explicitViewportProvider, the view will keep the last derived
/// `viewportSize`, `outputResolution`, and `safeArea`.
/// @warning If there is a mismatch between `viewportSize` and the view's frame size, part of the lens may
/// be cut off on the screen.
@property (assign, nonatomic) BOOL automaticallyConfiguresViewport;

/// Configures the content mode the preview view will use to render.
/// @note SCCameraKitPreviewViewContentModeAspectFill by default.
@property (assign, nonatomic) SCCameraKitPreviewViewContentMode contentMode;

/// Configures the safe area to an explicitly specified rect.
@property (assign, nonatomic) CGRect safeArea;

/// Setting this property configures the preview view to use its `viewportSize`, `outputResolution`, and `safeArea`.
/// @note Calling this method will set `automaticallyConfiguresViewport` to NO.
/// @warning If there is a mismatch between `viewportSize` and the view's frame size, part of the lens may be cut off
/// the screen.
@property (strong, nonatomic, nullable) SCCameraKitExplicitViewportProvider *explicitViewportProvider;

/// Automatically configures the safeArea property to avoid the specified views.
/// @param occludingViews any views that may be displayed in front of lenses content, such as the carousel, camera flip
/// button, etc. If the preview view itself is part of this array, it will be ignored.
/// @note the preview view maintain a weak reference to the provided views and update the safe area automatically as
/// needed.
/// @warning this method will reevaluate periodically (during bounds changes, etc), but will _NOT_ actively track
/// changes to occluding views between those intervals. If you move an occluding view without affecting the preview
/// view, call this method again to reevaluate.
- (void)configureSafeAreaWithOccludingViews:(NSArray<UIView *> *)occludingViews
    NS_SWIFT_NAME(configureSafeArea(with:));

@end

NS_ASSUME_NONNULL_END

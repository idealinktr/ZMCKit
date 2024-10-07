//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitOutputSpecialCase.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCCameraKitOutputViewportProviding;

NS_SWIFT_NAME(OutputViewportProvidingDelegate)
@protocol SCCameraKitOutputViewportProvidingDelegate <NSObject>

/// Notifies delegate that the viewport or safe area has changed, and change should be propogated to CameraKit.
/// @param sender the output providing the viewport change.
- (void)viewportChanged:(id<SCCameraKitOutputViewportProviding>)sender;

@end

NS_SWIFT_NAME(OutputViewportProviding)
/// Allows conformers to provide output viewport frame size
@protocol SCCameraKitOutputViewportProviding <SCCameraKitOutputSpecialCase>

/// A delegate to notify if you change the viewport. This property will be set by CameraKit automatically when you add
/// the output.
@property (nonatomic, weak) id<SCCameraKitOutputViewportProvidingDelegate> delegate;

/// Output viewport frame size
/// When modified, the protocol conformer should call viewportChanged: on its delegate.
@property (nonatomic, assign, readonly) CGSize viewportSize;

/// Output resolution size in _pixels_
/// When modified, the protocol conformer should call resolutionChanged: on its delegate
/// @note the size should be in pixels, not points (eg: an iPhone X would be 1125x2436, not 375x812)
@property (nonatomic, assign, readonly) CGSize outputResolution;

/// A CGRect describing an area that the host app will not draw on top of.
/// When modified, the protocol conformer should call viewportChanged: on its delegate.
/// @note If multiple viewport providers are given, CameraKit will use the smallest one provided.
@property (nonatomic, assign, readonly) CGRect safeArea;

@end

NS_ASSUME_NONNULL_END

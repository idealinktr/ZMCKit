//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitLens;
@protocol SCCameraKitLensProcessor;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LensHintDelegate)
/// Lens hint delegate used to notify receivers when to show/hide hints for applied lenses
@protocol SCCameraKitLensHintDelegate <NSObject>

/// Notifies receiver that they should show hint for current lens
/// @param lensProcessor curent lens processor instance
/// @param hint localized hint text to display
/// @param lens current lens applied
/// @param autohide should autohide hint
- (void)lensProcessor:(id<SCCameraKitLensProcessor>)lensProcessor
    shouldDisplayHint:(NSString *)hint
              forLens:(id<SCCameraKitLens>)lens
             autohide:(BOOL)autohide;

/// Notifies receiver that they should remove all hints for current lens
/// @param lensProcessor curent lens processor instance
/// @param lens current lens applied
- (void)lensProcessor:(id<SCCameraKitLensProcessor>)lensProcessor shouldHideAllHintsForLens:(id<SCCameraKitLens>)lens;

@end

NS_ASSUME_NONNULL_END

//#!announcer.rb
//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitLensProcessor;
@protocol SCCameraKitLens;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ProcessorObserver)
/// Allows conformers to be notified of changes to lens processor state
@protocol SCCameraKitLensProcessorObserver <NSObject>

/// Notifies that the lens processor did apply lens
/// @param processor lens processor instance
/// @param lens lens applied instance
- (void)processor:(id<SCCameraKitLensProcessor>)processor
     didApplyLens:(id<SCCameraKitLens>)lens NS_SWIFT_NAME(processor(_:didApplyLens:));

/// Notifies that the lens processor did clear any active lens and is now in an "idle" state
/// @param processor lens processor instance
- (void)processorDidIdle:(id<SCCameraKitLensProcessor>)processor NS_SWIFT_NAME(processorDidIdle(_:));

@optional

/// Notifies the listener that the first frame with the lens applied is ready
/// @param processor lens processor instance
/// @param lens current lens applied whose frame is ready for
- (void)processor:(id<SCCameraKitLensProcessor>)processor
    firstFrameDidBecomeReadyForLens:(id<SCCameraKitLens>)lens
    NS_SWIFT_NAME(processor(_:firstFrameDidBecomeReadyFor:));

@end

NS_ASSUME_NONNULL_END

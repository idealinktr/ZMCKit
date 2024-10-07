//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitAdjustmentsProcessor;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AdjustmentsProcessorObserver)
/// Allows conformers to be notified of changes to adjustments processor state
@protocol SCCameraKitAdjustmentsProcessorObserver <NSObject>

/// Notifies that the adjustments processor updated the state of available adjustments
/// @param adjustmentsProcessor the adjustments processor instance
- (void)processorUpdatedAdjustmentsAvailability:(id<SCCameraKitAdjustmentsProcessor>)adjustmentsProcessor;

@end

NS_ASSUME_NONNULL_END

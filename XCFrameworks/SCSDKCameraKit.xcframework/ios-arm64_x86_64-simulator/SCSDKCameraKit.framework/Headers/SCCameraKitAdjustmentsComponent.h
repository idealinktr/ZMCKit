//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <UIKit/UIKit.h>

@protocol SCCameraKitAdjustment;
@protocol SCCameraKitAdjustmentController;
@protocol SCCameraKitAdjustmentsProcessorObserver;

NS_ASSUME_NONNULL_BEGIN

// Error domain for Adjustments Component related errors.
FOUNDATION_EXTERN NSErrorDomain const
    SCCameraKitAdjustmentsComponentErrorDomain NS_SWIFT_NAME(AdjustmentsComponentErrorDomain);

// Enum for Adjustment Processor errors.
typedef NS_ERROR_ENUM(SCCameraKitAdjustmentsComponentErrorDomain, SCCameraKitAdjustmentsComponentError){

    // An unsupported adjustment was supplied. Check isAdjustmentAvailable before applying to avoid this.
    SCCameraKitAdjustmentsComponentErrorUnsupportedAdjustment = 0,

} NS_SWIFT_NAME(AdjustmentsComponentError);

NS_SWIFT_NAME(AdjustmentsProcessor) NS_REFINED_FOR_SWIFT
    /// The adjustments processor handles adjusting camera frames before they are processed by lenses.
    @protocol SCCameraKitAdjustmentsProcessor<NSObject>

/// Checks if an adjustment is available and supported by the current device. Some adjustments are performance sensitive
/// or require specific hardware which may mean they are unavailable on specific devices. You should call this method
/// before showing any UI associated with the adjustment.
/// @param adjustment the adjustment to check.
- (BOOL)isAdjustmentAvailable:(id<SCCameraKitAdjustment>)adjustment;

/// Applies the specified adjustment.
/// @param adjustment The adjustment to apply.
/// @param error  Any error that may occur during application.
- (nullable id<SCCameraKitAdjustmentController>)applyAdjustment:(id<SCCameraKitAdjustment>)adjustment
                                                          error:(NSError *_Nullable __autoreleasing *_Nullable)error
    NS_REFINED_FOR_SWIFT;

/// Removes an adjustment.
/// @param adjustmentController the controller associated with the adjustment you wish to remove.
- (void)removeAdjustmentController:(id<SCCameraKitAdjustmentController>)adjustmentController;

/// Adds observer to receive notifications of changes to adjustments processor state.
/// Returns if observer got successfully added
/// @param observer the observer who wishes to receive callbacks.
- (BOOL)addObserver:(id<SCCameraKitAdjustmentsProcessorObserver>)observer NS_SWIFT_NAME(addObserver(_:));

/// Removes observer from receiving notifications of changes to adjustments availability.
/// @param observer the observer who wishes to stop receiving callbacks.
- (void)removeObserver:(id<SCCameraKitAdjustmentsProcessorObserver>)observer NS_SWIFT_NAME(removeObserver(_:));

@end

NS_SWIFT_NAME(AdjustmentsComponent)
/// The adjustments component wraps several adjustment-related classes.
@protocol SCCameraKitAdjustmentsComponent <NSObject>

/// Handles the actual adjustment application. Will be null if CameraKit is not running with a valid input.
@property (strong, nonatomic, readonly, nullable) id<SCCameraKitAdjustmentsProcessor> processor;

@end

NS_ASSUME_NONNULL_END

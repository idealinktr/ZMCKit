//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@class CMDeviceMotion;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(DeviceMotionParameters)
/// Params for device motion interface
@protocol SCCameraKitDeviceMotionParameters <NSObject>

/// Requires device motion interface to be aligned with compass
@property (nonatomic, assign, readonly) BOOL requiresCompassAlignment;

@end

NS_SWIFT_NAME(DeviceMotionDataProvider)
/// Protocol to provide device motion data and handle starting/updating/stopping
@protocol SCCameraKitDeviceMotionDataProvider <NSObject>

/// Current device motion data
@property (nonatomic, strong, readonly, nullable) CMDeviceMotion *deviceMotion;

/// Start updating device motion with params
/// @param parameters device motion params
- (void)startUpdatingWithParameters:(id<SCCameraKitDeviceMotionParameters>)parameters;

/// Stop updating device motion
- (void)stopUpdating;

@end

NS_ASSUME_NONNULL_END

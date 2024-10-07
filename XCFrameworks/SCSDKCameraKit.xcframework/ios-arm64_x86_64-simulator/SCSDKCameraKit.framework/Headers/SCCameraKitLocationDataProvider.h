//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LocationParameters)
/// Params for device motion interface
@protocol SCCameraKitLocationParameters <NSObject>

/// Minimum interval between consecutive location updates
@property (nonatomic, readonly) int32_t updateIntervalMilliseconds;

/// Minimum distance between consecutive location updates
@property (nonatomic, readonly) CLLocationDistance distanceFilterMeters;

/// Desired accuracy
@property (nonatomic, readonly) CLLocationAccuracy desiredAccuracy;

@end

NS_SWIFT_NAME(LocationDataProvider)
/// Protocol to provide device motion data and handle starting/updating/stopping
@protocol SCCameraKitLocationDataProvider <NSObject>

/// Current location data
@property (nonatomic, strong, readonly, nullable) CLLocation *location;

/// Start updating location data with params
/// @param parameters location params
/// @warning If the user has not been prompted for location permission, it is the class's responsibility
/// to prompt them.
- (void)startUpdatingWithParameters:(id<SCCameraKitLocationParameters>)parameters;

/// Stop updating location
- (void)stopUpdating;

@end

NS_ASSUME_NONNULL_END

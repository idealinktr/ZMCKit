//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCCameraKitGeoDataProvider;

NS_SWIFT_NAME(GeoData)
/// Geo data class to pass in geo/location information to lenses
@interface SCCameraKitGeoData : NSObject

/// Name of the city for the current location
@property (nonatomic, copy, readonly) NSString *cityName;

/// Designated init to pass in geo data fields
/// @param cityName name of the city for current location
- (instancetype)initWithCityName:(NSString *)cityName NS_DESIGNATED_INITIALIZER;

/// Use designated init to pass in required geo data properties
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_SWIFT_NAME(GeoDataProviderDelegate)
/// Geo data provider delegate to provide receivers with new geo data on updates
@protocol SCCameraKitGeoDataProviderDelegate <NSObject>

/// Update delegate receivers with new geo data
/// @param geoDataProvider current geo data provider instance
/// @param geoData new geo data
- (void)geoDataProvider:(id<SCCameraKitGeoDataProvider>)geoDataProvider
       didUpdateGeoData:(SCCameraKitGeoData *)geoData;

@end

NS_SWIFT_NAME(GeoDataProvider)
/// Describes an interface that provides geo data to lenses
@protocol SCCameraKitGeoDataProvider <NSObject>

/// Current geo data
@property (nonatomic, strong, readonly, nullable) SCCameraKitGeoData *geoData;

/// Delegate to receive updates on geo data changes
@property (nonatomic, weak, nullable) id<SCCameraKitGeoDataProviderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

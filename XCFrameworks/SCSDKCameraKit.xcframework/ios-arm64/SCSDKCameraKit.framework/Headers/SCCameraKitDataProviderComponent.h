//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitDeviceMotionDataProvider;
@protocol SCCameraKitUserDataProvider;
@protocol SCCameraKitLensHintProvider;
@protocol SCCameraKitLocationDataProvider;
@protocol SCCameraKitLensMediaPickerProvider;
@protocol SCCameraKitLensRemoteApiServiceProvider;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(DataProviderComponent)
/// Component for user's custom data providers
@interface SCCameraKitDataProviderComponent : NSObject

/// Device motion data provider
@property (nonatomic, strong, nullable) id<SCCameraKitDeviceMotionDataProvider> deviceMotion;

/// User data provider
@property (nonatomic, strong, nullable) id<SCCameraKitUserDataProvider> userData;

/// Lens hint provider to provide lens hint localizations
@property (nonatomic, strong, nullable) id<SCCameraKitLensHintProvider> lensHint;

/// Location data provider
@property (nonatomic, strong, nullable) id<SCCameraKitLocationDataProvider> location;

/// Media picker provider for selecting and loading external images and video into lenses.
@property (nonatomic, strong, nullable) id<SCCameraKitLensMediaPickerProvider> mediaPicker;

/// List of remote api service providers to handle remote api requests sent by lenses.
@property (nonatomic, copy) NSArray<id<SCCameraKitLensRemoteApiServiceProvider>> *remoteApiServiceProviders;

/// Designated init to pass in user data providers
/// If nil is passed in for a specific data provider, CameraKit will create and handle the data provider by default
/// @param deviceMotion device motion data provider instance
/// @param userData user data provider instance
/// @param lensHint lens hint provider instance
/// @param location location provider instance
/// @param mediaPicker Media picker provider for selecting and loading external images and video into lenses.
/// @param remoteApiServiceProviders List of remote api service providers to handle remote api requests sent by lenses.
- (instancetype)initWithDeviceMotion:(nullable id<SCCameraKitDeviceMotionDataProvider>)deviceMotion
                            userData:(nullable id<SCCameraKitUserDataProvider>)userData
                            lensHint:(nullable id<SCCameraKitLensHintProvider>)lensHint
                            location:(nullable id<SCCameraKitLocationDataProvider>)location
                         mediaPicker:(nullable id<SCCameraKitLensMediaPickerProvider>)mediaPicker
           remoteApiServiceProviders:(NSArray<id<SCCameraKitLensRemoteApiServiceProvider>> *)remoteApiServiceProviders
    NS_DESIGNATED_INITIALIZER;

// MARK: Convenience Inits

/// Convenience init to mantain API compatibility
/// @param deviceMotion device motion data provider instance
/// @param userData user data provider instance
- (instancetype)initWithDeviceMotion:(nullable id<SCCameraKitDeviceMotionDataProvider>)deviceMotion
                            userData:(nullable id<SCCameraKitUserDataProvider>)userData;

/// Convenience init to mantain API compatibility
/// @param deviceMotion device motion data provider instance
/// @param userData user data provider instance
/// @param lensHint lens hint provider instance
- (instancetype)initWithDeviceMotion:(nullable id<SCCameraKitDeviceMotionDataProvider>)deviceMotion
                            userData:(nullable id<SCCameraKitUserDataProvider>)userData
                            lensHint:(nullable id<SCCameraKitLensHintProvider>)lensHint;

/// Convenience init to mantain API compatibility
/// If nil is passed in for a specific data provider, CameraKit will create and handle the data provider by default
/// @param deviceMotion device motion data provider instance
/// @param userData user data provider instance
/// @param lensHint lens hint provider instance
/// @param location location provider instance
- (instancetype)initWithDeviceMotion:(nullable id<SCCameraKitDeviceMotionDataProvider>)deviceMotion
                            userData:(nullable id<SCCameraKitUserDataProvider>)userData
                            lensHint:(nullable id<SCCameraKitLensHintProvider>)lensHint
                            location:(nullable id<SCCameraKitLocationDataProvider>)location;

/// Convenience init to mantain API compatibility
/// @param deviceMotion device motion data provider instance
/// @param userData user data provider instance
/// @param lensHint lens hint provider instance
/// @param location location provider instance
/// @param mediaPicker Media picker provider for selecting and loading external images and video into lenses.
- (instancetype)initWithDeviceMotion:(nullable id<SCCameraKitDeviceMotionDataProvider>)deviceMotion
                            userData:(nullable id<SCCameraKitUserDataProvider>)userData
                            lensHint:(nullable id<SCCameraKitLensHintProvider>)lensHint
                            location:(nullable id<SCCameraKitLocationDataProvider>)location
                         mediaPicker:(nullable id<SCCameraKitLensMediaPickerProvider>)mediaPicker;

@end

NS_ASSUME_NONNULL_END

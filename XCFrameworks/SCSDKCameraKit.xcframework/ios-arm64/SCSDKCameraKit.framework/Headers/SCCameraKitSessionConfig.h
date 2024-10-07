//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SessionConfig)
/// Data class that is used to pass in a configuration for the CameraKit Session.
/// Use this data class if you would like to be able to dynamically update config values like application id and api
/// token or overwrite the ones that are passed into `Info.plist`.
@interface SCCameraKitSessionConfig : NSObject

/// API token that is found in the dev portal
@property (nonatomic, copy, readonly) NSString *apiToken;

// Additional configuration.
/// @warning USE ONLY AS DIRECTED BY SNAP SUPPORT.
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *additionalConfigurationAttributes;

/// Designated init to pass in apiToken
/// @param apiToken api token that is found in the dev portal
/// @note as well as overwrite the apiToken passed into `Info.plist` with the key `SCCameraKitAPIToken`
- (instancetype)initWithApiToken:(NSString *)apiToken NS_DESIGNATED_INITIALIZER;

/// Init to pass in apiToken
/// @param apiToken api token that is found in the dev portal
/// @param additionalConfigurationAttributes additional configuration
/// @note as well as overwrite the apiToken passed into `Info.plist` with the key `SCCameraKitAPIToken`
/// @warning USE ONLY AS DIRECTED BY SNAP SUPPORT.
- (instancetype)initWithApiToken:(NSString *)apiToken
    additionalConfigurationAttributes:(nullable NSDictionary<NSString *, id> *)additionalConfigurationAttributes;

/// Use designated init to pass in require applicationID and apiToken
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

// Deprecated

/// applicationID/clientID that is found in the dev portal
@property (nonatomic, copy, readonly) NSString *applicationId
    __attribute__((deprecated("Application ID-based authentication is no longer supported. Use apiToken instead.")));

/// Designated init to pass in applicationID and apiToken
/// @param applicationID applicationID/clientID that is found in the dev portal
/// @param apiToken api token that is found in the dev portal
/// @note this will override the applicationID passed into `Info.plist` with the key `SCCameraKitClientID`
/// @note as well as overwrite the apiToken passed into `Info.plist` with the key `SCCameraKitAPIToken`
- (instancetype)initWithApplicationID:(NSString *)applicationID
                             apiToken:(NSString *)apiToken
    __attribute__((
        deprecated("Application ID-based authentication is no longer supported. Use initWithApiToken: instead.",
                   "initWithApiToken:")));

/// Init to pass in applicationID and apiToken
/// @param applicationID applicationID/clientID that is found in the dev portal
/// @param apiToken api token that is found in the dev portal
/// @param additionalConfigurationAttributes additional configuration
/// @note this will override the applicationID passed into `Info.plist` with the key `SCCameraKitClientID`
/// @note as well as overwrite the apiToken passed into `Info.plist` with the key `SCCameraKitAPIToken`
/// @warning USE ONLY AS DIRECTED BY SNAP SUPPORT.
- (instancetype)initWithApplicationID:(NSString *)applicationID
                             apiToken:(NSString *)apiToken
    additionalConfigurationAttributes:(nullable NSDictionary<NSString *, id> *)additionalConfigurationAttributes
    __attribute__((deprecated("Application ID-based authentication is no longer supported. Use "
                              "initWithApiToken:additionalConfigurationAttributes: instead.",
                              "initWithApiToken:additionalConfigurationAttributes:")));

@end

NS_ASSUME_NONNULL_END

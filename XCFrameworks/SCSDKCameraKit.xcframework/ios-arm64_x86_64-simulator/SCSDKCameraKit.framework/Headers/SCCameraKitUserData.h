//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCCameraKitUserDataProvider;

NS_SWIFT_NAME(UserData)
/// Concrete user data class to pass in user data that can be used by some lenses
@interface SCCameraKitUserData : NSObject

/// User's full display name
@property (nonatomic, copy, readonly) NSString *displayName;

/// User's birth date (optional)
@property (nonatomic, strong, readonly, nullable) NSDate *birthDate;

/// Designated init to pass in user data fields
/// @param displayName user's full display name
/// @param birthDate user's birth date (optional)
- (instancetype)initWithDisplayName:(NSString *)displayName birthDate:(nullable NSDate *)birthDate;

/// Use designated init or convenience init to pass in required user properties
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_SWIFT_NAME(UserDataProviderDelegate)
/// User data provider delegate to provide receivers with new user data on updates
@protocol SCCameraKitUserDataProviderDelegate <NSObject>

/// Update delegate receivers with new user data
/// @param userDataProvider current user data provider instance
/// @param userData new user data
- (void)userDataProvider:(id<SCCameraKitUserDataProvider>)userDataProvider
       didUpdateUserData:(SCCameraKitUserData *)userData;

@end

NS_SWIFT_NAME(UserDataProvider)
/// Describes an interface that provides user data to lenses
@protocol SCCameraKitUserDataProvider <NSObject>

/// Current user data
@property (nonatomic, strong, readonly, nullable) SCCameraKitUserData *userData;

/// Delegate to receive updates on user data changes
@property (nonatomic, weak, nullable) id<SCCameraKitUserDataProviderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

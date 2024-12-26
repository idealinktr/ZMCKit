//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AccessTokenProviderTask)
/// Describes an interface that will handle fetching the access token.
@protocol SCCameraKitAccessTokenProviderTask <NSObject>

/// Cancels fetching access token if it's currently in progress;
- (void)cancel;

@end

NS_SWIFT_NAME(AccessTokenProvider)
/// Describes an interface to provide an access token (ie. from LoginKit) required by some features like connected
/// lenses, push to device, etc.
@protocol SCCameraKitAccessTokenProvider <NSObject>

/// If the user is already authenticated, fetch a valid/non-expired access token to be used by some features like connected lenses, push to device, etc.
/// Returns an access token task if the fetch token task is cancellable or nil if the task is not cancellable.
/// @param completion Callback on completion with access token on success or error on failure.
/// @note It is up to the provider to ensure that the access token will be active for the lifetime of the feature using
/// the token.
- (nullable id<SCCameraKitAccessTokenProviderTask>)fetchAccessTokenIfAuthenticatedWithCompletion:
    (void (^)(NSString *_Nullable, NSError *_Nullable))completion;

/// Fetch a valid/non-expired access token to be used by some features like connected lenses, push to device, etc.
/// May take the user through an authentication flow if the user is not already authenticated.
/// Returns an access token task if the fetch token task is cancellable or nil if the task is not cancellable.
/// @param completion Callback on completion with access token on success or error on failure.
/// @note It is up to the provider to ensure that the access token will be active for the lifetime of the feature using
/// the token.
- (nullable id<SCCameraKitAccessTokenProviderTask>)fetchAccessTokenWithCompletion:
    (void (^)(NSString *_Nullable, NSError *_Nullable))completion;

@end
NS_ASSUME_NONNULL_END

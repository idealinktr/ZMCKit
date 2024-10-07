//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitLens;
@protocol SCCameraKitLensRepository;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LensRepositorySpecificObserver)
/// Allows conformers to be notified of changes to specific lenses in groups the repository has available.
@protocol SCCameraKitLensRepositorySpecificObserver <NSObject>

/// Notifies that an observed specific lens in a group has changed.
/// @param repository the CameraKit lens repository responsible for the update.
/// @param lens the newly updated lens object.
/// @param groupID the updated group ID.
- (void)repository:(id<SCCameraKitLensRepository>)repository
     didUpdateLens:(id<SCCameraKitLens>)lens
        forGroupID:(NSString *)groupID;

/// Notifies that an observed specific lens in a group has failed to be fetched.
/// @param repository the CameraKit lens repository responsible for the update.
/// @param lensID the lens ID that failed to update.
/// @param groupID the group ID that failed to update.
/// @param error a detailed error message of what went wrong, if available.
- (void)repository:(id<SCCameraKitLensRepository>)repository
    didFailToUpdateLensID:(NSString *)lensID
               forGroupID:(NSString *)groupID
                    error:(nullable NSError *)error;

NS_ASSUME_NONNULL_END

@end

//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitLens;
@protocol SCCameraKitLensRepository;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LensRepositoryGroupObserver)
/// Allows conformers to be notified of changes to lens groups the repository has available.
@protocol SCCameraKitLensRepositoryGroupObserver <NSObject>

/// Notifies that an observed group's lenses have changed.
/// @param repository the CameraKit lens repository responsible for the update.
/// @param lenses the updated lenses in the group.
/// @param groupID the updated group ID.
/// @note observers may receive notifications for lens groups they do not care about. Check groupID.
- (void)repository:(id<SCCameraKitLensRepository>)repository
    didUpdateLenses:(NSArray<id<SCCameraKitLens>> *)lenses
         forGroupID:(NSString *)groupID;

/// Notifies that an observed group's lenses failed to be fetched.
/// @param repository the CameraKit lens repository responsible for the update.
/// @param groupID the updated group ID.
/// @param error a detailed error message of what went wrong, if available.
- (void)repository:(id<SCCameraKitLensRepository>)repository
    didFailToUpdateLensesForGroupID:(NSString *)groupID
                              error:(nullable NSError *)error;

NS_ASSUME_NONNULL_END

@end

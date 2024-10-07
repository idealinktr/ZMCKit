//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitLens;
@protocol SCCameraKitLensProcessor;
@protocol SCCameraKitLensRepository;
@protocol SCCameraKitLensPrefetcher;
@protocol SCCameraKitPreferences;
@protocol SCCameraKitLensRepositoryGroupObserver;
@protocol SCCameraKitLensRepositorySpecificObserver;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const SCCameraKitLensRepositoryBundledGroup;

// MARK: Lens

NS_SWIFT_NAME(LensesComponent)
/// The lenses component wraps several lens-related classes.
@protocol SCCameraKitLensesComponent <NSObject>

/// The repository for lenses.  Lists available lenses, etc. in the `lenses` folder
@property (strong, nonatomic, readonly) id<SCCameraKitLensRepository> repository;

/// Handles the actual effect application. Will be null if CameraKit is not running with a valid input.
@property (strong, nonatomic, readonly, nullable) id<SCCameraKitLensProcessor> processor;

/// Prefetcher to prefetch lens content to reduce time when applying lens
@property (strong, nonatomic, readonly) id<SCCameraKitLensPrefetcher> prefetcher;

/// Property to deal with preferences (ie. clear stored preferences)
@property (strong, nonatomic, readonly) id<SCCameraKitPreferences> preferences;

@end

// MARK: Repository

NS_SWIFT_NAME(LensRepository)
/// Lens Repository for listing lenses, getting lenses, etc.
@protocol SCCameraKitLensRepository <NSObject>

// Group Observers

/// Add an observer to receive updates to a lens group
/// @param observer observer to receive updates
/// @param groupID id of lens group to observe
/// @note you should expect to receive at least one call to the observer after you add it (either success with list of
/// lenses or failure with error)
/// @note after you add an observer for a lens group you will receive updates for all lenses in that group (ie. you do
/// not have to add an observer for specific lenses in the group)
- (void)addObserver:(id<SCCameraKitLensRepositoryGroupObserver>)observer
         forGroupID:(NSString *)groupID NS_SWIFT_NAME(addObserver(_:groupID:));

/// Remove an observer from receiving updates for a lens group
/// @param observer observer to remove from receiving updates
/// @param groupID id of lens group to stop observing
- (void)removeObserver:(id<SCCameraKitLensRepositoryGroupObserver>)observer
            forGroupID:(NSString *)groupID NS_SWIFT_NAME(removeObserver(_:groupID:));

// Specific Lens Observers

/// Add an observer to receive updates for a specific lens in a group
/// @param observer observer to receive updates
/// @param lensID id of lens to receive updates for
/// @param groupID id of group which lens is in that you want to receive updates for
/// @note you should expect to receive at least one call to the observer after you add it (either success with lens obj
/// or failure with error)
- (void)addObserver:(id<SCCameraKitLensRepositorySpecificObserver>)observer
    forSpecificLensID:(NSString *)lensID
            inGroupID:(NSString *)groupID NS_SWIFT_NAME(addObserver(_:specificLensID:inGroupID:));

/// Remove an observer from receiving updates for a specific lens in a group
/// @param observer observer to remove from receiving updates
/// @param lensID id of lens to stop observing
/// @param groupID if of group which lens is in that you want to stop observing
- (void)removeObserver:(id<SCCameraKitLensRepositorySpecificObserver>)observer
     forSpecificLensID:(NSString *)lensID
             inGroupID:(NSString *)groupID NS_SWIFT_NAME(removeObserver(_:specificLensID:inGroupID:));

// Properties

/// Any available lenses for the group ID specified.
/// @param groupID the group ID containing the desired lenses.
/// @note this method will not return any lenses until the user has expressed interest in a group by calling
/// beginObservingGroupID:
/// @note for updates on when the return value of this method changes, add a observer in addObserver:
- (NSArray<id<SCCameraKitLens>> *)lensesForGroupID:(NSString *)groupID NS_SWIFT_NAME(lenses(groupID:));

/// Specific lens in group ID specified
/// @param lensID id of lens
/// @param groupID id of group lens is in
/// @note this method will not return any lenses until the user has expressed interest in a group by calling
/// beginObservingGroupID: or beginObservingLens:inGroup:
/// @note for updates on when the return value of this method changes, add a observer in addObserver:
- (nullable id<SCCameraKitLens>)lensWithID:(NSString *)lensID
                                 inGroupID:(NSString *)groupID NS_SWIFT_NAME(lens(id:groupID:));

@end

FOUNDATION_EXPORT NSString *const SCCameraKitLensesComponentErrorDomain;

NS_ASSUME_NONNULL_END

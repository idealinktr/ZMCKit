//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitLens;
@protocol SCCameraKitLensPrefetcher;

NS_ASSUME_NONNULL_BEGIN

/// Describes the fetch status for the lens
/// Unloaded - lens content has not been fetched or loaded
/// Loading - lens content is currently being downloaded
/// Loaded - lens content has already been downloaded and fetched
typedef NS_ENUM(NSInteger, SCCameraKitLensFetchStatus) {
    SCCameraKitLensFetchStatusUnloaded,
    SCCameraKitLensFetchStatusLoading,
    SCCameraKitLensFetchStatusLoaded,
} NS_SWIFT_NAME(LensFetchStatus);

NS_SWIFT_NAME(LensPrefetcherObserver)
/// Describes an interface used to observe changes in lens fetch status
@protocol SCCameraKitLensPrefetcherObserver <NSObject>

/// Notification when fetcher updates lens fetch status
/// @param prefetcher LensPrefetcher instance that updated lens fetch status
/// @param lens lens whose fetch status was updated
/// @param status new fetch status for lens
- (void)prefetcher:(id<SCCameraKitLensPrefetcher>)prefetcher
     didUpdateLens:(id<SCCameraKitLens>)lens
            status:(SCCameraKitLensFetchStatus)status;

@end

NS_SWIFT_NAME(LensPrefetcherTask)
/// Describes the interface used to cancel an ongoing prefetch task
@protocol SCCameraKitLensPrefetcherTask <NSObject>

/// Cancel prefetch task if it's ongoing
- (void)cancel;

@end

NS_SWIFT_NAME(LensPrefetcher)
/// Describes the interface used to prefetch lens content
@protocol SCCameraKitLensPrefetcher <NSObject>

/// Queues up a new fetch task for each of the `lenses` in order to prefetch their content.
/// A successful callback indiciates that all the content for the list of `lenses` is ready to be used/applied in lens
/// processor
/// @param lenses lenses to prefetch content for
/// @param completion callback on completion with success or failure
- (id<SCCameraKitLensPrefetcherTask>)prefetchLenses:(NSArray<id<SCCameraKitLens>> *)lenses
                                         completion:(nullable void (^)(BOOL success))completion
    NS_SWIFT_NAME(prefetch(lenses:completion:));

/// Add observer to observe changes in lens fetch status
/// @param observer observer instance which will receive updates
/// @param lens lens to observe
- (void)addStatusObserver:(id<SCCameraKitLensPrefetcherObserver>)observer
                  forLens:(id<SCCameraKitLens>)lens NS_SWIFT_NAME(addStatusObserver(_:lens:));

/// Remove observer to stop observing changes in lens fetch status
/// @param observer observer instance which will stop receiving updates
/// @param lens lens to stop observing
- (void)removeStatusObserver:(id<SCCameraKitLensPrefetcherObserver>)observer
                     forLens:(id<SCCameraKitLens>)lens NS_SWIFT_NAME(removeStatusObserver(_:lens:));

@end

NS_ASSUME_NONNULL_END

//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Cache types managed by SCCameraKitCachesManager.
typedef NS_ENUM(NSUInteger, SCCameraKitCacheType) {
    /// Default cache type, includes lens resources and assets.
    SCCameraKitCacheTypeDefault = 0,
} NS_SWIFT_NAME(CacheType);

/// Cache statistics 
typedef struct {
    NSUInteger byteLimit;
    NSUInteger byteCount;
    NSUInteger objectCount;
} SCCameraKitCacheStatistics NS_SWIFT_NAME(CacheStatistics);

NS_SWIFT_NAME(CachesManager)
/// Protocol for managing CameraKit caches.
@protocol SCCameraKitCachesManager <NSObject>

/// Clears the specified cache type and executes the completion block when finished.
///
/// @param type        The type of cache to clear.
/// @param completion  A block to execute when clearing completes.
- (void)clearCacheOfType:(SCCameraKitCacheType)type
              completion:(dispatch_block_t)completion;

/// Retrieves cache statistics for the specified cache type.
///
/// @param type        The type of cache to query.
/// @param completion  A block that receives cache statistics.
- (void)fetchCacheStatisticsForType:(SCCameraKitCacheType)type
                        completion:(nullable void (^)(SCCameraKitCacheStatistics statistics))completion;

@end

NS_ASSUME_NONNULL_END

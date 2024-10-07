//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(CacheConfig)
/// Concrete class to configure camera kit cache
@interface SCCameraKitCacheConfig : NSObject

/// Max size in bytes for lens content cache
/// @note Default max is 100MB and min is at least 50MB
@property (nonatomic, assign, readonly) NSUInteger lensContentMaxSize;

/// Init with specifed max size for lens content cache
/// @param lensContentMaxSize max size for lens content cache
- (instancetype)initWithLensContentMaxSize:(NSUInteger)lensContentMaxSize NS_DESIGNATED_INITIALIZER;

@end

NS_SWIFT_NAME(LensesConfig)
/// Concrete class to configure all available, user-configurable properties within the lenses component
@interface SCCameraKitLensesConfig : NSObject

/// Cache config instance to configure cache properties
@property (nonatomic, strong, readonly) SCCameraKitCacheConfig *cacheConfig;

/// Init with cache config instance
/// @param cacheConfig cache config instance
- (instancetype)initWithCacheConfig:(SCCameraKitCacheConfig *)cacheConfig NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

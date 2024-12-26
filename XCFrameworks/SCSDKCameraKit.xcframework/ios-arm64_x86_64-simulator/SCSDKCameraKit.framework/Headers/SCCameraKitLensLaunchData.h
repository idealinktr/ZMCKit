//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitErrorHandler;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LensLaunchData)
/// An opaque protocol used to pass launch data to processor when applying lens
@protocol SCCameraKitLensLaunchData <NSObject>

@end

NS_SWIFT_NAME(LensLaunchDataBuilder)
/// Concrete class to build lens launch data to pass to processor when applying
@interface SCCameraKitLensLaunchDataBuilder : NSObject

/// Builds and get launch data from current builder state
@property (nonatomic, strong, readonly, nullable) id<SCCameraKitLensLaunchData> launchData;

/// Add number key-value pair to launch data
/// @param value number value
/// @param key key for value
- (void)addNumber:(NSNumber *)value forKey:(NSString *)key NS_SWIFT_NAME(add(number:key:));

/// Add number array key-value pair to launch data
/// @param value number array value
/// @param key key for value
- (void)addNumberArray:(NSArray<NSNumber *> *)value forKey:(NSString *)key NS_SWIFT_NAME(add(numberArray:key:));

/// Add string key-value pair to launch data
/// @param value string value
/// @param key key for value
- (void)addString:(NSString *)value forKey:(NSString *)key NS_SWIFT_NAME(add(string:key:));

/// Add string array key-value pair to launch data
/// @param value string array value
/// @param key key for value
- (void)addStringArray:(NSArray<NSString *> *)value forKey:(NSString *)key NS_SWIFT_NAME(add(stringArray:key:));

/// Removes key-value pair from launch data
/// @param key key for value to remove
- (void)removeValueForKey:(NSString *)key NS_SWIFT_NAME(removeValue(key:));

@end

NS_SWIFT_NAME(EmptyLensLaunchData)
/// Final, opaque data class to reset persisted launch data
@interface SCCameraKitEmptyLensLaunchData : NSObject <SCCameraKitLensLaunchData>

@end

NS_ASSUME_NONNULL_END

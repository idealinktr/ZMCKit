//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Protocol to interface with preferences stored by CameraKit
/// This interface is intentionally opaque and should only be used to clear out stored preferences
@protocol SCCameraKitPreferences <NSObject>

/// Clear all stored preferences
- (void)clear;

@end

NS_ASSUME_NONNULL_END

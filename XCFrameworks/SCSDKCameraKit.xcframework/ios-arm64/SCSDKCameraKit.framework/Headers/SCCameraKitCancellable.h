//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Cancellable)
/// Describes the interface used to cancel an ongoing operation
@protocol SCCameraKitCancellable <NSObject>

/// Cancel the ongoing operation if it's in progress
- (void)cancel;

@end

NS_ASSUME_NONNULL_END


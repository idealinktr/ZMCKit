//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A special case is a protocol for allowing CameraKit to reconcile the needs of multiple outputs.
/// This is a support protocol underlying SCCameraKitOutputRequiringPixelBuffer and SCCameraKitOutputViewportProviding
/// You should not implement this protocol directly.
@protocol SCCameraKitOutputSpecialCase <NSObject>

@end

NS_ASSUME_NONNULL_END

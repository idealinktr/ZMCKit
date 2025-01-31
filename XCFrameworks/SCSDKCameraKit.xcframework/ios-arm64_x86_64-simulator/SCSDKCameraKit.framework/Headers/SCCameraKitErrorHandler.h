//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ErrorHandler)
/// Describes an interface to handler errors and exceptions related to CameraKit
@protocol SCCameraKitErrorHandler

/// Handle error thrown by CameraKit
/// @param error exception thrown by CameraKit
- (void)handleError:(NSException *)error;

@end

NS_ASSUME_NONNULL_END

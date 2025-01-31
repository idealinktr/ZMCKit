//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Reported when `SCCameraKitClientID` in `Info.plist` is missing or invalid.
FOUNDATION_EXPORT NSString *const SCCameraKitExceptionUnauthorized;

/// Reported when backend fails to authenticate client.
/// This could be due to numerous different reasons, one of the most common is due to having an invalid system date and
/// time settings.
FOUNDATION_EXPORT NSString *const SCCameraKitExceptionInvalidApplicationState;

/// Reported when trying to pass an invalid lens class that's different than the internal ones we support.
FOUNDATION_EXPORT NSString *const SCCameraKitExceptionInvalidLens;

/// Reported when trying to draw an invalid texture class that's different than the internal ones we support.
FOUNDATION_EXPORT NSString *const SCCameraKitExceptionInvalidTexture;

/// Reported whne processing fails due to a lens error. Lens errors are normally caused by
/// dynamic scripting errors or missing resources in lens bundle.
FOUNDATION_EXPORT NSString *const SCCameraKitExceptionProcessingLensFailure;

/// Reported when processing fails due to an internal error. Cause of such errors can be bugs in the
/// lenses processing engine or resource (memory, disk) exhaustion.
FOUNDATION_EXPORT NSString *const SCCameraKitExceptionProcessingInternalFailure;

NS_ASSUME_NONNULL_END

//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitLens;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LensHintProvider)
/// Describes an interface used to provide lens hint localizations from hint ids
@protocol SCCameraKitLensHintProvider <NSObject>

/// Get localized hint for hint id
/// @param hintId unique id for lens hint
/// @param lens lens instance which the hint belongs to
- (nullable NSString *)localizedHintForHintId:(NSString *)hintId
                                         lens:(id<SCCameraKitLens>)lens NS_SWIFT_NAME(localizedHint(for:lens:));

@end

NS_ASSUME_NONNULL_END

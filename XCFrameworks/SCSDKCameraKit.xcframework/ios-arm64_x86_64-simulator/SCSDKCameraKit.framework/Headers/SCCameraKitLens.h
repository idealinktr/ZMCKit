//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Describes all posible facings (inversely relative to the user) that a lens can be designed for.
typedef NS_ENUM(NSInteger, SCCameraKitLensFacingPreference) {
    SCCameraKitLensFacingPreferenceNone = 0,  // Lens has no preferred facing
    SCCameraKitLensFacingPreferenceFront = 1, // Lens prefers front facing
    SCCameraKitLensFacingPreferenceBack = 2   // Lens prefers back facing
} NS_SWIFT_NAME(LensFacingPreference);

NS_SWIFT_NAME(LensPreview)
/// Describes an interface that contains lens preview data
@protocol SCCameraKitLensPreview <NSObject>

/// URL for image preview
@property (copy, nonatomic, readonly, nullable) NSURL *imageUrl;

@end

NS_SWIFT_NAME(LensSnapcodes)
/// Describes an interface that contains lens snapcodes data
@protocol SCCameraKitLensSnapcodes <NSObject>

/// Image URL for Snapcode
@property (copy, nonatomic, readonly, nullable) NSURL *imageUrl;

/// Deeplink URL for Snapcode
@property (copy, nonatomic, readonly, nullable) NSURL *deeplink;

@end

NS_SWIFT_NAME(Lens)
/// Describes a lens object.
@protocol SCCameraKitLens <NSObject>

/// A unique identifier for the lens.
@property (copy, nonatomic, readonly) NSString *identifier NS_SWIFT_NAME(id);

/// A unique identifier for the group that the lens belongs to
@property (copy, nonatomic, readonly) NSString *groupIdentifier NS_SWIFT_NAME(groupId);

/// The name for the lens
@property (copy, nonatomic, readonly, nullable) NSString *name;

/// URL for icon image
@property (copy, nonatomic, readonly, nullable) NSURL *iconUrl;

/// Lens preview instance
@property (strong, nonatomic, readonly) id<SCCameraKitLensPreview> preview;

/// Extra metadata provided from vendor
@property (copy, nonatomic, readonly) NSDictionary<NSString *, NSString *> *vendorData;

/// Specifies which facing a lens is designed for.
@property (nonatomic, assign, readonly) SCCameraKitLensFacingPreference facingPreference;

/// Lens Snapcodes instance
@property (strong, nonatomic, readonly) id<SCCameraKitLensSnapcodes> snapcodes;

@end

NS_ASSUME_NONNULL_END

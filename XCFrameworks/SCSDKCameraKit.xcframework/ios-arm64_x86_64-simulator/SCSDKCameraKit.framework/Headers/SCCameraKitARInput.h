//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <SCSDKCameraKit/SCCameraKitInput.h>

@class ARSession;
@class ARAnchor;
@class ARConfiguration;
@protocol ARSessionDelegate;
typedef NS_OPTIONS(NSUInteger, ARSessionRunOptions);

NS_ASSUME_NONNULL_BEGIN

@protocol SCCameraKitARInput;

NS_SWIFT_NAME(ARInputDelegate)
/// Propogates ARKit session delegate methods back to CameraKit.
/// If you implement your own AR Input, you _MUST_ call these methods when their corresponding ARKit delegate methods
/// are called.
@protocol SCCameraKitARInputDelegate

/// Method to call when the input receives session:didAddAnchors:
/// @param input the sending input
/// @param anchors the anchors passed to the delegate
- (void)input:(id<SCCameraKitARInput>)input didAddAnchors:(NSArray<ARAnchor *> *)anchors;

/// Method to call when the input receives session:didUpdateAnchors:
/// @param input the sending input
/// @param anchors the anchors passed to the delegate
- (void)input:(id<SCCameraKitARInput>)input didUpdateAnchors:(NSArray<ARAnchor *> *)anchors;

/// Method to call when the input receives session:didRemoveAnchors:
/// @param input the sending input
/// @param anchors the anchors passed to the delegate
- (void)input:(id<SCCameraKitARInput>)input didRemoveAnchors:(NSArray<ARAnchor *> *)anchors;

@end

NS_SWIFT_NAME(ARInput)

/// Describes a source of AR data for CameraKit.
@protocol SCCameraKitARInput <SCCameraKitInput>

/// The managed ARSession.
@property (nonatomic, strong, readonly) ARSession *session;

/// The intermediate destination for ARKit delegate methods. See the protocol definition for more details.
/// This property should _NOT_ be set directly. CameraKit will assign this as appropriate.
@property (nonatomic, weak) id<SCCameraKitARInputDelegate> arDelegate;

/// The ARConfiguration to use when using the front camera.
/// @warning if your app supports lenses with true sizing, you MUST return an instance of ARFaceTrackingConfiguration
/// (additionally, we recommend setting the number of tracked faces to 0)
/// @note this is nil by default, as adding ARFaceTrackingConfiguration will subject your app to additional app review,
/// concerning your usage of the TrueDepth camera.
@property (nonatomic, strong, readonly) ARConfiguration *frontCameraConfiguration;

/// Runs the session with the provided configuration and options.
- (void)runWithConfiguration:(ARConfiguration *)configuration
                     options:(ARSessionRunOptions)options NS_SWIFT_NAME(run(_:options:));

/// Pauses the session.
- (void)pause;

@end

NS_ASSUME_NONNULL_END

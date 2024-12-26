
#import <SCSDKCameraKit/SCCameraKitOutputSpecialCase.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCCameraKitOutputRequiringPixelBuffer;

/// Delegate to receive notification or requirement changes.
@protocol SCCameraKitOutputRequiringPixelBufferDelegate <NSObject>

/// Notifies the resolver that the output has changed its requirements
/// @param output the output whose requirements have changed
- (void)outputChangedRequirements:(id<SCCameraKitOutputRequiringPixelBuffer> _Nonnull)output;

@end

NS_SWIFT_NAME(OutputRequiringPixelBuffer)
/// Indicates that the conformer will require pixel buffer output. This incurs performance overhead, so do not use it
/// unless you require it.
/// @note This incurs performance overhead, so do not add outputs requiring this unless you need to.
@protocol SCCameraKitOutputRequiringPixelBuffer <SCCameraKitOutputSpecialCase>

/// Whether the output is currently requiring pixel buffer output. Any custom implementers of this must call
/// outputChangedRequirements: after modifying this property.
@property (assign, nonatomic) BOOL currentlyRequiresPixelBuffer;

/// A delegate to receive notifications of changes
/// @note The resolver will automatically set this propety
@property (weak, nonatomic, nullable) id<SCCameraKitOutputRequiringPixelBufferDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

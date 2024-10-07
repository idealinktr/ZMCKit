//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AgreementsPresentationContextProvider)
/// Describes an interface to provide presentation context for CameraKit to present agreements.
@protocol SCCameraKitAgreementsPresentationContextProvider <NSObject>

/// The view controller to present the agreements view controller from.
@property (readonly, nonatomic, strong) UIViewController *viewControllerForPresentingAgreements;

/// Requests that the view controller passed be dismissed, with acceptance status.
/// @param agreementsViewController the view controller to dismiss.
/// @param accepted whether or not the user accepted all the agreements presented.
/// @warning the implementer of this protocol is responsible for dismissing the view controller.
- (void)dismissAgreementsViewController:(UIViewController *)agreementsViewController accepted:(BOOL)accepted;

@end

NS_ASSUME_NONNULL_END

//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

@protocol SCCameraKitAgreementSet;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AgreementsStore)
/// Protocol describing the CameraKit agreements store.
/// @warning DO NOT attempt to directly use this protocol. Attempting to do so WILL CAUSE YOUR APP TO CRASH. Use
/// SCCameraKitAgreementsPresentationContextProvider to define how CameraKit will show agreements on your behalf.
@protocol SCCameraKitAgreementsStore <NSObject>

@property (readonly, nonatomic) BOOL requiresNewAgreementAcceptance;
@property (readonly, nonatomic) BOOL childrenProtectionActRestricted;
@property (readonly, nonatomic) id<SCCameraKitAgreementSet> newestAvailableAgreements;
- (void)acceptAgreements:(id<SCCameraKitAgreementSet>)agreements;
- (void)declineAgreements:(id<SCCameraKitAgreementSet>)agreements;

@end

NS_ASSUME_NONNULL_END

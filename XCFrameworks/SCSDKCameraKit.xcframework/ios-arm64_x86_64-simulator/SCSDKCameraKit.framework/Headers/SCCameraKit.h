//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@protocol SCCameraKitLensesComponent;
@protocol SCCameraKitOutput;
@protocol SCCameraKitLensProcessor;
@protocol SCCameraKitLensHintDelegate;
@protocol SCCameraKitLensUIEventsDelegate;
@protocol SCCameraKitInput;
@protocol SCCameraKitARInput;
@protocol SCCameraKitErrorHandler;
@class SCCameraKitDataProviderComponent;
@class SCCameraKitLensesConfig;
@class SCCameraKitSessionConfig;
@protocol SCCameraKitAgreementsPresentationContextProvider;
@protocol SCCameraKitAgreementsStore;
@protocol SCCameraKitTextInputContextProvider;
@protocol SCCameraKitAdjustmentsComponent;
@protocol SCCameraKitCachesManager;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(CameraKitVersion)
/// Short CameraKit version (ie 1.8.0)
FOUNDATION_EXPORT NSString *const SCCameraKitVersion;

NS_SWIFT_NAME(CameraKitLensCoreVersion)
/// LensCore version (ie 243)
FOUNDATION_EXPORT NSInteger const SCCameraKitLensCoreVersion;

NS_SWIFT_NAME(CameraKitProtocol)
@protocol SCCameraKitProtocol <NSObject>

/// Contains lenses related objects.
@property (strong, nonatomic, readonly) id<SCCameraKitLensesComponent> lenses;

/// Contains adjustment related objects.
@property (strong, nonatomic, readonly) id<SCCameraKitAdjustmentsComponent> adjustments;

/// Begin processing input frames with front camera position and portrait video orientation
/// @param input the input to configure.
/// @param arInput the ARKit input to configure.
- (void)startWithInput:(id<SCCameraKitInput>)input
               arInput:(id<SCCameraKitARInput>)arInput NS_SWIFT_NAME(start(input:arInput:));

/// Deprecated. Use
/// -startWithInput:arInput:cameraPosition:videoOrientation:dataProvider:hintDelegate:agreementsPresentationContextProvider:
- (void)startWithInput:(id<SCCameraKitInput>)input
               arInput:(id<SCCameraKitARInput>)arInput
        cameraPosition:(AVCaptureDevicePosition)cameraPosition
      videoOrientation:(AVCaptureVideoOrientation)videoOrientation
          dataProvider:(SCCameraKitDataProviderComponent *)dataProvider
          hintDelegate:(id<SCCameraKitLensHintDelegate>)hintDelegate __attribute__((deprecated));

/// Deprecated. Use
/// -startWithInput:arInput:cameraPosition:videoOrientation:dataProvider:hintDelegate:textInputContextProvider:agreementsPresentationContextProvider:
- (void)startWithInput:(id<SCCameraKitInput>)input
                                  arInput:(id<SCCameraKitARInput>)arInput
                           cameraPosition:(AVCaptureDevicePosition)cameraPosition
                         videoOrientation:(AVCaptureVideoOrientation)videoOrientation
                             dataProvider:(nullable SCCameraKitDataProviderComponent *)dataProvider
                             hintDelegate:(nullable id<SCCameraKitLensHintDelegate>)hintDelegate
    agreementsPresentationContextProvider:
        (nullable id<SCCameraKitAgreementsPresentationContextProvider>)agreementsPresentationContextProvider
    NS_SWIFT_NAME(start(input:arInput:cameraPosition:videoOrientation:dataProvider:hintDelegate:agreementsPresentationContextProvider:))
        __attribute__((deprecated));
;

/// Begin processing input frames.
/// @param input the input to configure.
/// @param arInput the ARKit input to configure.
/// @param cameraPosition the camera position in use
/// @param videoOrientation the orientation for the outputted video buffers
/// @param dataProvider data provider component to pass in custom data providers (optional -- will create and handle
/// data providers by default if nil)
/// @param hintDelegate lens hint delegate to show/hide hints for applied lenses
/// @param textInputContextProvider context provider for providing keyboard access to lenses
/// @param agreementsPresentationContextProvider context provider for presenting agreements screens
- (void)startWithInput:(id<SCCameraKitInput>)input
                                  arInput:(id<SCCameraKitARInput>)arInput
                           cameraPosition:(AVCaptureDevicePosition)cameraPosition
                         videoOrientation:(AVCaptureVideoOrientation)videoOrientation
                             dataProvider:(nullable SCCameraKitDataProviderComponent *)dataProvider
                             hintDelegate:(nullable id<SCCameraKitLensHintDelegate>)hintDelegate
                 textInputContextProvider:(nullable id<SCCameraKitTextInputContextProvider>)textInputContextProvider
    agreementsPresentationContextProvider:
        (nullable id<SCCameraKitAgreementsPresentationContextProvider>)agreementsPresentationContextProvider
    NS_SWIFT_NAME(start(input:arInput:cameraPosition:videoOrientation:dataProvider:hintDelegate:textInputContextProvider:agreementsPresentationContextProvider:));

/// Begin processing input frames.
/// @param input the input to configure.
/// @param arInput the ARKit input to configure.
/// @param cameraPosition the camera position in use
/// @param videoOrientation the orientation for the outputted video buffers
/// @param dataProvider data provider component to pass in custom data providers (optional -- will create and handle
/// data providers by default if nil)
/// @param hintDelegate lens hint delegate to show/hide hints for applied lenses
/// @param textInputContextProvider context provider for providing keyboard access to lenses
/// @param agreementsPresentationContextProvider context provider for presenting agreements screens
/// @param lensUIEventsDelegate delegate to handle UI events from applied lenses
- (void)startWithInput:(id<SCCameraKitInput>)input
                                  arInput:(id<SCCameraKitARInput>)arInput
                           cameraPosition:(AVCaptureDevicePosition)cameraPosition
                         videoOrientation:(AVCaptureVideoOrientation)videoOrientation
                             dataProvider:(nullable SCCameraKitDataProviderComponent *)dataProvider
                             hintDelegate:(nullable id<SCCameraKitLensHintDelegate>)hintDelegate
                 textInputContextProvider:(nullable id<SCCameraKitTextInputContextProvider>)textInputContextProvider
    agreementsPresentationContextProvider:
        (nullable id<SCCameraKitAgreementsPresentationContextProvider>)agreementsPresentationContextProvider
                     lensUIEventsDelegate:(nullable id<SCCameraKitLensUIEventsDelegate>)lensUIEventsDelegate
    NS_SWIFT_NAME(start(input:arInput:cameraPosition:videoOrientation:dataProvider:hintDelegate:textInputContextProvider:agreementsPresentationContextProvider:lensUIEventsDelegate:));

/// End processing input frames.
- (void)stop;

/// End processing input frames.
/// @param completion Block to be called after processing is finished and session is stopped
- (void)stopWithCompletion:(nullable void (^)(void))completion NS_SWIFT_NAME(stop(completion:));

/// Add an output. Frames will still be processed if no outputs exist.
- (void)addOutput:(id<SCCameraKitOutput>)output NS_SWIFT_NAME(add(output:));

/// Remove an output.
- (void)removeOutput:(id<SCCameraKitOutput>)listener NS_SWIFT_NAME(remove(output:));

/// The camera position in use. Setting will automatically update the input.
@property (nonatomic, assign) AVCaptureDevicePosition cameraPosition;

/// The orientation for the outputted video buffers
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

/// The active input. May be either standard camera input or the AR input, depending on lens requirements.
@property (nonatomic, readonly) id<SCCameraKitInput> activeInput;

/// Store containing information above the acceptance state of terms of service
@property (nonatomic, readonly) id<SCCameraKitAgreementsStore> agreementsStore;

/// Presents any agreements such as Terms of Service or Privacy Policy for CameraKit immediately, if needed.
/// @note CameraKit will present this when the user applies a lens if they have new agreements to accept. You can call
/// this explicitly if you wish to present the terms before then (eg during an onboarding experience, alongside your own
/// app's Terms of Service)
- (void)presentAgreementsImmediately;

/// Registers an extension with CameraKit.
/// @param extension the extension to register.
/// @param completion Callback on completion with success or error on failure.
- (void)registerExtension:(id)extension completion:(void (^ _Nullable)(BOOL success, NSError * _Nullable error))completion NS_SWIFT_NAME(register(_:completion:));

/// Provides access to the caches manager for managing and freeing disk space.
///
/// Use this property to interact with cache-related functionality, such as clearing
/// cached resources and querying cache statistics.
@property (strong, nonatomic, readonly) id<SCCameraKitCachesManager> caches;

@end

NS_SWIFT_NAME(Session)
/// CameraKit handles interaction with the camera and contains several components like lenses.
@interface SCCameraKitSession : NSObject <SCCameraKitProtocol>

/// Init with session and lenses config instance to configure properties within lenses component
/// @param sessionConfig session config to configure session with application id and api token
/// @param lensesConfig lenses config to configure lenses component such as caches
/// @param errorHandler optional error handler instance to handle exceptions thrown by CameraKit
/// @param initializationExtensions extensions that should be registered to the session on initialization.
/// @note Only add extensions that are specifically designed for session initialization.
///       This requirement should be explicitly mentioned in the extension's documentation.
- (instancetype)initWithSessionConfig:(nullable SCCameraKitSessionConfig *)sessionConfig
                         lensesConfig:(SCCameraKitLensesConfig *)lensesConfig
                         errorHandler:(nullable id<SCCameraKitErrorHandler>)errorHandler
             initializationExtensions:(nullable NSArray<id> *)initializationExtensions;

/// Init with session and lenses config instance to configure properties within lenses component
/// @param sessionConfig session config to configure session with application id and api token
/// @param lensesConfig lenses config to configure lenses component such as caches
/// @param errorHandler optional error handler instance to handle exceptions thrown by CameraKit
- (instancetype)initWithSessionConfig:(nullable SCCameraKitSessionConfig *)sessionConfig
                         lensesConfig:(SCCameraKitLensesConfig *)lensesConfig
                         errorHandler:(nullable id<SCCameraKitErrorHandler>)errorHandler;

/// Init with lenses config instance to configure properties within lenses component
/// @param lensesConfig lenses config to configure lenses components such as caches
/// @param errorHandler optional error handler instance to handle exceptions thrown by CameraKit
- (instancetype)initWithLensesConfig:(SCCameraKitLensesConfig *)lensesConfig
                        errorHandler:(nullable id<SCCameraKitErrorHandler>)errorHandler;

@end

NS_ASSUME_NONNULL_END

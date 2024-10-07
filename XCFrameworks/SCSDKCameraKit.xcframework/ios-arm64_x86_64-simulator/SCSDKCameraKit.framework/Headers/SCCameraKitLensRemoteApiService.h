//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCCameraKitLens;

/// Describes the status of the response sent to the lens.
typedef NS_ENUM(NSInteger, SCCameraKitLensRemoteApiResponseStatus) {
    /// Request succeeded.
    SCCameraKitLensRemoteApiResponseStatusSuccess,
    /// Request was redirected.
    SCCameraKitLensRemoteApiResponseStatusRedirected,
    /// Invalid request.
    SCCameraKitLensRemoteApiResponseStatusBadRequest,
    /// Caller doesn't have permission to access resource.
    SCCameraKitLensRemoteApiResponseStatusAccessDenied,
    /// Resource not found.
    SCCameraKitLensRemoteApiResponseStatusNotFound,
    /// Request timed out.
    SCCameraKitLensRemoteApiResponseStatusTimeout,
    /// Request too large.
    SCCameraKitLensRemoteApiResponseStatusRequestTooLarge,
    /// Internal service error.
    SCCameraKitLensRemoteApiResponseStatusInternalServiceError,
    /// Request cancelled by caller.
    SCCameraKitLensRemoteApiResponseStatusCancelled,
} NS_SWIFT_NAME(SCCameraKitLensRemoteApiResponseStatus);

/// Describes the status of the call for the request handled by a remote api service.
typedef NS_ENUM(NSInteger, SCCameraKitLensRemoteApiServiceCallStatus) {
    /// Request was ignored typically due to a remote api service not interested in handling such request to allow other
    /// services to handle the same request.
    SCCameraKitLensRemoteApiServiceCallStatusIgnored,
    /// Request was received but one or more responses are yet to be sent.
    SCCameraKitLensRemoteApiServiceCallStatusOngoing,
    /// Request was received and a single response was sent indicating that the call is complete.
    SCCameraKitLensRemoteApiServiceCallStatusAnswered,
} NS_SWIFT_NAME(LensRemoteApiServiceCallStatus);

NS_SWIFT_NAME(LensRemoteApiRequest)
/// Describes the remote api service request sent by a lens.
@protocol SCCameraKitLensRemoteApiRequest <NSObject>

/// Unique id of the request.
@property (nonatomic, copy, readonly) NSString *requestId;

/// Unique id of the remote API service specification.
@property (nonatomic, copy, readonly) NSString *apiSpecId;

/// Unique id of the remote API service endpoint requested by this request.
@property (nonatomic, copy, readonly) NSString *endpointId;

/// A map of named parameters associated with the request.
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *parameters;

/// Additional request payload as bytes.
@property (nonatomic, copy, readonly) NSData *body;

@end

NS_SWIFT_NAME(LensRemoteApiResponseProtocol)
/// Describes the remote api service response to a request sent by a lens.
@protocol SCCameraKitLensRemoteApiResponse <NSObject>

/// Remote api service request sent by a lens.
@property (nonatomic, strong, readonly) id<SCCameraKitLensRemoteApiRequest> request;

/// Status of the response.
@property (nonatomic, assign, readonly) SCCameraKitLensRemoteApiResponseStatus status;

/// A map of named metadata associated with the response.
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *metadata;

/// Additional response payload as bytes.
@property (nonatomic, copy, readonly, nullable) NSData *body;

@end

NS_SWIFT_NAME(LensRemoteApiResponse)
/// Concrete data class for the remote api service response to a request sent by a lens.
@interface SCCameraKitLensRemoteApiResponse : NSObject <SCCameraKitLensRemoteApiResponse>

/// Designated init to pass in required properties for the response.
/// @param request Remote api service request sent by a lens.
/// @param status Status of the response.
/// @param metadata A map of named metadata associated with the response.
/// @param body Additional response payload as bytes.
- (instancetype)initWithRequest:(id<SCCameraKitLensRemoteApiRequest>)request
                         status:(SCCameraKitLensRemoteApiResponseStatus)status
                       metadata:(NSDictionary<NSString *, NSString *> *)metadata
                           body:(nullable NSData *)body NS_DESIGNATED_INITIALIZER;

/// Use designated init to pass in required properties
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_SWIFT_NAME(LensRemoteApiServiceCall)
/// Describes the call that is sent in response to a remote api request sent by a lens.
@protocol SCCameraKitLensRemoteApiServiceCall <NSObject>

/// The status of the call associated with the request.
@property (nonatomic, assign, readonly) SCCameraKitLensRemoteApiServiceCallStatus status;

/// Cancel the request call. This is usually sent if the lens no longer needs a response to the remote api request it
/// sent or if the lens is no longer active all active requests/calls should be cancelled.
- (void)cancelRequest;

@end

NS_SWIFT_NAME(LensRemoteApiService)
/// Describes a remote api service used to process requests sent by a lens.
@protocol SCCameraKitLensRemoteApiService <NSObject>

/// Process the remote api request sent by a lens. Returns a call associated with the request.
/// @param request The remote api request sent by a lens.
/// @param responseHandler Callback to send responses back to the lens who sent the remote api request.
- (id<SCCameraKitLensRemoteApiServiceCall>)processRequest:(id<SCCameraKitLensRemoteApiRequest>)request
                                          responseHandler:
                                              (void (^)(SCCameraKitLensRemoteApiServiceCallStatus,
                                                        id<SCCameraKitLensRemoteApiResponse>))responseHandler;

@end

NS_SWIFT_NAME(LensRemoteApiServiceProvider)
/// Describes an interface to provide remote api services for specific lenses and api spec identifiers.
@protocol SCCameraKitLensRemoteApiServiceProvider <NSObject>

/// The set of api spec identifiers that this provider supports.
@property (nonatomic, copy, readonly) NSSet<NSString *> *supportedApiSpecIds;

/// Returns the remote api service used for processing requests sent by the lens.
/// Lifecycle of the remote api service will be tied to the lifecycle of the lens.
/// @param lens The active lens whose requests the remote api service will be processing.
- (id<SCCameraKitLensRemoteApiService>)remoteApiServiceForLens:(id<SCCameraKitLens>)lens;

@end

NS_ASSUME_NONNULL_END

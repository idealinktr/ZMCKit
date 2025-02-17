//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(LensHttpRequest)
/// Represents an HTTP request that originates within a lens.
@interface SCCameraKitLensHttpRequest : NSObject

/// The unique id of the HTTP request.
@property (nonatomic, readonly) NSString *id;

/// The id of the lens that originated the request.
@property (nonatomic, readonly) NSString *lensId;

/// The URL request that represents the HTTP request.
@property (nonatomic, readonly) NSURLRequest *urlRequest;

/// Initializes the lens HTTP request with the given id, lens id and URL request.
- (instancetype)initWithId:(NSString *)id
                    lensId:(NSString *)lensId
                urlRequest:(NSURLRequest *)urlRequest NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end


NS_SWIFT_NAME(LensHttpHandler)
/// Provides ability to handle HTTP requests that originate within lenses.
@protocol SCCameraKitLensHttpHandler <NSObject>

/// Performs tjhe given HTTP request and calls the completion block when the request is complete.
- (void)performRequest:(SCCameraKitLensHttpRequest *)lensHttpRequest
            completion:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END

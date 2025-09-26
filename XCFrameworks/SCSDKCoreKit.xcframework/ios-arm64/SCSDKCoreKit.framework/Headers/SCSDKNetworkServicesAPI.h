//
//  SCSDKNetworkServicesAPI.h
//  SCSDKNetworking
//
//  Created by Duncan Riefler on 2/25/20.
//

#import "SCSDKCertPinningHandler.h"

#import <Foundation/Foundation.h>

typedef void (^SCSDKNetworkRequestCompletionCallback)(NSData *_Nullable data, NSHTTPURLResponse *_Nullable response,
                                                      NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface SCSDKNetworkServicesAPI : NSObject <NSURLSessionDelegate>

- (instancetype)initWithNSURLSession:(NSURLSession *_Nonnull)sessionConfiguration
                  certPinningHandler:(id<SCSDKCertPinningHandler>)certPinningHandler;

- (void)submitRequest:(NSURLRequest *_Nonnull)request completion:(SCSDKNetworkRequestCompletionCallback)callback;

@end

NS_ASSUME_NONNULL_END

//
//  SCSDKCertPinningHandler.h
//  SCSDKNetworking
//
//  Created by Duncan Riefler on 2/24/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCSDKCertPinningHandler <NSObject>

- (BOOL)isPinningEnabledHost:(NSString *)host;

- (void)didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
          completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                                      NSURLCredential *credential))completionHandler;

@end

@interface SCSDKCertPinningHandler : NSObject <SCSDKCertPinningHandler>

@end

NS_ASSUME_NONNULL_END

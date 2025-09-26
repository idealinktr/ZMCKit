//
//  SCSDKCertificateTrust.h
//  SCSDKNetworking
//
//  Created by Duncan Riefler on 2/24/20.
//

#import <Foundation/Foundation.h>

BOOL abc1(SecTrustRef serverTrust);

@interface SCSDKCertificateTrust : NSObject

+ (void)didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
          completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                                      NSURLCredential *credential))completionHandler;
+ (NSSet<NSData *> *)pinnedCertsPublicKeyHashes;
+ (NSDate *)certsExpirationDate;
+ (NSString *)def1;

@end

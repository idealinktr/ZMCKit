//
//  NSError+Helpers.h
//  SCSDKCoreKit
//
//  Copyright © 2017 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kSCOAuth2ClientLogoutError;
extern NSInteger const kSCSDKNSErrorStatusCodeUnknown;

@interface NSError (Helpers)

@property (nonatomic, readonly) NSInteger statusCode;

+ (instancetype)scsdk_errorWithStatusCode:(NSInteger)statusCode
                              description:(NSString *)description
                                   reason:(NSString *)reason;

+ (instancetype)scsdk_logoutErrorWithReason:(NSString *)reason;

@end

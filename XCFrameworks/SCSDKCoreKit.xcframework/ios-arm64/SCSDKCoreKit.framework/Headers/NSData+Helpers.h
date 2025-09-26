//
//  NSData+Helpers.h
//  SCSDKCoreKit
//
//  Copyright © 2017 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Helpers)

+ (instancetype)scsdk_dataWithBase64EncodedString:(NSString *)base64EncodedString;

+ (instancetype)scsdk_dataWithBase64UrlEncodedString:(NSString *)base64UrlEncodedString;

+ (instancetype)scsdk_randomDataWithSize:(size_t)size;

- (NSString *)scsdk_base64EncodedString;

/**
 * Variant of base64 that is url safe.
 * see https://tools.ietf.org/html/rfc7515#appendix-C for conversion between formats.
 */
- (NSString *)scsdk_base64UrlEncodedString;
- (NSString *)scsdk_md5Base64String;
- (NSString *)scsdk_sha256Base64String;
- (NSString *)scsdk_sha256Base64Url;
- (NSString *)scsdk_sha256HexBase64String;

@end

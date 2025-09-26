//
//  NSString+Helpers.h
//  SCSDKCoreKit
//
//  Copyright © 2017 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helpers)

+ (NSString *)scsdk_urlEncodeString:(NSString *)string;

+ (NSString *)scsdk_randomUrlSafeStringWithSize:(NSUInteger)size;

+ (NSString *)scsdk_randomBase64EncodedStringOfLength:(size_t)length;

@end

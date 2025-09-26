//
//  NSData+Helpers.h
//  SCSDKNetworking
//
//  Created by Duncan Riefler on 2/24/20.
//

#import <Foundation/Foundation.h>

@interface NSData (HelpersNew)

+ (instancetype)scsdk_dataWithBase64EncodedStringNew:(NSString *)base64EncodedString;

+ (instancetype)scsdk_dataWithBase64UrlEncodedStringNew:(NSString *)base64UrlEncodedString;

@end

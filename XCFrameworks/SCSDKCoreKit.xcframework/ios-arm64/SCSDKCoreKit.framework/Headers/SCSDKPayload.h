//
//  SCSDKPayload.h
//  SCSDKCoreKit
//
//  Copyright © 2017 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSDKPayload : NSObject

+ (NSString *)serializePayload:(NSData *)payload;

@end

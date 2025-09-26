//
//  NSDate+Helpers.h
//  SCSDKCoreKit
//
//  Copyright © 2017 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

+ (long long)scsdk_currentTimeMillis;
- (int)scsdk_getMonth;

@end

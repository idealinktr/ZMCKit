//
//  SCSDKSkateUtility.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 7/9/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCSDKSkateUtility : NSObject

+ (int)getLoginKitInstalledVersion;
+ (int)getCreativeKitInstalledVersion;
+ (BOOL)accessTokenExists;

@end

NS_ASSUME_NONNULL_END

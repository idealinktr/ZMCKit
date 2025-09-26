//
//  SCSDKSkateManager+Private.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 7/9/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/SCSDKSkateManager.h>
#import <SCSDKCoreKit/Skate.h>

#import <Foundation/Foundation.h>

@class LoginRouteWrapper;

@interface SCSDKSkateManager (VisibleForTesting)

- (NSArray *)_installedKits;
- (NSString *)_kitVersionJson;
- (LoginRouteWrapper *)_loginRoute;
- (void)_recordSkateEvent;
- (void)_updateSkateDate:(NSDate *)date;
- (BOOL)_shouldRecordSkateEvent;
- (double)_skateConfigSampleRate;
- (BOOL)_isFirstWithinMonth;
- (BOOL)_accessTokenExists;
+ (DailySessionBucket)_dailySessionBucket;

@end

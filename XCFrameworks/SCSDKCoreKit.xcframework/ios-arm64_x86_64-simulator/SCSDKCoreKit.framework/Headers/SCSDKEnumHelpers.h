//
//  SCSDKEnumHelpers.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 6/25/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/CommonEnums.h>
#import <SCSDKCoreKit/Skate.h>

#import <Foundation/Foundation.h>

extern NSString *const KitTypeToString[];
extern NSString *const LoginRouteToString[];
extern NSString *const DailySessionBucketToString[];
extern NSString *stringForKitsArray(NSArray<NSNumber *> *kits);
extern NSString *stringForLoginRoute(LoginRoute loginRoute);
extern NSString *stringForDailySessionBucket(DailySessionBucket dailySessionBucket);

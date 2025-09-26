//
//  NSNotificationCenter+Helpers.h
//  SCSDKCoreKit
//
//  Created by David Xia on 2018-07-03.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *_Nonnull const kSCSDKLoginClientStateChangeNotification = @"kSCSDKLoginClientStateChangeNotification";

@interface NSNotificationCenter (Helpers)

@property (class, nonatomic, strong, readonly, nonnull) NSNotificationCenter *scsdkCenter;

@end

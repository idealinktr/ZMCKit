//
//  SCSDKSkateEventsQueue.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 6/18/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSDKSkate;

NS_ASSUME_NONNULL_BEGIN

@interface SCSDKSkateEventsQueue : NSObject

+ (instancetype)sharedInstance;

- (void)addEvent:(SCSDKSkate *)event;
- (void)clearEvents;

@end

NS_ASSUME_NONNULL_END

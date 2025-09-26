//
//  SCSDKOperationalMetricsQueue.h
//  SCSDKCoreKit
//
//  Created by Hongjai Cho on 5/24/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CounterMetric;
@class TimerMetric;

@interface SCSDKOperationalMetricsQueue : NSObject

+ (instancetype)sharedInstance;

- (void)addCount:(int64_t)count name:(NSString *)name;

- (void)addLatency:(int64_t)latency name:(NSString *)name;

- (void)addLatencyFromTime:(NSTimeInterval)time name:(NSString *)name;

@end

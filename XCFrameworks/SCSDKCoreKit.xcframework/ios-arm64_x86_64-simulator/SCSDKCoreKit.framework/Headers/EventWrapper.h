//
//  EventWrapper.h
//  SCSDKCoreKit
//
//  Created by Hongjai Cho on 9/4/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EncodablePicoproto;

@interface EventWrapper : NSObject <NSSecureCoding>

- (nonnull instancetype)initWithSequenceId:(NSUInteger)sequenceId event:(EncodablePicoproto *_Nonnull)event;

@property (nonatomic, assign, readonly) NSUInteger sequenceId;

@property (nonatomic, strong, readonly, nonnull) EncodablePicoproto *event;

@property (nonatomic, assign, readonly) BOOL isRetry;

@property (nonatomic, assign, readonly) NSUInteger numRetried;

@property (nonatomic, assign, readonly) int64_t nextRetryTimeMillis;

- (void)setSequenceId:(NSUInteger)sequenceId;
- (void)setEvent:(EncodablePicoproto *_Nonnull)event;
- (void)setIsRetry:(bool)isRetry;
- (void)setNumRetried:(NSUInteger)numRetried;
- (void)setNextRetryTimeMillis:(int64_t)nextRetryTimeMillis;

@end

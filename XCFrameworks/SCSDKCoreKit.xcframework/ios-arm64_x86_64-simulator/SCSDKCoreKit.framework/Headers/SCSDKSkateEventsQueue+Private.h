//
//  SCSDKSkateEventsQueue+Private.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 7/27/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/SCSDKPicoprotoHelper.h>
#import <SCSDKCoreKit/SCSDKSkateEventsQueue.h>

@class SCSDKNetworkRequest;
@interface SCSDKSkateEventsQueue (VisibleForTesting)

- (PicoprotoDataConversionDouble)getSampleRateFromData:(nonnull NSData *)data;
- (void)requestDidComplete:(nonnull SCSDKNetworkRequest *)request
                      data:(NSData *_Nullable)data
                 numEvents:(int)eventCount
                     error:(NSError *_Nullable)error
                statusCode:(NSInteger)statusCode;

@end

//
//  SCSDKDynamicConfigManager.h
//  SCSDKCoreKit
//
//  Created by Yang Gao on 8/22/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SCSDKDynamicConfigPullCallback)(BOOL success);

@class SCSDKDynamicConfigEntity;

@interface SCSDKDynamicConfigManager : NSObject

@property (class, nonnull, readonly) SCSDKDynamicConfigManager *shared;

/**
 * Asynchoronously fetch dynamic config from gateway only once in one cold start session. If this method is
 * called for the first time in the current session, it starts the network request and calls completion when
 * it's finished. If the method is called during the network request to fetch configs, it waits until the
 * network request finishes then calls completion. If the method is called after the network request, it calls
 * completion immediately with the status from the network request.
 */
- (void)updateIfNecessary:(SCSDKDynamicConfigPullCallback)completion;
- (SCSDKDynamicConfigEntity *)dynamicConfig:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

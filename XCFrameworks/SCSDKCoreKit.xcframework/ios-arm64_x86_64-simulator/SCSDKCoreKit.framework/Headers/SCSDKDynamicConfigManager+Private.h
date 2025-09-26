//
//  SCSDKDynamicConfigManager+Private.h
//  SCSDKCoreKit
//
//  Created by Yang Gao on 8/23/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//
//

#import <SCSDKCoreKit/SCSDKDynamicConfigManager.h>
#import <SCSDKCoreKit/SCSDKNetworkServicesAPI.h>

#import <Foundation/Foundation.h>

@class SCSDKDynamicConfigArchive;

@interface SCSDKDynamicConfigManager (VisibleForTesting)

- (instancetype)initWithArchive:(SCSDKDynamicConfigArchive *)archive
                     kitVersion:(NSString *)kitVersion
             networkServicesAPI:(SCSDKNetworkServicesAPI *)networkServicesAPI;

@end

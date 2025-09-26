//
//  SCSDKKitPluginHelpers.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 1/15/21.
//  Copyright © 2021 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/KitPluginType.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCSDKKitPluginHelpers : NSObject

+ (KitPluginType)pluginTypeForString:(NSString *)pluginTypeString;
+ (NSString *)stringForPluginType:(KitPluginType)pluginType;

@end

NS_ASSUME_NONNULL_END

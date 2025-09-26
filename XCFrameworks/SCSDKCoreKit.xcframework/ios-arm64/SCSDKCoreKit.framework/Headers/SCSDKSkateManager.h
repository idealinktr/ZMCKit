//
//  SCSDKSkateManager.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 6/25/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/Skate.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCSDKSkateManager : NSObject

- (void)recordSkateOpenEvent;

@property (nonatomic) SnapKitInitType snapKitInitType;
@property (nonatomic) KitPluginType kitPluginType;

@end

NS_ASSUME_NONNULL_END

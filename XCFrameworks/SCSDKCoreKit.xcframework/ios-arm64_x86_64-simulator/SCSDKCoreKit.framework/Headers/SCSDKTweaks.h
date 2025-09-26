//
//  SCSDKTweaksManager.h
//  SCSDKCoreKit
//
//  Created by Yang Gao on 6/26/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSDKTweaks : NSObject

+ (nonnull instancetype)shared;

@property (nonatomic, readonly, nonnull) NSString *snapKitApiBaseUrl;
@property (nonatomic, readonly, nonnull) NSString *canvasApiBaseUrl;
@property (nonatomic, readonly, nonnull) NSString *accountsBaseUrl;
@property (nonatomic, readonly, nullable) NSString *overrideClientId;
@property (nonatomic, readonly, nullable) NSString *bundleId;
@property (nonatomic, readonly, nullable) NSURL *redirectUrl;
@property (nonatomic, readonly, nullable) NSArray<NSString *> *scopes;

@end

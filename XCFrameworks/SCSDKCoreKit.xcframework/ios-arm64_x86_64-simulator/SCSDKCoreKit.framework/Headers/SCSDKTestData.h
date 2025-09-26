//
//  SCSDKTestData.h
//  SCSDKCoreKit
//
//  Created by Yang Gao on 6/23/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSDKTestData : NSObject

@property (nonatomic, readonly, nullable) NSString *oauthAccessToken;

+ (nonnull instancetype)shared;

@end

//
//  SCSDKSetupVerifier.h
//  SCSDKCoreKit
//
//  Created by Tamer Bader on 11/8/21.
//  Copyright © 2021 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSDKSetupVerifier : NSObject

+ (void)verifyCoreKit;
+ (void)verifyLoginKit;
+ (void)verifyCreativeKit;

@end

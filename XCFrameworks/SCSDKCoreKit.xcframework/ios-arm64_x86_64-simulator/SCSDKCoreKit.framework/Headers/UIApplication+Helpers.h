//
//  UIApplication+Helpers.h
//  SCSDKCoreKit
//
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Helpers)

@property (class, nonatomic, readonly) BOOL scsdk_isRTL;
@property (class, nonatomic, readonly, nullable) UIViewController *scsdk_topViewController;

+ (void)scsdk_openURL:(nonnull NSURL *)url completion:(nullable void (^)(BOOL success))completion;

@end

//
//  SCSDKDeepLinker.h
//  SCSDKCoreKit
//
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SafariServices/SafariServices.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCSDKDeepLinkFeature) {
    SCSDKDeepLinkFeatureCamera,
    SCSDKDeepLinkFeatureOAuth,
    SCSDKDeepLinkFeaturePreview,
    SCSDKDeepLinkFeatureToken
};

@interface SCSDKDeepLinker : NSObject

- (instancetype _Nullable)initWithFeature:(SCSDKDeepLinkFeature)feature
                                 metadata:(NSDictionary *_Nullable)metadata
                                  payload:(NSDictionary *_Nullable)payload
                        additionalQueries:(NSDictionary *_Nullable)additionalQueries;

- (void)connectWithFpAuth:(BOOL)withFpAuth completionHandler:(void (^__nullable)(BOOL success))completionHandler;

+ (NSURL *_Nonnull)appStoreURL;

+ (BOOL)isSnapchatInstalled;

@end

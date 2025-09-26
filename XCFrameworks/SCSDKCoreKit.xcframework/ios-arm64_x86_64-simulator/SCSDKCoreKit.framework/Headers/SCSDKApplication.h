//
//  SCSDKApplication.h
//  SCSDKCoreKit
//
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^SCSDKApplicationRoute)(UIApplication *_Nullable application, NSURL *_Nullable url,
                                      NSDictionary<UIApplicationOpenURLOptionsKey, id> *_Nullable options);

@interface SCSDKApplication : NSObject

/**
 * Load Snapchat enabled application.
 *
 * @param application for singleton app object of calling app
 * @param url created by Snapchat.
 * @param options for the url to handle
 * @return YES if Snapchat can open the the url, NO if it cannot
 */
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

+ (void)registerApplicationRoute:(SCSDKApplicationRoute)applicationRoute;

@end

NS_ASSUME_NONNULL_END

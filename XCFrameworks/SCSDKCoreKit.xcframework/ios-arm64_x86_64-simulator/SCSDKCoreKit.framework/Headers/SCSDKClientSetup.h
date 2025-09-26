//
//  SCSDKClientSetup.h
//  SCSDKCoreKit
//
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/KitPluginType.h>
#import <SCSDKCoreKit/SCSDKFont.h>
#import <SCSDKCoreKit/SnapKitInitType.h>

#import <Foundation/Foundation.h>

@interface SCSDKClientSetup : NSObject

@property (nonatomic, copy, readonly) NSString *bundleId;

@property (nonatomic, copy, readonly) NSString *clientID;

@property (nonatomic, copy, readonly) NSURL *redirectURL;

@property (nonatomic, strong, readonly) NSArray<NSString *> *scopes;

@property (nonatomic, strong, readonly) NSString *firebaseExtCustomTokenEndpoint;

@property (nonatomic, strong, readonly) SCSDKFont *font;

@property (nonatomic, readonly) KitPluginType pluginType;

+ (instancetype)sharedInstance;
+ (void)resetSharedInstance;

- (instancetype)init NS_UNAVAILABLE;
- (void)skateInitialize:(SnapKitInitType)snapKitInitType recordEvent:(BOOL)shouldRecordEvent;
- (void)skateDeinitialize;

@end

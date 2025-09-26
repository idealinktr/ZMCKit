//
//  SCSDKKeychainManager.h
//  SCSDKCoreKit
//
//  Copyright (c) 2014 Snapchat, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSDKKeychainManager : NSObject

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key;
+ (OSStatus)setDataWithStatus:(NSData *)data forKey:(NSString *)key;
+ (NSData *)dataForKey:(NSString *)key status:(OSStatus *)statusRef;
+ (NSData *)dataForKey:(NSString *)key;
+ (BOOL)removeDataForKey:(NSString *)key;
+ (OSStatus)removeDataForKeyWithStatus:(NSString *)key;
+ (BOOL)setBackgroundData:(NSData *)data forKey:(NSString *)key;
+ (OSStatus)setBackgroundDataWithStatus:(NSData *)data forKey:(NSString *)key;

+ (void)removeAllData;
+ (void)removeAllDataExcludingWhitelist:(NSArray *)whitelist;

@end

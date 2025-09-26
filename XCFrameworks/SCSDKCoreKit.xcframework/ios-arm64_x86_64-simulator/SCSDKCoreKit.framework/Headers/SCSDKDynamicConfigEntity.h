//
//  SCSDKDynamicConfig.h
//  SCSDKCoreKit
//
//  Created by Yang Gao on 8/22/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSDKDynamicConfigEntity : NSObject

- (instancetype)initWithName:(NSString *)name config:(NSDictionary *)config;

/**
 * Get config value given a series of keys in the config hierarchy; if a valid config value is
 * not present, use default value. For instance, if the dynamic config entity is hosting
 * { configA: { configB: false, configC: true }}, retrieving boolean value at [configA, configC]
 * will return true
 *
 * @param path an array of keys leads to config value to be retrieved
 */
- (BOOL)boolValue:(NSArray<NSString *> *)path defaultValue:(BOOL)defaultValue;
- (long)longValue:(NSArray<NSString *> *)path defaultValue:(long)defaultValue;
- (double)doubleValue:(NSArray<NSString *> *)path defaultValue:(double)defaultValue;
- (NSString *)stringValue:(NSArray<NSString *> *)path defaultValue:(NSString *)defaultValue;

@end

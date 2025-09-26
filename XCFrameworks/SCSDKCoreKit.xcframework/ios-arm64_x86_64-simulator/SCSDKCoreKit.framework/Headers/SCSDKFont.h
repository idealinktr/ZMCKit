//
//  SCSDKFont.h
//  SCSDKCoreKit
//
//  Created by David Xia on 2018-09-19.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSDKFont : NSObject

@property (nonatomic, strong, readonly) NSString *regularFontName;

@property (nonatomic, strong, readonly) NSString *boldFontName;

- (instancetype)initWithFontConfig:(NSDictionary<NSString *, NSString *> *)config;

@end

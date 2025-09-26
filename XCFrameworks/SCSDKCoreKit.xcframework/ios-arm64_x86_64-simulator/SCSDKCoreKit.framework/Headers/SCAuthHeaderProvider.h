//
//  SCAuthHeaderProvider.h
//  SCSDKCoreKit
//
//  Created by Hongjai Cho on 12/14/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCAuthHeaderProvider <NSObject>

- (NSString *)authHeaderName;
- (NSString *)authHeaderValue;

@end

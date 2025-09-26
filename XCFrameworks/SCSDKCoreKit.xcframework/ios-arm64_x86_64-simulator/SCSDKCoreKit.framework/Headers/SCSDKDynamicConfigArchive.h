//
//  SCSDKDynamicConfigArchive.h
//  SCSDKCoreKit
//
//  Created by Yang Gao on 8/22/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import "SCSDKDynamicConfigEntity.h"

#import <Foundation/Foundation.h>

typedef NSDictionary<NSString *, SCSDKDynamicConfigEntity *> SCSDKDynamicConfigArchiveMapping;

@interface SCSDKDynamicConfigArchive : NSObject

- (BOOL)archiveSync:(SCSDKDynamicConfigArchiveMapping *)mapping;
- (SCSDKDynamicConfigArchiveMapping *)unarchiveSync;

@end

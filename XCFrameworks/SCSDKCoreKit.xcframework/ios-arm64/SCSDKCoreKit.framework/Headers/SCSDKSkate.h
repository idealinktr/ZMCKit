//
//  SCSDKSkate.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 6/18/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/Skate.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EncodablePicoproto;
@class LoginRouteWrapper;

@interface SCSDKSkate : NSObject

- (instancetype)initWithKits:(NSArray<NSNumber *> *)kits
          isFirstWithinMonth:(BOOL)isFirstWithinMonth
          dailySessionBucket:(DailySessionBucket)dailySessionBucket
                  sampleRate:(double)sampleRate
                  loginRoute:(LoginRouteWrapper *)loginRoute
                    skateDay:(int)day
                  skateMonth:(int)month
                   skateYear:(int)year
             snapKitInitType:(SnapKitInitType)kitInitType
               kitPluginType:(KitPluginType)kitPluginType
              kitVersionJson:(NSString *)kitVersionJson;

- (EncodablePicoproto *)encodeablePicoproto;

@end

NS_ASSUME_NONNULL_END

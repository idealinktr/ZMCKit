//
//  SCUILogger.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 8/6/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCUILoggerDelegate <NSObject>

- (void)logsUpdated:(NSArray<NSString *> *_Nonnull)logs;

@end

@class SCUILoggerDelegate;

@interface SCUILogger : NSObject

@property (nonatomic, weak, nullable) id<SCUILoggerDelegate> delegate;

+ (SCUILogger *_Nonnull)shared;
- (void)logString:(NSString *_Nullable)log, ...;
- (NSArray<NSString *> *_Nullable)getLogs;

@end

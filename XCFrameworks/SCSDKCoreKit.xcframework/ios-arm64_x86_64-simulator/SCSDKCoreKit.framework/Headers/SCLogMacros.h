//
//  SCLogMacros.h
//  SCSDKCoreKit
//
//  Created by Hongjai Cho on 1/18/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/SCSDKAppEnvironment.h>
#import <SCSDKCoreKit/SCSDKMacros.h>
#import <SCSDKCoreKit/SCUILogger.h>

#import <stdarg.h>

#import <Foundation/Foundation.h>

static SCSDK_ALWAYS_INLINE void SCLogDebug(NSString *errorMessage, ...)
{
    if (SCSDKIsDebugBuild()) {
        va_list args;
        va_start(args, errorMessage);
        NSString *logFormatted = [[NSString alloc] initWithFormat:errorMessage arguments:args];
        va_end(args);

        // @phantom-linter off nslog
        NSLog(@"%@", logFormatted);
        // @phantom-linter on nslog
    }
}

static SCSDK_ALWAYS_INLINE void SCLogWarning(NSString *errorMessage, ...)
{
    if (SCSDKIsDebugBuild()) {
        va_list args;
        va_start(args, errorMessage);
        NSString *logFormatted = [[NSString alloc] initWithFormat:errorMessage arguments:args];
        va_end(args);

        // @phantom-linter off nslog
        NSLog(@"%@", logFormatted);
        // @phantom-linter on nslog
    }
}

static SCSDK_ALWAYS_INLINE void SCLogError(NSString *errorMessage, ...)
{
    if (SCSDKIsDebugBuild()) {
        va_list args;
        va_start(args, errorMessage);
        NSString *logFormatted = [[NSString alloc] initWithFormat:errorMessage arguments:args];
        va_end(args);

        // @phantom-linter off nslog
        NSLog(@"%@", logFormatted);
        // @phantom-linter on nslog
    }
}

//
//  SCAppEnvironment.h
//  SCSDKCoreKit
//

#import <SCSDKCoreKit/Event.h>
#import <SCSDKCoreKit/SCSDKMacros.h>

#import <Foundation/Foundation.h>

SCSDK_EXTERN_C_BEGIN

FOUNDATION_EXTERN BOOL SCSDKIsDebugBuild(void);
FOUNDATION_EXTERN BOOL SCSDKIsSimulator(void);
FOUNDATION_EXTERN BOOL SCSDKIsRunningUITests(void);

FOUNDATION_EXTERN NSString *SCLocale(void);
FOUNDATION_EXTERN NSString *SCArchitecture(void);
FOUNDATION_EXTERN NSString *SCKitVersionForClass(Class clazz);

FOUNDATION_EXTERN BOOL SCSDKIsRunningTests(void);
FOUNDATION_EXTERN BOOL SCSDKIsRunningExtension(void);
FOUNDATION_EXTERN BOOL SCSDKIsRunningWithDebugger(void);
FOUNDATION_EXTERN NSString *SCLocale(void);
FOUNDATION_EXTERN NSString *SCArchitecture(void);
FOUNDATION_EXTERN NSString *SCKitVersionForClass(Class clazz);
FOUNDATION_EXTERN NSString *SCKitVersionForKitType(KitType kitType);

SCSDK_EXTERN_C_END

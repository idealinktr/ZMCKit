
#import <SCSDKCoreKit/Event.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EncodablePicoproto;

@interface KitApplicationEvents : NSObject

+ (EncodablePicoproto *)logOpenSession:(BOOL)isFirstOpenSinceInstall;

+ (EncodablePicoproto *)logOpenSession:(NSString *)deeplinkUrl
                    deeplinkSourceType:(KitDeepLinkSourceType)deeplinkSourceType;

+ (EncodablePicoproto *)logCloseSession;

@end

NS_ASSUME_NONNULL_END

//
//  SCSDKNetworkRequest.h
//  SCSDKCoreKit
//
//  Copyright © 2017 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/Event.h>

#import <Foundation/Foundation.h>

@protocol SCAuthHeaderProvider;

@interface SCSDKNetworkRequest : NSObject

@property (nonatomic, copy, readonly) NSString *path;

@property (nonatomic, copy, readonly) NSString *method;

@property (nonatomic, assign, readonly) NSInteger expectedStatusCode;

@property (nonatomic, copy, readonly) NSString *identifier;

@property (nonatomic, strong) NSMutableDictionary *headers;

@property (nonatomic, strong) NSDictionary *queryParams;

@property (nonatomic, copy) NSData *httpBody;

@property (nonatomic, copy) NSString *contentType;

@property (nonatomic, strong) id<SCAuthHeaderProvider> authHeaderProvider;

@property (nonatomic) KitType kitType;

@property (nonatomic, copy) NSString *sessionId;

- (instancetype)initWithPath:(NSString *)path
                      method:(NSString *)method
                     kitType:(KitType)kitType
                   sessionId:(NSString *)sessionId;

- (instancetype)initWithPath:(NSString *)path method:(NSString *)method kitType:(KitType)kitType;

- (instancetype)initWithPath:(NSString *)path method:(NSString *)method;

- (NSURLRequest *)toUrlRequest;

- (NSURLRequest *)toCanvasApiUrlRequest;

- (NSURLRequest *)toUrlRequestWithBaseUrl:(NSString *)baseUrl;

+ (NSString *)userAgent;

+ (NSMutableURLRequest *)addHeadersToUrlRequest:(NSMutableURLRequest *)urlRequest
                                        kitType:(KitType)kitType
                                      sessionId:(NSString *)sessionId;

+ (NSMutableDictionary *)requestHeadersForKitType:(KitType)kitType sessionId:(NSString *)sessionId;

@end

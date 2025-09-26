//
//  AnalyticsEventsQueue.h
//  SCSDKCoreKit
//
//  Created by Hongjai Cho on 8/30/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AnalyticsEventsQueue;
@class EncodablePicoproto;
@class EventWrapper;
@class SCSDKNetworkRequest;

typedef void (^AnalyticsEventsQueueSubmitCallback)(NSError *_Nullable error, NSInteger statusCode,
                                                   NSDictionary *_Nullable headers, NSData *_Nullable data);

@protocol AnalyticsEventsQueueDelegate <NSObject>

@required
/*!
 @method eventsQueue:parseEvents:maxSequenceId:
 @brief Method to implement for custom events parsing
 @discussion AnalyticsEnventsQueue maintains a list of EventWrapper, which are wrappers of events
             added using pushEvent method. Different events have different requirements, and might
             need to be parsed differentely. Implement this method to parse events before they
             are submitted to the backend
 @param eventsQueue the current AnalyticsEventsQueue object with the delegate
 @param events the list of queued events
 @param maxSequenceId current maximum sequence ID, incremented every time an event is added using pushEvent
 */
- (nonnull NSData *)eventsQueue:(nonnull AnalyticsEventsQueue *)eventsQueue
                    parseEvents:(nonnull NSArray<EventWrapper *> *)events
                  maxSequenceId:(NSInteger)maxSequenceId;

@optional
/*!
 @method submit:completion:
 @brief Method to implement for custom events submission
 @discussion Different events might need different events submission. For example, some events might
             need to add custom headers. Implement this method to add custom event submission logic.
 @param request the basic request for event submission.
 @param completion callback called after event submission is complete.
 */
- (void)submit:(nonnull SCSDKNetworkRequest *)request
    completion:(nullable AnalyticsEventsQueueSubmitCallback)completion;

- (void)requestDidComplete:(nonnull SCSDKNetworkRequest *)request
                      data:(NSData *_Nullable)data
                 numEvents:(int)eventCount
                     error:(NSError *_Nullable)error
                statusCode:(NSInteger)statusCode;

- (void)willSubmitRequest:(nonnull SCSDKNetworkRequest *)request withEvents:(NSArray<EventWrapper *> *_Nullable)events;
@end

@interface AnalyticsEventsQueue : NSObject

@property (nonatomic, weak, nullable) id<AnalyticsEventsQueueDelegate> delegate;

- (nonnull instancetype)initWithAnalyticsEndpoint:(NSString *_Nonnull)analyticsEndpoint
                                      archiveName:(NSString *_Nonnull)archiveName
                                   maxEventBuffer:(NSUInteger)maxEventBuffer
                                         delegate:(id<AnalyticsEventsQueueDelegate> _Nonnull)delegate;

- (void)pushEvent:(EncodablePicoproto *_Nonnull)event;

- (void)flushQueue;
- (void)clearEvents;

@end

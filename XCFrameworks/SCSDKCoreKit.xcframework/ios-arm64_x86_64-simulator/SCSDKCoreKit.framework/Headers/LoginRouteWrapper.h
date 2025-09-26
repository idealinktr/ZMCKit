//
//  LoginRouteWrapper.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 7/13/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/Skate.h>

#import <Foundation/Foundation.h>

@interface LoginRouteWrapper : NSObject

@property (nonatomic) LoginRoute loginRoute;

- (instancetype)initWithLoginRoute:(LoginRoute)loginRoute;

@end

//
//  EncodablePicoproto.h
//  SCPicoproto
//
//  Created by Hongjai Cho on 8/8/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import "picoproto_ctx.h"

#import <Foundation/Foundation.h>

@interface EncodablePicoproto : NSObject <NSSecureCoding>

@property (nonatomic) picoproto_ctx *ctx;

- (instancetype)initWithCtx:(picoproto_ctx *)ctx;

@end

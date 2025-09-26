//
//  SCSDKPicoprotoHelper.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 7/27/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/EncodablePicoproto.h>

#import <Foundation/Foundation.h>

typedef struct {
    BOOL success;
    double value;
} PicoprotoDataConversionDouble;

extern PicoprotoDataConversionDouble doubleFromData(NSData *data, const char *fieldName, int fieldNumber);

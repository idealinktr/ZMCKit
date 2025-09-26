//
//  Skate.h
//  SCSDKCoreKit
//
//  Created by Duncan Riefler on 6/18/20.
//  Copyright © 2020 Snap, Inc. All rights reserved.
//

#import <SCSDKCoreKit/KitPluginType.h>
#import <SCSDKCoreKit/SnapKitInitType.h>
#import <SCSDKCoreKit/picoproto.h>

typedef enum {
    NO_SESSION_BUCKET = 0,
    ONE_SESSION = 1,
    TWO_SESSION = 2,
    THREE_SESSION = 3,
    FOUR_SESSION = 4,
    FIVE_SESSION = 5,
    SIX_SESSION = 6,
    SEVEN_SESSION = 7,
    EIGHT_SESSION = 8,
    NINE_SESSION = 9,
    TEN_OR_MORE_SESSION = 10
} DailySessionBucket;

typedef enum { UNKNOWN_LOGIN_ROUTE = 0, LOGIN_ROUTE = 1 } LoginRoute;

/**
 * message SkateEvent
 */
PICOPROTO_VARINT(daily_session_bucket, 1);
PICOPROTO_VARINT(is_first_within_month, 2);
PICOPROTO_VARINT(login_route, 3);
PICOPROTO_DOUBLE(sample_rate, 4);
PICOPROTO_STRING(kit_variants_string_list, 5);
PICOPROTO_VARINT(day, 6);
PICOPROTO_VARINT(month, 7);
PICOPROTO_VARINT(year, 8);
PICOPROTO_VARINT(snap_kit_init_type, 9);
PICOPROTO_VARINT(kit_plugin_type, 10);
PICOPROTO_STRING(core_version, 11);
PICOPROTO_STRING(kit_version_string_list, 12);

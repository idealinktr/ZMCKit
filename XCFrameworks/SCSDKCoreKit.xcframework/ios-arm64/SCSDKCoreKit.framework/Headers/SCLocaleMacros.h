// @phantom-linter off localizedstring
//
//  SCLocaleMacros.h
//  SCSDKCoreKit
//
//  Created by Ethan Myers on 7/23/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

// NOTE: Must be called from ObjC methods - no C functions

#define SCLocalizedString(key, comment)                                                                                \
    SCLocalizedStringFromTableInBundle(key, nil, [NSBundle bundleForClass:[self class]], comment)

#define SCLocalizedStringFromTable(key, tbl, comment)                                                                  \
    SCLocalizedStringFromTableInBundle(key, tbl, [NSBundle bundleForClass:[self class]], comment)

#define SCLocalizedStringFromTableInBundle(key, tbl, bundle, comment)                                                  \
    NSLocalizedStringFromTableInBundle(key, tbl, bundle, comment)

#define SCLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment)                                              \
    NSLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment)

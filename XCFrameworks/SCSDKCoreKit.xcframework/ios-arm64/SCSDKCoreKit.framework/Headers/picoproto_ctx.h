//
//  picoproto_ctx.h
//  SCPicoproto
//
//  Created by Hongjai Cho on 7/24/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

typedef struct picoproto_ctx_s {
    char* name;
    unsigned long long len;
    unsigned long long max;
    char* bufptr;

} picoproto_ctx;

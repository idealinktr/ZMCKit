//
//  SCSDKPayloadFormatterV1.h
//  SCSDKCoreKit
//
//  Copyright © 2017 Snap, Inc. All rights reserved.
//

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

/******************************************************************************/
/* EXTERNAL API                                                               */
/******************************************************************************/

typedef enum { PRUNEAU_TAG_OK, PRUNEAU_TAG_NOK, PRUNEAU_TAG_GEN, PRUNEAU_INTERNAL_ERROR } PRUNEAU_result_t;

typedef enum { PRUNEAU_MODE_TAG_GEN, PRUNEAU_MODE_TAG_CHECK } PRUNEAU_mode_t;

// If mode == PRUNEAU_TAG_GEN, then tag must be a pre-allocated array of
// 16 bytes. The encrypted/decrypted result is returned into the outputData
// buffer, and the tag is returned into the tag buffer.
// The return value is then always PRUNEAU_TAG_GEN.

// If mode == PRUNEAU_TAG_CHECK, then tag must be filled with the received
// tag.
//
//   If the return value == PRUNEAU_TAG_OK, then the outputData buffer
//   contains the encrypted/decrypted result.
//
//   If the return value == PRUNEAU_TAG_NOK, then the outputData buffer
//   contains zeroes.

// Nonces must be freshly generated with a cryptographically secure
// pseudo-random generator for *each call* to the routines.
//
// Given an initial message {inputData, attachedData}, the resulting message
// that will have to be transmitted will be
//
// {nonce, outputData, attachedData, tag}
//
// and its length will be
//
// inputDataLen + attachedDataLen + (16 + 16) bytes.

PRUNEAU_result_t PRUNEAUv1_peer1_format(uint8_t* outputData, uint8_t* tag, const uint8_t* nonce,
                                        const uint8_t* attachedData, const uint32_t attachedDataLen,
                                        const uint8_t* inputData, const uint32_t inputDataLen,
                                        const PRUNEAU_mode_t mode);

PRUNEAU_result_t PRUNEAUv1_peer2_format(uint8_t* outputData, uint8_t* tag, const uint8_t* nonce,
                                        const uint8_t* attachedData, const uint32_t attachedDataLen,
                                        const uint8_t* inputData, const uint32_t inputDataLen,
                                        const PRUNEAU_mode_t mode);

//
//  NSData+Encryption.h
//  SCSDKCoreKit
//
//  Created by Ethan Myers on 8/28/18.
//  Copyright © 2018 Snapchat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)
// How stories do encryption and decryption (AES/CBC/PKCS7Padding)
// Key is base 64 encoded string or NSData.
- (NSData *)sc_secureEncryptWithKey:(id)key iv:(id)iv;
- (NSData *)sc_secureDecryptWithKey:(id)key iv:(id)iv;

@end

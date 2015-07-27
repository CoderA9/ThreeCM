//
//  Cipher.h
//  LifeixFoundation
//
//  Created by James Liu on 8/18/11.
//  Copyright 2011 Lifeix Inc. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <UIKit/UIKit.h>

@interface Cipher : NSObject {
	NSString* cipherKey;
}

@property (strong) NSString* cipherKey;

- (Cipher *) initWithKey:(NSString *) key;

- (NSData *) encrypt:(NSData *) plainText;
- (NSData *) decrypt:(NSData *) cipherText;

- (NSData *) transform:(CCOperation) encryptOrDecrypt data:(NSData *) inputData;

+ (NSData *) md5:(NSString *) stringToHash;

@end
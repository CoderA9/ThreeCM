//
//  NSData+Base64.h
//  LifeixFoundation
//
//  Created by James Liu on 8/18/11.
//  Copyright 2011 Lifeix Inc. All rights reserved.
//  
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import <Foundation/Foundation.h>

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSData (Base64)

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;
- (NSData *)base64EncodedData;

@end

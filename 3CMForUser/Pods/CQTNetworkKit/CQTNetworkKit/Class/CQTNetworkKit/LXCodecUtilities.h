//
//  LXCodecUtilities.h
//  LifeixNetworkKit
//
//  Created by James Liu on 1/16/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#ifndef __LXCodecUtilities__

#define __LXCodecUtilities__
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

//TODO md5Hash method from LifeixFoundation
static NSString * LXMD5Hash(NSString* object) {
    const char *cStr = [object UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];  
}

/**
 Base64 Encoding
 */
static NSString * LXBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string length]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]); 
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

/**
 Returns a string, replacing certain characters with the equivalent percent escape sequence based on the specified encoding.
 
 @param string The string to URL encode
 @param encoding The encoding to use for the replacement. If you are uncertain of the correct encoding, you should use UTF-8 (NSUTF8StringEncoding), which is the encoding designated by RFC 3986 as the correct encoding for use in URLs.
 
 @discussion The characters escaped are all characters that are not legal URL characters (based on RFC 3986), including any whitespace, punctuation, or special characters.
 
 @return A URL-encoded string. If it does not need to be modified (no percent escape sequences are missing), this function may merely return string argument.
 */
static NSString * LXURLEncodedStringFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFLegalCharactersToBeEscaped = @"?!@#$^&%*+=,:;'\"`<>()[]{}/\\|~ ";
    
    /* 
     The documentation for `CFURLCreateStringByAddingPercentEscapes` suggests that one should "pre-process" URL strings with unpredictable sequences that may already contain percent escapes. However, if the string contains an unescaped sequence with '%' appearing without an escape code (such as when representing percentages like "42%"), `stringByReplacingPercentEscapesUsingEncoding` will return `nil`. Thus, the string is only unescaped if there are no invalid percent-escaped sequences. 
     */
    NSString *unescapedString = [string stringByReplacingPercentEscapesUsingEncoding:encoding];
    if (unescapedString) {
        string = unescapedString;
    }
    
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, (CFStringRef)kAFLegalCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding)));
}

#endif
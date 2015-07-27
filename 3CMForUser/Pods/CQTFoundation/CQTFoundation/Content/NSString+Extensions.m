//
//  NSString+Extensions.m
//  CQTIda
//
//  Created by ANine on 4/14/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "NSString+Extensions.h"
#import "NSData+Base64.h"
#import "Cipher.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#import "CQTGlobalConstants.h"
#import "CQTResourceBrige.h"



@implementation NSString (Extensions)


#pragma mark Encryption & Codec


- (NSString *)stringForAESEncrypt:(NSString *)encryptKey {
    Cipher *cr = [[Cipher alloc] initWithKey:encryptKey];
	NSData *encryptedData = [cr encrypt:[self dataUsingEncoding:NSUTF8StringEncoding]];
	return [encryptedData base64EncodedString];
}


- (NSString *)stringByBase64Shift:(NSInteger)count {
    NSString *strBefore = [self base64Encoding];
	if (count < 1) {
		return strBefore;
	}
	
	return [strBefore stringByShift:count];
}

- (NSString *)stringByShift:(NSInteger)count {
	int repeats = [self length] / (count * 2);
	
	if (repeats < 1) return self;
	
	NSString *afterStr = [[NSString alloc] init];
	
	NSRange range;
	for (int i = 0; i < repeats; i ++) {
		range = NSMakeRange(2 * i * count, count);
		NSString *front = [self substringWithRange:range];
		range.location = (2 * i + 1) * count;
		NSString *back = [self substringWithRange:range];
		
		afterStr = [afterStr stringByAppendingFormat:@"%@%@" , back, front];
	}
	
	range = NSMakeRange(2 * repeats * count, [self length] - 2 * repeats * count);
	NSString *lost = [self substringWithRange:range];
	return [afterStr stringByAppendingString:lost];
}


- (NSString *) stringByUrlEncoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)self,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]",  kCFStringEncodingUTF8)) ;
}

- (NSString *)base64Encoding {
    
	NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSString *encodedString = [stringData base64EncodedString];
	
	return encodedString;
}

- (NSString *) md5Hash {
    const char *cStr = [self UTF8String];
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



#pragma mark - others

- (NSString *)stringByReplacingCQTEntities {
    return [self stringByReplacingOccurrencesOfString:@"${lx-br}" withString:@"\n"];
}




#pragma mark UUID

+ (NSString *)guid
{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef cfStr = CFUUIDCreateString(NULL, uuid);
	
	NSString *ret = [NSString stringWithString:CFBridgingRelease(cfStr)];
	
	CFRelease(uuid);
	// CFRelease(cfStr);
	
	return ret;
}

+ (NSString*)stringWithNewUUID
{
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    // Get the string representation of the UUID
    NSString *newUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    
    return newUUID;
}

+ (NSString *)deviceModel {
	char *buffer[256] = { 0 };
	size_t size = sizeof(buffer);
    sysctlbyname("hw.machine", buffer, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:(const char*)buffer
											encoding:NSUTF8StringEncoding];
	return platform;
}

- (BOOL)matchAnyOf:(NSArray *)array
{
	for ( NSString * str in array )
	{
		if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] )
		{
			return YES;
		}
	}
	
	return NO;
}


+ (NSString *)firstCaracterCapitalized:(NSString *)aString {
    if (!aString || !aString.length) {
        return aString;
    }
    NSMutableString *string = [[NSMutableString alloc] initWithString:aString];
    NSString *returnStr ;
    char *echo = (char *)string.UTF8String;
    char *p = echo;
    if ((' ' == *(echo -1) || echo == p) && 'a' <= *echo && 'z' >= *echo) {
        *echo = *echo - 32;
    }
    returnStr = [NSString stringWithUTF8String:echo];
    string = nil;
    return returnStr;
}

+ (NSString *)getCutDownTimeFromInterval:(NSTimeInterval)inter {
    
    int hour = inter / (60*60);

    int min = ((int)inter % (60 * 60) )/ 60;

    int sec = (int)inter%60;

    if (inter < 0) {
        
        hour = min = sec = 0;
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
}

+ (NSString *)getCutDownTime:(NSDate *)date {
    
    NSTimeInterval inter = [date timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970];
    
    return [NSString getCutDownTimeFromInterval:inter];
}

+ (NSString *)getCutDownTimeIntervalSince1970:(NSTimeInterval)inter {
    
    inter = inter - [[NSDate date] timeIntervalSince1970];
    return [NSString getCutDownTimeFromInterval:inter];
}

/* 将字符串中的半角%&改换为全角的＆％,replace=NO则去掉%& */
- (NSString *)adjustJSONFormatter:(BOOL)replace {
    
    NSString *str;
    
    if (replace) {
        
        str = [self stringByReplacingOccurrencesOfString:@"%" withString:@"％"];
        
        str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"＆"];
    }else {
        
        str = [self stringByReplacingOccurrencesOfString:@"%" withString:@""];
        
        str = [str  stringByReplacingOccurrencesOfString:@"&" withString:@""];
    }

    
    return str;
}

/* 在字符串后面追加一个cqtidabigdata=xxx */
- (NSString *)appendBigdataWithSuffix:(NSString *)suffix {
    
    NSString *appendFormat = @"&";
    
    if (![self rangeOfString:@"?"].length) {
        
        appendFormat = @"?";
    }
    
    appendFormat = [appendFormat stringByAppendingString:[NSString stringWithFormat:@"%@=%@",@"cqtidabigdata",suffix]];
    
    return [self stringByAppendingString:appendFormat];
}

- (NSString *)adjustImageHeader:(NSString *)imageHeader {
    
    NSString *resultStr = self;
    
    if ([self hasPrefix:[CQTResourceBrige sharedBrige].appBaseUrl]) {
    }else {
        
        resultStr = [imageHeader ? imageHeader : [CQTResourceBrige sharedBrige].appBaseUrl stringByAppendingFormat:@"/%@",self];
    }
    
    return resultStr;
}

- (NSString *)needThubmailImageStr {

    NSString *resultStr = self;
    
    NSString *suffix = [[self componentsSeparatedByString:@"."] lastObject];
    
    resultStr = [self substringToIndex:self.length - suffix.length - 1];
    
    if (![resultStr hasPrefix:@"_s"]) {
        
        resultStr = [NSString stringWithFormat:@"%@_s.%@",resultStr,suffix];
    }else {
        
        resultStr = self;
    }
    
    return resultStr;
}

+ (NSString *)getOctalString:(long long)cnt {
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    while (cnt != 0 ) {
        
        [resultStr insertString:[NSString stringWithFormat:@"%lld",cnt % 8] atIndex:0];
        cnt /= 8;
    }
    return CQT_AUTORELEASE(resultStr);
}

+ (NSString *)getHexString:(long long)cnt {
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    while (cnt != 0 ) {
        
        int surplus = cnt % 16;
        static NSString *subStr = nil;
        switch (surplus) {
            case 10:
                subStr = @"a";
                break;
            case 11:
                subStr = @"b";
                break;
            case 12:
                subStr = @"c";
                break;
            case 13:
                subStr = @"d";
                break;
            case 14:
                subStr = @"e";
                break;
            case 15:
                subStr = @"f";
                break;
            default:
                subStr = [NSString stringWithFormat:@"%d",surplus];
                break;
        }
        [resultStr insertString:subStr atIndex:0];
        
        cnt /= 16;
    }
    return CQT_AUTORELEASE(resultStr);
}
@end

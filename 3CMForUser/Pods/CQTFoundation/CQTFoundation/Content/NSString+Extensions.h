//
//  NSString+Extensions.h
//  CQTIda
//
//  Created by ANine on 4/14/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief NSString 的扩展类
 
 @discussion
 NSString+Extensions Features: AES encryption with given key , shiftting string with give count , convert string into URL encoding , convert string into base64 encoding , hash string with MD5, create a new universally unique identifier.
 */


@interface NSString (Extensions)

#pragma mark - Encryption & Codec

///---------------------------------------------------------------------------------------
/// @name Encryption & Codec
///---------------------------------------------------------------------------------------
/** Encrypt string using AES with given key.
 
 @param encryptKey The key will be used.
 @return Returns encrypted string with AES.
 */
- (NSString *)stringForAESEncrypt:(NSString *)encryptKey;

/**
 将字符串转化为base64编码，同时进行置换操作。
 
 @warning *Important:* 此方法现只用于A06项目的验证环节。
 
 @param count 以多少个字符进行置换,例如count=4，将每次取8个字符，4、4进行前后置换，如不足8则不置换。
 @return 返回 转码并置换完毕的字符串。
 @see stringByShift:    直接置换字符串
 */
- (NSString *)stringByBase64Shift:(NSInteger)count;

/**
 将给定的字符串进行置换操作。
 
 @warning *Important:* 此方法现只用于A06项目的验证环节。
 
 @param count 以多少个字符进行置换,例如count=4，将每次取8个字符，4、4进行前后置换，如不足8则不置换。
 @return 返回置换完毕的字符串。
 */
- (NSString *)stringByShift:(NSInteger)count;

/**
 Convert the string into URL encoding.
 @return  Returns url encoded string.
 */
- (NSString *)stringByUrlEncoding;

/**
 Convert the string into base64 encoding.
 @return Returns base64 encoded string.
 */
- (NSString *) base64Encoding;

/**
 Hash the string using MD5.
 @return Returns md5 hashed string.
 */
- (NSString *) md5Hash;



#pragma mark - others

- (NSString *)stringByReplacingCQTEntities;



#pragma mark - UUID
///---------------------------------------------------------------------------------------
/// @name UUID
///---------------------------------------------------------------------------------------

/**
 Create a globally unique identifier to uniquely identify something. Used to create a GUID, store it in a dictionary or other data structure and retrieve it to uniquely identifiy something. In DTLinkButton multiple parts of the same hyperlink synchronize their looks through the GUID.
 @returns GUID assigned to this string to easily and uniquely identify it..
 */
+ (NSString *)guid;

/**
 Create a new universally unique identifier.
 @return Returns uuid
 */
+ (NSString*)stringWithNewUUID;

/**
 Gets the device model string.
 @return a platform string identifying the device
 */
+ (NSString *)deviceModel;

/**
 gets the string which the first caracter is Capitalized.
 @return nsstring.
 */
+ (NSString *)firstCaracterCapitalized:(NSString *)aString;

/* 通过一个基于1970.1.1的绝对时间戳来获取倒计时时间 */
+ (NSString *)getCutDownTimeIntervalSince1970:(NSTimeInterval)inter;

/* 通过一个date与当前时间对比得到倒计时时间 */
+ (NSString *)getCutDownTime:(NSDate *)date;

/* 通过一个相对时间戳来获取倒计时时间 */
+ (NSString *)getCutDownTimeFromInterval:(NSTimeInterval)inter;

/* 匹配一个数组 */
- (BOOL)matchAnyOf:(NSArray *)array;

/* 回传一个ImagePath
   if imageHeader== nil  imageHeader = kIDaImageUrlPrefix
 */
- (NSString *)adjustImageHeader:(NSString *)imageHeader;

/* 如果不是缩略图则做成缩略图的字符串 */
- (NSString *)needThubmailImageStr ;

/* 获取一个十六进制的字符串 */
+ (NSString *)getHexString:(long long)cnt;

/* 获取一个八进制的字符串 */
+ (NSString *)getOctalString:(long long)cnt;

/* 将字符串中的半角%&改换为全角的＆％,replace=NO则去掉%& */
- (NSString *)adjustJSONFormatter:(BOOL)replace;

/* 在字符串后面追加一个cqtidabigdata=xxx */
- (NSString *)appendBigdataWithSuffix:(NSString *)suffix;
@end

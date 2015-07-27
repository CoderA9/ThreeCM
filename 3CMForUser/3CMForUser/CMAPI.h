//
//  CMAPI.h
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "LXHTTPEngine.h"

#define kCMBaseLocalUrlString @"http://i.idavip.com/index.php?m=mobile&"
#define kCMBaseOnLineUrlString @"http://m.idavip.com/index.php?m=mobile&"

#define kCMLocalURL  @"i.idavip.com"
#define kCMOnLineURL @"m.idavip.com"
//TODO:A9.
#define kCMBaseUrlString kCMBaseOnLineUrlString

#define kUserIdKey          @"userid"
#define kPlatformKey        @"sysplat"
#define kDeviceIdKey        @"devicenum"
#define kVersionKey         @"version"
#define kSESSIONKey         @"session"
#define kSystemVersionKey   @"sysver"
#define kAppNameKey         @"appname"
#define kPhoneNumKey        @"tel"
#define kSessionIDKey       @"session_id"

typedef void (^CMAPIClientSuccessBlock) ( id dataBody);
typedef void (^CMAPIClientFailureBlock) ( id dataBody);
typedef void (^CMAPIClientUploaderBlock) (NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);

/**
 @brief 3CM  API
 
 @discussion <#some notes or alert with this class#>
 */

@interface CMAPI : LXHTTPEngine

+ (instancetype)sharedAPI;

@end

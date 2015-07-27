//
//  CMUser.h
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 @brief 用于处理用户信息类
 
 @discussion 
 */

#define NNKEY_USER_INFO_DID_CHANGED @"kNotificationUserInfoDidChanged"
#define NNKEY_USER_DID_LOGIN @"kNotificationUserDidLogin"

static NSString * kDefaultUserKey = @"kDefaultUserKey";

@interface CMUser : NSObject {
    
    USER *_defaultUser;
}

@property (nonatomic,strong) USER *defaultAccount;

@property (nonatomic,strong) NSString *userId;

+ (instancetype)sharedUser;

/**
 默认帐号信息
 @return 帐号信息,如果没有帐号就为nil
 */
- (USER *)defaultAccount;

/**
 默认帐号ID
 @return 帐号信息,如果没有帐号就为@"-1"
 */
- (NSString *)userId;

/**
 设置指定的帐号为默认帐号
 @param user 用户帐号对象
 */
- (void)setDefaultAccount:(USER *)user;

/* 设置指定的账号为默认账号
 @param user 用户帐号对象
 @param post 是否发送通知
 */
- (void)setDefaultAccount:(USER *)user postNotification:(BOOL)post;

@end

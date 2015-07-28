//
//  CMUser.m
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CMUser.h"

#import "CMDataStructure.h"

@implementation CMUser

+ (instancetype)sharedUser {
    
    static CMUser *_shredUser = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _shredUser = [[self alloc] init];
    });
    
    return _shredUser;
}

/**
 默认帐号信息
 @return 帐号信息,如果没有帐号就为nil
 */
- (USER *)defaultAccount {

    _defaultUser = CQT_RETAIN([CQTArchive unarchiveObjectFromDocumentDirectory:kDefaultUserKey]);
    
    if (!_defaultUser) {
        
        _defaultUser = [[USER alloc] init];
    }
    
    return _defaultUser;
}

/**
 默认帐号ID
 @return 帐号信息,如果没有帐号就为@"-1"
 */
- (NSString *)userId {
    
    USER *user = [self defaultAccount];
    
    if (user && user.userId) {
        
        return user.userId;
    }
    return @"-1";
}

/**
 设置指定的帐号为默认帐号
 @param user 用户帐号对象
 */
- (void)setDefaultAccount:(USER *)user {

    [self setDefaultAccount:user postNotification:YES];
}

/* 设置指定的账号为默认账号
 @param user 用户帐号对象
 @param post 是否发送通知
 */
- (void)setDefaultAccount:(USER *)user postNotification:(BOOL)post {
    
    [CQTArchive archiveData:user inDocumentDirectory:kDefaultUserKey success:^{
        
        if (post) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                POST_NOTIFICATION_OBJ(NNKEY_USER_INFO_DID_CHANGED, nil);
            });
        }
        
    } failure:^(NSError *error) {
    }];
}

/* 检测帐号信息完整性 */
- (BOOL)checkAccountInfoIntegrity:(USER *)user {
    
    BOOL integrity = NO;

    if ( user && validStr(user.userName) && validStr(user.password) ) {
        
        integrity = YES;
    }
    
    return integrity;
}

@end

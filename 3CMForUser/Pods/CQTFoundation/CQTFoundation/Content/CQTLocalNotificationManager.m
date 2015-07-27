//
//  CQTLocalNotificationManager.m
//  CQTIda
//
//  Created by ANine on 2/10/15.
//  Copyright (c) 2015 www.cqtimes.com. All rights reserved.
//

#import "CQTLocalNotificationManager.h"

#import "CQTGlobalConstants.h"

@implementation CQTLocalNotificationManager

+ (instancetype)sharedManager {

    static CQTLocalNotificationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initialSomeData];
    }
    return self;
}

- (void)initialSomeData {
    
}

- (void)sendLocalPushNotificationWithAlertBody:(NSString *)body action:(NSString *)alertAction {
    
    [self sendLocalPushNotificationWithAlertBody:body action:alertAction type:CQTLocalNotificationTypeNothing];
}

/* 负责发送本地通知 */
- (void)sendLocalPushNotificationWithAlertBody:(NSString *)body action:(NSString *)alertAction type:(CQTLocalNotificationType)type {
    
    self.type = type;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *notify = CQT_AUTORELEASE([[UILocalNotification alloc] init]);
    notify.alertBody = body;
    notify.timeZone = [NSTimeZone defaultTimeZone];
    notify.alertAction = alertAction;
    notify.soundName = UILocalNotificationDefaultSoundName;
    notify.applicationIconBadgeNumber = 1;
#warning 现在是20秒 上线前请修改时间
    notify.fireDate = [NSDate dateWithTimeInterval:2*10 sinceDate:[NSDate date]];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
}

- (void)removeLocalNotificationWithType:(CQTLocalNotificationType)type {
    
    if (self.type == type) {
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}
@end

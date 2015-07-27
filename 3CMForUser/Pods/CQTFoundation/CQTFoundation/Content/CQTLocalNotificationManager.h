//
//  CQTLocalNotificationManager.h
//  CQTIda
//
//  Created by ANine on 2/10/15.
//  Copyright (c) 2015 www.cqtimes.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 @brief 本地推送管理器
 
 @discussion <#some notes or alert with this class#>
 */

typedef NS_ENUM (NSUInteger,CQTLocalNotificationType) {
    
    CQTLocalNotificationTypeNothing = 0,
    CQTLocalNotificationTypeShoppingcart = 1 << 0,
    CQTLocalNotificationTypeWaitepurchase = 1 << 1,
};

@interface CQTLocalNotificationManager : NSObject
/**
 *  当前显示本地推送的类型.爱达中有购物车和待付款的区别.
 */
@property (nonatomic,assign)CQTLocalNotificationType type;
/**
 *  获取本地推送管理器唯一单例
 *
 *  @return
 */
+ (instancetype)sharedManager;

- (void)sendLocalPushNotificationWithAlertBody:(NSString *)body action:(NSString *)alertAction;
/* 负责发送本地通知 */
- (void)sendLocalPushNotificationWithAlertBody:(NSString *)body action:(NSString *)alertAction type:(CQTLocalNotificationType)type;

/* 移除localNotification */
- (void)removeLocalNotificationWithType:(CQTLocalNotificationType)type;

@end

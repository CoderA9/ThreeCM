//
//  CMDataManager.h
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 @brief 数据管理类.
 
 @discussion  
 */
@interface CMDataManager : NSObject

@property (nonatomic,retain)NSString *platformStr;

/* 初始化单例 */
+ (instancetype)sharedManager;

/* 获取手机UUID */
+ (NSString *)getUUIDString;
@end

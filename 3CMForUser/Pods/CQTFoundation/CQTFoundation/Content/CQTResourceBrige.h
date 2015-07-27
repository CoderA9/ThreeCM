//
//  CQTResourceBrige.h
//  QRCodeDemo
//
//  Created by ANine on 7/2/14.
//  Copyright (c) 2014 ANine. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief 项目数据需要在Base-Resource中用到的,Brige是中转站.
 
 @discussion 数据需要在App启动时初始化,
 
 coder states just like this:
 
 [CQTResourceBrige sharedBrige].modelMapping = [IDDataManager sharedManager].modelMapping;
 
 [CQTResourceBrige sharedBrige].suffixMapping = @"idamodelmapping";
 */
@interface CQTResourceBrige : NSObject

//获取modelMapping的全部数据.
@property (nonatomic,strong)NSMutableDictionary *modelMapping;

//modelMapping的后缀名.

@property (nonatomic,strong)NSString *suffixMapping;

//创建singleton Brige.
+ (instancetype)sharedBrige;

/* 当前App支付回调url. */
@property (nonatomic,strong)NSString *notifyUrl;

/* 当前AppUrl前缀. */
@property (nonatomic,strong)NSString *appBaseUrl;

/* 创建一个假的SESSION,供大数据分析. */
@property (nonatomic,strong)NSString *pseudoSessionId;


/* 是否禁止显示提示框，default = NO */
@property (nonatomic,assign)BOOL forbiddenAlertView;
@end

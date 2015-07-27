//
//  CMDataStructure.h
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CQTDataBaseStructure.h"
/**
 @brief 所有数据结构集合
 
 @discussion <#some notes or alert with this class#>
 */
@interface USER : CQTDataBaseStructure

@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *trueName;
@property (nonatomic,strong)NSString *phoneNum;
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *birthday;
@property (nonatomic,strong)NSString *emailStr;
@property (nonatomic,strong)NSString *gender;
@property (nonatomic,strong)NSString *avatarUrl;

@end
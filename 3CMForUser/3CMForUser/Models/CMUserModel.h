//
//  CMUserModel.h
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CQTBaseModel.h"
/**
 @brief 用户相关业务逻辑处理
 
 @discussion <#some notes or alert with this class#>
 */
@interface CMUserModel : CQTBaseModel

@property (nonatomic,strong) USER *selectedUser;

@property (nonatomic,strong) NSMutableArray *userList;

/* Model初始化后selectedUser设置为默认user. */
- (instancetype)initWithDefaultUser;

@end

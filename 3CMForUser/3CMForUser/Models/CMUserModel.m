//
//  CMUserModel.m
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CMUserModel.h"

@implementation CMUserModel

#pragma mark - | ***** super methods ***** |

- (instancetype)init {
    
    if (self = [super init]) {
    }
    return self;
}

/* Model初始化后selectedUser设置为默认user. */
- (instancetype)initWithDefaultUser {
    
    if (self = [super init]) {
        
        self.selectedUser = [[CMUser sharedUser] defaultAccount];
    }
    
    return self;
}

- (void)createModel {
    
    [super createModel];
    
    if (!self.selectedUser) {
        
        _selectedUser = [[USER alloc] init];
    }
}

- (void)createModels {
    
    [super createModels];
    
    if (!_userList) {
        
        _userList = [[NSMutableArray alloc] init];
    }
}

- (void)dealloc {
    
    A9_ObjectReleaseSafely(_selectedUser);
    
    A9_ObjectReleaseSafely(_userList);
    
    CQT_SUPER_DEALLOC();
}




#pragma mark - | ***** API ***** |


#pragma mark - | ***** public methods ***** |
@end

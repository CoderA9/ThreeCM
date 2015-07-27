//
//  CMDataManager.m
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CMDataManager.h"

@implementation CMDataManager

/* 初始化单例 */
+ (instancetype)sharedManager {

    static CMDataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

@end

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


+ (NSString *)getUUIDString {
    
    NSString *UUIDString;
    
    NSMutableDictionary *dic = [CQTKeyChain load:KEY_IDENTIFIER_FOR_WENDOR];
    
    UUIDString = dic[KEY_IDENTIFIER_FOR_WENDOR];
    
    if (! validStr(UUIDString)) {
        
        UUIDString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSMutableDictionary *tempDIc = [NSMutableDictionary dictionary];
        
        [tempDIc setObject:UUIDString forKey:KEY_IDENTIFIER_FOR_WENDOR];
        
        [CQTKeyChain save:KEY_IDENTIFIER_FOR_WENDOR data:tempDIc];
    }
    
    return UUIDString;
}

- (NSString *)platformStr {
    
    if (!_platformStr) {
        
        _platformStr = A9_platformString();
    }
    
    return _platformStr;
}

@end

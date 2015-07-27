//
//  CQTKeyChain.h
//  CQTIda
//
//  Created by ANine on 9/24/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//


//Thank4 for CHKeychain. https://github.com/xinyu198736/CHKeychain




#import <Foundation/Foundation.h>
#import <Security/Security.h>

static NSString * const KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
static NSString * const KEY_USERNAME = @"com.company.app.username";
static NSString * const KEY_PASSWORD = @"com.company.app.password";
static NSString * const KEY_IDENTIFIER_FOR_WENDOR = @"com.company.app.identifierForVendor";

@interface CQTKeyChain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;


@end
//
//  CQTResourceBrige.m
//  QRCodeDemo
//
//  Created by ANine on 7/2/14.
//  Copyright (c) 2014 ANine. All rights reserved.
//

#import "CQTResourceBrige.h"
#import "NSObject+Resource.h"
#import "NSString+Extensions.h"

@implementation CQTResourceBrige


@synthesize pseudoSessionId = _pseudoSessionId;

//创建共有Brige.
+ (instancetype)sharedBrige {
    
    static CQTResourceBrige *_sharedBrige = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedBrige = [[self alloc] init];
    });
    
    return _sharedBrige;
}

- (NSString *)appBaseUrl {
    
    if (!_appBaseUrl) {
        
        return @"noBaseUrl";
    }
    
    NSString *httpPrefix = @"http://";
    
    if (![_appBaseUrl hasPrefix:httpPrefix]) {
        
        _appBaseUrl = [NSString stringWithFormat:@"%@%@",httpPrefix,_appBaseUrl];
    }
    
    return _appBaseUrl;
}

- (void)setPseudoSessionId:(NSString *)pseudoSessionId {
    
    _pseudoSessionId = [CQTResourceBrige getPseudoSessionIdString];
    
}

- (NSString *)pseudoSessionId {
    
    if (!validStr(_pseudoSessionId)) {
        
        _pseudoSessionId = [CQTResourceBrige getPseudoSessionIdString];
    }
    
    return _pseudoSessionId;
}
#pragma mark - | ***** private methods ***** |
+ (NSString *)getPseudoSessionIdString {
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    
    NSString *sessionString = [NSString stringWithFormat:@"%f",interval];
    
    sessionString = [sessionString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    long long value = sessionString.longLongValue;
    
    NSString *HexStr = [NSString getHexString:value];
    HexStr = [NSString stringWithFormat:@"%@%@%@",HexStr,HexStr,HexStr];
    
//    NSLog(@"sessionId is %@",[HexStr substringToIndex:32]);
    
    return [HexStr substringToIndex:32];
}
@end

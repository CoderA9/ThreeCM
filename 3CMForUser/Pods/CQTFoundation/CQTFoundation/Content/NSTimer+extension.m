//
//  NSTimer+extension.m
//  QRCodeDemo
//
//  Created by ANine on 7/2/14.
//  Copyright (c) 2014 ANine. All rights reserved.
//

#import "NSTimer+extension.h"

@interface NSTimer (Private)

+ (void)bk_executeBlockFromTimer:(NSTimer *)aTimer;

@end

@implementation NSTimer (extension)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats {
    
    NSParameterAssert(block != nil);
    
	return [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(bk_executeBlockFromTimer:) userInfo:[block copy] repeats:inRepeats];
}

+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats
{
	NSParameterAssert(block != nil);
	return [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(bk_executeBlockFromTimer:) userInfo:[block copy] repeats:inRepeats];
}


+ (void)bk_executeBlockFromTimer:(NSTimer *)aTimer {
    
	void (^block)(NSTimer *) = [aTimer userInfo];
    
	if (block) block(aTimer);
}

@end

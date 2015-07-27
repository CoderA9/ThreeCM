//
//  NSTimer+extension.h
//  QRCodeDemo
//
//  Created by ANine on 7/2/14.
//  Copyright (c) 2014 ANine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (extension)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))inBlock repeats:(BOOL)inRepeats;

+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats;
@end

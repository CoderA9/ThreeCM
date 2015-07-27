//
//  CQTTapGestureRecognizer.m
//  CQTIda
//
//  Created by ANine on 1/14/15.
//  Copyright (c) 2015 www.cqtimes.com. All rights reserved.
//

#import "CQTTapGestureRecognizer.h"

@implementation CQTTapGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    
    if (self = [super initWithTarget:target action:action]) {
        
        _target = target;
        _selctor = action;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.touches = touches;
    self.event = event;
    
    if (_target && NSStringFromSelector(_selctor) &&
        [_target respondsToSelector:_selctor]) {
        
        [_target performSelector:_selctor withObject:self];
    }
}

@end

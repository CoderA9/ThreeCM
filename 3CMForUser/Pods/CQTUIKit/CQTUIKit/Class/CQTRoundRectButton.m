//
//  CQTRoundRectButton.m
//  CQTIda
//
//  Created by sky on 14-4-27.
//  Copyright (c) 2014年 www.cqtimes.com. All rights reserved.
//

#import "CQTRoundRectButton.h"

@implementation CQTRoundRectButton

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [RGB(255.f, 63.f, 31.f) CGColor];
        self.highlighted = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {

    [super setFrame:frame];
    self.layer.cornerRadius = (int)((MIN(frame.size.width, frame.size.height))/2);
}

- (void)setEnabled:(BOOL)enabled {

    [super setEnabled:enabled];
    if (enabled) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:RGB(255.f, 63.f, 31.f) forState:UIControlStateNormal];
         self.layer.borderColor = [RGB(255.f, 63.f, 31.f) CGColor];
    }
    else {
        
        self.backgroundColor = [UIColor colorWithWhite:.9f alpha:.9f];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
         self.layer.borderColor = [[UIColor grayColor] CGColor];
    }
}


- (void)setHighlighted:(BOOL)highlighted {

    [super setHighlighted:highlighted];
    
    if (self.enabled) {
     
        if (highlighted) {
            
            self.backgroundColor = RGB(255.f, 63.f, 31.f);
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            
            self.backgroundColor = [UIColor whiteColor];
            [self setTitleColor:RGB(255.f, 63.f, 31.f) forState:UIControlStateNormal];
        }
    }
}

@end

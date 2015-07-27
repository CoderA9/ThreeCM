//
//  CQTBlurView.m
//  CQTIda
//
//  Created by ANine on 5/12/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTBlurView.h"


#import <QuartzCore/QuartzCore.h>
@interface CQTBlurView ()

@end

@implementation CQTBlurView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    // If we don't clip to bounds the toolbar draws a thin shadow on top
    [self setClipsToBounds:YES];
    
    self.needRespondScreenShot = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBeginScreenShot:) name:kNotifiCationWillBeginGetScreenShot object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishScreenShot:) name:kNotifiCationFinishGetScreenShot object:nil];
    
    if (iOS_IS_UP_VERSION(7.0)) {
        
        if (![self toolbar]) {
            
            [self setToolbar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
            
            self.layer.borderWidth = 0.;
            
            self.toolbar.translucent = YES;
            
            [self.layer insertSublayer:[self.toolbar layer] atIndex:0];
            
        }
    }else {
        
        self.backgroundColor = HEX_RGBA(0xffffff, .88);
    }

}

//- (void)setBlurTintColor:(UIColor *)blurTintColor {
//
//    [self.toolbar setBarTintColor:blurTintColor];
//    [self.toolbar setNeedsLayout];
//}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (iOS_IS_UP_VERSION(7.0)) {
        
        [self.toolbar setFrame:[self bounds]];
    }
}


- (void)dealloc {
    
    A9_ObjectReleaseSafely(_toolbar);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    CQT_SUPER_DEALLOC();
}


#pragma mark - | ***** private methods ***** |
- (void)willBeginScreenShot:(NSNotification *)notify {
    
    if (!self.needRespondScreenShot) {
        
        return;
    }
    
    self.toolbar.layer.hidden = YES;
    
    self.backgroundColor = HEX_RGBA(0xffffff, 1.);
}

- (void)finishScreenShot:(NSNotification *)notify {
    
    [self finishScreenShot];
}
- (void)finishScreenShot {
    
    if (!self.needRespondScreenShot) {
        
        return;
    }
    
    if (iOS_IS_UP_VERSION(7.0)) {
        
        self.toolbar.layer.hidden = NO;
        self.backgroundColor = HEX_RGBA(0xffffff,0.);
        
    }else {
        
        self.backgroundColor = HEX_RGBA(0xffffff, .88);
    }
}
@end

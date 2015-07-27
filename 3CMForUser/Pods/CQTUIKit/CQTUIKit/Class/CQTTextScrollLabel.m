//
//  CQTTextScrollLabel.m
//  CQTIda
//
//  Created by ANine on 6/25/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTTextScrollLabel.h"

#import "UIButton+Extension.h"

@interface CQTTextScrollLabel () {
    
    BOOL _canDoAnimation;
    
    UIButton *_pauseBtn;
    
    int _runloopTimes;
    
    int _run;
}

@end
@implementation CQTTextScrollLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.adjustsFontSizeToFitWidth = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        return;
    }

}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _pauseBtn.frame = self.superView.bounds;
}

- (void)setText:(NSString *)text {
    
     [super setText:text];
    
    if (text && text.length) {
        
        if ([self checkTextAccessTheBounds] && self.textCanScroll) {
            
            self.hidden = YES;
            
            _canDoAnimation = YES;
            
            [self showScrollLoop];
        }
    }else {
        
        _canDoAnimation = NO ;
    }

}

- (void)setTextCanScroll:(BOOL)textCanScroll {
    
    _textCanScroll = textCanScroll;
    
    if (textCanScroll) {
        
        if ([self checkTextAccessTheBounds]) {
            
            self.hidden = YES;
            
            _canDoAnimation = YES;
            
            [self showScrollLoop];
        }
    }else {
        
        _canDoAnimation = NO;
    }
}

- (void)setEnablePauseFunc:(BOOL)enablePauseFunc {
    
    _enablePauseFunc = enablePauseFunc;
    
    if (enablePauseFunc) {
        
        self.userInteractionEnabled = YES;
        
        [self createPauseBtnIfNeeded];
        
        [self.superView addSubview:_pauseBtn];
        
    }else {
        
        [self createPauseBtnIfNeeded];
        _pauseBtn = nil;
    }
}

- (void)dealloc {
    
    A9_ViewReleaseSafely(_superView);
    
    CQT_SUPER_DEALLOC();
}
#pragma mark - | ***** handleNotification ***** |

- (void)handleNotification:(NSNotification *)notify {
    
    if ([notify.name isEqualToString:kNotificationtimerUpdatedKey]) {
        
        
    }
    else if ([notify.name isEqualToString:kNotificationViewDeceleratingKey]) {
        
        _canDoAnimation = [notify.object[kCanDoAnimationKey] boolValue];
        
        [self showScrollLoop];
    }
}


#pragma mark - | ***** create views ***** |
- (void)createPauseBtnIfNeeded {
    
    
    
    if (!_pauseBtn) {
        
        _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        _pauseBtn.frame = self.superView.bounds;
        
        _pauseBtn.selected = NO;

        [_pauseBtn addTarget:self action:@selector(pauBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else {
    
        CQTRemoveFromSuperViewSafely(_pauseBtn);
    }
}
#pragma mark - | *****  private methods ***** |

- (void)pauseBtnClicked:(UIButton *)sender {

    if (_pauseBtn.selected) {
        
        _canDoAnimation = YES;
        
        [self showScrollLoop];
    }else {
        
        _canDoAnimation = NO;
    }
    
    _pauseBtn.selected = !_pauseBtn.selected;
}

- (void)showScrollLoop
{
    @synchronized(self){
        
        static BOOL firstScroll = YES;
        
        if (_canDoAnimation) {
            
            if (firstScroll) {
                
                [self performSelector:@selector(doAnimation) withObject:self afterDelay:1.f];
            }else {
                
                [self doAnimation];
            }
            
            firstScroll = NO;
        }else {
            
            firstScroll = YES;
            
            CGRect foo = self.frame;
            foo.origin.x = 0;
            self.frame = foo;
        }
    }
}

- (void)doAnimation {
    
    self.hidden = NO;
    
    CGRect foo = self.frame;
    
    if (foo.origin.x + foo.size.width <= 0) {
        
        foo.origin.x = ViewWidth(self.superView);
        
        self.hidden = YES;
        self.frame = foo;
        self.hidden = NO;
        
    }
    
    if (_canDoAnimation && !_run) {
        
        _run = YES;
        foo.origin.x -= 2;
        //show aniamtion
        [UIView animateWithDuration:.1f animations:^{
            
            self.frame = foo;
        }completion:^(BOOL finished) {
                             
            _run = NO;
                             
            [self doAnimation];
        }];
    }
}

- (BOOL)checkTextAccessTheBounds {
    
    if (CGSizeEqualToSize(CGSizeZero, self.frame.size) || CGSizeEqualToSize(CGSizeZero, self.superView.frame.size)) {
        
        return NO;
    }
    
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(1000, 1000)];
    
    CGRect foo = self.frame;
    
    CQTDebugLog(@"label.text :%@ ",self.text);
    
    if (size.width >= ViewWidth(self.superView)) {
        
        foo.size.width = size.width;
        
        self.frame = foo;
        
        return YES;
    }else {
        
        foo.size.width = self.superView.frame.size.width;
        
        self.frame = foo;
    }
    
    return NO;
}
@end

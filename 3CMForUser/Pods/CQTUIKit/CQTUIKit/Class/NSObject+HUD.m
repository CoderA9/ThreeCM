//
//  NSObject+HUD.m
//  CQTIda
//
//  Created by ANine on 7/31/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "NSObject+HUD.h"

#define MAIN_VIEW [[UIApplication sharedApplication] keyWindow]

static char HUD_IS_LOADING_KEY;

static char IS_HUD_FLAG;

@implementation NSObject (HUD)

- (void)setIsHud:(BOOL)isHud {

    objc_setAssociatedObject(self, &IS_HUD_FLAG, @(isHud), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isHud {
    
    id obj = objc_getAssociatedObject(self, &IS_HUD_FLAG);
    
    BOOL isHUD = [obj boolValue];
    
    return isHUD;
}


- (void)startProcessWithTitle:(NSString*)strTitle {
    
    [self startProcessWithTitle:strTitle detailTitle:@""];
}

- (void)startProcessWithTitle:(NSString*)strTitle detailTitle:(NSString*)detailTitle {
    
    [self startProcessWithTitle:strTitle detailTitle:detailTitle key:cqt_alertview_network_key];
}

- (void)startProcessWithTitle:(NSString*)strTitle detailTitle:(NSString*)detailTitle key:(NSString *)key {
    
    CQTAlertView *ProgressingHUD = [CQTAlertManager sharedManager].showingAlertView;;
    
    if (!ProgressingHUD || !ProgressingHUD.isHud) {
        
        ProgressingHUD = [[CQTAlertView alloc] init];
        
        CQTRemoveFromSuperViewSafely(ProgressingHUD.titleLabel);
        CQTRemoveFromSuperViewSafely(ProgressingHUD.subTitleLabel);
        A9_ViewReleaseSafely(ProgressingHUD.bgView);
        
        ProgressingHUD.bgView = [[CQTView alloc] init];
        [ProgressingHUD addSubview:ProgressingHUD.bgView];
        [ProgressingHUD.bgView addSubview:ProgressingHUD.titleLabel];
        [ProgressingHUD.bgView addSubview:ProgressingHUD.subTitleLabel];
        [ProgressingHUD.bgView addSubview:ProgressingHUD.closeBtn];
        
        ProgressingHUD.bgView.backgroundColor = HEX_RGBA(0x000000,0.9);
        
        ProgressingHUD.isHud = YES;
        
        ProgressingHUD.tag = [self hudTag];
        
        ProgressingHUD.backgroundColor = kClearColor;
        
        ProgressingHUD.needGesture = NO;
        
        ProgressingHUD.closeBtn.hidden = NO;
        
        ProgressingHUD.ALERT_KEY = key;
    }
    
    ProgressingHUD.hudIsLoading = YES;
    
    ProgressingHUD.titleLabel.textColor = HEX_RGB(0xffffff);
    
    ProgressingHUD.subTitleLabel.textColor = HEX_RGB(0xffffff);
    
    [ProgressingHUD showTipsWithTitle:strTitle subTitle:detailTitle timerLength:30.];
    
    CQT_RELEASE(ProgressingHUD);
}

- (NSInteger)hudTag {
    
    return (NSInteger)-9876326;
}

- (void)setHudIsLoading:(BOOL)hudIsLoading {
    
    objc_setAssociatedObject(self,&HUD_IS_LOADING_KEY,[NSNumber numberWithBool:hudIsLoading],OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hudIsLoading {
    
    id obj = objc_getAssociatedObject(self, &HUD_IS_LOADING_KEY);
    
    BOOL hudIsLoading = NO;
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        
        hudIsLoading = [obj boolValue];
    }
    
    return hudIsLoading;
}

- (void)finishProcess {
    
    CQTAlertView *ProgressingHUD = nil;
    
    if (ProgressingHUD && !ProgressingHUD.hudIsLoading) {
        
        return;
    }
    [self finishProcessWithTitle:@""];
}

- (void)finishProcessWithTitle:(NSString*)strTitle {
    
    [self finishProcessWithTitle:strTitle timeLength:(strTitle && strTitle.length) ? .6f : 0.f];
}

- (void)finishProcessWithTitleWaitLong:(NSString*)strTitle {
    
    [self finishProcessWithTitle:strTitle timeLength:1.6f];
}

- (void)finishProcessWithTitle:(NSString*)strTitle timeLength:(CGFloat)timeLength {
    
    [self finishProcessWithTitle:strTitle subTitle:nil timeLength:timeLength];
}

- (void)finishProcessWithTitle:(NSString *)strTitle subTitle:(NSString *)subTitle timeLength:(CGFloat)timeLength {
    
    [self finishProcessWithTitle:strTitle subTitle:subTitle timeLength:timeLength key:cqt_alertview_network_key];
}

- (void)finishProcessWithTitle:(NSString *)strTitle subTitle:(NSString *)subTitle timeLength:(CGFloat)timeLength  key:(NSString *)key {
    
    if ((! strTitle && !subTitle  && !strTitle.length && !subTitle.length) || !timeLength ) {
        
        CQTAlertView *ProgressingHUD = [CQTAlertManager sharedManager].showingAlertView;
        
        if (ProgressingHUD.isHud) {
            
            [ProgressingHUD dismiss];
            
            ProgressingHUD.hudIsLoading = NO;
        }
        
        return;
    }
    
    @synchronized(self) {
        
        CQTAlertView *ProgressingHUD = [CQTAlertManager sharedManager].showingAlertView;
        
        if (ProgressingHUD.isHud) {
            
            ProgressingHUD.showTimeLength = timeLength;
            
            ProgressingHUD.needGesture = YES;
            
            ProgressingHUD.hudIsLoading = NO;
            
            [ProgressingHUD showTipsWithTitle:strTitle subTitle:subTitle timerLength:timeLength];
        }
            
        for (CQTAlertView *view in [CQTAlertManager sharedManager].alertQueue) {
            
            if (view.isHud) {
                
                view.showTimeLength = timeLength;
                
                view.needGesture = YES;
            }
        }
        
    }
    
}

- (void)finishProcessWithTitle:(NSString *)strTitle subTitle:(NSString *)subTitle showTitle:(NSString *)showtitle showSubTitle:(NSString *)showsubtitle timeLength:(CGFloat)timeLength  key:(NSString *)key {}

@end

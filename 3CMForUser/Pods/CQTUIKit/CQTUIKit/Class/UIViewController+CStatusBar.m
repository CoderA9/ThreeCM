//
//  UIViewController+CStatusBar.m
//  StatusBarDemo
//
//  Created by ANine on 2/11/15.
//  Copyright (c) 2015 ZZH. All rights reserved.
//

#import "UIViewController+CStatusBar.h"
#import <objc/runtime.h>

#define STATUS_BAR_ANIMATION_LENGTH .5f
#define FONT_SIZE 12.0f

NSString const *CStatusBarIsHiddenKey = @"CStatusBarIsHiddenKey";
NSString const *CStatusBarIsHiddendedForThisVCKey = @"CStatusBarIsHiddendedForThisVCKey";
NSString const *CStatusBarNotificationIsShowingKey = @"CStatusBarNotificationIsShowingKey";
NSString const *CStatusBarNotificationLabelKey = @"CStatusBarNotificationLabelKey";
NSString const *CRepeatCountKey = @"CRepeatCountKey";
NSString const *CLabelSpacingKey = @"CLabelSpacingKey";



@implementation UIViewController (CStatusBar)

#pragma mark -
#pragma mark publicFunction
- (void)showStatusLabelMessage:(NSString *)message {

    [self showStatusLabelMessage:message timeLength:0];
}

- (void)showStatusLabelMessage:(NSString *)message timeLength:(NSInteger)timeLength {

    [self showStatusLabelMessage:message bgColor:[UIColor blackColor] textColor:[UIColor whiteColor] timeLength:timeLength];
}

- (void)showStatusLabelMessage:(NSString *)message bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor {
    
    [self showStatusLabelMessage:message bgColor:bgColor textColor:textColor timeLength:0];
}

- (void)showStatusLabelMessage:(NSString *)message bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor timeLength:(NSInteger)timeLength {
    
    if (!self.statusBarNotificationIsShowing) {
        
        self.statusBarNotificationIsShowing = YES;
        self.statusBarNotificationLabel = [[CBAutoScrollLabel alloc] initWithFrame:[self getStatusBarHiddenFrame]];
        self.statusBarNotificationLabel.text = message;
        self.statusBarNotificationLabel.backgroundColor = bgColor;
        self.statusBarNotificationLabel.textColor = textColor;
//        self.statusBarNotificationLabel.timeLength = timeLength;
        self.statusBarNotificationLabel.labelSpacing = self.labelSpacing;
//        self.statusBarNotificationLabel.delegate = self;
//        self.statusBarNotificationLabel.repeatCount = self.repeatCount;
        self.statusBarNotificationLabel.tFont = [UIFont fontWithName:@"Avenir-Heavy" size:14.];
        [self.view addSubview:self.statusBarNotificationLabel];
        [self.view bringSubviewToFront:self.statusBarNotificationLabel];
        [self.statusBarNotificationLabel observeApplicationNotifications];
        
        CGRect statusBarFrame = [self getStatusBarFrame];
        [UIView animateWithDuration:STATUS_BAR_ANIMATION_LENGTH animations:^{
            self.statusBarIsHidden = YES;
            [self updateStatusBar];
            self.statusBarNotificationLabel.frame = statusBarFrame;
        } completion:^(BOOL finished) {
            
//            [self.statusBarNotificationLabel enabelScroll];
        }];
    }

}

- (void)finishStatusBarNotificationLabel {
    
    [self repeatFinishScroll];
}

#pragma mark - 
#pragma mark CBAutoScrollLabelDelegate
- (void)repeatFinishScroll {
    
    [UIView animateWithDuration:STATUS_BAR_ANIMATION_LENGTH animations:^{
    
        self.statusBarIsHidden = NO;
        
        [self updateStatusBar];
        self.statusBarNotificationLabel.frame = [self getStatusBarHiddenFrame];
        
    } completion:^(BOOL finished) {
        [self.statusBarNotificationLabel removeFromSuperview];
        self.statusBarNotificationIsShowing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }];
}

#pragma mark -
#pragma mark privateFunction
- (CGFloat)getStatusBarHeight {
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.width;
    }
    NSLog(@"%f", statusBarHeight);
    return statusBarHeight;
}

- (CGFloat)getStatusBarWidth {
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        return [UIScreen mainScreen].bounds.size.width;
    }
    return [UIScreen mainScreen].bounds.size.height;
}

- (CGRect)getStatusBarHiddenFrame {
    return CGRectMake(0, -1*[self getStatusBarHeight], [self getStatusBarWidth], [self getStatusBarHeight]);
}

- (CGRect)getStatusBarFrame {
    return CGRectMake(0, 0, [self getStatusBarWidth], [self getStatusBarHeight]);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (BOOL)prefersStatusBarHidden {
    
    return self.statusBarIsHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationSlide;
}
#pragma clang diagnostic pop
- (void)updateStatusBar {
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self setNeedsStatusBarAppearanceUpdate];
    
    }
    
    BOOL isHidden = self.statusBarIsHidden;
    
    if (self.statusBarIsHiddendedForThisVC) {
        
        isHidden = YES;
    }
    

    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:self.preferredStatusBarUpdateAnimation];
}

#pragma mark - 
#pragma mark setter/getter
- (void)setStatusBarIsHidden:(BOOL)statusBarIsHidden {
    
    objc_setAssociatedObject(self, &CStatusBarIsHiddenKey, [NSNumber numberWithBool:statusBarIsHidden], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)statusBarIsHidden {
    return [objc_getAssociatedObject(self, &CStatusBarIsHiddenKey) boolValue];
}

- (void)setStatusBarIsHiddendedForThisVC:(BOOL)statusBarIsHiddendedForThisVC {
    
        objc_setAssociatedObject(self, &CStatusBarIsHiddendedForThisVCKey, [NSNumber numberWithBool:statusBarIsHiddendedForThisVC], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)statusBarIsHiddendedForThisVC {

    return [objc_getAssociatedObject(self, &CStatusBarIsHiddendedForThisVCKey) boolValue];
}

- (void)setStatusBarNotificationIsShowing:(BOOL)statusBarNotificationIsShowing {
    objc_setAssociatedObject(self, &CStatusBarNotificationIsShowingKey, [NSNumber numberWithBool:statusBarNotificationIsShowing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)statusBarNotificationIsShowing {
    return [objc_getAssociatedObject(self, &CStatusBarNotificationIsShowingKey) boolValue];
}

- (void)setStatusBarNotificationLabel:(UILabel *)statusBarNotificationLabel {
    objc_setAssociatedObject(self, &CStatusBarNotificationLabelKey, statusBarNotificationLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)statusBarNotificationLabel
{
    if (objc_getAssociatedObject(self, &CStatusBarNotificationLabelKey) == nil) {
        [self setStatusBarNotificationLabel:[CBAutoScrollLabel new]];
    }
    return objc_getAssociatedObject(self, &CStatusBarNotificationLabelKey);
}

- (void)setRepeatCount:(NSInteger)repeatCount {
    objc_setAssociatedObject(self, &CRepeatCountKey, [NSNumber numberWithInteger:repeatCount], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)repeatCount {
    return [objc_getAssociatedObject(self, &CRepeatCountKey) integerValue];
}

- (void)setLabelSpacing:(NSInteger)labelSpacing {
    objc_setAssociatedObject(self, &CLabelSpacingKey, [NSNumber numberWithInteger:labelSpacing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)labelSpacing {
    
    NSInteger spacing = [objc_getAssociatedObject(self, &CLabelSpacingKey) integerValue];
    
    if (spacing <= 0) {
        
        spacing =  15.f;
    }
    
    return spacing;
}

@end

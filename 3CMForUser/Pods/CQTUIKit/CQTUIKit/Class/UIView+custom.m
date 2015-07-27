//
//  UIView+custom.m
//  Robot
//
//  Created by A9 on 2/18/14.
//  Copyright (c) 2014 A9. All rights reserved.
//

#import "UIView+custom.h"

#import <objc/runtime.h>

#import "CQTTapGestureRecognizer.h"

#import "CQTView.h"

#define TagLineTop   -53456
#define TagLineBottom   -53455
#define TagLineLeft   -53454
#define TagLineRight   -53453


#define TagLineTop   -53456
#define TagLineBottom   -53455
#define TagLineLeft   -53454
#define TagLineRight   -53453

#define TagLineVerticalCenter -53452
#define TagLineHorizontalCenter -53451


#define lineWidthDefault 1.f

#define lineWidth lineWidthDefault
#define lineColorDefault HEX_RGBA(0xCCCCCC,1.f)

static char SINGLE_LINE_WIDTH;


@implementation UIView (custom)

- (void)updateSingleLine {
    
    //    CGFloat width = lineWidth;
    //
    //    UIView *label = [self viewWithTag:TagLineLeft];
    //    label.frame = CGRectMake(0, 0, width, self.frame.size.height);
    //
    //    label = [self viewWithTag:TagLineRight];
    //    label.frame = CGRectMake( self.frame.size.width - width, 0,width, self.frame.size.height);
    //
    //    label = [self viewWithTag:TagLineTop];
    //    label.frame = CGRectMake(0, 0, self.frame.size.width, width);
    //
    //    label = [self viewWithTag:TagLineBottom];
    //    label.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
    //
    //    label = [self viewWithTag:TagLineVerticalCenter];
    //    label.frame = CGRectMake(0, self.frame.size.height /2 - width, self.frame.size.width   ,width );
    //
    //    label = [self viewWithTag:TagLineHorizontalCenter];
    //    label.frame = CGRectMake(self.frame.size.width /2 - width, 0, width, self.frame.size.height);
}

- (void)addSingleLineWithTop:(BOOL)top buttom:(BOOL)buttom {
    [self addSingleLineWithTop:top buttom:buttom singleLinedth:lineWidth];
}

- (void)addSingleLineWithLeft:(BOOL)left right:(BOOL)right {
    [self addSingleLineWithLeft:left right:right singleLinedth:lineWidth];
}

- (void)addSingleLineWithTop:(BOOL)top buttom:(BOOL)buttom lineColor:(UIColor *)color {
    [self addSingleLineWithTop:top buttom:buttom singleLinedth:lineWidth lineColor:color];
}

- (void)addSingleLineWithLeft:(BOOL)left right:(BOOL)right lineColor:(UIColor *)color {
    [self addSingleLineWithLeft:left right:right singleLinedth:lineWidth lineColor:color];
}

- (void)addSingleLineWithLeft:(BOOL)left right:(BOOL)right singleLinedth:(CGFloat)singleLinedth {
    [self addSingleLineWithLeft:left right:right singleLinedth:singleLinedth lineColor:HEX_RGBA(0xCCCCCC,0.3f)];
}

- (void)addSingleLineWithTop:(BOOL)top buttom:(BOOL)buttom singleLinedth:(CGFloat)singleLinedth {
    [self addSingleLineWithTop:top buttom:buttom singleLinedth:singleLinedth lineColor:HEX_RGBA(0xCCCCCC,0.3f)];
}
- (void)addSingleLineWithLeft:(BOOL)left right:(BOOL)right singleLinedth:(CGFloat)singleLinedth lineColor:(UIColor *)color {
    
    if (singleLinedth <= 0.) {
        
        singleLinedth = lineWidth;
    }
    
    UILabel *label;
    
    if (left) {
        
        label = (UILabel *)[self viewWithTag:TagLineLeft];
        if (!label) {
            
            label = [[UILabel alloc] init];
            
            label.translatesAutoresizingMaskIntoConstraints=NO;
            
            [self addSubview:label];
        }
        
        label.backgroundColor = color;
        label.tag = TagLineLeft;
        
        UIView *view = self;
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:singleLinedth]];
        
        
    }else {
        
        label = (UILabel *)[self viewWithTag:TagLineLeft];
        
        if (label && [label.superview isEqual:self]) {
            
            //            A9_ViewReleaseSafely(label);
            label = nil;
        }
        label = nil;
    }
    
    
    if (right) {
        label = (UILabel *)[self viewWithTag:TagLineRight];
        if (!label) {
            label = [[UILabel alloc] init];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];
        }
        
        label.backgroundColor = color;
        label.tag = TagLineRight;
        
        UIView *view = self;
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:singleLinedth]];
    }else {
        
        label = (UILabel *)[self viewWithTag:TagLineRight];
        
        if (label && [label.superview isEqual:self]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                label.hidden = YES;
                
            });
            //            A9_ViewReleaseSafely(label);
            label = nil;
        }
        label = nil;
    }
}
- (void)addSingleLineWithTop:(BOOL)top buttom:(BOOL)buttom singleLinedth:(CGFloat)singleLinedth lineColor:(UIColor *)color {
    
    if (singleLinedth <= 0.) {
        singleLinedth = lineWidth;
    }
    UILabel *label;
    if (top) {
        label = (UILabel *)[self viewWithTag:TagLineTop];
        if (!label) {
            label = [[UILabel alloc] init];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];
        }
        label.backgroundColor = color;
        label.tag = TagLineTop;
        
        UIView *view = self;
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:singleLinedth]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
    }else {
        
        label = (UILabel *)[self viewWithTag:TagLineTop];
        
        if (label && [label.superview isEqual:self]) {
            
            label = nil;
        }
        label = nil;
    }
    
    if (buttom) {
        label = (UILabel *)[self viewWithTag:TagLineBottom];
        if (!label) {
            label = [[UILabel alloc] init];
            
            label.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self addSubview:label];
        }
        label.backgroundColor = color;
        
        label.tag = TagLineBottom;
        
        UIView *view = self;
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:singleLinedth]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    }else {
        
        if (label && [label.superview isEqual:self]) {
            
            //            A9_ViewReleaseSafely(label);
            label = nil;
        }
        
        label = nil;
    }
}


- (void)addVerticalLineToCenter:(BOOL)vertical {
    [self addVerticalLineToCenter:vertical width:lineWidthDefault];
}

- (void)addVerticalLineToCenter:(BOOL)vertical scale:(CGFloat)scale {
    
    [self addVerticalLineToCenter:vertical width:lineWidth color:lineColorDefault scale:scale];
}

- (void)addVerticalLineToCenter:(BOOL)vertical width:(CGFloat)width {
    [self addVerticalLineToCenter:vertical width:width color:lineColorDefault];
}
- (void)addVerticalLineToCenter:(BOOL)vertical color:(UIColor *)color {
    [self addVerticalLineToCenter:vertical width:lineWidthDefault color:color];
}
- (void)addVerticalLineToCenter:(BOOL)vertical width:(CGFloat)width color:(UIColor *)color {
    
    [self addVerticalLineToCenter:vertical width:width color:color scale:1.];
    
}

- (void)addVerticalLineToCenter:(BOOL)vertical width:(CGFloat)width color:(UIColor *)color scale:(CGFloat)scale {
    
    if (width <= 0.) {
        
        width = lineWidth;
    }
    
    if (!color) {
        
        color = lineColorDefault;
    }
    
    if (scale < 0) {
        
        scale = 1.;
    }
    
    
    UILabel *label;
    if (vertical) {
        
        label = (UILabel *)[self viewWithTag:TagLineVerticalCenter];
        
        if (!label) {
            
            label = [[UILabel alloc] init];
            
            label.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self addSubview:label];
        }
        
        label.backgroundColor = color;
        label.tag = TagLineVerticalCenter;
        
        UIView *view = self;
        
        CGFloat widthSeperate = view.frame.size.height *(1 - scale) / 2;
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:scale constant:0]];
        
    }else {
        
        label = (UILabel *)[self viewWithTag:TagLineVerticalCenter];
        if (label && [label.superview isEqual:self]) {
            
            //            A9_ViewReleaseSafely(label);
            label = nil;
        }
        label = nil;
    }
}

- (void)addHorizontalLineToCenter:(BOOL)horizontal {
    [self addHorizontalLineToCenter:horizontal color:lineColorDefault];
}

- (void)addHorizontalLineToCenter:(BOOL)horizontal scale:(CGFloat)scale {
    
    [self addHorizontalLineToCenter:horizontal width:lineWidth color:lineColorDefault scale:scale];
}

- (void)addHorizontalLineToCenter:(BOOL)horizontal width:(CGFloat)width {
    [self addHorizontalLineToCenter:horizontal width:width color:lineColorDefault];
}
- (void)addHorizontalLineToCenter:(BOOL)horizontal color:(UIColor *)color {
    [self addHorizontalLineToCenter:horizontal width:lineWidthDefault color:color scale:1.];
}
- (void)addHorizontalLineToCenter:(BOOL)horizontal width:(CGFloat)width color:(UIColor *)color {
    
    [self addHorizontalLineToCenter:horizontal width:width color:color scale:1.];
}
- (void)addHorizontalLineToCenter:(BOOL)horizontal width:(CGFloat)width color:(UIColor *)color scale:(CGFloat)scale {
    
    if (width <= 0.) {
        
        width = lineWidth;
    }
    
    if (!color) {
        
        color = lineColorDefault;
    }
    if (scale < 0) {
        
        scale = 1.;
    }
    
    
    UILabel *label;
    
    if (horizontal) {
        
        label = (UILabel *)[self viewWithTag:TagLineHorizontalCenter];
        
        if (!label) {
            
            label = [[UILabel alloc] init];
            
            label.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self addSubview:label];
        }
        
        label.backgroundColor = color;
        label.tag = TagLineHorizontalCenter;
        
        UIView *view = self;
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1. constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1.]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:scale constant:0]];
    }else {
        
        label = (UILabel *)[self viewWithTag:TagLineVerticalCenter];
        
        if (label && [label.superview isEqual:self]) {
            
            label = nil;
        }
        label = nil;
    }
}


static void completionCallback (SystemSoundID mySSID) {
    
    //    SoundEngine_StartBackgroundMusic();
    
}

#pragma mark - | ***** public methods ***** |

- (void)beginTremble:(BOOL)shake {
    
    CATransform3D transform;
    
    if (arc4random() % 2 == 1)
        transform = CATransform3DMakeRotation(-0.015, 0.0, 0.0 , 1.0);
    else
        transform = CATransform3DMakeRotation(0.015, 0, 0, 1.0);
    
    
    
    transform = CATransform3DMakeTranslation( 4.0, 0.0 , 0.0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.autoreverses = YES;
    animation.duration = 0.02;
    animation.delegate = self;
    
    CATransform3D transformV = CATransform3DMakeTranslation( 0, - 3.0 , 0);
    CABasicAnimation *animationV = [CABasicAnimation animationWithKeyPath:@"transform"];
    animationV.autoreverses = YES;
    animationV.duration = 0.02;
    animationV.beginTime = 0.02;
    animationV.toValue = [NSValue valueWithCATransform3D:transformV];
    animationV.delegate = self;
    
    
    CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
    animaGroup.animations = [NSArray arrayWithObjects:animation,animationV, nil];
    animaGroup.duration = 0.08;
    animaGroup.repeatCount = 10000;
    
    [[self layer] addAnimation:animaGroup forKey:@"animationGroup"];
    
    
    
    if (shake) {
        
        //        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL,shakeCallBack,(__bridge void *)self);
        //        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //        [self triggerShake];
        //        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    
}

- (void)setLayerCornerRadius:(CGFloat)cornerRadius {
    
    [self setLayerWidth:0 color:kClearColor cornerRadius:cornerRadius];
}
- (void)setLayerWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

+ (void)viewBeVisiabledWithView:(UIView *)view scrollView:(UIScrollView *)scrollView yoffet:(CGFloat)yOffset{
    
    [CQTView viewBeVisiabledWithView:view scrollView:scrollView yoffet:yOffset animation:NO ];
}

+ (void)viewBeVisiabledWithView:(UIView *)view scrollView:(UIScrollView *)scrollView yoffet:(CGFloat)yOffset  animation:(BOOL)animation {
    
    CGFloat animationInterval = 0.;
    if (animation) {
        
        animation = 0.3f;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    CGRect foo = [view convertRect:view.frame toView:window];
    
    foo.origin.y += yOffset;
    
    CGFloat pickerHeight = 217;
    
    CGFloat delta = (foo.origin.y+ foo.size.height) - (ViewHeight(window) - pickerHeight);
    
    if (delta <= 0) {
        
        return;
    }
    
    [UIView animateWithDuration:animationInterval animations:^{
        
        scrollView.contentOffset = CGPointMake(0, delta);
    }];
}

+ (void)cellSubviewBeVisiabledWithView:(UIView *)view tableview:(UIScrollView *)scrollView controlView:(UIView *)controlView yoffet:(CGFloat)yOffset{
    
    [CQTView cellSubviewBeVisiabledWithView:view tableview:scrollView controlView:controlView yoffet:yOffset animation:NO];
}
+ (void)cellSubviewBeVisiabledWithView:(UIView *)view tableview:(UIScrollView *)scrollView controlView:(UIView *)controlView yoffet:(CGFloat)yOffset animation:(BOOL)animation {
    
    CGFloat animationInterval = 0.;
    if (animation) {
        
        animation = 0.3f;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    CGRect foo = [scrollView convertRect:view.frame toView:controlView];
    
    foo = [controlView convertRect:foo fromView:window];
    
    foo.origin.y += yOffset;
    
    CGFloat pickerHeight = 217;
    
    CGFloat delta = (foo.origin.y+ foo.size.height) - (ViewHeight(window) - pickerHeight);
    
    if (delta < 0) {
        
        return;
    }
    [UIView animateWithDuration:animationInterval animations:^{
        
        scrollView.contentOffset = CGPointMake(0, delta);
    }];
}

- (void)needOneTouchWithInvokeSel:(SEL)sel target:(id)target {
    
    CQTTapGestureRecognizer *oneTap = nil;
    
    NSArray *gestures = self.gestureRecognizers;
    
    for (UIGestureRecognizer *subGesture in gestures) {
        
        if (subGesture.tag.integerValue == kScrollView_OneTouchGesture_TAG &&
            [subGesture isKindOfClass:[UITapGestureRecognizer class]]) {
            
            oneTap = (CQTTapGestureRecognizer *)subGesture;
        }
    }
    
    if (!oneTap) {
        
        oneTap = [[CQTTapGestureRecognizer alloc] initWithTarget:target action:sel];
        
        [self addGestureRecognizer:oneTap];
        
        oneTap.tag = @(kScrollView_OneTouchGesture_TAG);
        
        CQT_RELEASE(oneTap);
        oneTap = nil;
    }
    
}

- (CQTTapGestureRecognizer *)getOneTouchGesture {
    
    CQTTapGestureRecognizer *oneTap = nil;
    
    NSArray *gestures = self.gestureRecognizers;
    
    for (UIGestureRecognizer *subGesture in gestures) {
        
        if (subGesture.tag == @(kScrollView_OneTouchGesture_TAG) &&
            [subGesture isKindOfClass:[UITapGestureRecognizer class]]) {
            
            oneTap = (CQTTapGestureRecognizer *)subGesture;
        }
    }
    
    return oneTap;
}

- (void)removeOneTouchGesture {
    
    UIGestureRecognizer *gesture = [self getOneTouchGesture];
    
    if (gesture) {
        
        [self removeGestureRecognizer:gesture];
    }
}

- (BOOL)selfOrSuperIsKindOfClass:(Class)aclass {
    
    UIView *view = self;
    
    BOOL isKind = NO;
    
    while (view != nil && !isKind) {
        
        if (![view isKindOfClass:aclass]) {
            
            view = view.superview;
        }else {
            
            isKind = YES;
        }
    }
    
    return isKind;
}
#pragma mark - | ***** private methods ***** |

static void shakeCallBack(SystemSoundID soundId, void* user_data) {
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)triggerShake {
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self performSelector:@selector(triggerShake) withObject:nil afterDelay:0.1];
}

- (void)tremBle:(CGFloat)seconds shake:(BOOL)shake {
    
    [self beginTremble:shake];
    
    if (seconds >= 15) {
        
        seconds = 15;
    }
    
    [self performSelector:@selector(endTremble) withObject:nil afterDelay:seconds];
}

- (void)endTremble {
    
    [self.layer removeAnimationForKey:@"animationGroup"];
    
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(triggerShake)
                                               object:nil];
}

- (void)needBlur:(BOOL)needBlur {
    
    static int blur = 0;
    
    if (blur == 0) {
        
        if (iOS_IS_UP_VERSION(7.0)) {
            self.backgroundColor = [UIColor clearColor];
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:self.bounds];
            toolBar.translucent = YES;
            
            [self.layer insertSublayer:[toolBar layer] atIndex:0];
        }else {
        }
    }
}


@end

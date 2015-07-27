//
//  UIView+custom.h
//  Robot
//
//  Created by A9 on 2/18/14.
//  Copyright (c) 2014 A9. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @brief
 add custom singleLine to UIView
 @discuss
 this method will invoked after the method:[UIView setFrame:frame],because i disability override the method: - (void)setFrame:(CGRect)frame.
 */


@class CQTTapGestureRecognizer;


@interface UIView (custom)

#define kSingleLineColorDefault HEX_RGBA(0xeeeeee,1.f)

#define kScrollView_OneTouchGesture_TAG -985625

@property (nonatomic,assign)CGFloat singlelineWidth;

- (void)updateSingleLine;

- (void)addSingleLineWithLeft:(BOOL)left right:(BOOL)right;
- (void)addSingleLineWithTop:(BOOL)top buttom:(BOOL)buttom;
- (void)addSingleLineWithTop:(BOOL)top buttom:(BOOL)buttom singleLinedth:(CGFloat)singleLinedth;
- (void)addSingleLineWithLeft:(BOOL)left right:(BOOL)right singleLinedth:(CGFloat)singleLinedth;
- (void)addSingleLineWithLeft:(BOOL)left right:(BOOL)right lineColor:(UIColor *)color;
- (void)addSingleLineWithTop:(BOOL)top buttom:(BOOL)buttom lineColor:(UIColor *)color;
- (void)addSingleLineWithLeft:(BOOL)left right:(BOOL)right singleLinedth:(CGFloat)singleLinedth lineColor:(UIColor *)color;
- (void)addSingleLineWithTop:(BOOL)top buttom:(BOOL)buttom singleLinedth:(CGFloat)singleLinedth lineColor:(UIColor *)color;


- (void)addVerticalLineToCenter:(BOOL)vertical;
- (void)addVerticalLineToCenter:(BOOL)vertical scale:(CGFloat)scale;
- (void)addVerticalLineToCenter:(BOOL)vertical color:(UIColor *)color;
- (void)addVerticalLineToCenter:(BOOL)vertical width:(CGFloat)width color:(UIColor *)color;
- (void)addVerticalLineToCenter:(BOOL)vertical width:(CGFloat)width color:(UIColor *)color scale:(CGFloat)scale;

- (void)addHorizontalLineToCenter:(BOOL)horizontal;
- (void)addHorizontalLineToCenter:(BOOL)horizontal scale:(CGFloat)scale;
- (void)addHorizontalLineToCenter:(BOOL)horizontal width:(CGFloat)width;
- (void)addHorizontalLineToCenter:(BOOL)horizontal color:(UIColor *)color;
- (void)addHorizontalLineToCenter:(BOOL)horizontal width:(CGFloat)width color:(UIColor *)color;
- (void)addHorizontalLineToCenter:(BOOL)horizontal width:(CGFloat)width color:(UIColor *)color scale:(CGFloat)scale;
- (void)updateSubviewsGUI;

//启动抖动功能，shake == YES 带震动.下面同理.
- (void)beginTremble:(BOOL)shake;

/* 启用毛玻璃,会自动将该View的backgorundColor设置为透明. */
- (void)needBlur:(BOOL)needBlur;

//抖动,seconds秒后,自动结束.
- (void)tremBle:(CGFloat)seconds shake:(BOOL)shake;
//结束抖动.
- (void)endTremble;


- (void)setLayerCornerRadius:(CGFloat)cornerRadius;
- (void)setLayerWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

/* 使view在window中可见.view必须是scrollView的子view */
+ (void)viewBeVisiabledWithView:(UIView *)view scrollView:(UIScrollView *)scrollView yoffet:(CGFloat)yOffset;
+ (void)viewBeVisiabledWithView:(UIView *)view scrollView:(UIScrollView *)scrollView yoffet:(CGFloat)yOffset animation:(BOOL)animation ;


+ (void)cellSubviewBeVisiabledWithView:(UIView *)view tableview:(UIScrollView *)scrollView controlView:(UIView *)controlView yoffet:(CGFloat)yOffset;
+ (void)cellSubviewBeVisiabledWithView:(UIView *)view tableview:(UIScrollView *)scrollView controlView:(UIView *)controlView yoffet:(CGFloat)yOffset animation:(BOOL)animation;

/*
 注册一个oneTapGesture
 
 @pragma
 sel  回调的方法.
 target 回调的target.
 
 @discussion:
 
 使用该方法必须要调用removeOneTouchGesture,否则会引起内存泄露
 */
- (void)needOneTouchWithInvokeSel:(SEL)sel target:(id)target;
/* 获取oneTouchGesture */
- (CQTTapGestureRecognizer *)getOneTouchGesture;
/* 移除oneTouchGesture */
- (void)removeOneTouchGesture;

- (BOOL)selfOrSuperIsKindOfClass:(Class)aclass;

@end

//
//  UIViewController+CStatusBar.h
//  StatusBarDemo
//
//  Created by ANine on 2/11/15.
//  Copyright (c) 2015 ZZH. All rights reserved.
//
// 使用方法
// 在VC中调用

// 1.若文字超出一屏,则会自动滚动.
//    self.repeatCount = 3; //如果滚动,重复的次数.
//    self.labelSpacing = 30;//如果滚动,头尾间隔的像素.
//    [self showStatusLabelMessage:text bgColor:bgColor textColor:textColor];

// 2.如果没有滚动.
//    2.1:可以调用[self showStatusLabelMessage:message timeLenght:timeLength];来指定显示的时间.
//    2.2:如果没有指定显示的时长,则需要在VC中调用[self finishStatusBarNotificationLabel];来完成显示.
//

#import <UIKit/UIKit.h>
#import "CBAutoScrollLabel.h"

@interface UIViewController (CStatusBar)

@property (strong, nonatomic) CBAutoScrollLabel *statusBarNotificationLabel;
@property (nonatomic, readwrite) BOOL statusBarIsHidden;

/* 默认是NO,如果调用的VC本来就是隐藏statusBar时,需要调用设置属性 */
@property (nonatomic, readwrite) BOOL statusBarIsHiddendedForThisVC;
@property (nonatomic, readwrite) BOOL statusBarNotificationIsShowing;
@property (nonatomic, readwrite) NSInteger repeatCount;
@property (nonatomic, readwrite) NSInteger labelSpacing;

- (void)showStatusLabelMessage:(NSString *)message;
- (void)showStatusLabelMessage:(NSString *)message timeLength:(NSInteger)timeLength;
- (void)showStatusLabelMessage:(NSString *)message bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor;
- (void)showStatusLabelMessage:(NSString *)message bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor timeLength:(NSInteger)timeLength;;



- (void)finishStatusBarNotificationLabel;
@end


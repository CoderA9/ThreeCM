//
//  UILabel+ANineExtension.h
//  Demo_xib
//
//  Created by ANine on 4/29/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+ANineExtension.h"

@interface UILabel (ANineExtension)

/* 初始化Label */
+ (instancetype)loadLabel;
//设置背景色.
- (UILabel * (^)(UIColor * attr))background_color;
//设置字体.
- (UILabel * (^)(UIFont * attr))text_font;
//设置字体颜色.
- (UILabel * (^)(UIColor * attr))text_color;
//设置字体居中.
- (UILabel * (^)(NSTextAlignment alignment))text_alignMent;
//设置文本.
- (UILabel * (^)(NSString * attr))_text;
//设置断行模式
- (UILabel * (^)(NSLineBreakMode lbModel))line_breakModel;
//设置userInterfaceEnable
- (UILabel * (^)(BOOL enable))user_inter_enable;
//设置Enable
- (UILabel * (^)(BOOL enable))Enable;
//设置numberOfLines
- (UILabel * (^)(NSInteger num))number_lines;
//设置文本自适应宽度
- (UILabel * (^)(BOOL adjust))adjusts_fontSizeFitWidth;
@end

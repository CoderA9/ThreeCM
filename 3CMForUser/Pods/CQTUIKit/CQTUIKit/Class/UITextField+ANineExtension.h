//
//  UITextField+ANineExtension.h
//  Demo_xib
//
//  Created by ANine on 4/30/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+ANineExtension.h"

@interface UITextField (ANineExtension)

/* 设置文本 */
- (UITextField * (^)(NSString *))Text;
/* 设置attributedText */
- (UITextField * (^)(NSAttributedString *))attri_text;
- (UITextField * (^)(UIColor *))text_color;
- (UITextField * (^)(UIFont *))Font;
- (UITextField * (^)(NSTextAlignment ))text_alignment;
- (UITextField * (^)(UITextBorderStyle ))boarder_style;
- (UITextField * (^)(NSDictionary * ))default_text_attr;
- (UITextField * (^)(NSString * ))place_holder;
- (UITextField * (^)(NSAttributedString * ))attr_place_holder;
- (UITextField * (^)(BOOL ))clear_on_begin_editing;
- (UITextField * (^)(BOOL ))adjust_font_size_to_fit_width;
- (UITextField * (^)(CGFloat ))min_font_size;
- (UITextField * (^)(id<UITextFieldDelegate> ))Delegate;
- (UITextField * (^)(UIImage * ))Background;
- (UITextField * (^)(UIImage * ))dis_background;
- (UITextField * (^)(BOOL ))allow_editing_text_attr;
- (UITextField * (^)(NSDictionary * ))typing_attr;
- (UITextField * (^)(UITextFieldViewMode ))clear_btn_mode;
- (UITextField * (^)(UIView * ))left_view;
- (UITextField * (^)(UITextFieldViewMode ))left_view_mode;
- (UITextField * (^)(UIView * ))right_view;
- (UITextField * (^)(UITextFieldViewMode ))right_view_mode;
- (UITextField * (^)(UIView * ))input_view;
- (UITextField * (^)(UIView * ))input_accessory_view;
- (UITextField * (^)(BOOL ))clear_on_insertion;
@end

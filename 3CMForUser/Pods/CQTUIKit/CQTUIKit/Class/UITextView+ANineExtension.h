//
//  UITextView+ANineExtension.h
//  Demo_xib
//
//  Created by ANine on 4/30/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+ANineExtension.h"

@interface UITextView (ANineExtension)

/* 设置文本 */
- (UITextView * (^)(NSString *))Text;
/* 设置attributedText */
- (UITextView * (^)(NSAttributedString *))attri_text;
- (UITextView * (^)(UIColor *))text_color;
- (UITextView * (^)(UIFont *))Font;
- (UITextView * (^)(NSTextAlignment ))text_alignment;
- (UITextView * (^)(NSRange ))select_range;
- (UITextView * (^)(BOOL ))Editable;
- (UITextView * (^)(BOOL ))Selectable;
- (UITextView * (^)(UIDataDetectorTypes ))data_detector_types;
- (UITextView * (^)(id<UITextViewDelegate> ))Delegate;
- (UITextView * (^)(BOOL ))allow_editing_text_attr;
- (UITextView * (^)(NSDictionary * ))typing_attr;
- (UITextView * (^)(UIView * ))input_view;
- (UITextView * (^)(UIView * ))input_accessory_view;
- (UITextView * (^)(BOOL ))clear_on_insertion;
- (UITextView * (^)(UIEdgeInsets ))text_container_insets;
- (UITextView * (^)(NSDictionary * ))link_text_attr;
@end

//
//  UITableViewCell+ANineExtension.h
//  Odering
//
//  Created by CQTimes iMac-002 on 15/4/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ANineExtension)

- (UITableViewCell * (^)(UIView *))select_background_view;
- (UITableViewCell * (^)(UIView *))multiple_select_background_view;
- (UITableViewCell * (^)(UITableViewCellSelectionStyle ))selection_style;
- (UITableViewCell * (^)(BOOL ))Selected;
- (UITableViewCell * (^)(BOOL ))Highlighted;
- (UITableViewCell * (^)(BOOL ))shows_reorder_control;
- (UITableViewCell * (^)(BOOL ))should_indent_while_editing;
- (UITableViewCell * (^)(UITableViewCellAccessoryType ))accessory_type;
- (UITableViewCell * (^)(UITableViewCellAccessoryType ))editing_accessory_type;
- (UITableViewCell * (^)(UIView *))accessory_view;
- (UITableViewCell * (^)(UIView *))editing_accessory_view;
- (UITableViewCell * (^)(NSInteger ))indentation_level;
- (UITableViewCell * (^)(CGFloat ))indentation_width;
- (UITableViewCell * (^)(UIEdgeInsets ))separator_inset;
- (UITableViewCell * (^)(BOOL ))Editing;

@end

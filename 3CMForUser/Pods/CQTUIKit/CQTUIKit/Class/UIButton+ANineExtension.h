//
//  UIButton+ANineExtension.h
//  Demo_xib
//
//  Created by ANine on 4/29/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+ANineExtension.h"

@interface UIButton (ANineExtension)

/* 点击时是否高亮 */
- (UIButton * (^)(BOOL value))shows_touch_highlighted;
/* 设置tintColor */
- (UIButton * (^)(UIColor *value))tint_color;
/* 设置state下的Title */
- (UIButton * (^)(NSString *value,UIControlState state))title_state;
/* 设置state下的TitleColor */
- (UIButton * (^)(UIColor *value,UIControlState state))title_color_state;
/* 设置state下的backgroundImage */
- (UIButton * (^)(UIImage *value,UIControlState state))background_image_state;
/* 设置state下的Image */
- (UIButton * (^)(UIImage *value,UIControlState state))image_state;
@end

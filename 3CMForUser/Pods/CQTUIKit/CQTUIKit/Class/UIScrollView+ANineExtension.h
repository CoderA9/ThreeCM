//
//  UIScrollView+ANineExtension.h
//  Demo_xib
//
//  Created by ANine on 4/30/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+ANineExtension.h"

@interface UIScrollView (ANineExtension)

- (UIScrollView * (^)(CGPoint value))content_offset;
- (UIScrollView * (^)(CGSize value))content_size;
- (UIScrollView * (^)(UIEdgeInsets value))content_inset;
- (UIScrollView * (^)(id<UIScrollViewDelegate> value))Delegate;
- (UIScrollView * (^)(BOOL value))directional_lock_enabled;
- (UIScrollView * (^)(BOOL value))Bounces;
- (UIScrollView * (^)(BOOL value))always_bounds_vertical;
- (UIScrollView * (^)(BOOL value))always_bounds_horizontal;
- (UIScrollView * (^)(BOOL value))page_enable;
- (UIScrollView * (^)(BOOL value))scroll_enable;
- (UIScrollView * (^)(BOOL value))shows_horizontal_scroll_indicator;
- (UIScrollView * (^)(BOOL value))shows_vertical_scroll_indicator;
- (UIScrollView * (^)(UIEdgeInsets value))scroll_indicator_insets;
- (UIScrollView * (^)(UIScrollViewIndicatorStyle value))indicator_style;
- (UIScrollView * (^)(CGFloat value))deceleration_rate;
- (UIScrollView * (^)(BOOL value))delays_content_touches;
- (UIScrollView * (^)(BOOL value))can_cancel_content_touches;
- (UIScrollView * (^)(CGFloat value))min_zoom_scale;
- (UIScrollView * (^)(CGFloat value))max_zoom_scale;
- (UIScrollView * (^)(BOOL value))bounces_zoom;
- (UIScrollView * (^)(BOOL value))scroll_to_top;
- (UIScrollView * (^)(UIScrollViewKeyboardDismissMode value))keyboard_dismiss_mode;

@end

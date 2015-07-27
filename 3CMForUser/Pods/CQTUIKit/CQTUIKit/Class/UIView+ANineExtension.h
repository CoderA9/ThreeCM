//
//  UIView+ANineExtension.h
//  Demo_xib
//
//  Created by ANine on 4/29/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ANineExtension)

/* 设置userInteractionEnabled */
- (UIView * (^)(BOOL value))user_inter_enable;

/* 设置Tag */
- (UIView * (^)(NSInteger value))Tag;

/* 设置Frame */
- (UIView * (^)(CGRect value))Frame;

/* 设置bounds */
- (UIView * (^)(CGRect value))Bounds;

/* 设置Center */
- (UIView * (^)(CGPoint value))Center;

/* 设置transform */
- (UIView * (^)(CGAffineTransform value))Transform;

/* 设置contentScaleFactor */
- (UIView * (^)(CGFloat value))content_scale_factor;

/* 设置clipsToBounds */
- (UIView * (^)(BOOL value))clips_bounds;

/* 设置backgroundColor */
- (UIView * (^)(UIColor *value))background_color;

/* 设置alpha */
- (UIView * (^)(CGFloat value))Alpha;

/* 设置Hidden */
- (UIView * (^)(BOOL value))_hidden;

/* 设置contentMode */
- (UIView * (^)(UIViewContentMode value))content_mode;

/* 设置tintColor */
- (UIView * (^)(UIColor * value))tint_color;

/* 设置multipleTouchEnabled */
- (UIView * (^)(BOOL  value))multi_touch_enable;

/* 设置exclusiveTouch */
- (UIView * (^)(BOOL  value))exclusive_touch;

- (void)testUIView;

@end

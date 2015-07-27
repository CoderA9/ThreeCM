//
//  UIImageView+ANineExtension.h
//  Demo_xib
//
//  Created by ANine on 4/29/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+ANineExtension.h"

@interface UIImageView (ANineExtension)

/* 设置Image */
- (UIImageView *(^)(UIImage *value))Image;

/* 设置highlightImage */
- (UIImageView *(^)(UIImage *value))highlight_image;

/* 设置userInteractionEnabled */
- (UIImageView *(^)(BOOL value))UIEnable;

/* 设置highlighted */
- (UIImageView *(^)(BOOL value))high_lighted;

/* 设置TintColor */
- (UIImageView *(^)(UIColor * value))tint_color;

/* 设置动画照片组 */
- (UIImageView *(^)(NSArray * value))anim_Images;

/* 设置高亮状态动画照片组 */
- (UIImageView *(^)(NSArray * value))high_anim_Images;

/* 设置动画时间间隔 */
- (UIImageView *(^)(NSTimeInterval value))animation_duration;

/* 设置动画重复次数 */
- (UIImageView *(^)(NSInteger value))anim_repeat_cnt;
@end

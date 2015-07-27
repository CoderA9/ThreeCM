//
//  UIImageView+ANineExtension.m
//  Demo_xib
//
//  Created by ANine on 4/29/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "UIImageView+ANineExtension.h"

@implementation UIImageView (ANineExtension)

/* 设置Image */
- (UIImageView *(^)(UIImage *value))Image {
    
    return ^id(UIImage *value) {
        
        self.image = value;
        return self;
    };
}

/* 设置highlightImage */
- (UIImageView *(^)(UIImage *value))highlight_image {

    return ^id(UIImage *value) {
        
        self.highlightedImage = value;
        return self;
    };
}

/* 设置userInteractionEnabled */
- (UIImageView *(^)(BOOL value))UIEnable {

    return ^id(BOOL value) {
        
        self.userInteractionEnabled = value;
        return self;
    };
}

/* 设置highlighted */
- (UIImageView *(^)(BOOL value))high_lighted {

    return ^id(BOOL value) {
        
        self.highlighted = value;
        return self;
    };
}

/* 设置TintColor */
- (UIImageView *(^)(UIColor * value))tint_color {

    return ^id(UIColor * value) {
        
        self.tintColor = value;
        return self;
    };
}

/* 设置动画照片组 */
- (UIImageView *(^)(NSArray * value))anim_Images {

    return ^id(NSArray * value) {
        
        self.animationImages = value;
        return self;
    };
}

/* 设置高亮状态动画照片组 */
- (UIImageView *(^)(NSArray * value))high_anim_Images {

    return ^id(NSArray * value) {
        
        self.highlightedAnimationImages = value;
        return self;
    };
}

/* 设置动画时间间隔 */
- (UIImageView *(^)(NSTimeInterval value))animation_duration {
    
    return ^id(NSTimeInterval value) {
    
        self.animationDuration = value;
        return self;
    };
}

/* 设置动画重复次数 */
- (UIImageView *(^)(NSInteger value))anim_repeat_cnt {

    return ^id(NSInteger value) {
        
        self.animationRepeatCount = value;
        return self;
    };
}


@end

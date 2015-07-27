//
//  UIButton+ANineExtension.m
//  Demo_xib
//
//  Created by ANine on 4/29/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "UIButton+ANineExtension.h"

@implementation UIButton (ANineExtension)

/* 点击时是否高亮 */
- (UIButton * (^)(BOOL value))shows_touch_highlighted {

    return ^id(BOOL value) {
        
        self.showsTouchWhenHighlighted = value;
        
        return self;
    };
}
/* 设置tintColor */
- (UIButton * (^)(UIColor *value))tint_color {

    return ^id(UIColor *value) {
        
        self.tintColor = value;
        
        return self;
    };
}

/* 设置state下的Title */
- (UIButton * (^)(NSString *value,UIControlState state))title_state {

    return ^id(NSString *value,UIControlState state) {
    
        [self setTitle:value forState:state];
        
        return self;
    };
}
/* 设置state下的TitleColor */
- (UIButton * (^)(UIColor *value,UIControlState state))title_color_state {

    return ^id(UIColor *value,UIControlState state) {
        
        [self setTitleColor:value forState:state];
        
        return self;
    };
}
/* 设置state下的backgroundImage */
- (UIButton * (^)(UIImage *value,UIControlState state))background_image_state {

    return ^id(UIImage *value,UIControlState state) {
    
        [self setBackgroundImage:value forState:state];
        
        return self;
    };
}
/* 设置state下的Image */
- (UIButton * (^)(UIImage *value,UIControlState state))image_state {

    return ^id(UIImage *value,UIControlState state) {
        
        [self setImage:value forState:state];
        
        return self;
    };
}
@end

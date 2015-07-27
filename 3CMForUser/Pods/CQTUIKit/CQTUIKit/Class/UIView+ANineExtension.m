//
//  UIView+ANineExtension.m
//  Demo_xib
//
//  Created by ANine on 4/29/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "UIView+ANineExtension.h"

@implementation UIView (ANineExtension)
/* 设置userInteractionEnabled */
- (UIView * (^)(BOOL value))user_inter_enable {

    return ^id(BOOL value) {
        
        self.userInteractionEnabled = value;
        return self;
    };
}

/* 设置Tag */
- (UIView * (^)(NSInteger value))Tag {

    return ^id(NSInteger value) {
        
        self.tag = value;
        
        return self;
    };
}

/* 设置Frame */
- (UIView * (^)(CGRect value))Frame {
    
    return ^id(CGRect value) {
        
        self.frame = value;
        
        return self;
    };
}

/* 设置bounds */
- (UIView * (^)(CGRect value))Bounds {

    return ^id(CGRect value) {
        
        self.bounds = value;
        return self;
    };
}

/* 设置Center */
- (UIView * (^)(CGPoint value))Center {
    
    return ^id(CGPoint value) {
        
        self.center = value;
        return self;
    };
}

/* 设置transform */
- (UIView * (^)(CGAffineTransform value))Transform {
    
    return ^id(CGAffineTransform value) {
        
        self.transform = value;
        return self;
    };
}

/* 设置contentScaleFactor */
- (UIView * (^)(CGFloat value))content_scale_factor {
    
    return ^id(CGFloat value) {
        
        self.contentScaleFactor = value;
        return self;
    };
}


/* 设置clipsToBounds */
- (UIView * (^)(BOOL value))clips_bounds {
    
    return ^id(BOOL value) {
        
        self.clipsToBounds = value;
        
        return self;
    };
}

/* 设置backgroundColor */
- (UIView * (^)(UIColor *value))background_color {
    
    return ^id(UIColor * value) {
        
        self.backgroundColor = value;
        
        return self;
    };
}




/* 设置alpha */
- (UIView * (^)(CGFloat value))Alpha {

    return ^id(CGFloat value) {
        
        self.alpha = value;
        return self;
    };
}

/* 设置Hidden */
- (UIView * (^)(BOOL value))_hidden {
    
    return ^id(BOOL value) {
        
        self.hidden = value;
        return self;
    };
}

/* 设置contentMode */
- (UIView * (^)(UIViewContentMode value))content_mode {

    return ^id(UIViewContentMode value) {
        
        self.contentMode = value;
        return self;
    };
}

/* 设置tintColor */
- (UIView * (^)(UIColor * value))tint_color {
    
    return ^id(UIColor * value) {
        
        self.tintColor = value;
        
        return self;
    };
}

/* 设置multipleTouchEnabled */
- (UIView * (^)(BOOL  value))multi_touch_enable {
    
    return ^id(BOOL value) {
        
        self.multipleTouchEnabled = value;
        return self;
    };
}

/* 设置exclusiveTouch */
- (UIView * (^)(BOOL  value))exclusive_touch {
    
    return ^id(BOOL value) {
        
        self.exclusiveTouch = value;
        return self;
    };
}

- (void)testUIView {
    
    NSLog(@"123243242");
}

@end

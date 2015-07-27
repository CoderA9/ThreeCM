//
//  UIScrollView+ANineExtension.m
//  Demo_xib
//
//  Created by ANine on 4/30/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "UIScrollView+ANineExtension.h"

@implementation UIScrollView (ANineExtension)

- (UIScrollView * (^)(CGPoint value))content_offset {
    
    return ^(CGPoint value) {
        
        self.contentOffset=value;
        
        return self;
    };
}


- (UIScrollView * (^)(CGSize value))content_size {
    
    return ^(CGSize value) {
        
        self.contentSize=value;
        
        return self;
    };
}


- (UIScrollView * (^)(UIEdgeInsets value))content_inset {
    
    return ^(UIEdgeInsets value) {
        
        self.contentInset=value;
        
        return self;
    };
}


- (UIScrollView * (^)(id<UIScrollViewDelegate> value))Delegate {
    
    return ^(id<UIScrollViewDelegate> value) {
        
        self.delegate=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))directional_lock_enabled {
    
    return ^(BOOL value) {
        
        self.directionalLockEnabled=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))Bounces {
    
    return ^(BOOL value) {
        
        self.bounces=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))always_bounds_vertical {
    
    return ^(BOOL value) {
        
        self.alwaysBounceVertical=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))always_bounds_horizontal {
    
    return ^(BOOL value) {
        
        self.alwaysBounceHorizontal=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))page_enable {
    
    return ^(BOOL value) {
        
        self.pagingEnabled=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))scroll_enable {
    
    return ^(BOOL value) {
        
        self.scrollEnabled=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))shows_horizontal_scroll_indicator {
    
    return ^(BOOL value) {
        
        self.showsHorizontalScrollIndicator=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))shows_vertical_scroll_indicator {
    
    return ^(BOOL value) {
        
        self.showsVerticalScrollIndicator=value;
        
        return self;
    };
}


- (UIScrollView * (^)(UIEdgeInsets value))scroll_indicator_insets {
    
    return ^(UIEdgeInsets value) {
        
        self.scrollIndicatorInsets=value;
        
        return self;
    };
}


- (UIScrollView * (^)(UIScrollViewIndicatorStyle value))indicator_style {
    
    return ^(UIScrollViewIndicatorStyle value) {
        
        self.indicatorStyle=value;
        
        return self;
    };
}


- (UIScrollView * (^)(CGFloat value))deceleration_rate {
    
    return ^(CGFloat value) {
        
        self.decelerationRate=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))delays_content_touches {
    
    return ^(BOOL value) {
        
        self.delaysContentTouches=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))can_cancel_content_touches {
    
    return ^(BOOL value) {
        
        self.canCancelContentTouches=value;
        
        return self;
    };
}


- (UIScrollView * (^)(CGFloat value))min_zoom_scale {
    
    return ^(CGFloat value) {
        
        self.minimumZoomScale=value;
        
        return self;
    };
}


- (UIScrollView * (^)(CGFloat value))max_zoom_scale {
    
    return ^(CGFloat value) {
        
        self.maximumZoomScale=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))bounces_zoom {
    
    return ^(BOOL value) {
        
        self.bouncesZoom=value;
        
        return self;
    };
}


- (UIScrollView * (^)(BOOL value))scroll_to_top {
    
    return ^(BOOL value) {
        
        self.scrollsToTop=value;
        
        return self;
    };
}


- (UIScrollView * (^)(UIScrollViewKeyboardDismissMode value))keyboard_dismiss_mode {
    
    return ^(UIScrollViewKeyboardDismissMode value) {
    
        self.keyboardDismissMode=value;
        
        return self;
    };
}

@end

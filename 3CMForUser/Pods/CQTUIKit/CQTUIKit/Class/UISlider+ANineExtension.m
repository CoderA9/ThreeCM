//
//  UISlider+ANineExtension.m
//  Demo_xib
//
//  Created by ANine on 4/30/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "UISlider+ANineExtension.h"

@implementation UISlider (ANineExtension)

- (UISlider *(^)(float))Value {
    
    return ^(float value) {
        
        self.value = value;
        
        return self;
    };
}


- (UISlider *(^)(float))min_value {
    
    return ^(float value) {
        
        self.minimumValue = value;
        
        return self;
    };
}


- (UISlider *(^)(float))max_value {
    
    return ^(float value) {
        
        self.maximumValue = value;
        
        return self;
    };
}


- (UISlider *(^)(UIImage *))min_value_image {
    
    return ^(UIImage *value) {
        
        self.minimumValueImage = value;
        
        return self;
    };
}


- (UISlider *(^)(UIImage *))max_value_image {
    
    return ^(UIImage *value) {
        
        self.maximumValueImage = value;
        
        return self;
    };
}


- (UISlider *(^)(BOOL))Continuous {
    
    return ^(BOOL value) {
        
        self.continuous = value;
        
        return self;
    };
}


- (UISlider *(^)(UIColor *))min_track_tint_color {
    
    return ^(UIColor *value) {
        
        self.minimumTrackTintColor = value;
        
        return self;
    };
}


- (UISlider *(^)(UIColor *))max_track_tint_color {
    
    return ^(UIColor *value) {
        
        self.maximumTrackTintColor = value;
        
        return self;
    };
}


- (UISlider *(^)(UIColor *))thumb_tint_color {

    return ^(UIColor *value) {
    
        self.thumbTintColor = value;
        
        return self;
    };
}

@end

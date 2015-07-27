//
//  UISlider+ANineExtension.h
//  Demo_xib
//
//  Created by ANine on 4/30/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISlider (ANineExtension)
- (UISlider *(^)(float))Value;
- (UISlider *(^)(float))min_value;
- (UISlider *(^)(float))max_value;
- (UISlider *(^)(UIImage *))min_value_image;
- (UISlider *(^)(UIImage *))max_value_image;
- (UISlider *(^)(BOOL))Continuous;
- (UISlider *(^)(UIColor *))min_track_tint_color;
- (UISlider *(^)(UIColor *))max_track_tint_color;
- (UISlider *(^)(UIColor *))thumb_tint_color;

@end

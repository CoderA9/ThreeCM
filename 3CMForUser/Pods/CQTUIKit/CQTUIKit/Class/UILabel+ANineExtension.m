//
//  UILabel+ANineExtension.m
//  Demo_xib
//
//  Created by ANine on 4/29/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "UILabel+ANineExtension.h"

@implementation UILabel (ANineExtension)

+ (instancetype)loadLabel {
    
    UILabel *label = [[UILabel alloc] init];
    
    return label;
}
//设置背景色.
- (UILabel * (^)(UIColor * attr))background_color {
    
    return ^id(UIColor * attr) {
        
        [self setBackgroundColor:attr];
        
        return self;
    };
}
//设置字体.
- (UILabel * (^)(UIFont * attr))text_font {
    
    return ^id(UIFont * attr) {
        
        [self setFont:attr];
        
        return self;
    };
}
//设置字体颜色.
- (UILabel * (^)(UIColor * attr))text_color {
    
    return ^id(UIColor * attr) {
        
        [self setTextColor:attr];
        
        return self;
    };
}

//设置字体居中.
- (UILabel * (^)(NSTextAlignment alignment))text_alignMent {
    
    return ^id(NSTextAlignment alignment) {
        
        [self setTextAlignment:alignment];
        
        return self;
    };
}

//设置文本.
- (UILabel * (^)(NSString * attr))_text {

    return ^id(NSString * attr) {
        
        self.text = attr;
        
        return self;
    };
}

//设置断行模式
- (UILabel * (^)(NSLineBreakMode lbModel))line_breakModel {

    return ^id(NSLineBreakMode lbModel) {
        
        self.lineBreakMode = lbModel;
        
        return self;
    };
}
//设置userInterfaceEnable
- (UILabel * (^)(BOOL enable))user_inter_enable {

    return ^id(BOOL enable) {
        
        self.userInteractionEnabled = enable;
        
        return self;
    };
}
//设置Enable
- (UILabel * (^)(BOOL enable))Enable {

    return ^id(BOOL enable) {
        
        self.enabled = enable;
        
        return self;
    };
}
//设置numberOfLines
- (UILabel * (^)(NSInteger num))number_lines {

    return ^id(NSInteger num) {
        
        self.numberOfLines = num;
        
        return self;
    };
}
//设置文本自适应宽度
- (UILabel * (^)(BOOL adjust))adjusts_fontSizeFitWidth {

    return ^id(BOOL adjust) {
        
        self.adjustsFontSizeToFitWidth = adjust;
        
        return self;
    };
}
@end

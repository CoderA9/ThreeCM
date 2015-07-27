//
//  UITextField+ANineExtension.m
//  Demo_xib
//
//  Created by ANine on 4/30/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "UITextField+ANineExtension.h"

@implementation UITextField (ANineExtension)

/* 设置文本 */
- (UITextField * (^)(NSString *))Text {
    
    return ^(NSString *value) {
        
        self.text = value;
        
        return self;
    };
}
/* 设置attributedText */
- (UITextField * (^)(NSAttributedString *))attri_text {
    
    return ^(NSAttributedString *value) {
        
        self.attributedText = value;
        
        return self;
    };
}
- (UITextField * (^)(UIColor *))text_color {
    
    return ^(UIColor *value) {
        
        self.textColor = value;
        
        return self;
    };
}
- (UITextField * (^)(UIFont *))Font {
    
    return ^(UIFont *value) {
        
        self.font = value;
        
        return self;
    };
}
- (UITextField * (^)(NSTextAlignment ))text_alignment {
    
    return ^(NSTextAlignment value) {
        
        self.textAlignment = value;
        
        return self;
    };
}
- (UITextField * (^)(UITextBorderStyle ))boarder_style {
    
    return ^(UITextBorderStyle value) {
        
        self.borderStyle = value;
        
        return self;
    };
}
- (UITextField * (^)(NSDictionary * ))default_text_attr {
    
    return ^(NSDictionary *value) {
        
        self.defaultTextAttributes = value;
        
        return self;
    };
}
- (UITextField * (^)(NSString * ))place_holder {
    
    return ^(NSString *value) {
        
        self.placeholder = value;
        
        return self;
    };
}
- (UITextField * (^)(NSAttributedString * ))attr_place_holder {
    
    return ^(NSAttributedString *value) {
        
        self.attributedPlaceholder = value;
        
        return self;
    };
}
- (UITextField * (^)(BOOL ))clear_on_begin_editing {
    
    return ^(BOOL value) {
        
        self.clearsOnBeginEditing = value;
        
        return self;
    };
}
- (UITextField * (^)(BOOL ))adjust_font_size_to_fit_width {
    
    return ^(BOOL value) {
        
        self.adjustsFontSizeToFitWidth = value;
        
        return self;
    };
}
- (UITextField * (^)(CGFloat ))min_font_size {
    
    return ^(CGFloat value) {
        
        self.minimumFontSize = value;
        
        return self;
    };
}
- (UITextField * (^)(id<UITextFieldDelegate> ))Delegate {
    
    return ^(id<UITextFieldDelegate> value) {
        
        self.delegate = value;
        
        return self;
    };
}
- (UITextField * (^)(UIImage * ))Background {
    
    return ^(UIImage * value) {
        
        self.background = value;
        
        return self;
    };
}
- (UITextField * (^)(UIImage * ))dis_background {
    
    return ^(UIImage * value) {
        
        self.disabledBackground = value;
        
        return self;
    };
}
- (UITextField * (^)(BOOL ))allow_editing_text_attr {
    
    return ^(BOOL value) {
        
        self.allowsEditingTextAttributes = value;
        
        return self;
    };
}
- (UITextField * (^)(NSDictionary * ))typing_attr {
    
    return ^(NSDictionary * value) {
        
        self.typingAttributes= value;
        
        return self;
    };
}
- (UITextField * (^)(UITextFieldViewMode ))clear_btn_mode {
    
    return ^(UITextFieldViewMode value) {
        
        self.clearButtonMode = value;
        
        return self;
    };
}
- (UITextField * (^)(UIView * ))left_view {
    
    return ^(UIView * value) {
        
        self.leftView = value;
        
        return self;
    };
}
- (UITextField * (^)(UITextFieldViewMode ))left_view_mode {
    
    return ^(UITextFieldViewMode value) {
        
        self.leftViewMode = value;
        
        return self;
    };
}
- (UITextField * (^)(UIView * ))right_view {
    
    return ^(UIView * value) {
        
        self.rightView = value;
        
        return self;
    };
}
- (UITextField * (^)(UITextFieldViewMode ))right_view_mode {
    
    return ^(UITextFieldViewMode value) {
        
        self.rightViewMode = value;
        
        return self;
    };
}
- (UITextField * (^)(UIView * ))input_view {
    
    return ^(UIView * value) {
        
        self.inputView = value;
        
        return self;
    };
}
- (UITextField * (^)(UIView * ))input_accessory_view {
    
    return ^(UIView * value) {
        
        self.inputAccessoryView = value;
        
        return self;
    };
}
- (UITextField * (^)(BOOL ))clear_on_insertion {
    
    return ^(BOOL value) {
        
        self.clearsOnInsertion = value;
        
        return self;
    };
}

@end

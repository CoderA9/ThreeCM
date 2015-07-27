//
//  UITextView+ANineExtension.m
//  Demo_xib
//
//  Created by ANine on 4/30/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "UITextView+ANineExtension.h"

@implementation UITextView (ANineExtension)

/* 设置文本 */
- (UITextView * (^)(NSString *))Text {

    return ^(NSString *value) {
        
        self.text = value;
        
        return self;
    };
}
/* 设置attributedText */
- (UITextView * (^)(NSAttributedString *))attri_text {
    
    return ^(NSAttributedString *value) {
        
        self.attributedText = value;
        
        return self;
    };
}
- (UITextView * (^)(UIColor *))text_color {
    
    return ^(UIColor *value) {
        
        self.textColor = value;
        
        return self;
    };
}
- (UITextView * (^)(UIFont *))Font {
    
    return ^(UIFont *value) {
        
        self.font = value;
        
        return self;
    };
}
- (UITextView * (^)(NSTextAlignment ))text_alignment {
    
    return ^(NSTextAlignment value) {
        
        self.textAlignment = value;
        
        return self;
    };
}
- (UITextView * (^)(NSRange ))select_range {
    
    return ^(NSRange value) {
        
        self.selectedRange = value;
        
        return self;
    };
}
- (UITextView * (^)(BOOL ))Editable {
    
    return ^(BOOL value) {
        
        self.editable = value;
        
        return self;
    };
}
- (UITextView * (^)(BOOL ))Selectable {
    
    return ^(BOOL value) {
        
        self.selectable = value;
        
        return self;
    };
}
- (UITextView * (^)(UIDataDetectorTypes ))data_detector_types {
    
    return ^(UIDataDetectorTypes value) {
        
        self.dataDetectorTypes = value;
        
        return self;
    };
}

- (UITextView * (^)(id<UITextViewDelegate> ))Delegate {
    
    return ^(id<UITextViewDelegate> value) {
        
        self.delegate = value;
        
        return self;
    };
}
- (UITextView * (^)(BOOL ))allow_editing_text_attr {
    
    return ^(BOOL value) {
        
        self.allowsEditingTextAttributes = value;
        
        return self;
    };
}
- (UITextView * (^)(NSDictionary * ))typing_attr {
    
    return ^(NSDictionary *value) {
        
        self.typingAttributes = value;
        
        return self;
    };
}
- (UITextView * (^)(UIView * ))input_view {
    
    return ^(UIView *value) {
        
        self.inputView = value;
        
        return self;
    };
}
- (UITextView * (^)(UIView * ))input_accessory_view {
    
    return ^(UIView *value) {
        
        self.inputAccessoryView = value;
        
        return self;
    };
}
- (UITextView * (^)(BOOL ))clear_on_insertion {
    
    return ^(BOOL value) {
        
        self.clearsOnInsertion = value;
        
        return self;
    };
}

- (UITextView * (^)(UIEdgeInsets ))text_container_insets {
    
    return ^(UIEdgeInsets value) {
        
        self.textContainerInset = value;
        
        return self;
    };
}

- (UITextView * (^)(NSDictionary * ))link_text_attr {
    
    return ^(NSDictionary *value) {
        
        self.linkTextAttributes = value;
        
        return self;
    };
}
@end

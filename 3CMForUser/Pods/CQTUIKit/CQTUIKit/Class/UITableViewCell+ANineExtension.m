//
//  UITableViewCell+ANineExtension.m
//  Odering
//
//  Created by CQTimes iMac-002 on 15/4/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UITableViewCell+ANineExtension.h"

@implementation UITableViewCell (ANineExtension)

- (UITableViewCell * (^)(UIView *))select_background_view {
    
    return ^(UIView * value) {
      
        self.selectedBackgroundView = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(UIView *))multiple_select_background_view {
    
    return ^(UIView * value) {
        
        self.multipleSelectionBackgroundView = value;
        
        return self;
    };
}


- (UITableViewCell * (^)(UITableViewCellSelectionStyle ))selection_style {
    
    return ^(UITableViewCellSelectionStyle  value) {
        
        self.selectionStyle = value;
        
        return self;
    };
}


- (UITableViewCell * (^)(BOOL ))Selected {
    
    return ^(BOOL value) {
        
        self.selected = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(BOOL ))Highlighted {
    
    return ^(BOOL value) {
        
        self.highlighted = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(BOOL ))shows_reorder_control {
    
    return ^(BOOL value) {
        
        self.showsReorderControl = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(BOOL ))should_indent_while_editing {
    
    return ^(BOOL value) {
        
        self.shouldIndentWhileEditing = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(UITableViewCellAccessoryType ))accessory_type {
    
    return ^(UITableViewCellAccessoryType value) {
        
        self.accessoryType = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(UITableViewCellAccessoryType ))editing_accessory_type {
    
    return ^(UITableViewCellAccessoryType value) {
        
        self.editingAccessoryType = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(UIView *))accessory_view {
    
    return ^(UIView * value) {
        
        self.accessoryView = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(UIView *))editing_accessory_view {
    
    return ^(UIView * value) {
        
        self.editingAccessoryView = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(NSInteger ))indentation_level {
    
    return ^(NSInteger value) {
        
        self.indentationLevel = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(CGFloat ))indentation_width {
    
    return ^(CGFloat value) {
        
        self.indentationWidth = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(UIEdgeInsets ))separator_inset {
    
    return ^(UIEdgeInsets value) {
        
        self.separatorInset = value;
        
        return self;
    };
}

- (UITableViewCell * (^)(BOOL ))Editing {
    
    return ^(BOOL value) {
        
        self.editing = value;
        
        return self;
    };
}

@end

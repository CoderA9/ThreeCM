//
//  UITableView+ANineExtension.m
//  Demo_xib
//
//  Created by ANine on 4/30/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "UITableView+ANineExtension.h"

@implementation UITableView (ANineExtension)
- (UITableView * (^)(id<UITableViewDataSource> value))Datasource {
    
    return ^(id<UITableViewDataSource> value) {
        
        self.dataSource = value;
        return self;
    };
}


- (UITableView * (^)(id<UITableViewDelegate> value))Delegate {
    
    return ^(id<UITableViewDelegate> value) {
        
        self.delegate = value;
        return self;
    };
}


- (UITableView * (^)(CGFloat value))row_height {
    
    return ^(CGFloat value) {
        
        self.rowHeight = value;
        return self;
    };
}


- (UITableView * (^)(CGFloat value))section_header_height {
    
    return ^(CGFloat value) {
        
        self.sectionHeaderHeight = value;
        return self;
    };
}


- (UITableView * (^)(CGFloat value))section_footer_height {
    
    return ^(CGFloat value) {
        
        self.sectionFooterHeight = value;
        return self;
    };
}


- (UITableView * (^)(CGFloat value))estimate_row_height {
    
    return ^(CGFloat value) {
        
        self.estimatedRowHeight = value;
        return self;
    };
}


- (UITableView * (^)(CGFloat value))estimate_section_header_height {
    
    return ^(CGFloat value) {
        
        self.estimatedSectionHeaderHeight = value;
        return self;
    };
}


- (UITableView * (^)(CGFloat value))estimate_section_footer_height {
    
    return ^(CGFloat value) {
        
        self.estimatedSectionFooterHeight = value;
        return self;
    };
}


- (UITableView * (^)(UIEdgeInsets value))separate_inset {
    
    return ^(UIEdgeInsets value) {
        
        self.separatorInset = value;
        return self;
    };
}


- (UITableView * (^)(UIView * value))background_view {
    
    return ^(UIView * value) {
        
        self.backgroundView = value;
        return self;
    };
}


- (UITableView * (^)(BOOL value))Editing {
    
    return ^(BOOL value) {
        
        self.editing = value;
        return self;
    };
}


- (UITableView * (^)(BOOL value))allows_selection {
    
    return ^(BOOL value) {
        
        self.allowsSelection = value;
        return self;
    };
}


- (UITableView * (^)(BOOL value))allows_selection_during_editing {
    
    return ^(BOOL value) {
        
        self.allowsSelectionDuringEditing = value;
        return self;
    };
}


- (UITableView * (^)(BOOL value))allows_multiple_selection {
    
    return ^(BOOL value) {
        
        self.allowsMultipleSelection = value;
        return self;
    };
}


- (UITableView * (^)(BOOL value))allows_multiple_selection_during_editing {
    
    return ^(BOOL value) {
        
        self.allowsMultipleSelectionDuringEditing = value;
        return self;
    };
}


- (UITableView * (^)(NSInteger value))section_index_minimum_display_row_count {
    
    return ^(NSInteger value) {
        
        self.sectionIndexMinimumDisplayRowCount = value;
        return self;
    };
}


- (UITableView * (^)(UIColor * value))section_index_color {
    
    return ^(UIColor * value) {
        
        self.sectionIndexColor = value;
        return self;
    };
}


- (UITableView * (^)(UIColor * value))section_index_background_color {
    
    return ^(UIColor * value) {
        
        self.sectionIndexBackgroundColor = value;
        return self;
    };
}


- (UITableView * (^)(UIColor * value))section_index_tracking_background_color {
    
    return ^(UIColor * value) {
        
        self.sectionIndexTrackingBackgroundColor = value;
        return self;
    };
}


- (UITableView * (^)(UITableViewCellSeparatorStyle value))separate_style {
    
    return ^(UITableViewCellSeparatorStyle value) {
        
        self.separatorStyle = value;
        return self;
    };
}


- (UITableView * (^)(UIColor * value))separate_color {
    
    return ^(UIColor * value) {
        
        self.separatorColor = value;
        return self;
    };
}


- (UITableView * (^)(UIVisualEffect * value))separate_effect {
    
    return ^(UIVisualEffect * value) {
        
        self.separatorEffect = value;
        return self;
    };
}


- (UITableView * (^)(UIView * value))table_header_view {
    
    return ^(UIView * value) {
        
        self.tableHeaderView = value;
        return self;
    };
}


- (UITableView * (^)(UIView * value))table_footer_view {
    
    return ^(UIView * value) {
    
        self.tableFooterView = value;
        return self;
    };
}

@end

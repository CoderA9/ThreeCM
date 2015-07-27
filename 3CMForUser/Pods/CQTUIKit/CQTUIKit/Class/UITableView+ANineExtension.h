//
//  UITableView+ANineExtension.h
//  Demo_xib
//
//  Created by ANine on 4/30/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIScrollView+ANineExtension.h"

@interface UITableView (ANineExtension)

- (UITableView * (^)(id<UITableViewDataSource> value))Datasource;
- (UITableView * (^)(id<UITableViewDelegate> value))Delegate;
- (UITableView * (^)(CGFloat value))row_height;
- (UITableView * (^)(CGFloat value))section_header_height;
- (UITableView * (^)(CGFloat value))section_footer_height;
- (UITableView * (^)(CGFloat value))estimate_row_height;
- (UITableView * (^)(CGFloat value))estimate_section_header_height;
- (UITableView * (^)(CGFloat value))estimate_section_footer_height;
- (UITableView * (^)(UIEdgeInsets value))separate_inset;
- (UITableView * (^)(UIView * value))background_view;
- (UITableView * (^)(BOOL value))Editing;
- (UITableView * (^)(BOOL value))allows_selection;
- (UITableView * (^)(BOOL value))allows_selection_during_editing;
- (UITableView * (^)(BOOL value))allows_multiple_selection;
- (UITableView * (^)(BOOL value))allows_multiple_selection_during_editing;
- (UITableView * (^)(NSInteger value))section_index_minimum_display_row_count;
- (UITableView * (^)(UIColor * value))section_index_color;
- (UITableView * (^)(UIColor * value))section_index_background_color;
- (UITableView * (^)(UIColor * value))section_index_tracking_background_color;
- (UITableView * (^)(UITableViewCellSeparatorStyle value))separate_style;
- (UITableView * (^)(UIColor * value))separate_color;
- (UITableView * (^)(UIVisualEffect * value))separate_effect;
- (UITableView * (^)(UIView * value))table_header_view;
- (UITableView * (^)(UIView * value))table_footer_view;
@end

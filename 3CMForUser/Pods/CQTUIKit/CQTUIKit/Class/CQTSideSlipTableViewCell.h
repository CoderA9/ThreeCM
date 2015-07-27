//
//  CQTSideSlipTableViewCell.h
//  CQTIda
//
//  Created by ANine on 1/19/15.
//  Copyright (c) 2015 www.cqtimes.com. All rights reserved.
//

// Thanks to @Chris in code4App.

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "CQTBaseTableViewCell.h"

@class SWUtilityButtonView;
/**
 @brief TaleViewCell具有左滑右滑隐藏功能按钮的cell.
 
 @discussion <#some notes or alert with this class#>
 */

@class CQTSideSlipTableViewCell;

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} SWCellState;

@protocol CQTSideSlipTableViewCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(CQTSideSlipTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(CQTSideSlipTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(CQTSideSlipTableViewCell *)cell scrollingToState:(SWCellState)state;

@end

@interface CQTSideSlipTableViewCell : CQTBaseTableViewCell

@property (nonatomic, strong) NSArray *leftUtilityButtons;
@property (nonatomic, strong) NSArray *rightUtilityButtons;

@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewLeft;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewRight;

// Scroll view to be added to UITableViewCell
@property (nonatomic, strong) UIScrollView *cellScrollView;
// Views that live in the scroll view
@property (nonatomic, strong) UIView *scrollViewContentView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic) id <CQTSideSlipTableViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)initializer;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;

@end

@interface NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;

@end

#pragma mark - SWUtilityButtonView

@interface SWUtilityButtonView : UIView

@property (nonatomic, strong) NSArray *utilityButtons;
@property (nonatomic, strong) NSArray *btnArrays;
@property (nonatomic) CGFloat utilityButtonWidth;
@property (nonatomic, weak) CQTSideSlipTableViewCell *parentCell;

@property (nonatomic) SEL utilityButtonSelector;

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(CQTSideSlipTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(CQTSideSlipTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

@end

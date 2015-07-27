//
//  CQTSideSlipTableViewCell.m
//  CQTIda
//
//  Created by ANine on 1/19/15.
//  Copyright (c) 2015 www.cqtimes.com. All rights reserved.
//

#import "CQTSideSlipTableViewCell.h"

#define kUtilityButtonsWidthMax 260
#define kUtilityButtonWidthDefault 90

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";




@implementation SWUtilityButtonView

#pragma mark - SWUtilityButonView initializers

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(CQTSideSlipTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super init];
    
    if (self) {
        
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
        
        [self populateUtilityButtons];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(CQTSideSlipTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
        
        [self populateUtilityButtons];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        return;
    }
    
    NSUInteger utilityButtonsCounter = 0;
    
    for (UIButton *utilityButton in _utilityButtons) {
        
        CGFloat utilityButtonXCord = 0;
        utilityButtonXCord = _utilityButtonWidth * utilityButtonsCounter;
        [utilityButton setFrame:CGRectMake(utilityButtonXCord, 0, _utilityButtonWidth, CGRectGetHeight(self.bounds))];
        
        [utilityButton setTag:utilityButtonsCounter];
        utilityButtonsCounter++;
    }
    
}
#pragma mark Populating utility buttons

- (CGFloat)calculateUtilityButtonWidth {
    
    CGFloat buttonWidth = kUtilityButtonWidthDefault;
    
    if (buttonWidth * _utilityButtons.count > kUtilityButtonsWidthMax) {
        
        CGFloat buffer = (buttonWidth * _utilityButtons.count) - kUtilityButtonsWidthMax;
        buttonWidth -= (buffer / _utilityButtons.count);
    }
    return buttonWidth;
}

- (CGFloat)utilityButtonsWidth {
    
    return (_utilityButtons.count * _utilityButtonWidth);
}

- (void)populateUtilityButtons {
    
    NSUInteger utilityButtonsCounter = 0;
    
    for (UIButton *utilityButton in _utilityButtons) {
        
        UIColor *color = utilityButton.backgroundColor;
        NSLog(@"%@",color);

        CGFloat utilityButtonXCord = 0;
        if (utilityButtonsCounter >= 1) utilityButtonXCord = _utilityButtonWidth * utilityButtonsCounter;
        [utilityButton setTag:utilityButtonsCounter];
//        utilityButton.layer.borderColor = [UIColor redColor].CGColor;
//        utilityButton.layer.borderWidth = 1.0f;
        [utilityButton addTarget:_parentCell action:_utilityButtonSelector forControlEvents:UIControlEventTouchDown];

        [utilityButton setFrame:CGRectMake(utilityButtonXCord, 0, _utilityButtonWidth, CGRectGetHeight(self.bounds))];
        
        [self addSubview: utilityButton];
        utilityButtonsCounter++;
    }
}

@end

@interface CQTSideSlipTableViewCell () <UIScrollViewDelegate> {
    SWCellState _cellState; // The state of the cell within the scroll view, can be left, right or middle
}



// The cell's height
@property (nonatomic) CGFloat height;




// Used for row height and selection
@property (nonatomic, strong) UITableView *containingTableView;

@end

@implementation CQTSideSlipTableViewCell

#pragma mark Initializers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.rightUtilityButtons = rightUtilityButtons;
        self.leftUtilityButtons = leftUtilityButtons;
        self.height = containingTableView.rowHeight;
        self.containingTableView = containingTableView;
        self.highlighted = NO;
        
        [self initializer];
    }
    
    return self;
}

- (void)initializer {
    
    if (!self.containingTableView && !self.leftUtilityButtons && !self.rightUtilityButtons) {
        
        return;
    }
    // Set up scroll view that will host our cell content
    if (!_cellScrollView) {
    
        _cellScrollView = [[UIScrollView alloc] init];
        _cellScrollView.delegate = self;
        _cellScrollView.showsHorizontalScrollIndicator = NO ;
        
        if (self.containingTableView) {
        
            UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            
            [_cellScrollView addGestureRecognizer:pressGesture];
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
            [_cellScrollView addGestureRecognizer:tapGestureRecognizer];
            
            [tapGestureRecognizer requireGestureRecognizerToFail:pressGesture];
        }

    }

    if (!_scrollViewButtonViewLeft) {
        
        // Set up the views that will hold the utility buttons
        _scrollViewButtonViewLeft = [[SWUtilityButtonView alloc] initWithUtilityButtons:_leftUtilityButtons parentCell:self utilityButtonSelector:@selector(leftUtilityButtonHandler:)];
        
        
        [self.cellScrollView addSubview:_scrollViewButtonViewLeft];
    }
    
    if (!_scrollViewButtonViewRight) {
        
        _scrollViewButtonViewRight = [[SWUtilityButtonView alloc] initWithUtilityButtons:_rightUtilityButtons parentCell:self utilityButtonSelector:@selector(rightUtilityButtonHandler:)];

        [self.cellScrollView addSubview:_scrollViewButtonViewRight];
    }
    
    if (!_scrollViewContentView) {
        
        _scrollViewContentView = [[UIView alloc] init];

        [self.cellScrollView addSubview:_scrollViewContentView];
    }
    
    // Add the cell scroll view to the cell
    UIView *contentViewParent = self;
    
    UIView * classView = [self.subviews objectAtIndex:0];
    
    NSString *classStr = NSStringFromClass([classView class]);
    
    if (![classStr isEqualToString:kTableViewCellContentView]) {
        // iOS 7
        contentViewParent = classView;
    }
    NSArray *cellSubviews = [contentViewParent subviews];
    
    NSLog(@"%@\n%@\n%@",contentViewParent,self,self.subviews);
    
    for (UIView *subview in cellSubviews) {
        
        [self.scrollViewContentView addSubview:subview];
    }
    
    [self insertSubview:_cellScrollView atIndex:0];
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        return;
    }
    
    _cellScrollView.frame = ViewRect([self leftUtilityButtonsWidth], 0, ViewWidth(self), ViewHeight(self));
    _cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], ViewHeight(self));
    _cellScrollView.contentOffset = [self scrollViewContentOffset];
    self.scrollViewButtonViewLeft.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], ViewHeight(self));
    self.scrollViewButtonViewRight.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], ViewHeight(self));
    self.scrollViewContentView.frame = CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), ViewHeight(self));
}

- (void)updateSubviewsGUI {
    
    [super updateSubviewsGUI];
    
}
#pragma mark Selection

- (void)longPress:(id)sender {
    
//    [self scrollViewPressed:sender];
}

- (void)scrollViewPressed:(id)sender {
    
    if(_cellState == kCellStateCenter) {
        // Selection hack
        if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            NSIndexPath *cellIndexPath = [_containingTableView indexPathForCell:self];
            [self.containingTableView.delegate tableView:_containingTableView didSelectRowAtIndexPath:cellIndexPath];
        }
        // Highlight hack
        if (!self.highlighted) {
            self.scrollViewButtonViewLeft.hidden = YES;
            self.scrollViewButtonViewRight.hidden = NO;
            NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerEndCellHighlight:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:endHighlightTimer forMode:NSRunLoopCommonModes];
            [self setHighlighted:YES animated:YES];
        }
    } else {
        // Scroll back to center
        [self hideUtilityButtonsAnimated:YES];
    }
}

- (void)timerEndCellHighlight:(id)sender {
    
//    if (self.highlighted) {
    
        self.scrollViewButtonViewLeft.hidden = NO;
        self.scrollViewButtonViewRight.hidden = NO;
        [self setHighlighted:NO];
//    }
}

#pragma mark UITableViewCell overrider

#pragma mark - Utility buttons handling

- (void)rightUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerRightUtilityButtonWithIndex:)]) {
        [_delegate swippableTableViewCell:self didTriggerRightUtilityButtonWithIndex:utilityButtonTag];
    }
}

- (void)leftUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerLeftUtilityButtonWithIndex:)]) {
        [_delegate swippableTableViewCell:self didTriggerLeftUtilityButtonWithIndex:utilityButtonTag];
    }
}

- (void)hideUtilityButtonsAnimated:(BOOL)animated {
    // Scroll back to center
    [self.cellScrollView setContentOffset:CGPointMake([self leftUtilityButtonsWidth], 0) animated:animated];
    _cellState = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
    }
}

#pragma mark - Setup helpers

- (CGFloat)leftUtilityButtonsWidth {
    return [_scrollViewButtonViewLeft utilityButtonsWidth];
}

- (CGFloat)rightUtilityButtonsWidth {
    return [_scrollViewButtonViewRight utilityButtonsWidth];
}

- (CGFloat)utilityButtonsPadding {
    return ([_scrollViewButtonViewLeft utilityButtonsWidth] + [_scrollViewButtonViewRight utilityButtonsWidth]);
}

- (CGPoint)scrollViewContentOffset {
    return CGPointMake([_scrollViewButtonViewLeft utilityButtonsWidth], 0);
}

#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = [self utilityButtonsPadding];
    _cellState = kCellStateRight;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateRight];
    }
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    
    targetContentOffset->x = [self leftUtilityButtonsWidth];
    _cellState = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
    }
}

- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    _cellState = kCellStateLeft;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateLeft];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat rightThreshold = [self utilityButtonsPadding] - ([self rightUtilityButtonsWidth] / 2);
                CGFloat leftThreshold = [self leftUtilityButtonsWidth] / 2;
                if (targetContentOffset->x > rightThreshold)
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x < leftThreshold)
                    [self scrollToLeft:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                // No-op
            } else {
                if (targetContentOffset->x >= ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x > [self leftUtilityButtonsWidth] / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
                // No-op
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x <= [self leftUtilityButtonsWidth] / 2)
                    [self scrollToLeft:targetContentOffset];
                else if (targetContentOffset->x < ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [self leftUtilityButtonsWidth]) {
        // Expose the right button view
        self.scrollViewButtonViewRight.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - [self rightUtilityButtonsWidth]), 0.0f, [self rightUtilityButtonsWidth], ViewHeight(self));
    } else {
        // Expose the left button view
        self.scrollViewButtonViewLeft.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, [self leftUtilityButtonsWidth], ViewHeight(self));
    }
}

@end


#pragma mark NSMutableArray class extension helper

@implementation NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self addObject:button];
}

- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setImage:icon forState:UIControlStateNormal];
    [self addObject:button];
}

@end

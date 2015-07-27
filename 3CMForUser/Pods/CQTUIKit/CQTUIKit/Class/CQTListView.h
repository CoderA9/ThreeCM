//
//  JTListView.h
//  JTListView
//
//  Created by Jun on 5/6/11.
//  Copyright 2011 Jun Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CQTListView;


typedef enum {
    CQTListViewLayoutLeftToRight,
    CQTListViewLayoutRightToLeft,
    CQTListViewLayoutTopToBottom,
    CQTListViewLayoutBottomToTop
} CQTListViewLayout;


typedef enum {
    CQTListViewScrollPositionNone   = UITableViewScrollPositionNone,
    CQTListViewScrollPositionCenter = UITableViewRowAnimationMiddle,
    CQTListViewScrollPositionCenterElseNone // center if the view size is smaller than bounds size, else none
} CQTListViewScrollPosition;




@protocol CQTListViewDataSource <NSObject>
@required
- (NSUInteger)numberOfItemsInListView:(CQTListView *)listView;
- (UIView *)listView:(CQTListView *)listView viewForItemAtIndex:(NSUInteger)index;

@end


@protocol CQTListViewDelegate <UIScrollViewDelegate>
@optional
- (void)listView:(CQTListView *)listView willDisplayView:(UIView *)view forItemAtIndex:(NSUInteger)index;

- (CGFloat)listView:(CQTListView *)listView widthForItemAtIndex:(NSUInteger)index;  // for horizontal layouts
- (CGFloat)listView:(CQTListView *)listView heightForItemAtIndex:(NSUInteger)index; // for vertical layouts
@end


typedef enum _ListViewScrollState {
    
    ListViewScrollEnded,
    ListViewScrolling,
    
}ListViewScrollState;

@interface CQTListView : UIScrollView {
@package
    NSMutableArray *_itemRects;
    NSRange         _visibleRange;
    NSMutableArray *_visibleViews;
    NSMutableSet   *_reuseableViews;
}

@property (nonatomic, assign) id <CQTListViewDataSource> dataSource;
@property (nonatomic, assign) id <CQTListViewDelegate>   delegate;

@property (nonatomic) CQTListViewLayout layout;
@property (nonatomic) CGFloat          itemWidth;       // for horizontal layouts. default is 44.0
@property (nonatomic) CGFloat          itemHeight;      // for vertical layouts. default is 44.0
@property (nonatomic) CGFloat          gapBetweenItems; // default is zero
@property (nonatomic) UIEdgeInsets     visibleInsets;   // set negative values to load views outside bounds. default is UIEdgeInsetsZeroo

@property (nonatomic,assign)BOOL forbiddenScroll;//default is NO.
@property (nonatomic,assign)ListViewScrollState scrollState;

- (id)initWithFrame:(CGRect)frame layout:(CQTListViewLayout)layout; // must specify style at creation. -initWithFrame: calls this with CQTListViewLayoutLeftToRight

- (void)reloadData;
- (void)reloadItemsAtIndexes:(NSIndexSet *)indexes;

- (void)updateItemSizes;
- (void)updateItemSizesAtIndexes:(NSIndexSet *)indexes;

- (NSUInteger)numberOfItems;

- (CGRect)rectForItemAtIndex:(NSUInteger)index;         // returns CGRectNull if index is out of range
- (UIView *)viewForItemAtIndex:(NSUInteger)index;       // returns nil if view is not visible or index is out of range

- (NSUInteger)indexForView:(UIView *)view;              // returns NSNotFound if view is not visible
- (NSUInteger)indexForItemAtPoint:(CGPoint)point;       // returns NSNotFound if point is outside list
- (NSUInteger)indexForItemAtCenterOfBounds;
- (NSIndexSet *)indexesForItemsInRect:(CGRect)rect;     // returns nil if rect is outside list

- (CGRect)visibleRect;
- (NSArray *)visibleViews;
- (NSArray *)allViews;
- (NSIndexSet *)indexesForVisibleItems;

- (void)scrollToItemAtIndex:(NSUInteger)index atScrollPosition:(CQTListViewScrollPosition)scrollPosition animated:(BOOL)animated;

// smart paging
- (void)goBack:(BOOL)animated;
- (void)goForward:(BOOL)animated;

- (UIView *)dequeueReusableView;   // similar to UITableView's dequeueReusableCellWithIdentifier:

@end


@interface CQTListViewController : UIViewController <CQTListViewDataSource, CQTListViewDelegate> 

@property (nonatomic, retain) CQTListView *listView;

@end

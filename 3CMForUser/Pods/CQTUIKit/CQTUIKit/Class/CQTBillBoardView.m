//
//  CQTBillBoardView.m
//  CQTIda
//
//  Created by ANine on 10/9/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTBillBoardView.h"
#import "VCDef.h"
#import "CQTFullScreenBillBoardView.h"
#import "CQTViewConstants.h"
#import "UIView+custom.h"

#define pageControlPerWidth 18
#define pageControlHeight 20

#define kTagBase 13056

#define kTouchImageViewTagBase 65031

@interface CQTTouchImageTextView : CQTTouchImageView
@property (nonatomic,retain)UILabel *label;
@end

@implementation CQTTouchImageTextView

- (instancetype)init {
    
    if (self = [super init]) {
        
        _label = [[UILabel alloc] init];
        [self addSubview:_label];
        
        _label.backgroundColor = HEX_RGBA(0x000000, .6f);
        _label.userInteractionEnabled = NO;
        _label.textColor = [UIColor whiteColor];
        _label.font = AvenirFont(10.);
        
//        _label.adjustsFontSizeToFitth = YES;
        
//        UILabel *label = _label;
//        UIView *view = self;
//        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//        
//        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
//        
//        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20]];
//        
//        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        return;
    }
    
    CGFloat labelheight = 20.;
    
    _label.frame = ViewRect(0, ViewHeight(self) - labelheight, ViewWidth(self), labelheight);
}

- (void)dealloc {
    
    CQTRemoveFromSuperViewSafely(_label);
    
    CQT_SUPER_DEALLOC();
}
@end

@interface CQTBillBoardView () {

    CQTFullScreenBillBoardView *_fsGalleryView;
}

@end

@implementation CQTBillBoardView


#pragma mark - | ***** super Methods ***** |

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code
        [self createScrollViewIfNeeded];
        [self addSubview:_scrollView];
        
        [self createPageControlIfNeeded];
        [self addSubview:_pageControl];
        
        [self createLabelBgViewIfNeeded];
        [self addSubview:_labelBgView];

        [self createLabelIfNeeded];
        [_labelBgView addSubview:_label];
        
        self.page = 0;
        
        self.boardsAry = [[NSMutableArray alloc] init];
        
        self.autoPlayInterval = -110;
        self.cycleScrollState = billBoardCycleScrollForbidden;
        
        self.needShowContext = YES;
        
        self.canViewEnlarge = NO;
        
        self.cycleScroll = YES;
        
        self.forbiddenRefreshItemWidth = NO;
        
        self.itemCornerRadius = 0.;
        self.itemSeperate = 0.;
        self.itemLayerColor = [UIColor clearColor];
        self.itemLayerWidth = 0.;
        
        [self addObserver:self forKeyPath:@"needShowContext" options:0 context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:kNotificationtimerUpdatedKey object:nil];
        
    }
    
    self.frame = frame;
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size,CGSizeZero)) {
        return;
    }
    
    _scrollView.frame = self.bounds;
    
    if (_scrollView.itemWidth != ViewWidth(self) && !self.forbiddenRefreshItemWidth) {
       
        _scrollView.itemWidth = ViewWidth(self);
    }
    
    CQTDebugLog(@"itemWith:%f , viewwith:%f, itemHeight:%f,self.Height:%f",_scrollView.itemWidth,ViewWidth(self),ViewHeight(_scrollView),ViewHeight(self));
    
    _pageControl.hidden = YES;
    _labelBgView.hidden = YES;
    
    [self resetPageControlFrame];
    
    if (_needShowContext && _scrollView.itemWidth == ViewWidth(self)) {
        
        _labelBgView.hidden = NO;
    }
    
    _labelBgView.frame = ViewRect(0, ViewHeight(self) - 20, ViewWidth(self), 20);
    _label.frame = _labelBgView.bounds;
}

- (void)resetPageControlFrame {
    
    BOOL baseYOffset = 0.;
    
    if (_needShowContext) {
        
        baseYOffset = 20;
    }
    
    if (self.trueCount > 1) {
        
        _pageControl.frame = ViewRect((ViewWidth(self) -  pageControlPerWidth * self.trueCount)/2,
                                      ViewHeight(self) - baseYOffset - pageControlHeight,
                                      pageControlPerWidth * self.trueCount,
                                      pageControlHeight);
        
        _pageControl.numberOfPages = self.trueCount;
        
        _pageControl.hidden = NO;
    }
}

- (void)dealloc {
 
    [self removeObserver:self forKeyPath:@"needShowContext" context:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.scrollView.forbiddenScroll = YES;
    
    if (self.scrollView.scrollState == ListViewScrolling) {
        
        NSLog(@"scrollview is scrolling...........!!!!!!!!!");
        [self performSelector:@selector(doDealloc) withObject:nil afterDelay:.5f];
        
        return;
    }
    
    
    [self doDealloc];
}

- (void)doDealloc {
    
    A9_ObjectReleaseSafely(_boardsAry);
    
    if (_fsGalleryView) {
        
        CQT_RELEASE(_fsGalleryView);
    }
    
    if (_oneTapBlock) {
        
        CQT_BLOCK_RELEASE(_oneTapBlock);
    }
    
    _oneTapBlock = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

#pragma mark - | ***** create views ***** |
- (void)createScrollViewIfNeeded {

    if (!_scrollView) {
        
        _scrollView = [[CQTListView alloc] init];
        _scrollView.layout = CQTListViewLayoutLeftToRight;
        _scrollView.dataSource = self;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }else {
        
        CQTRemoveFromSuperViewSafely(_scrollView);
    }
}

- (void)createPageControlIfNeeded {
    
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = kRedColor;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    }else {
    
        CQTRemoveFromSuperViewSafely(_pageControl);
    }
}

- (void)createLabelBgViewIfNeeded {
    
    if (!_labelBgView) {
        
        _labelBgView = [[CQTView alloc] init];
        _labelBgView.backgroundColor = HEX_RGBA(0x000000, .3);
    }else {
        
        CQTRemoveFromSuperViewSafely(_labelBgView);
    }
}

- (void)createLabelIfNeeded {
    
    if (!_label) {
        
        _label = [[CQTLabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.font = AvenirFont(14);
        _label.textAlignment = UITextAlignmentCenter;
    }else {
        
        CQTRemoveFromSuperViewSafely(_label);
    }
}



#pragma mark - | ***** public methods ***** |
- (UIView *)viewForIndex:(int)index {
    
    return [self.scrollView viewForItemAtIndex:index];
}

/* 注册一个响应事件 */
- (void)addTapAction:(tapAction)block {
    
    if (_oneTapBlock) {
        
        CQT_BLOCK_RELEASE(_oneTapBlock);
    }
    
    _oneTapBlock = CQT_BLOCK_COPY(block);
}

- (void)setPage:(int)page {
    
    if (_page != page) {
        
        _page = page;
        
        _pageControl.currentPage = _page;
        
        [self refreshLabel];
    }
}

- (void)setAutoPlayInterval:(int)autoPlayInterval {
    
    if (_autoPlayInterval != autoPlayInterval) {
        
        _autoPlayInterval = autoPlayInterval;
    }
    
    if (_autoPlayInterval > 0) {
        
        self.cycleScrollState = billBoardCycleScrollScrolling;
    }
}

- (void)setCycleScrollState:(billBoardCycleScrollState)cycleScrollState {
    
    if (_cycleScrollState != cycleScrollState) {
        
        _cycleScrollState = cycleScrollState;
    }
}

- (void)reloadData {
    
    [self.scrollView reloadData];
    
    if (self.cycleScroll) {
        
        [self.scrollView scrollToItemAtIndex:1 atScrollPosition:CQTListViewScrollPositionNone animated:NO];
    }
    
    [self refreshLabel];
}

- (void)setBoardsAry:(NSMutableArray *)boardsAry {
    
    if (![_boardsAry isEqual:boardsAry]) {
        
        [_boardsAry removeAllObjects];
        
        _boardsAry = [boardsAry mutableCopy];
        
        if (validAry(_boardsAry) && _boardsAry.count <= 1) {
            
            self.cycleScroll = NO;
        }
        
        if (self.cycleScroll) {
            
            self.cycleScrollState = billBoardCycleScrollScrolling;
        }
        
        self.trueCount = _boardsAry.count;
        
        [self controlBoardsAry];
        
        [self resetPageControlFrame];

    }
}

- (void)setCycleScroll:(BOOL)cycleScroll {
    
    if (cycleScroll != _cycleScroll) {
        
        _cycleScroll = cycleScroll;
        
        [self controlBoardsAry];
        
        self.scrollView.showsHorizontalScrollIndicator = !_cycleScroll;
    }
}

#pragma mark - | *****  private methods ***** |

- (void)refreshLabel {
    
    if (validAry(self.boardsAry) && self.boardsAry.count > self.page ) {
        
        BILLBOARD *board = self.boardsAry[self.page];
        
        if (board && [board isKindOfClass:[BILLBOARD class]]) {
            
            _label.text = safelyStr(board.summary);
        }
        
    }
}


- (void)controlBoardsAry {
    
    if (self.boardsAry.count == self.trueCount && self.cycleScroll) {
        
        BILLBOARD *firstBoard = self.boardsAry.firstObject;
        BILLBOARD *lastBoard = self.boardsAry.lastObject;
        
        if (firstBoard && lastBoard) {
            
            [self.boardsAry addObject:firstBoard];
            [self.boardsAry insertObject:lastBoard atIndex:0];
        }
        
    }else if (validAry(self.boardsAry) &&
              self.boardsAry.count == self.trueCount + 2 &&
              ! self.cycleScroll) {
        
        [self.boardsAry removeObjectAtIndex:0];
        [self.boardsAry removeLastObject];
    }
}


- (void)showFullScreenGallery:(NSArray*)images page:(NSInteger)page fromView:(UIView*)fromView fromRect:(CGRect)fromRect {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    CGRect foo = [[[UIApplication sharedApplication] keyWindow] convertRect:fromRect
                                                                   fromView:self.scrollView];
    
    if (!_fsGalleryView) {
        
        _fsGalleryView = [[CQTFullScreenBillBoardView alloc] initWithFrame:CGRectZero];
    }
    _fsGalleryView.backgroundColor = [UIColor blackColor];
    
    _fsGalleryView.page = page;
    _fsGalleryView.fromRect = foo;
    
    NSMutableArray *array = CQT_AUTORELEASE([self.boardsAry mutableCopy]);
    if (self.cycleScroll && array.count == self.trueCount + 2) {
        
        [array removeObjectAtIndex:0];
        [array removeLastObject];
    }
    _fsGalleryView.boardsAry = array;

    _fsGalleryView.originViewContentModel = UIViewContentModeScaleAspectFill;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_fsGalleryView];
    
    _fsGalleryView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    [_fsGalleryView show];
    [_fsGalleryView reloadData];

}
#pragma mark - CQTListViewDataSource (Required)

- (NSUInteger)numberOfItemsInListView:(CQTListView *)listView {
    
    return self.boardsAry.count;
}

- (UIView *)listView:(CQTListView *)listView viewForItemAtIndex:(NSUInteger)index {
    
    CQTView *reuseView = (CQTView *)[listView dequeueReusableView];
    
    if (!reuseView) {
        
        reuseView = CQT_AUTORELEASE([[CQTView alloc] init]);
    }
    
    CQTTouchImageTextView *view = (CQTTouchImageTextView *)[reuseView viewWithTag: kTouchImageViewTagBase + index];
    
    if (view && [view isKindOfClass:[UIView class]]) {
        
        [view removeFromSuperview];
        CQT_RELEASE(view);
    }
    
    BOOL hidden = NO;
    
    if (self.scrollView.itemWidth == ViewWidth(self) || self.needShowPerViewContext == NO) {
        
        hidden = YES;
    }

    if (!view) {
        
        view = CQT_AUTORELEASE([[CQTTouchImageTextView alloc] init]);
        view.contentMode = UIViewContentModeScaleAspectFill;
        
        [reuseView addSubview:view];
    }
    
    reuseView.clipsToBounds = YES;
    view.clipsToBounds = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view setLayerWidth:self.itemLayerWidth color:self.itemLayerColor cornerRadius:self.itemCornerRadius];
    
    
    view.tag = kTouchImageViewTagBase + index ;
    
    view.image = nil;
    
    CGRect foo = CGRectMake(self.itemSeperate / 2, 0, ViewWidth(reuseView) - self.itemSeperate, ViewHeight(reuseView));
    
    view.frame = foo;
    
    __unsafe_unretained id weakSelf = self;
    __unsafe_unretained id weakView = view;
    
    [view addTapAction:^{
        
        [weakSelf imageViewDidTap:weakView];
    }];
   
    reuseView.tag = kTagBase + index;
    
    if (validAry(self.boardsAry) && self.boardsAry.count > index) {
        
        BILLBOARD *board = self.boardsAry[index];
        
        NSString *imgPath = [board.imagePath adjustImageHeader:[CQTResourceBrige sharedBrige].appBaseUrl];
        
        if (self.needThubmailImage) {
            
            imgPath = [imgPath needThubmailImageStr];
        }
        
        NSString *summary = board.summary;
        
        if (!validStr(summary)) {
            
            hidden = YES;
        }
        
        view.label.hidden = hidden;
        view.label.text = summary;
        
        [view setImageWithURLString:imgPath placeholderImage:PlaceHolderImage];
//        [view setImage:[UIImage imageNamed:@"testAdv"]];
    }
    
    return reuseView;
}

#pragma mark - CQTListViewDelegate (Optional)

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    self.scrollView.scrollState = ListViewScrollEnded;
}

- (void)listView:(CQTListView *)listView willDisplayView:(UIView *)view forItemAtIndex:(NSUInteger)index {
    
    UIView * imgView = [view viewWithTag:kTouchImageViewTagBase + index];
    
    CGRect foo = CGRectMake(self.itemSeperate / 2, 0, ViewWidth(view) - self.itemSeperate, ViewHeight(view));
    
    imgView.frame = foo;
}
#pragma mark - | ***** CQTTouchImageViewDelegate ***** |
- (void)imageViewDidTap:(CQTTouchImageView *)view {
    
    __unsafe_unretained CQTBillBoardView * weakSelf = self;
    
    int index = view.tag - kTouchImageViewTagBase;
    
    if (_oneTapBlock) {

      BILLBOARD *bords = nil;

        if (validAry(weakSelf.boardsAry) && weakSelf.boardsAry.count > index) {

            bords = weakSelf.boardsAry[index];
        }

    _oneTapBlock(index,bords);
        
    }else if (weakSelf.canViewEnlarge) {
        
        [weakSelf showFullScreenGallery:weakSelf.boardsAry page:weakSelf.page fromView:weakSelf.superview fromRect:weakSelf.frame];
    }

}
#pragma mark - | ***** NSKeyValueObserving ***** |

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
 
    if (object == self) {
        
        if ([keyPath isEqualToString:@"needShowContext"]) {
            
            _labelBgView.hidden = !_needShowContext;
            
            [self resetPageControlFrame];
        }
    }
}

- (void)correctScrollView:(NSString *)pageStr {

    [self.scrollView scrollToItemAtIndex:pageStr.intValue atScrollPosition:CQTListViewScrollPositionCenterElseNone animated:NO];
}

#pragma mark - | ***** UIScrollViewDelegate ***** |
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.page = ( scrollView.contentOffset.x + ViewWidth(scrollView)/2 ) / ViewWidth(scrollView);
    
    if (self.cycleScroll) {
        
        _pageControl.currentPage = _page - 1 ;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(correctScrollView) object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.page = ( scrollView.contentOffset.x + ViewWidth(scrollView)/2 ) / ViewWidth(scrollView);
    
    if(self.cycleScroll) {
    
        if (self.page == 0) {
            
            self.page = self.trueCount ;
            
        }else if (self.page == self.trueCount + 1) {
            
            self.page = 1;
        }
        
        [self.scrollView scrollToItemAtIndex:self.page atScrollPosition:CQTListViewScrollPositionCenterElseNone animated:NO];
    }
}
#pragma mark - | ***** NSNotification ***** |
- (void)handleNotification:(NSNotification *)notify {
    
    static int indexCnt = 0;
    
    static int delayRepondtimer = 0;
    
    if ([notify.name isEqualToString:kNotificationtimerUpdatedKey] && self.autoPlayInterval >= 0) {
        
        if (self.scrollView.tracking) {
            
            delayRepondtimer = 5;
            self.cycleScrollState = billBoardCycleScrollSuspend;
            
        }else if (_fsGalleryView.alpha == 1 ||
                  self.trueCount <= 1) {
            
            self.cycleScrollState = billBoardCycleScrollSuspend;
            
        }else if (delayRepondtimer > 0) {
            
            delayRepondtimer --;
            
            self.cycleScrollState = billBoardCycleScrollSuspend;
            
            if (delayRepondtimer == 0) {
                
                self.cycleScrollState = billBoardCycleScrollScrolling;
            }
        }else if (self.scrollView.forbiddenScroll) {
            
            self.cycleScroll = billBoardCycleScrollEnded;
        }
        
        if (self.cycleScrollState == billBoardCycleScrollSuspend ||
            self.cycleScrollState == billBoardCycleScrollForbidden ||
            self.cycleScrollState == billBoardCycleScrollEnded) {
            
            return;
        }
        
        self.cycleScrollState = billBoardCycleScrollScrolling;
        
        delayRepondtimer = 0;
        
        indexCnt ++;
        
        if (indexCnt == self.autoPlayInterval && self.autoPlayInterval > 0) {
            
            indexCnt = 0;
            
            [self.scrollView goForward:YES];
            
            if(self.cycleScroll) {
                
                if (self.page == self.trueCount) {
                    
                    self.page = 1;
                    
                    [self performSelector:@selector(correctScrollView:) withObject:NSStringFromInt(self.page) afterDelay:.4f];
                }
            }
        }
    }
}


@end


@implementation BILLBOARD

+ (BILLBOARD *)billBoard {
    
    BILLBOARD *board = [[BILLBOARD alloc] init];
    
    return board;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        _infoDic = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

@end



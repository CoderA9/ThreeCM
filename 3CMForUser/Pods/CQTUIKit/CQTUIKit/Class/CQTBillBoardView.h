//
//  CQTBillBoardView.h
//  CQTIda
//
//  Created by ANine on 10/9/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTView.h"

#import "CQTListView.h"

#import "CQTDataBaseStructure.h"

#import "CQTTouchImageView.h"
@class BILLBOARD;
/**
 @brief 广告图
 
 @discussion <#some notes or alert with this class#>
 */
typedef void (^tapAction)(int index , BILLBOARD *board);

typedef enum _billBoardCycleScrollState {
    
    billBoardCycleScrollForbidden ,//禁止滚动.
    billBoardCycleScrollScrolling ,//可以滚动.只有在这个状态才可以滚动.
    billBoardCycleScrollSuspend ,//暂停滚动.
    billBoardCycleScrollEnded ,//已经停止滚动.
}billBoardCycleScrollState;

@interface CQTBillBoardView : CQTView <CQTListViewDataSource,CQTListViewDelegate ,CQTTouchImageViewDelegate > {
    
    tapAction _oneTapBlock;
}

/* 用户点击的页数记录 */
@property (nonatomic,assign) int page;

/* 滚动视图. */
@property (nonatomic,retain)CQTListView *scrollView;

/* 翻页滚动. */
@property (nonatomic,retain)UIPageControl *pageControl;

/* 文字显示背景,仅适用于满宽显示 */
@property (nonatomic,retain)UIView *labelBgView;

/* 文字显示,仅适用于满宽显示 */
@property (nonatomic,retain)CQTLabel *label;

/* 广告位数据 */
@property (nonatomic,retain)NSMutableArray *boardsAry;

/* 真实的广告位数量,当支持循环滚动时,当前视图的前后会分别增加一条数据,这样就会使广告位数量增加2,这个成员变量是来记录真实的广告位数量的. */
@property (nonatomic,assign)int trueCount;

/* 是否显示文字,满宽屏时显示 */
@property (nonatomic,assign)BOOL needShowContext;

/* 是否显示非全频显示的view的文本,当前的view有文本就显示,没文本就不显示. */
@property (nonatomic,assign)BOOL needShowPerViewContext;

/* 是否可点击查看大图.默认为NO. */
@property (nonatomic, assign)BOOL canViewEnlarge;

/* 设置自动翻页播放间隔时间,默认=-110,不自动播放 */
@property (nonatomic, assign) int autoPlayInterval;

/* 是否支持循环滚动,默认= yes */
@property (nonatomic, assign) BOOL cycleScroll;

/* 指示当前滚动状态 */
@property (nonatomic, assign)billBoardCycleScrollState cycleScrollState;

/* scrollView上每个itemView之间的间隔距离 default = 0 */
@property (nonatomic, assign)float itemSeperate;

/* scrollView上每个itemView的圆角 default = 0 */
@property (nonatomic, assign)float itemCornerRadius;

/* scrollView上每个itemView的线条颜色 default = clearColor */
@property (nonatomic, retain)UIColor *itemLayerColor;

/* scrollView上每个itemView的layer线宽 default = 0 */
@property (nonatomic, assign)float itemLayerWidth;

/* default is NO. */
@property (nonatomic, assign)BOOL forbiddenRefreshItemWidth;
/* 默认是No */
@property (nonatomic, assign)BOOL needThubmailImage;

- (UIView *)viewForIndex:(int)index;

/* 刷新页面 */
- (void)reloadData;

/* 注册一个响应事件 */
- (void)addTapAction:(tapAction)block;

@end

/**
 @brief 广告位数据结构
 
 @discussion <#some notes or alert with this class#>
 */
@interface BILLBOARD : CQTDataBaseStructure

@property (nonatomic,retain)NSString *detailInfo;//详细描述.
@property (nonatomic,retain)NSString *summary;//概述.
@property (nonatomic,retain)NSMutableDictionary *infoDic;//广告位图片的备用数据传递.
@property (nonatomic,retain)NSString *imagePath;//图片路径.

+ (BILLBOARD *)billBoard;

@end
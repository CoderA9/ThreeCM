//
//  CQTBaseTableViewCell.h
//  CQTIda
//
//  Created by ANine on 1/13/15.
//  Copyright (c) 2015 www.cqtimes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQTView.h"
#import "CQTTouchImageView.h"
/**
 @brief CQTimes 所有Cell的基类.

 @description 该类封装了一些基础的UI,以避免做重复性的UI工作.
 
 @discussion 基类中各子控件的UI效果是基于爱达App,为适应各项目的不同UI需求,有两种方式:
                
             1.创建一个类别方法,重载方法- (void)resetSubViewsGUI;
             2.根据不同的cell,在cell内部做相应的适配工作.
 */

#define cellTitleKey @"title"
#define cellSubTitleKey @"subTitle"
#define cellDetailKey @"detailKey"


@interface CQTBaseTableViewCell : UITableViewCell {
    
    /* _contentBgView是为了满足有些列表,需要有点击效果,重载setSelected:Animation:方法或者setHighted:Animation:来做动画 */
    CQTView *_contentBgView;
    
    /* 管理使用Block来响应事件的数组 */
    NSMutableArray *_globalBlocksAry;
}


/* 回收全局block */
- (void)releaseGlobalBlocks;
/* IDa所有ViewControllerbutton事件处理的注册方法,viewController的Button添加事件使用这个方法. */
- (void)handleObject:(UIButton *)button event:(UIControlEvents)event block:(void(^)(UIButton * sender))block;

@property (nonatomic,retain)CQTView *contentBgView;
@property (nonatomic,retain)UIColor *hightlightColor;
@property (nonatomic,retain)UIColor *normalColor;

/* 图片展示View */
@property (nonatomic,retain)CQTTouchImageView *imgView;

/* 标题Label */
@property (nonatomic,retain)CQTLabel *titleLabel;

/* 描述Label */
@property (nonatomic,retain)CQTLabel *descLabel;

/* 副标题Label */
@property (nonatomic,retain)CQTLabel *subTitleLabel;
/* 副标题Label2 */
@property (nonatomic,retain)CQTLabel *subTitleLabel_2;

/* 按钮1 */
@property (nonatomic,retain)CQTCustomButton *reserveBtn;

/* 按钮2 */
@property (nonatomic,retain)CQTCustomButton *LeftBtn;

/* 按钮3 */
@property (nonatomic,retain)CQTCustomButton *rightBtn;

/* 覆盖Cell的bgBtn. */
@property (nonatomic,retain)UIButton *bgBtn;

/* 是否需要顶部线 */
@property (nonatomic,assign)BOOL topLine;

/* 是否需要底部线 */
@property (nonatomic,assign)BOOL bottomLine;

/* 
 * 是否需要ContentBgView
 * 如果need = YES,cell上面所有的子控件需要加到ContentBgView上.
 */
- (void)needContentBgView:(BOOL)need;

/* 便捷创建ContentBgView */
- (void)createContentBgViewIfNeeded;

//返回需要tableView为cell配置的cell.
+ (CGFloat)cellNeedHeight;
- (CGFloat)cellNeedHeight ;

/*
 key:              desc:
 title            标题
 subTitle        副标题
 cellWidth      cell的宽度
 */
+ (CGFloat)cellNeedHeightWithDic:(NSDictionary *)atrDic;

/* 创建TitleLabel */
- (void)createTitleLabelIfNeeded;

/* 创建左边展示图 */
- (void)createImgViewIfNeeded ;

/* 创建一个描述Label */
- (void)createDescInfoIfNeeded;

/* 创建一个副标题 */
- (void)createSubtitleIfNeeded;

/* 创建左边的按钮 */
- (void)createLeftButtonIfNeeded;

/* 创建右边的按钮 */
- (void)createRightButtonIfNeeded;

/* 创建一个备用的按钮 */
- (void)createReserveButtonIfNeeded;

/* 增加一个Action */
- (void)handleTouchUpInside:(void (^)(UIButton *btn))block;

/* 适应各项目的不同UI需求 */
- (void)resetSubViewsGUI;
- (void)updateSubviewsGUI;
/* 装载不同的子View. */
#define BaseCellImgView  @"imgView"
#define BaseCellTitleLabel  @"titleLabel"
#define BaseCellSubTitleLabel  @"subtitleLabel"
#define BaseCellSubTitleLabel_2  @"subtitleLabel_2"
#define BaseCellDescLabel  @"DescLabel"
#define BaseCellLeftBtn  @"LeftBtn"
#define BaseCellRightBtn  @"RightBtn"
#define BaseCellReveserBtn  @"ReveserBtn"
#define BaseCellBgBtn  @"BgBtn"

- (void)loadSubViews:(NSArray *)keys;

@end

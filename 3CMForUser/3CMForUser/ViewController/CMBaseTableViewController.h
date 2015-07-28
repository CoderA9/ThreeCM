//
//  CMBaseTableViewController.h
//  3CMForUser
//
//  Created by ANine on 7/28/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CMBaseViewController.h"

#import "CQTPullToRefreshView.h"
#import "CQTLoadMoreButton.h"

@interface CMBaseTableViewController : CMBaseViewController <UIScrollViewDelegate,CQTPullToRefreshViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    
    /* 主tableView */
    UITableView *_tableView;
    
    /* 下拉刷新View */
    CQTPullToRefreshView *pullToRefreshView;
    
    /* 上拉加载View */
    CQTLoadMoreButton *moreButton;
    
    /* 加载方式 */
    CQTLoadType loadType;
    
    /* tableView头 */
    CQTView *_tableHeaderView;
    
    /* tableView底部 */
    CQTView *_tableFooterView;
}


@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) CQTPullToRefreshView *pullToRefreshView;
@property (nonatomic, retain) CQTLoadMoreButton *moreButton;
//需要重新拉取数据.
@property (nonatomic, assign) BOOL needReLoadData;

/* 加载的方式:下拉刷新/上拉加载 */
@property (nonatomic, assign) CQTLoadType loadType;

@property (nonatomic, assign) BOOL needRefresh;//标记当前tableView是否需要更新.

/* 创建tableView头 */
- (void)createTableHeaderViewIfNeeded;

/* 创建tableView底 */
- (void)createTableFooterViewIfNeeded;

- (void)addPullToRefreshView;
- (void)pullToRefresh;

/* 下拉刷新加载数据 */
- (void)toLoad;

/* 完成加载,不考虑家在更多按钮和空数据页面 */
- (void)finishLoad;
//前一个参数决定是否加载更多的UI，后一个参数决定页面数据是否为空.
- (void)finishLoadingWithCnt:(NSInteger)thisTimeRequestCnt showTableHolderWithCnt:(NSInteger)dataCnt;



@end

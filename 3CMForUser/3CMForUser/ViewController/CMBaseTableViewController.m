//
//  CMBaseTableViewController.m
//  3CMForUser
//
//  Created by ANine on 7/28/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CMBaseTableViewController.h"



@interface CMBaseTableViewController () 

@end

@implementation CMBaseTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _needReLoadData = NO;
    }
    return self;
}

- (void)configVisualSubviews {
    
    [super configVisualSubviews];
    
    [self  createTableViewIfNeeded];
    [self.view addSubview:_tableView];
    
    [self.view bringSubviewToFront:_headView];
}

- (void)addPullToRefreshView {
    
    if (!pullToRefreshView) {
        
        pullToRefreshView = [[CQTPullToRefreshView alloc] initWithScrollView:self.tableView];
        
        UIView *parentView = _tableView;
        
        if (_tableView.tableHeaderView) {
            
            parentView = _tableView.tableHeaderView;
            
            pullToRefreshView.yOffset = ViewHeight(parentView);
        }else {
            
            pullToRefreshView.yOffset = 0.;
        }
        
        [parentView addSubview:pullToRefreshView];
    }
    
    pullToRefreshView.backgroundColor = kClearColor;
    
    [pullToRefreshView setDelegate:self];

}

- (void)removePullToRefreshView {
    
    if (pullToRefreshView != nil) {
        
        [pullToRefreshView removeKVO4ContentOffset];
        pullToRefreshView.delegate = nil;
        
        A9_ViewReleaseSafely(pullToRefreshView);
        
    }
}

- (void)pullToRefresh {
    
    [self.pullToRefreshView setState:PullToRefreshViewStateLoading];
    [self.pullToRefreshView  doManualRefresh];
}

/* 下拉刷新加载数据 */
- (void)toLoad {
    
    if (self.needRequestData == YES ) {
        
        [self loadNeedData];
    }
}

/* 完成加载,不考虑家在更多按钮和空数据页面 */
- (void)finishLoad {
}
//前一个参数决定是否加载更多的UI，后一个参数决定页面数据是否为空.
- (void)finishLoadingWithCnt:(NSInteger)thisTimeRequestCnt showTableHolderWithCnt:(NSInteger)dataCnt {
}


#pragma mark - | ***** createViews ***** |
- (void)createTableViewIfNeeded {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kBgMainColor;//HEX_RGB(0xD9D9D9);
        
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *view =CQT_AUTORELEASE([[UIView alloc] initWithFrame:CGRectZero]);
        _tableView.tableFooterView = view;
        
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = YES;
        
        _tableView.frame = ViewRect(0,0, ViewWidth(self.view), ViewHeight(self.view));
    }
    else {
        
        CQTRemoveFromSuperViewSafely(_tableView);
    }
}


- (void)createTableHeaderViewIfNeeded {
    
    if (!_tableHeaderView) {
        
        _tableHeaderView = [[CQTView alloc] initWithFrame:ViewRect(0, 0, ViewWidth(_tableView), HEAD_VIEW_HEIGHT + statusHeight)];
        _tableHeaderView.clipsToBounds = YES;
    }else {
        _tableHeaderView.frame = ViewRect(0, 0, ViewWidth(_tableView), HEAD_VIEW_HEIGHT + statusHeight);
        CQTRemoveFromSuperViewSafely(_tableHeaderView);
    }
}

- (void)createTableFooterViewIfNeeded {
    
    if (!_tableFooterView) {
        
        _tableFooterView = [[CQTView alloc] initWithFrame:ViewRect(0, 0, ViewWidth(_tableView), TAB_BAR_HEIGHT)];
    }else {
        
        CQTRemoveFromSuperViewSafely(_tableFooterView);
    }
}

@end

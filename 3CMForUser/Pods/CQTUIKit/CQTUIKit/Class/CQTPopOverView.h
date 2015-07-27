//
//  CQTPopOverView.h
//  CQTIda
//
//  Created by ANine on 7/10/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQTView.h"
/**
 @brief 类似于iPad的popOver效果.
 
 @discussion <#some problem description with this class#>
 */
@interface CQTPopOverView : CQTView

/* 头部View */
@property (nonatomic,strong)CQTImgView *headView;

/* popOver的列表UI和数据需要从外部加载. */
@property (nonatomic,strong)UITableView *tableView;

/* popOver主体颜色. */
@property (nonatomic,strong)UIColor *mainColor;

/* 字体颜色 */
@property (nonatomic,strong)UIColor *mainTextColor;

/* 当前是否显示. */
@property (nonatomic,assign)BOOL isShow;

/* 是否需要小三角 */
@property (nonatomic,assign)BOOL needGuide;

- (instancetype)initWithTarget:(id <UITableViewDataSource,UITableViewDelegate>)target;

@end


@protocol CQTPopOverViewDelegate <NSObject>

@required



@end
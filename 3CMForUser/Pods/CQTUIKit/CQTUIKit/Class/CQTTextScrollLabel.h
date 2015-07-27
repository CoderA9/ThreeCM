//
//  CQTTextScrollLabel.h
//  CQTIda
//
//  Created by ANine on 6/25/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTView.h"

/**
 @brief 文字可滚动显示的Label.
 
 @discussion <#some problem description with this class#>
 */
@interface CQTTextScrollLabel : CQTLabel
/* 当label现实不全的时候,是否启动滚动显示文字.默认 textCanScroll = NO */
@property (nonatomic,assign)BOOL textCanScroll;

@property (nonatomic,retain)UIView *superView;

/* 禁用暂停功能. */
@property (nonatomic,assign)BOOL enablePauseFunc;

- (BOOL)checkTextAccessTheBounds;

@end

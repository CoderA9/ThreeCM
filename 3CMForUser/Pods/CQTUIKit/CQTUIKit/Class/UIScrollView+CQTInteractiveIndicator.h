//
//  UIScrollView+UzysInteractiveIndicator.h
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQTRadialProgressActivityIndicator.h"

@interface UIScrollView (CQTInteractiveIndicator)
@property (nonatomic,assign) BOOL showPullToRefresh;
@property (nonatomic,strong,readonly) CQTRadialProgressActivityIndicator *pullToRefreshView;

- (void)addPullToRefreshActionHandler:(actionHandler)handler imageName:(NSString *)imageName offset:(CGPoint)point;
- (void)triggerPullToRefresh;
- (void)stopRefreshAnimation;
@end

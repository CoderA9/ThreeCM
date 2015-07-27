//
//  UIScrollView+UzysInteractiveIndicator.m
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import "UIScrollView+CQTInteractiveIndicator.h"
#import <objc/runtime.h>
static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (CQTInteractiveIndicator)
@dynamic pullToRefreshView, showPullToRefresh;

- (void)addPullToRefreshActionHandler:(actionHandler)handler imageName:(NSString *)imageName offset:(CGPoint)point {
    if(self.pullToRefreshView == nil)
    {
        CQTRadialProgressActivityIndicator *view = [[CQTRadialProgressActivityIndicator alloc] initWithImage:[UIImage imageNamed:imageName]];
        view.pullToRefreshHandler = handler;
        view.scrollView = self;
        CGRect foo = CGRectMake(point.x + (self.bounds.size.width - view.bounds.size.width)/2,point.y - view.bounds.size.height,view.bounds.size.width, view.bounds.size.height);
        view.frame = foo;
        
        view.originalTopInset = self.contentInset.top;
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToRefreshView = view;
        self.showPullToRefresh = YES;
    }
}

- (void)triggerPullToRefresh
{
    [self.pullToRefreshView manuallyTriggered];
}
- (void)stopRefreshAnimation
{
    [self.pullToRefreshView stopIndicatorAnimation];
}
#pragma mark - property
- (void)setPullToRefreshView:(CQTRadialProgressActivityIndicator *)pullToRefreshView
{
    [self willChangeValueForKey:@"UzysRadialProgressActivityIndicator"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView, pullToRefreshView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UzysRadialProgressActivityIndicator"];
}
- (CQTRadialProgressActivityIndicator *)pullToRefreshView
{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowPullToRefresh:(BOOL)showPullToRefresh {
    self.pullToRefreshView.hidden = !showPullToRefresh;
    
    if(showPullToRefresh)
    {
        if(!self.pullToRefreshView.isObserving)
        {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.pullToRefreshView.isObserving = YES;
        }
    }
    else
    {
        if(self.pullToRefreshView.isObserving)
        {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            self.pullToRefreshView.isObserving = NO;
        }
    }
}

- (BOOL)showPullToRefresh
{
    return !self.pullToRefreshView.hidden;
}
@end

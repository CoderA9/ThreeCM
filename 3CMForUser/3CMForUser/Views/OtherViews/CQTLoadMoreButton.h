//
//  LoadMoreView.h
//  newsyc
//
//  Created by Grant Paul on 9/5/11.
//  Copyright (c) 2011 Xuzz Productions, LLC. All rights reserved.
//

#import "CQTLoadingIndicatorView.h"

@interface CQTLoadMoreButton : UIButton {
   
	CQTLoadingIndicatorView *indicatorView;
    UILabel *moreLabel;
}

@property (nonatomic, retain)  UILabel *moreLabel;

- (void)startLoading;
- (void)stopLoading;

@end

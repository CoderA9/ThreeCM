//
//  LoadMoreView.m
//  newsyc
//
//  Created by Grant Paul on 9/5/11.
//  Copyright (c) 2011 Xuzz Productions, LLC. All rights reserved.
//

#import "CQTLoadMoreButton.h"

@implementation CQTLoadMoreButton

@synthesize moreLabel;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		indicatorView = [[CQTLoadingIndicatorView alloc] initWithFrame:[self bounds]];
        [indicatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [indicatorView setHidden:YES];
        [indicatorView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:indicatorView];
        
        moreLabel = [[UILabel alloc] initWithFrame:[self bounds]];
        [moreLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [moreLabel setText:@"更多"];
        [moreLabel setTextAlignment:NSTextAlignmentCenter];
        [moreLabel setTextColor:[UIColor grayColor]];
        [moreLabel setBackgroundColor:[UIColor clearColor]];
        [moreLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [self addSubview:moreLabel];
    }
    
    return self;
}

- (void)startLoading {
	
    [indicatorView setHidden:NO];
    [moreLabel setHidden:YES];
}

- (void)stopLoading {
	
    [indicatorView setHidden:YES];
    [moreLabel setHidden:NO];
}

- (void)dealloc {
	
    CQT_RELEASE(indicatorView);
    CQT_RELEASE(moreLabel);
    
    
}

@end

//
//  NBMessageStatusReportView.m
//  twitBird
//
//  Created by wei li on 12/11/09.
//  Copyright 2009 nibirutech. All rights reserved.
//

#import "CQTReportView.h"
#import <QuartzCore/QuartzCore.h>
#import "Util.h"
#import "Def.h"


#define INIT_TAG 0
#define SHOW_TAG 1
#define HIDE_TAG 2

#define kLabelHeight              35
#define kVOIsFinishedReport       @"isFinishedReport"
#define KVOStrReport              @"strReport"
#define kTag4CustomNavBarView           987L
  

static CQTReportView *_statusReport = nil; 

@implementation CQTReportView
@synthesize isFinishedReport;
@synthesize strReport;


+ (CQTReportView *)sharedInstance {

	if(_statusReport) {
        
		return _statusReport;
	}
		
	@synchronized([CQTReportView class]) {
        
		if(!_statusReport) _statusReport = [[CQTReportView alloc] initWithFrame:CGRectZero];
	}
	return _statusReport;
}

- (void)layoutSubviews {
	[super layoutSubviews];
   
	CGFloat xOff = 25.0f;
	CGFloat indicatorHeight = 20.0f;
	CGFloat lableHeight  = 25.0f;
	activityIndicatorView.frame = CGRectMake(xOff, (int)((self.frame.size.height-indicatorHeight)/2), indicatorHeight, indicatorHeight);
	textLabel.frame = CGRectMake(CGRectGetMaxX(activityIndicatorView.frame)+5, (int)(activityIndicatorView.center.y-lableHeight/2), 
								 self.frame.size.width-indicatorHeight-5-2*xOff, lableHeight);
	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor colorWithWhite:0.f alpha:.6f];
        //[UIColor colorWithRed:255.f/255.f green:107.f/255.f blue:82.f/255.f alpha:1.0];//[UIColor colorWithWhite:1.f alpha:.7f];
        
		self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleWidth;
//		self.layer.borderColor = [[UIColor grayColor] CGColor];
//		self.layer.borderWidth = 1.0f;
		
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[self addSubview:activityIndicatorView];
		
		textLabel = [[UILabel alloc] initWithFrame:CGRectZero];	
		textLabel.textAlignment = UITextAlignmentCenter;	
		textLabel.backgroundColor = [UIColor clearColor];	
		textLabel.textColor = [UIColor whiteColor];
		textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
		[textLabel setAutoresizingMask:self.autoresizingMask];
		[self addSubview:textLabel];	
		
		[self addObserver:self forKeyPath:kVOIsFinishedReport options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
		[self addObserver:self forKeyPath:KVOStrReport options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)show:(NSString *)status container:(UIView *)container {
	
	float width = container.frame.size.width;
	float height = kLabelHeight;
    float navHeight = 44.;
    float statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    float yOff = navHeight + (iOS_IS_UP_VERSION(7.0)?statusBarHeight:0);
	CGRect statusFrame = CGRectMake(0, yOff, width, height);
	self.frame = statusFrame;
	textLabel.font = [UIFont systemFontOfSize:14.0f];
	textLabel.text = status;
	if(![self superview]) {
        
		self.alpha = 0;
		CATransition *animation = [CATransition animation];
		[animation setType:kCATransitionMoveIn]; 
		[animation setSubtype:kCATransitionFromBottom];
		[animation setDuration:.3f];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		animation.delegate = self;
		animation.removedOnCompletion = YES;
		self.tag = SHOW_TAG;
		[[self layer] addAnimation:animation forKey:@"showViewAnimation"];
		self.alpha = 1;
        UIView *v = [container viewWithTag:kTag4CustomNavBarView];
        if (v != nil) {
            
            [container insertSubview:self belowSubview:v];
        }
        else {
        
            [container addSubview:self];
            [container bringSubviewToFront:self];
        }
	}
	[[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];
}

+ (void)showStatus:(NSString *)status container:(UIView *)container {

//	float width = container.frame.size.width;
//	float height = kTextLabelHeight;
//	CGRect statusFrame = CGRectMake(0, 0, width, height);
//	CQTReportView *reportView = [[CQTReportView alloc] initWithFrame:statusFrame];
//	[reportView show:status container:container];
//	[reportView release];
	
//	float width = container.frame.size.width;
//	float height = kLabelHeight;
//	CGRect statusFrame = CGRectMake(0, 0, width, height);
//  [[CQTReportView sharedInstance] setFrame:statusFrame];
//	[[CQTReportView sharedInstance] show:status container:container];
//	[[CQTReportView sharedInstance] release];
    
    //
    [[CQTReportView sharedInstance] show:status container:container];
}

- (void)hide {
    
	float timeHide = 0.25;
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionReveal]; 
	[animation setSubtype:kCATransitionFromTop];
	[animation setDuration:timeHide];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	animation.delegate = self;
	self.tag = HIDE_TAG;
	animation.removedOnCompletion = YES;
	[[self layer] addAnimation:animation forKey:@"hideViewAnimation"];
	self.alpha = 0;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	
    if(self.tag == SHOW_TAG) {

        self.isFinishedReport = YES;
	}
	else if(self.tag == HIDE_TAG) {
		
		[self removeFromSuperview];	
		self.tag = INIT_TAG;
		isFinishedReport = NO;
	}
	[self.layer removeAllAnimations];
}

- (void)dealloc {
	
	[self removeObserver:self forKeyPath:kVOIsFinishedReport];
	[self removeObserver:self forKeyPath:KVOStrReport];
    
    CQT_RELEASE(strReport);
    CQT_RELEASE(activityIndicatorView);
    CQT_RELEASE(textLabel);
	if(_statusReport == self) _statusReport = nil;
	[[NSRunLoop mainRunLoop] cancelPerformSelectorsWithTarget:self];
	
}

#pragma mark KVO

- (void)report {

	textLabel.text = strReport;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	if ([keyPath isEqualToString:kVOIsFinishedReport]) {
	
		if (self.isFinishedReport) {
			
			[self performSelector:@selector(hide) withObject:nil afterDelay:1.5f];
		}
	}
	else if([keyPath isEqualToString:KVOStrReport]) {
		
		[self performSelectorOnMainThread:@selector(report) withObject:nil waitUntilDone:YES];
 }
}

- (void)startActivityIndicator {

	[activityIndicatorView startAnimating];
}

- (void)stopActivityIndicator {

	[activityIndicatorView stopAnimating];
}

#pragma mark -

@end

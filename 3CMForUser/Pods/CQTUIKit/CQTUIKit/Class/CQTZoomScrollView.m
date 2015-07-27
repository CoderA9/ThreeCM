//
//  PDFLandScapeView.m
//  CaseSearch
//
//  Created by BraveSoft on 8/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CQTZoomScrollView.h"

#define DOUBLE_TAP_DELAY .35f

CGPoint MidPointBetweenPoints(CGPoint a, CGPoint b) {
    
    CGFloat x = (a.x + b.x) / 2.0;
    CGFloat y = (a.y + b.y) / 2.0;
    return CGPointMake(x, y);
}

@interface CQTZoomScrollView ()

- (void)handleSingleTap;
- (void)handleDoubleTap;
- (void)handleTwoFingerTap;

@end

@implementation CQTZoomScrollView
@synthesize curPage;
@synthesize contentView;
@synthesize logical_origin;
@synthesize tapDelegate;


#pragma mark -
#pragma mark lifecircle

- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        [super setDelegate: self];
		[self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
		[self setBouncesZoom:NO];
		[self setMinimumZoomScale:1.0f];
        [self setMaximumZoomScale:2.0f];
		self.scrollEnabled = YES;
		self.contentSize = frame.size;
        self.autoresizesSubviews = YES;
        self.clipsToBounds = YES;
	}
    return self;
}

- (void)dealloc {
    
    tapDelegate = nil;
    
    CQT_RELEASE(contentView);
    
}

- (void)setContentView:(UIView *)v {

    if (v != nil && v != contentView) {
        
        
        CQT_RELEASE(contentView);
        contentView = CQT_RETAIN(v);

        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
    }
}

#pragma mark 
#pragma mark handleEvent

- (void)handleSingleTap  {
    
    if (self.zoomScale>1.0) {
    
        [self setZoomScale:1.0 animated:YES];
    }
    else {
    
        if (tapDelegate != nil &&  [tapDelegate respondsToSelector:@selector(zoomScrollView:gotSingleTapAtPoint:)]) {
        
            [tapDelegate zoomScrollView:self gotSingleTapAtPoint:tapLocation];
        }
    }
}

- (void)handleDoubleTap {
    
    if (tapDelegate != nil && [tapDelegate respondsToSelector:@selector(zoomScrollView:gotDoubleTapAtPoint:)]) {
    
        [tapDelegate zoomScrollView:self gotDoubleTapAtPoint:tapLocation];
    }
}

- (void)handleTwoFingerTap  {
    
    if (tapDelegate != nil && [tapDelegate respondsToSelector:@selector(zoomScrollView:gotTwoFingerTapAtPoint:)]) {
    
         [tapDelegate zoomScrollView:self gotTwoFingerTapAtPoint:tapLocation];
    }
}

#pragma mark -
#pragma mark touches event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // cancel any pending handleSingleTap messages 
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap) object:nil];
    
    // update our touch state
    if ([[event touchesForView:self] count] > 1)
        multipleTouches = YES;
    if ([[event touchesForView:self] count] > 2)
        twoFingerTapIsPossible = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self] count]);
    
    // first check for plain single/double tap, which is only possible if we haven't seen multiple touches
    if (!multipleTouches)  {
        
        UITouch *touch = [touches anyObject];
        tapLocation = [touch locationInView:self];
       // NSLog(@"tap location: %f, %f", tapLocation.x, tapLocation.y);
        if([touch tapCount] == 2){
            
            [self handleDoubleTap];
        }
        else if ([touch tapCount] == 1) {
            
            //modify by sky
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
        }
    }    
    
    // check for 2-finger tap if we've seen multiple touches and haven't yet ruled out that possibility
    else if (multipleTouches && twoFingerTapIsPossible) 
	{ 
        
        // case 1: this is the end of both touches at once 
        if ([touches count] == 2 && allTouchesEnded) 
		{
            int i = 0; 
            int tapCounts[2];
            CGPoint tapLocations[2];
            for (UITouch *touch in touches) 
			{
                tapCounts[i]    = [touch tapCount];
                tapLocations[i] = [touch locationInView:self];
                i++;
            }
            if ((tapCounts[0] == 1) && (tapCounts[1] == 1)) { // it's a two-finger tap if they're both single taps
                
                tapLocation = MidPointBetweenPoints(tapLocations[0], tapLocations[1]);
                [self handleTwoFingerTap];
            }
        }
        
        // case 2: this is the end of one touch, and the other hasn't ended yet
        else if ([touches count] == 1 && !allTouchesEnded) 
		{
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) 
			{
                // if touch is a single tap, store its location so we can average it with the second touch location
                tapLocation = [touch locationInView:self];
            } 
			else 
			{
                twoFingerTapIsPossible = NO;
            }
        }
        
        // case 3: this is the end of the second of the two touches
        else if ([touches count] == 1 && allTouchesEnded) 
		{
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) 
			{
                // if the last touch up is a single tap, this was a 2-finger tap
                tapLocation = MidPointBetweenPoints(tapLocation, [touch locationInView:self]);
                [self handleTwoFingerTap];
            }
        }
    }
    
    // if all touches are up, reset touch monitoring state
    if (allTouchesEnded) 
	{
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
}

#pragma mark -
#pragma mark CQTZoomScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return contentView;
}

- (void)zoomScrollView:(CQTZoomScrollView *)zoomScrollView gotSingleTapAtPoint:(CGPoint)tapPoint  {
    
    [[NSNotificationCenter defaultCenter]postNotificationName: @"singleTapNotification" object:nil];
}

- (void)zoomScrollView:(CQTZoomScrollView *)zoomScrollView gotDoubleTapAtPoint:(CGPoint)tapPoint  {
    
    //double tap zooms in
    CGRect r = CGRectZero;
    if(contentView != nil) {
        
		r.size.height = contentView.frame.size.height * 0.5;
		r.size.width  = contentView.frame.size.width  * 0.5;
		r.origin.x = tapPoint.x - (r.size.width  / 2.0);
		r.origin.y = tapPoint.y - (r.size.height / 2.0);
	}
	
    [self zoomToRect:r animated:YES];
}

- (void)zoomScrollView:(CQTZoomScrollView *)zoomScrollView gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    
    CGRect r = CGRectZero;
    if(contentView != nil) {
        
		r.size.height = contentView.frame.size.height;
		r.size.width  = contentView.frame.size.width;
		r.origin.x = tapPoint.x - (r.size.width  / 2.0);
		r.origin.y = tapPoint.y - (r.size.height / 2.0);
	}
    
    [self zoomToRect:r animated:YES];
}

#pragma mark -

@end


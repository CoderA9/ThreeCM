//
//  PDFLandScapeView.h
//  CaseSearch
//
//  Created by BraveSoft on 8/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CQTBigImageView;
@class CQTZoomScrollView;

@protocol CQTZoomScrollViewDelegate<NSObject>

@optional
- (void)zoomScrollView:(CQTZoomScrollView *)zoomScrollView gotSingleTapAtPoint:(CGPoint)tapPoint;
- (void)zoomScrollView:(CQTZoomScrollView *)zoomScrollView gotDoubleTapAtPoint:(CGPoint)tapPoint;
- (void)zoomScrollView:(CQTZoomScrollView *)zoomScrollView gotTwoFingerTapAtPoint:(CGPoint)tapPoint;
@end

@interface CQTZoomScrollView: UIScrollView<UIScrollViewDelegate> {
	
	NSInteger  curPage;
	UIView* contentView;
	CGPoint tapLocation;         // Needed to record location of single tap, which will only be registered after delayed perform.
    BOOL   multipleTouches;        // YES if a touch event contains more than one touch; reset when all fingers are lifted.
    BOOL  twoFingerTapIsPossible; // Set to NO when 2-finger tap can be ruled out (e.g. 3rd finger down, fingers touch down too far apart, etc).
    CGPoint logical_origin;
	__unsafe_unretained id <CQTZoomScrollViewDelegate> tapDelegate;
}

@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, retain) UIView* contentView;
@property (nonatomic, assign) id <CQTZoomScrollViewDelegate> tapDelegate;
@property (nonatomic, assign) CGPoint logical_origin;

@end


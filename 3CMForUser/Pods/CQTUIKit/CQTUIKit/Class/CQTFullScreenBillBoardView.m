//
//  CQTFullScreenBillBoardView.m
//  CQTIda
//
//  Created by ANine on 10/10/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTFullScreenBillBoardView.h"
#import "CQTViewConstants.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LXImageView.h"
#import "CQTAlertView.h"

#define kDefalutWidth           10
#define kTagBase                500
#define kAnimationDuration      .3f
#define kPageLabelSize          CGSizeMake(100, 16)
#define kPageFormat             @"%i / %i"
#define kShowAnimationKey       @"showAnimation"
#define kHideAnimationKey       @"hideAnimation"
#define kFadeInAnimationKey     @"fadeInAnimation"
#define kFadeOutAnimationKey    @"fadeOutAnimation"


@implementation CQTFullScreenBillBoardView



#pragma mark - | ***** super Methods ***** |

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.needShowAnimation = YES;
        
        self.originViewContentModel = UIViewContentModeScaleAspectFit;
        
        self.needShowStatusBarWhenHide = YES;
        
        self.needShowContext = NO;
        
        self.canViewEnlarge = NO;
        
        self.needShowChecked = NO;
        
        self.needSHowStorage = NO;
        
        [self createSaveBtnIfNeeded];
        [self addSubview:_saveBtn];
        
        [self createPageLabelIfNeeded];
        [self addSubview:_pageLabel];
        
        if (!_selectedSet) {
            
            _selectedSet = [[NSMutableDictionary alloc] init];
        }
    }
    return self;

}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size,CGSizeZero)) {
        return;
    }
    
    UIImage *img = [UIImage imageNamed:@"save_album_normal.png"] ;

    _saveBtn.frame = CGRectMake(15, CGRectGetHeight(self.frame)-15-img.size.height,img.size.width, img.size.height);
    [self bringSubviewToFront:self.saveBtn];
    
    self.pageLabel.frame = CGRectMake((int)((CGRectGetWidth(self.frame)-kPageLabelSize.width)/2),
                                      CGRectGetHeight(self.frame)-5-kPageLabelSize.height,
                                      kPageLabelSize.width, kPageLabelSize.height);
    self.pageLabel.text = [NSString stringWithFormat:kPageFormat, self.page+1, self.boardsAry.count];
    //do something.
    
    self.scrollView.itemWidth = ViewWidth(self);
    
    _saveBtn.hidden = !self.needSHowStorage;
}


- (void)dealloc {
    
    if (_animationLayer != nil) {
        
        _animationLayer = nil;
    }
    
    CQT_RELEASE(_saveBtn);
    CQT_RELEASE(_pageLabel);
    
    if (_selectedSet) {
        
        [_selectedSet removeAllObjects];
    }
    
    if (selectedResultBlock) {
        
        CQT_BLOCK_RELEASE(selectedResultBlock);
    }
    
    CQT_RELEASE(_selectedSet);
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
    
}

- (void)reloadData {
    
    [super reloadData];
    
    int index = self.currentIndex;
    
    if (self.cycleScroll) {
        
        index ++;
    }
    
    [self.scrollView scrollToItemAtIndex:index atScrollPosition:CQTListViewScrollPositionCenter animated:NO];
}
#pragma mark - | ***** create views ***** |
- (void)createSaveBtnIfNeeded {

    if (!_saveBtn) {
        
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.enabled = YES;
        [_saveBtn setBackgroundImage:Image(save_album_normal.png) forState:UIControlStateNormal];
        [_saveBtn setBackgroundImage:Image(save_album_hilighted.png) forState:UIControlStateHighlighted];
        
        
        [_saveBtn addTarget:self action:@selector(handleSaveTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _saveBtn.hidden = YES;
    }else {
        
        CQTRemoveFromSuperViewSafely(_saveBtn);
    }
}

- (void)createPageLabelIfNeeded {

    if (!_pageLabel) {
        
        _pageLabel = [[CQTLabel alloc] init];
        _pageLabel.font = AvenirFont(13.);
        _pageLabel.textColor = kClearColor;
        _pageLabel.backgroundColor = kClearColor;
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        
    }else {
        
        CQTRemoveFromSuperViewSafely(_pageLabel);
    }
}

#pragma mark - CQTListViewDataSource (Required)
- (UIView *)listView:(CQTListView *)listView viewForItemAtIndex:(NSUInteger)index {

    CQTZoomScrollView *scrollview = (CQTZoomScrollView *)[listView dequeueReusableView];
    
    int btnTag = kTagBase - 100;
    
    if (!scrollview) {
        
        scrollview = CQT_AUTORELEASE([[CQTZoomScrollView alloc] init]);
        
        CQTTouchImageView *view = [[CQTTouchImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFit;
        scrollview.contentView = view;
        view.userInteractionEnabled = NO;
        
        UIButton *btn;
        if (!btn) {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        UIImage * img = [UIImage imageNamed:@"pickerNotChecked.png"];
        
        [btn setImage:img forState:UIControlStateNormal];
        btn.selected = YES;
        [btn setImage:[UIImage imageNamed:@"pickerChecked.png"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(handleCheckedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = btnTag;
        btn.hidden = YES;
        [scrollview addSubview:btn];
        
        
        CQT_RELEASE(view);
    }

    scrollview.tapDelegate = self;
    scrollview.tag = kTagBase + index;

    CQTTouchImageView *view = (CQTTouchImageView *)scrollview.contentView;
    view.frame = scrollview.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    view.image = nil;
    
    CGSize size = CGSizeMake(70, 70);
    UIButton *btn = (UIButton *)[scrollview viewWithTag:btnTag];
    btn.tag = btnTag;
//    btn.backgroundColor = [UIColor redColor];
    btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    btn.hidden = !self.needShowChecked;
    
    int selectedIndex = (int)index;
    if (self.cycleScroll) {
        
        selectedIndex --;
    }
    
    BOOL selected = [_selectedSet[@(selectedIndex)] boolValue];
    btn.selected = selected;
    
    btn.frame = CGRectMake(CGRectGetWidth(scrollview.frame)- size.width - 15, 15,
                           size.width, size.height);
    
    
    if (validAry(self.boardsAry) && self.boardsAry.count > index) {
        
        BILLBOARD *board = self.boardsAry[index];
        
        if(board) {
            
            if ([board isKindOfClass:[BILLBOARD class]]) {
                
                [view setImageWithURLString:[board.imagePath adjustImageHeader:[CQTResourceBrige sharedBrige].appBaseUrl] placeholderImage:PlaceHolderImage];
            }else if ([board isKindOfClass:[ALAsset class]]) {
                
                ALAsset *asset = self.boardsAry[index];
                
                view.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            }
        }
    }
    
    view.clipsToBounds = YES;
    
    return scrollview;
}

- (UIView *)xxxxlistView:(CQTListView *)listView viewForItemAtIndex:(NSUInteger)index {
    
    CQTZoomScrollView *scrollview = (CQTZoomScrollView *)[listView dequeueReusableView];
    
    if (!scrollview) {
        
        scrollview = CQT_AUTORELEASE([[CQTZoomScrollView alloc] init]);
        
        CQTTouchImageView *view = [[CQTTouchImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFit;
        scrollview.contentView = view;
    }
    
    CQTTouchImageView *view = (CQTTouchImageView *)[listView dequeueReusableView];
    
    if (!view) {
        
        view = CQT_AUTORELEASE([[CQTTouchImageView alloc] init]);
        
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    view.image = nil;
    
    if (validAry(self.boardsAry) && self.boardsAry.count > index) {
        
        BILLBOARD *board = self.boardsAry[index];
        
        if(board) {
            
            if ([board isKindOfClass:[BILLBOARD class]]) {
                
                [view setImageWithURLString:[board.imagePath adjustImageHeader:[CQTResourceBrige sharedBrige].appBaseUrl] placeholderImage:Image(Default.png)];
            }else if ([board isKindOfClass:[ALAsset class]]) {
                
                ALAsset *asset = self.boardsAry[index];
                
                view.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            }
        }
    }
    
    view.clipsToBounds = YES;
    
    return view;
}

#pragma mark - CQTListViewDelegate (Optional)
- (CGFloat)listView:(CQTListView *)listView widthForItemAtIndex:(NSUInteger)index {

    return ViewWidth(self);
}
#pragma mark - | ***** public methods ***** |

- (void)setBoardsAry:(NSMutableArray *)boardsAry {
    
    [super setBoardsAry:boardsAry];
    
    if (_selectedSet) {
        
        [_selectedSet removeAllObjects];
        
        for (int index = 0; index < boardsAry.count; index ++) {
        
            [_selectedSet setObject:@(1) forKey:@(index)];
        }
    }
}

- (void)show {
    
    POST_NOTIFICATION(kFullScreenBillBoardViewWillShow);
    
    switch (self.originViewContentModel) {
            
        case UIViewContentModeScaleAspectFit: {
            
            [self doShowAnimationWithAspectFit];
        }
            break;
        case UIViewContentModeScaleAspectFill: {
        }
        case UIViewContentModeScaleToFill: {
            
            [self doShowAnimationWithScale];
        }
            break;
        default:
            break;
    }
    
}

- (void)hide {
    
    POST_NOTIFICATION(kFullScreenBillBoardViewWillHide);
    
    switch (self.originViewContentModel) {
            
        case UIViewContentModeScaleAspectFit: {
            
            [self doHideAnimationWithAspectFit];
        }
            break;
        case UIViewContentModeScaleAspectFill: {
        }
        case UIViewContentModeScaleToFill: {
            
            [self doHideAnimationWithScale];
        }
            break;
        default:
            break;
    }
    
}

- (void)addSelectedPhotoResultBlock:(void(^)(NSMutableDictionary *dic))block {
    
    if (selectedResultBlock) {
    
        CQT_BLOCK_RELEASE(selectedResultBlock);
    }
    
    selectedResultBlock = CQT_BLOCK_COPY(block);
}

- (void)config4Page {
    
    NSInteger totalCount = self.boardsAry.count;
    NSInteger start = self.page-2;
    NSInteger end = self.page+3;
    if (totalCount>0) {
        
        for (int i=start; i<end; i++) {
            
            if (i>=0 && i<totalCount) {
                
                CQTZoomScrollView *pageView = (CQTZoomScrollView *)[self viewForIndex:i];
                
                BILLBOARD *board = self.boardsAry[i];
                
                LXImageView *view = [self imageView4Page:i];
                
                if(board) {
                    
                    if ([board isKindOfClass:[BILLBOARD class]]) {
                        
                        NSString *imageURL = [board imagePath];
                        NSString *originImageURL = [board imagePath];
                        imageURL = [imageURL adjustImageHeader:[CQTResourceBrige sharedBrige].appBaseUrl];
                        originImageURL = [originImageURL adjustImageHeader:[CQTResourceBrige sharedBrige].appBaseUrl];
                        
                        
                        if (pageView == nil) {
                            
                            pageView = [self zoomScrollViewForScrollViewAtPage:i];
                            [self.scrollView addSubview:pageView];
                            
                        }
                        
                        if (i == self.page) {
                            
                            [view setImageWithURLString:originImageURL placeholderImage:PlaceHolderImage];
                        }
                        else {
                            
                            [view setImageWithURLString:originImageURL placeholderImage:PlaceHolderImage];
                        }
                    }else if ([board isKindOfClass:[ALAsset class]]) {
                        
                        ALAsset *asset = self.boardsAry[i];
                        
                        view.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    }
                }

                
                
                
            }
        }
    }
}

- (void)showCurrentPage {
    
    self.pageLabel.text = [NSString stringWithFormat:kPageFormat, self.page+1, (int)self.boardsAry.count];
    self.saveBtn.enabled = ([self imageView4Page:self.page].image != nil);
    if (!self.scrollView.dragging) {
        
        [self.scrollView scrollRectToVisible:CGRectMake(self.page*CGRectGetWidth(self.scrollView.frame), 0,
                                                         CGRectGetWidth(self.scrollView.frame),
                                                         CGRectGetHeight(self.scrollView.frame)) animated:NO];
    }
}

#pragma mark - | *****  private methods ***** |

- (void)doShowAnimationWithAspectFit {
    
    self.userInteractionEnabled = NO;
    UIView *animaionView = [self viewForIndex:self.page];
    CGSize size = animaionView.frame.size;
    _animationLayer = [CALayer layer];
    animaionView.backgroundColor = kClearColor;
    _animationLayer.contents = (id)[[Util shotImageFrameView:animaionView shotSize:size] CGImage];
    _animationLayer.frame = animaionView.bounds;
    _animationLayer.anchorPoint = CGPointMake(0, 0);
    [animaionView.layer addSublayer:_animationLayer];
    [self viewForIndex:self.page].hidden = YES;
    animaionView.backgroundColor = [UIColor blackColor];;
    
    // opacity
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opcity"];
    fadeInAnimation.fillMode = kCAFillModeBoth;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:.2f];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.f];
    fadeInAnimation.duration = 5.f;
    fadeInAnimation.delegate = self;
    fadeInAnimation.removedOnCompletion = NO;
    
    // poition
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fillMode = kCAFillModeBoth;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.fromRect.origin];
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    
    //scale
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:
                                CATransform3DMakeScale((float)self.fromRect.size.width/size.width,
                                                    (float)self.fromRect.size.height/size.height, 1.0)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    scaleAnimation.fillMode = kCAFillModeBoth;
    scaleAnimation.removedOnCompletion = NO;
    
    //
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = self;
    animationGroup.duration = kAnimationDuration;
    animationGroup.fillMode = kCAFillModeBoth;
    animationGroup.removedOnCompletion = NO;
    [animationGroup setAnimations:[NSArray arrayWithObjects:positionAnimation, scaleAnimation, nil]];
    [_animationLayer addAnimation:animationGroup forKey:kShowAnimationKey];
    [animaionView.layer addAnimation:fadeInAnimation forKey:kFadeInAnimationKey];
}

- (void)doShowAnimationWithScale {
    
    self.alpha = .0;
    
    [UIView animateWithDuration:kAnimationDuration *2 animations:^{
        
        self.alpha = 1.f;
    } completion:^(BOOL finished) {

    }];
}

- (void)doHideAnimationWithAspectFit {
    
    self.userInteractionEnabled = NO;
    UIView *animaionView = [self viewForIndex:self.page];
    CGSize size = animaionView.frame.size;
    _animationLayer = [CALayer layer];
    _animationLayer.contents = (id)[[Util shotImageFrameView:animaionView shotSize:size] CGImage];
    _animationLayer.frame = animaionView.bounds;
    _animationLayer.anchorPoint = CGPointMake(0, 0);
    [animaionView.layer addSublayer:_animationLayer];
    [self viewForIndex:self.page].hidden = YES;
    
    // opacity
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.fillMode = kCAFillModeBoth;
    fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.f];
    fadeOutAnimation.toValue = [NSNumber numberWithFloat:.2f];
    fadeOutAnimation.duration = kAnimationDuration;
    fadeOutAnimation.delegate = self;
    fadeOutAnimation.beginTime = kAnimationDuration+.2f;
    fadeOutAnimation.removedOnCompletion = NO;
    
    
    // poition
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fillMode = kCAFillModeBoth;
    positionAnimation.toValue = [NSValue valueWithCGPoint:self.fromRect.origin];
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    
    //scale
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale((float)self.fromRect.size.width/size.width,
                                                                                    (float)self.fromRect.size.height/size.height, .2f)];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    scaleAnimation.fillMode = kCAFillModeBoth;
    scaleAnimation.removedOnCompletion = NO;
    
    //
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = self;
    animationGroup.duration = kAnimationDuration;
    animationGroup.fillMode = kCAFillModeBoth;
    animationGroup.removedOnCompletion = NO;
    [animationGroup setAnimations:[NSArray arrayWithObjects:scaleAnimation, positionAnimation, nil]];
    [_animationLayer addAnimation:animationGroup forKey:kHideAnimationKey];
    [animaionView.layer addAnimation:fadeOutAnimation forKey:kFadeOutAnimationKey];
}

- (void)doHideAnimationWithScale {
    
    self.alpha = 1.f;
    
    [UIView animateWithDuration:kAnimationDuration * 2 animations:^{
        
        self.alpha = 0.;
        
    } completion:^(BOOL finished) {
        
        NSArray *subViews = self.scrollView.visibleViews;
        
        for (UIView *subview in subViews) {
            
            if ([subview isKindOfClass:[CQTTouchImageView class]] &&
                [subview respondsToSelector:@selector(disableBlocks)]) {
                
                [subview performSelector:@selector(disableBlocks)];
            }
        }
        
        _willEnd = NO;
        
        CQTRemoveFromSuperViewSafely(self);
        
        [[UIApplication sharedApplication] setStatusBarHidden:!self.needShowStatusBarWhenHide];
    }];
}


- (CQTZoomScrollView*)zoomScrollViewForScrollViewAtPage:(NSInteger)pg {
    
    //
    CQTZoomScrollView *zoomScrollView = [[CQTZoomScrollView alloc] initWithFrame:CGRectMake(pg*CGRectGetWidth(self.scrollView.frame), 0,
                                                                                            CGRectGetWidth(self.scrollView.frame), CGRectGetHeight (self.scrollView.frame))];
    zoomScrollView.tapDelegate = self;
    zoomScrollView.tag = kTagBase + pg;
    
    //
    //  CGRect rect = (self.needShowAnimation && pg == self.page)?self.fromRect:zoomScrollView.bounds;
    CGRect rect = zoomScrollView.bounds;
    LXImageView *imageView = [[LXImageView alloc] initWithFrame:rect];
    imageView.layer.borderWidth = 0.;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = NO;
    imageView.enableLoadingIndicator = YES;
    imageView.clipsToBounds = YES;
    zoomScrollView.clipsToBounds = YES;
    zoomScrollView.contentView = imageView;
    
    CQT_RELEASE(imageView);
    
    return CQT_AUTORELEASE(zoomScrollView);
}

- (CQTZoomScrollView*)view4Index:(NSInteger)index {
    
    CQTZoomScrollView *zoomScrollView = (CQTZoomScrollView*)[self.scrollView viewWithTag:kTagBase + index];
    return zoomScrollView;
}

- (LXImageView*)imageView4Page:(NSInteger)index {
    
    LXImageView *imv = (LXImageView*)[(CQTZoomScrollView*)[self viewForIndex:index] contentView];
    
    return imv;
}

- (LXImageView*)imageView4CurrentPage {
    
    return [self imageView4Page:self.page];
}

- (void)handleSaveTapped:(id)sender {
    
    self.saveBtn.enabled = NO;
    
    [CQTAlertView showTipsWithTitle:@"正在保存"];
    
    UIImageView *view = (UIImageView *)[self imageView4CurrentPage];
    
    UIImage *img = view.image;
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}



- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    
    NSString *msg = (error == NULL)?@"保存成功":@"保存失败";
    
    if (!image) {
        
        msg = @"保存失败";
    }
    
    [CQTAlertView showTipsWithTitle:msg];
    
    self.saveBtn.enabled = YES;
}

- (void)handleCheckedBtnClicked:(UIButton *)btn {

    btn.selected = !btn.selected;
    
    UIView *view = btn.superview;
    
    int index = view.tag - kTagBase;
    
    if (self.cycleScroll) {
        
        index -= 1;
    }
    
    [_selectedSet setObject:@(btn.selected) forKey:@(index)];
}

#pragma mark -
#pragma mark CQTZoomScrollViewDelegate
- (void)zoomScrollView:(CQTZoomScrollView*)zoomScrollView gotSingleTapAtPoint:(CGPoint)tapPoint  {
    
    if (!_willEnd) {
        
        _willEnd = YES;
        
        if (selectedResultBlock) {
            
            selectedResultBlock(_selectedSet);
        }
        
        [self hide];
    }
}
- (void)zoomScrollView:(CQTZoomScrollView*)zoomScrollView gotDoubleTapAtPoint:(CGPoint)tapPoint  {
    
    //double tap zooms in
    if (self.needShowChecked) {
        
        return;
    }
    
    if (!_willEnd) {
        
        CGRect r = CGRectZero;
        if(zoomScrollView.contentView != nil) {
            
            r.size.height = zoomScrollView.contentView.frame.size.height * 0.5;
            r.size.width  = zoomScrollView.contentView.frame.size.width  * 0.5;
            r.origin.x = tapPoint.x - (r.size.width  / 2.0);
            r.origin.y = tapPoint.y - (r.size.height / 2.0);
        }
        
        [zoomScrollView zoomToRect:r animated:YES];
    }
}

- (void)zoomScrollView:(CQTZoomScrollView*)zoomScrollView gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    
    if (self.needShowChecked) {
        
        return;
    }
    
    if (!_willEnd) {
        
        CGRect r = CGRectZero;
        if(zoomScrollView.contentView != nil) {
            
            r.size.height = zoomScrollView.contentView.frame.size.height;
            r.size.width  = zoomScrollView.contentView.frame.size.width;
            r.origin.x = tapPoint.x - (r.size.width  / 2.0);
            r.origin.y = tapPoint.y - (r.size.height / 2.0);
        }
        [zoomScrollView zoomToRect:r animated:YES];
    }
}



@end

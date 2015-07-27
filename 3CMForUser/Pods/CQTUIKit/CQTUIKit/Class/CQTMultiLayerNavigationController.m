//
//  CQTMultiLayerNavigationController.m
//  CQTMultiLayerNavigationController
//
//  Created by ANine on 5/24/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define TOP_VIEW  [[UIApplication sharedApplication]keyWindow].rootViewController.view


#import "CQTMultiLayerNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import "UIImage+Extensions.h"
#import "CQTViewConstants.h"

//extern "C" CGImageRef UIGetScreenImage();

@interface CQTMultiLayerNavigationController ()
{
    CGPoint _startTouch;
    
    UIImageView *_lastScreenShotView;
    
    UIView *_blackMask;
    
    int _numberOfTouches;
    
    NSString *_currentVCName;
    
    UIImageView *_shadowView;
}

@property (nonatomic,retain) UIView *backgroundView;



@property (nonatomic,assign) BOOL isMoving;

@end

@implementation CQTMultiLayerNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.screenShotsList = CQT_AUTORELEASE([[NSMutableArray alloc]initWithCapacity:2]);
        self.canDragBack = YES;
    }
    return self;
}

- (void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (useSystemPopGesture) {
        
        __weak CQTMultiLayerNavigationController *weakSelf = self;
        
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
            
        {
            
            self.interactivePopGestureRecognizer.delegate = weakSelf;
            
            self.delegate = weakSelf;
        }
    }else {
        
        _recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                             action:@selector(paningGestureReceive:)];
        CQT_AUTORELEASE(_recognizer);
        
        _recognizer.delegate = self;
        [_recognizer delaysTouchesBegan];
        [self.view addGestureRecognizer:_recognizer];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:(BOOL)animated];
    
    if (self.screenShotsList.count == 0 && self.canDragBack) {
        
        UIImage *capturedImage = [UIImage capture];
        
        if (capturedImage) {
            
            [self.screenShotsList addObject:capturedImage];
        }
    }
    
    _shadowView.frame = CGRectMake(-10, 0, 10, TOP_VIEW.frame.size.height);
    
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (!useSystemPopGesture) {
        
        UIImage *capturedImage;
        
        if (self.canDragBack) {
            
            capturedImage = [UIImage capture];
        }
        
        if (capturedImage) {
            
            [self.screenShotsList addObject:capturedImage];
        }
        
        _currentVCName = getClassName(viewController);
    }else {
        
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
            
            self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    if (!useSystemPopGesture) {
        
        [self.screenShotsList removeLastObject];
    }
    
    return [super popViewControllerAnimated:animated];
}


- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        
        self.interactivePopGestureRecognizer.enabled = NO;
    
    return [super popToViewController:viewController animated:animated];
    
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    
    if (!useSystemPopGesture) {
        
        [self.screenShotsList removeAllObjects];
    }
    
    NSArray *viewControllers = [super popToRootViewControllerAnimated:animated];
    
    if (useSystemPopGesture && validAry(viewControllers)) {
        
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated==YES) {
            
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    
    return viewControllers;
}
#pragma mark - Utility Methods


- (UIImage *)glToUIImage {
    
    int width = TOP_VIEW.bounds.size.width;
    int height = TOP_VIEW.bounds.size.height;
    
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *) self.view.layer;
    
    eaglLayer.drawableProperties = @{ kEAGLDrawablePropertyRetainedBacking: [NSNumber numberWithBool:YES], kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8 };
    
    NSInteger myDataLength = width * height * 4;
    
    GLubyte *buffer = (GLubyte *)malloc(myDataLength);
    
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    
    GLubyte *buffer2 = (GLubyte *)malloc(myDataLength);
    
    for (int y = 0; y < height; y ++) {
        
        for (int x = 0; x < width * 4; x ++) {
            
            buffer2[(height - 1 - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    
    //make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    
    //prep the ingredients.
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    
    CGColorRenderingIntent rederingIntent = kCGRenderingIntentDefault;
    
    //make the CGImage
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, rederingIntent);
    
    //then take the UIImage From that
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    //    UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
    
    return image;
}



// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x {
    
    x = x > SCREEN_WIDTH ? SCREEN_WIDTH : x;
    
    x = x < 0 ? 0 : x ;
    
    CGRect frame = TOP_VIEW.frame;
    frame.origin.x = x;
    TOP_VIEW.frame = frame;
    
    float scale = (x/6400)+0.95;
    
    float alpha = 0.4 - (x/800);
    
    _lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    _blackMask.alpha = alpha;
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (self.viewControllers.count <= 1 || !self.canDragBack) return NO;
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    BOOL shouldBegin = YES;
    
    if (useSystemPopGesture) {
        
        if (gestureRecognizer==self.interactivePopGestureRecognizer) {
            
            if (self.viewControllers.count<2||self.visibleViewController==[self.viewControllers objectAtIndex:0]) {
                
                shouldBegin =  NO;
                
            }
        }
    }else {
        
        shouldBegin = self.canDragBack;
    }
    return shouldBegin;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer {
    
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        _startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = TOP_VIEW.frame;
            
            self.backgroundView = CQT_AUTORELEASE([[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)]);
            [TOP_VIEW.superview insertSubview:self.backgroundView belowSubview:TOP_VIEW];
            
            _blackMask = CQT_AUTORELEASE([[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)]);
            _blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:_blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (_lastScreenShotView) [_lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = nil;
        
        _numberOfTouches = recoginzer.numberOfTouches;
        
        if (_numberOfTouches == 1) {
            
            lastScreenShot = [self.screenShotsList lastObject];
        }else {
            
            lastScreenShot = [self.screenShotsList firstObject];
        }
        
        _lastScreenShotView = CQT_AUTORELEASE([[UIImageView alloc]initWithImage:lastScreenShot]);
        _lastScreenShotView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.backgroundView insertSubview:_lastScreenShotView belowSubview:_blackMask];
        
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - _startTouch.x > 60)
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                [self moveViewWithX:320];
                
            } completion:^(BOOL finished) {
                
                if (_numberOfTouches == 1) {
                    
                    POST_NOTIFICATION(kNotificationPopViewController);
                }else {
                    
                    POST_NOTIFICATION(kNotificationPopToRootViewController);
                }
                
                CGRect frame = TOP_VIEW.frame;
                frame.origin.x = 0;
                TOP_VIEW.frame = frame;
                
                _isMoving = NO;
                
                self.backgroundView.hidden = YES;
                
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                [self moveViewWithX:0];
                
            } completion:^(BOOL finished) {
                
                _isMoving = NO;
                
                self.backgroundView.hidden = YES;
                
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self moveViewWithX:0];
            
        } completion:^(BOOL finished) {
            
            _isMoving = NO;
            
            self.backgroundView.hidden = YES;
            
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        
        [self moveViewWithX:touchPoint.x - _startTouch.x];
    }
}


#pragma mark-UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count == 1) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showBottomBar" object:nil];
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}


@end

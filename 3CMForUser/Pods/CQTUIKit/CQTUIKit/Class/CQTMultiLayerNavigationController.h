//
//  CQTMultiLayerNavigationController.h
//  CQTMultiLayerNavigationController
//
//  Created by ANine on 5/24/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//thanks to @Feather Chan.


/**
 @brief implementation rightPanGesture singleFinger to PreViewController,
                       rightPanGesture twoFingle    to RootViewController,
 
 @discussion conflict With webView Gesture.
 */

#define kNotificationPushViewController        @"kNotificationPushViewController"

#define kNotificationPopViewController         @"kNotificationPopViewController"

#define kNotificationPopToRootViewController   @"kNotificationPopToRootViewController"

#define useSystemPopGesture 1

@interface CQTMultiLayerNavigationController : UINavigationController <UIGestureRecognizerDelegate>

// Enable the drag to back interaction, Defalt is YES.
@property (nonatomic,assign) BOOL canDragBack;

@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,retain)UIPanGestureRecognizer *recognizer;

@end

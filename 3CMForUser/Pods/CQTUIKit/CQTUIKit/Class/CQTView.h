//
//  CQTView.h
//  CQTIda
//
//  Created by ANine on 4/15/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CQTRoundRectButton.h"

#define allocStandardImageView(__View) \
if (!__View) {\
    \
    __View = [[CQTImgView alloc] init];\
}else {\
    \
    CQTRemoveFromSuperViewSafely(__View);\
}

#define allocStandardLabel(__View) \
\
if (!__View) {\
    \
    __View = [[CQTLabel alloc] init];\
}else {\
    \
    CQTRemoveFromSuperViewSafely(__View);\
}


#define createStandardCQTBtn(__View) \
if (!__View) {\
    \
    __View = [CQTCustomButton buttonWithType:UIButtonTypeCustom];\
}else {\
    \
    CQTRemoveFromSuperViewSafely(__View);\
}


@interface CQTView : UIView

/*
 
 @brief
 实现两次view动画,呈现前后关系.后视图被缩小,前视图呈现的动画.
 @param:
 view:后视图.
 targetView:前景视图.
 scale:后视图缩放比例.
 rect:前景视图展示的尺寸.
 dTop:后视图距离顶部的距离.
 
 */
+ (void)multiLayerVerticalFromView:(UIView *)view targetView:(UIView *)targetView scale:(float)scale rect:(CGRect)rect distanceTop:(float)dTop;

@end

@interface CQTImgView : UIImageView

@end

@interface CQTLabel : UILabel

/* 获取制定长度的空格符 */
- (NSString *)getPlaceholderWidth:(CGFloat)width;

/* 估算宽度,首先需要指定高度 */
@property (nonatomic,assign)CGFloat estimateWidth;

/* 估算高度,首先需要指定宽度 */
@property (nonatomic,assign)CGFloat estimateHeight;

/* 指定的宽度 */
@property (nonatomic,assign)CGFloat specifyWidth;

/* 指定的高度 */
@property (nonatomic,assign)CGFloat specifyHeight;

/* 估算label的尺寸,Note:需要首先指定label的宽度. */
- (CGSize)estimateSizeForHeight ;

/* 估算label的尺寸,Note:需要首先指定label的高度. */
- (CGSize)estimateSizeForWidth;
@end


@interface CQTScrollView : UIScrollView

@end




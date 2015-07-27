//
//  CQTFullScreenBillBoardView.h
//  CQTIda
//
//  Created by ANine on 10/10/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTBillBoardView.h"

#define kFullScreenBillBoardViewWillShow @"kFullScreenBillBoardViewWillShow"
#define kFullScreenBillBoardViewWillHide @"kFullScreenBillBoardViewWillHide"

/**
 @brief 全屏看大图.
 
 @discussion <#some notes or alert with this class#>
 */
#import "CQTZoomScrollView.h"

@interface CQTFullScreenBillBoardView : CQTBillBoardView <UIScrollViewDelegate, CQTZoomScrollViewDelegate> {
    
    CALayer *_animationLayer;
    
    BOOL _willEnd;
    
    void (^selectedResultBlock)(NSMutableDictionary *);
}

/* 显示当前页数 */
@property (nonatomic, retain) UILabel *pageLabel;

/* 保存图片到相册 */
@property (nonatomic, retain) UIButton *saveBtn;

/* 是否需要动画 */
@property (nonatomic, assign) BOOL needShowAnimation;

/* 需要动画时,该图片相对于window的原始坐标. */
@property (nonatomic, assign) CGRect fromRect;

/* 当全屏大图隐藏时,是否需要显示tabBar.default= YES */
@property (nonatomic, assign) BOOL needShowStatusBarWhenHide;

/* 不同的contentModel可能对应不同的效果, */
@property (nonatomic, assign) UIViewContentMode originViewContentModel;

/* 是否显示照片已经被选中,default = NO */
@property (nonatomic,assign)BOOL needShowChecked;

/* 是否显示保存图片到相册功能, default = YES */
@property (nonatomic,assign)BOOL needSHowStorage;

/* 记录选中状态 */
@property (nonatomic,retain,readonly)NSMutableDictionary * selectedSet;

/* 默认显示第几张 */
@property (nonatomic,assign)int currentIndex;

/* 显示全屏大图 */
- (void)show;

/* 隐藏全屏大图 */
- (void)hide;

- (void)addSelectedPhotoResultBlock:(void(^)(NSMutableDictionary *dic))block;

@end

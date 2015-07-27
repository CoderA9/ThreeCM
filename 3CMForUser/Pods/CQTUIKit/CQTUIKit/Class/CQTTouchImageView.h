//
//  CQTTouchImageView.h
//  CQTIda
//
//  Created by ANine on 7/16/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "LXImageView.h"


@class CQTFullScreenBillBoardView;

@class CQTCustomButton;

/**
 @brief 支持点击和长按的按钮.
 
 @discussion <#some problem description with this class#>
 */

/* 供外部使用TouchImageView时使用. */
@class CQTTouchImageView;
@protocol CQTTouchImageViewDelegate;

typedef void (^ TouchActionBlock )(CQTTouchImageView *view);

@interface CQTTouchImageView : LXImageView  {
    
    CQTFullScreenBillBoardView *_fsGalleryView;
}

@property (nonatomic,strong)CQTCustomButton *shadowView;

@property (nonatomic,assign)id<CQTTouchImageViewDelegate> delegate;

/* 是否可点击查看大图.默认为NO. */
@property (nonatomic, assign)BOOL canViewEnlarge;

- (void)addTapAction:(void (^)(void))block;

- (void)addLongPressAction:(void (^)(void))block;
@end


@protocol CQTTouchImageViewDelegate <NSObject>

- (void)imageViewDidTap:(CQTTouchImageView *)touchView;

- (void)imageViewDidLongPress:(CQTTouchImageView *)touchView;

@end
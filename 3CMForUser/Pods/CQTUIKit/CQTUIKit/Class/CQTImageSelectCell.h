//
//  CQTImageSelectCell.h
//  CQTIda
//
//  Created by ANine on 12/18/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CQTTouchImageView.h"
#import "CQTFullScreenBillBoardView.h"
/**
 @brief 图片选择基础Cell
 
 @discussion <#some notes or alert with this class#>
 */
@interface CQTImageSelectCell : UITableViewCell {
    
    void (^_tapBlock)(ALAsset *asset,CQTTouchImageView *view);
    
    CQTFullScreenBillBoardView *_fsGalleryView;
}

/* 一共可以选择多少张图片,default = 1 */
@property (nonatomic,assign)NSInteger imageCount;

/* 每一行显示的图片的高度,default = 60,图片大小50*50 */
@property (nonatomic,assign)CGFloat heightForPerLine;

/* 每一行显示的图片数量,defalt = 4 */
@property (nonatomic,assign)NSInteger imageCountPerLine;

/* 默认图片. */
@property (nonatomic,retain)UIImage *placeHoldImage;

/* 相册图片的按钮图片.默认close_btn.png */
@property (nonatomic,retain)UIImage *closeBtnImage;

/* 相册图片的按钮高亮图片.默认close_btn_red.png */
@property (nonatomic,retain)UIImage *closeBtnHightLightImage;

/* 用于选择图片的按钮 */
@property (nonatomic,retain)UIButton *selectePhotoBtn;

/* 目前加载的图片 */
@property (nonatomic,retain,readonly)NSMutableArray *assets;

/* 是否可以查看高清图，Default = YES */
@property (nonatomic,assign)BOOL canViewEnlarge;



- (void)loadImages:(NSArray *)images;

/* 注册一个响应事件 */
- (void)addTapAction:(void (^)(ALAsset *asset,CQTTouchImageView *view))block;
@end

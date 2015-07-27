//
//  CQTCustomButton.h
//  CQTIda
//
//  Created by ANine on 4/11/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CQTLabel;
/**
 @brief 高度定制的button.
 
 @discussion <#some problem description with this class#>
 */

/* 供外部使用. */
@class CQTCustomButton;

typedef void (^ CustomButtonTapBlock)(CQTCustomButton *sender);


@interface CQTCustomButton : UIButton

@property (nonatomic,strong)UIImageView *imgView;

@property (nonatomic,strong)UIImage *imgViewSelectedImg;

@property (nonatomic,strong)UIImage *imgViewNormalImg;

@property (nonatomic,strong)CQTLabel *label;

@property (nonatomic,retain)UIColor *textSelectedColor;

@property (nonatomic,retain)UIColor *textNormalColor;

@property (nonatomic,retain)NSString *textNormal;

@property (nonatomic,retain)NSString *textSelected;

@property (nonatomic,assign)BOOL labelRefresh;

@property (nonatomic,assign)BOOL imgRefresh;

@property (nonatomic,strong)UIColor *bgHighLightColor;

@property (nonatomic,strong)UIColor *normalColor;

@property (nonatomic,strong)id info;

@property (nonatomic,strong)CQTLabel *badgeLabel;

@property (nonatomic,assign)NSInteger badgeNum;

@property (nonatomic,assign)CGPoint badgeOffset;//默认在按钮右上角,通过设置badgeOffset来控制位置.

@property (nonatomic,assign)CGPoint labelOffset;//文本的偏移.

@property (nonatomic,assign)CGPoint imgViewOffset;//图片的偏移.

- (void)setLabelTextColor:(UIColor *)color forState:(UIControlState)state;

- (void)setImgViewImage:(UIImage *)image forState:(UIControlState)state;



@end

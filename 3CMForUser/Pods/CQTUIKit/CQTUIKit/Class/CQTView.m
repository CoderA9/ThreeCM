//
//  CQTView.m
//  CQTIda
//
//  Created by ANine on 4/15/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTView.h"
#import "UIView+custom.h"


@implementation CQTView

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateSingleLine];
}


#pragma mark - | ***** Transform View ***** |


/*
 
 structCATransform3D
 {
 CGFloat m11（x缩放）, m12（y切变）, m13（旋转）, m14（）;
 CGFloat m21（x切变）, m22（y缩放）, m23（）, m24（）;
 CGFloat m31（旋转）, m32（）, m33（）, m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;
 CGFloat m41（x平移）, m42（y平移）, m43（z平移）, m44（）;
 };
 
 */
+ (void)multiLayerVerticalFromView:(UIView *)view targetView:(UIView *)targetView scale:(float)scale rect:(CGRect)rect distanceTop:(float)dTop {
    
    static CGFloat viewOriginHeight = 0.;
    if (scale < 1) {
        
        viewOriginHeight = view.frame.size.height;
    }
    
    CGFloat timerInter = 0.4;
    CGFloat arcs = 20;//X轴旋转弧度.
    CGFloat tanarcs = tan(arcs * (M_PI/180));
    CGFloat zOffSet =  - viewOriginHeight * tanarcs;
    CGFloat yOffSet = dTop - viewOriginHeight * (1 - scale) / 2;
    
    [UIView animateWithDuration:timerInter animations:^{
        
        [UIView animateWithDuration:timerInter/2 animations:^{
            
            if (scale < 1) {
                
                view.layer.transform = [CQTView transformWithArc:-arcs scale:scale yOffset:yOffSet zOffset:zOffSet];
                
            }else if(scale == 1) {
                
                view.layer.transform = [CQTView transformWithArc:-arcs scale:scale yOffset:yOffSet zOffset:-zOffSet];
            }
            
        }completion:^(BOOL finished) {
            
            if (scale < 1) {
                
                [UIView animateWithDuration:timerInter/2 animations:^{
                    
                    view.layer.transform = [CQTView transformWithArc:0 scale:scale yOffset:yOffSet zOffset:zOffSet];
                }];
            }else if (scale == 1) {
                
                [UIView animateWithDuration:timerInter/2 animations:^{
                    
                    view.layer.transform = [CQTView transformWithArc:0 scale:scale yOffset:0 zOffset:0];
                }];
            }
        }];
        
        view.alpha = scale;
        
        targetView.frame = rect;
    }];
}

+ (CATransform3D)transformWithArc:(CGFloat)arcs scale:(CGFloat)scale yOffset:(CGFloat)yOffSet zOffset:(CGFloat)zOffSet {
    
    CATransform3D rotateTrans = CATransform3DIdentity;
    rotateTrans.m34 = 0.0005;
    rotateTrans = CATransform3DRotate(rotateTrans,arcs *(M_PI/180), 1, 0, 0);
    
    CATransform3D transform1 = CATransform3DMakeTranslation(0, yOffSet, zOffSet);
    
    CATransform3D moveTrans = CATransform3DMakeScale(scale, scale, 1);
    
    CATransform3D transformR = CATransform3DConcat(rotateTrans, moveTrans);
    
    transformR = CATransform3DConcat(transformR, transform1);
    
    return transformR;
}

CATransform3D transform3DMakePerspective(CGFloat disZ, CGPoint point){
    CATransform3D transToCenter = CATransform3DMakeTranslation(point.x, point.y, 0);
    CATransform3D identity = CATransform3DIdentity;
    identity.m34 = -1/disZ;
    return CATransform3DConcat(transToCenter, identity) ;
}
/**
 *  3D转换透视图，有远小近大的效果,(如果要让视图按照某条边旋转，就要设置锚点。计算公式：postion.x = position.x + (layer.width * (0.5-锚点.x)),y坐标也如此)
 *
 *  @param viewOffset 视图的偏移，主要是为了视图能够偏移相应的位置，从而使偏移角度正常化
 *  @param disZ       m34的距离，这个值就是具有透视效果，值越大越不明显，反之越明显
 *  @param transform  自定义的3D转换
 *
 *  @return 返回的3D转换
 */
+(CATransform3D) transform3DPerspective:(CGPoint)viewOffset disZ:(CGFloat)disZ transform:(CATransform3D)transform{
    return CATransform3DConcat(transform, transform3DMakePerspective(disZ, viewOffset));
}

- (void)dealloc {
    
    CQT_SUPER_DEALLOC();
}
@end

@implementation CQTImgView

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initial];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initial];
    }
    return self;
}

- (id)init {
    
    if (self = [super init]) {
        
        [self initial];
    }
    return self;
}


- (void)initial {
    
    setClearColor(self);
    
    /* 默认打开自适应宽度 */
    self.userInteractionEnabled = YES;
    
    self.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateSingleLine];
}

@end

@implementation CQTLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initial];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initial];
    }
    return self;
}


- (id)init {
    
    if (self = [super init]) {
        
        [self initial];
    }
    return self;
}


- (void)initial {
    
    setClearColor(self);
    
    /* 默认打开自适应宽度 */
    self.adjustsFontSizeToFitWidth = YES;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateSingleLine];
}


- (NSString *)getPlaceholderWidth:(CGFloat)width {
    
    NSString *resultStr = @" ";
    
    CGSize size = [resultStr sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, ViewHeight(self)) lineBreakMode:NSLineBreakByWordWrapping];
    
    int holderCnt = (width / size.width );
    
    for (int  index = 0; index < holderCnt; index ++) {
        
        resultStr = [resultStr stringByAppendingString:@" "];
    }
    return resultStr;
}


#pragma mark - | ***** public methods ***** |
- (CGFloat)estimateHeight {
    
    return  [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(ViewWidth(self), MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
}

- (CGFloat)estimateWidth {
    
    return  [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, ViewHeight(self)) lineBreakMode:NSLineBreakByCharWrapping].width;
}

@end

@implementation CQTScrollView
- (void)dealloc {
    
    CQT_SUPER_DEALLOC();
}
@end



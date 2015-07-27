//
//  CQTCustomButton.m
//  CQTIda
//
//  Created by ANine on 4/11/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTCustomButton.h"

#import "UIView+custom.h"
#import "UILabel+ANineExtension.h"
#import "CQTGlobalConstants.h"
#import "VCDef.h"
#import "CQTViewConstants.h"
#import "CQTView.h"

@implementation CQTCustomButton

@synthesize imgView = _imgView,label = _label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.showsTouchWhenHighlighted = NO;
        
        self.labelRefresh = YES;
        
        self.imgRefresh = YES;
        
        self.bgHighLightColor = kClearColor;
        
        self.backgroundColor = kClearColor;
        
        self.labelOffset = CGPointMake(0, 0);
        self.imgViewOffset = CGPointMake(0, 0);
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    [super setBackgroundColor:backgroundColor];
    
    _normalColor = backgroundColor;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    [super setTitle:title forState:state];
    
    if( state == UIControlStateNormal ) {
        
        self.textNormal = title;
        
        self.label.text = title;
    }else if ( state == UIControlStateSelected ) {
    
        self.textSelected = title;
    }
    
}



- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        return;
    }
    
    if (self.imgRefresh) {
        
        self.imgView.frame = CGRectMake(self.imgViewOffset.x, self.imgViewOffset.y, CGRectGetWidth(self.frame) - self.imgViewOffset.x, CGRectGetHeight(self.frame) - self.imgViewOffset.y);
        self.imgView.userInteractionEnabled = NO;
    }
    
    
    if (self.labelRefresh) {
        
        self.label.frame = CGRectMake(self.labelOffset.x, self.labelOffset.y, CGRectGetWidth(self.frame) - self.labelOffset.x, CGRectGetHeight(self.frame) - self.labelOffset.y);
        self.label.userInteractionEnabled = NO;
    }
    
    [self bringSubviewToFront:self.label];
    
    self.highlighted = NO;
    
    if (_badgeLabel) {
        
        [self updateBadgeLabel];
    }

}

- (void)updateBadgeLabel {
    
    if (CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
        return;
    }
    
    
    @synchronized(self) {

        CGRect foo = _badgeLabel.frame;
        
        _badgeLabel.hidden = _badgeNum > 0 ? NO : YES;
        
        if (_badgeLabel.hidden) {
            
            return;
        }
        
        CGFloat height = foo.size.height;
        if (height <= 0) {
            
            height = 16 <= ViewHeight(self) ? 16 : ViewHeight(self);
        }
        
        if (CGRectEqualToRect(foo,CGRectZero)) {
            
            foo = ViewRect(ViewWidth(self) - height,- height/2, height, height);
            _badgeLabel.frame = foo;
        }
        
        self.clipsToBounds = NO ;
        
        CGFloat estimateWidth = _badgeLabel.estimateWidth;
        estimateWidth += 6.;
        if (estimateWidth < ViewHeight(_badgeLabel)) {
            
            estimateWidth = ViewHeight(_badgeLabel);
        }
        
        foo.size.width = estimateWidth;
        
        foo.origin.x = ViewWidth(self) - estimateWidth/2 + _badgeOffset.x;
        foo.origin.y = 0 - ViewHeight(_badgeLabel)/2 + _badgeOffset.y;
        _badgeLabel.frame = foo;
        
        [_badgeLabel setLayerCornerRadius:ViewHeight(_badgeLabel)/2];
    }
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    [self updateSingleLine];
}

- (void)dealloc {
    
    A9_ViewReleaseSafely(_label);
    A9_ViewReleaseSafely(_imgView);
    A9_ViewReleaseSafely(_badgeLabel);
    A9_ObjectReleaseSafely(_imgViewSelectedImg);
    A9_ObjectReleaseSafely(_imgViewNormalImg);
    self.textSelectedColor = nil;
    self.textNormalColor = nil;
    
    CQT_SUPER_DEALLOC();
    
}


- (void)setLabelTextColor:(UIColor *)color forState:(UIControlState)state {
    
    switch (state) {
        case UIControlStateNormal: {
            
            self.label.textColor = color;
            
            self.textNormalColor = color;
            
            if (!self.textSelectedColor) {
                
                self.textSelectedColor = color;
            }
        }
            break;
        case UIControlStateHighlighted: {
            
            self.textSelectedColor = color;
            
            if (!self.textNormalColor) {
                
                self.textNormalColor = color;
            }
        }
            break;
        default:
            break;
    }
    [self setHighlighted:NO];
}

- (void)setImgViewImage:(UIImage *)image forState:(UIControlState)state {
    
    switch (state) {
        case UIControlStateNormal: {
         
            self.imgView.image = image;
            
            self.imgViewNormalImg = image;
            
            if (!self.imgViewSelectedImg) {
                
                self.imgViewSelectedImg = image;
            }
        }
            break;
        case UIControlStateHighlighted: {
            
            self.imgViewSelectedImg = image;
            
            if (!self.imgViewNormalImg) {
                
                self.imgViewNormalImg = image;
            }
        }
            break;
        default:
            break;
    }
    [self setHighlighted:NO];
}

- (void)setImgView:(UIImageView *)imgView {
    
    [self initialImgView];
}

- (void)setLabel:(CQTLabel *)label {
    
    [self initialLabel];
}

- (void)setBadgeLabel:(CQTLabel *)badgeLabel {
    
    [self initialBadgeLabel];
}

- (void)setBadgeNum:(NSInteger)badgeNum {
    
    _badgeNum = badgeNum;
    [self initialBadgeLabel];
    _badgeLabel.text = [NSObject messageStringWithCount:(int)badgeNum];
    [self updateBadgeLabel];
}

- (void)setBadgeOffset:(CGPoint)badgeOffset {
    
    _badgeOffset = badgeOffset;
    [self updateBadgeLabel];
}

- (UIImageView *)imgView {
    
    return [self initialImgView];
}

- (CQTLabel *)label {
    
    return [self initialLabel];
}

- (void)setTextNormalColor:(UIColor *)textNormalColor {
    
    if (!_textNormalColor) {
        
        _textNormalColor = [[UIColor alloc] initWithWhite:1 alpha:1];
    }
    
    if (_textNormalColor != textNormalColor) {
        
        CQT_RELEASE(_textNormalColor);
        self.label.textColor = self.textNormalColor;
        
        _textNormalColor = CQT_RETAIN(textNormalColor);

    }
}

- (void)setTextSelectedColor:(UIColor *)textSelectedColor {
    
    if (!_textSelectedColor) {
        
        _textSelectedColor = [[UIColor alloc] initWithWhite:1 alpha:1];
    }
    
    if (_textSelectedColor != textSelectedColor) {
        
        CQT_RELEASE(_textSelectedColor);
        _textSelectedColor = CQT_RETAIN(textSelectedColor);
    }
}

- (id)initialImgView {
    
    if (!_imgView) {
        
        _imgView = [[UIImageView alloc] init];
        _imgView.userInteractionEnabled = NO;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (id)initialLabel {
    
    if (!_label) {
     
        _label = [[CQTLabel alloc] init];
        _label.backgroundColor = kClearColor;
        _label.textAlignment = UITextAlignmentCenter;
        _label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_label];
    }
    return _label;
}

- (id)initialBadgeLabel {
    
    if (!_badgeLabel) {
        
        _badgeLabel = [[CQTLabel alloc] init];
        _badgeLabel.background_color(kRedColor).text_alignMent(NSTextAlignmentCenter).adjusts_fontSizeFitWidth(NO).text_font(AvenirBoldFont(12)).text_color([UIColor whiteColor]);
        [self addSubview:_badgeLabel];
    }
    
    return _badgeLabel;
}

- (void)setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        if (highlighted) {
            
            UIColor *color = [self.normalColor copy];
            
            self.backgroundColor = self.bgHighLightColor;
            
            self.normalColor = CQT_AUTORELEASE(color) ;
            
            if (self.textSelectedColor) {
                
                self.label.textColor = self.textSelectedColor;
            }
            
            if (self.imgViewSelectedImg) {
                
                self.imgView.image = self.imgViewSelectedImg;
            }
        }
        else {
            
            self.backgroundColor = self.normalColor;
            
            if (self.textNormalColor) {
                
                self.label.textColor = self.textNormalColor;
            }
            
            if (self.imgViewNormalImg) {
                
                self.imgView.image = self.imgViewNormalImg;
            }
            
            [self setSelected:self.selected animated:YES];
        }
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (selected) {
            
            if (self.imgViewSelectedImg) {
                
                self.imgView.image = self.imgViewSelectedImg;
            }
            
            if (self.textSelectedColor) {
                
                self.label.textColor = self.textSelectedColor;
            }
            
            if (self.textNormal && self.textNormal.length) {
                
                self.label.text = self.textNormal;
            }
        }else {
            
            if (self.imgViewNormalImg) {
                
                self.imgView.image = self.imgViewNormalImg;
            }
            
            if (self.textSelectedColor) {
                
                self.label.textColor = self.textNormalColor;
            }
            
            if (self.textSelected && self.textSelected.length) {
                
                self.label.text = self.textSelected;
            }
        }
    });
}

- (void)setNormalColor:(UIColor *)normalColor {
    
    if ([_normalColor isEqual:normalColor]) {
        
        _normalColor = normalColor;
    }
    
    self.backgroundColor = normalColor;
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    [self setSelected:selected animated:YES];
}

- (void)setImgViewNormalImg:(UIImage *)imgViewNormalImg {
    
    if (nil == _imgViewNormalImg) {
        
        _imgViewNormalImg = [[UIImage alloc] init];
    }
    
    if (_imgViewNormalImg != imgViewNormalImg) {
        
        self.imgView.image = imgViewNormalImg;
        
        CQT_RELEASE(_imgViewNormalImg);
        
        _imgViewNormalImg = CQT_RETAIN(imgViewNormalImg);
    }

}

- (void)setImgViewSelectedImg:(UIImage *)imgViewSelectedImg {
    
    if (!_imgViewSelectedImg) {
        
        _imgViewSelectedImg = [[UIImage alloc] init];
    }
    
    if (_imgViewSelectedImg != imgViewSelectedImg) {
        
        CQT_RELEASE(_imgViewSelectedImg);
        
        _imgViewSelectedImg = CQT_RETAIN(imgViewSelectedImg);
    }
}
@end

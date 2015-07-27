//
//  CQTBaseTableViewCell.m
//  CQTIda
//
//  Created by ANine on 1/13/15.
//  Copyright (c) 2015 www.cqtimes.com. All rights reserved.
//

#import "CQTBaseTableViewCell.h"
#import "UIView+custom.h"
#import "CQTCustomButton.h"
#import "UIButton+Extension.h"

/* 爱达生活管家 字体颜色 */
#define kTextColorHenvy HEX_RGB(0x303030)//标题字
#define kTextColorNormal HEX_RGB(0x434242)//正文字
#define kTextColorSoft  HEX_RGB(0xafa5a5)//小字,若现字
#define kTextColorEmphasize HEX_RGB(0xff4200)//强调字

@implementation CQTBaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
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

- (void)initial {
    
    self.backgroundColor = HEX_RGB(0xFFFFFF);
    self.contentView.backgroundColor = HEX_RGB(0xFFFFFF);
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.clipsToBounds = YES;
    self.contentView.clipsToBounds = YES;
}

- (void)dealloc {
    
    CQTDebugLog(@"%@ ********************Dealloc",NSStringFromClass([self class]));
    
    A9_ViewReleaseSafely(_contentBgView);
    
    A9_ViewReleaseSafely(_imgView);
    A9_ViewReleaseSafely(_titleLabel);
    A9_ViewReleaseSafely(_subTitleLabel);
    A9_ViewReleaseSafely(_descLabel);
    
    A9_ObjectReleaseSafely(_globalBlocksAry);
    
    CQT_SUPER_DEALLOC();
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self updateSingleLine];
    
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        
        return;
    }
    
    _bgBtn.frame = self.bounds;
    
    [self resetSubViewsGUI];
    
    [self updateSubviewsGUI];
}

- (void)updateSubviewsGUI {
    //subClass implementation this thods.
    
    [self addSingleLineWithTop:self.topLine buttom:self.bottomLine];
}

#pragma mark - | ***** create Views ***** |

- (void)createContentBgViewIfNeeded {
    
    if (!_contentBgView) {
        
        _contentBgView = [[CQTView alloc] init];
        _contentBgView.backgroundColor = [UIColor whiteColor];
        _contentBgView.layer.cornerRadius = 4.;
        _contentBgView.clipsToBounds = YES;
        self.normalColor = HEX_RGB(0xFFFFFF);
        self.hightlightColor = HEX_RGB(0xCCCCCC);
    }else  {
        
        CQTRemoveFromSuperViewSafely(_contentBgView);
    }
}

- (void)createTitleLabelIfNeeded {
    
    if (!self.titleLabel) {
        
        self.titleLabel = [[CQTLabel alloc] init];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.titleLabel.font = kBigFont;
        self.titleLabel.textColor = HEX_RGB(0x303030);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }else {
        
        CQTRemoveFromSuperViewSafely(self.titleLabel);
    }
}

- (void)createImgViewIfNeeded {
    
    if (!_imgView) {
        
        _imgView = [[CQTTouchImageView alloc] init];
        [_imgView setLayerWidth:.3f color:kSingleLineColorDefault cornerRadius:4.];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        //        _imgView.layer.borderWidth = .3;
        //        _imgView.layer.cornerRadius = 4.;
        //        _imgView.layer.borderColor = kBgMainColor.CGColor;
        
    }else {
        
        CQTRemoveFromSuperViewSafely(_imgView);
    }
}

/* 创建一个描述Label */
- (void)createDescInfoIfNeeded {
    
    if (!_descLabel) {
        
        _descLabel = [[CQTLabel alloc] init];
        self.descLabel.font = kMidFont;
        self.descLabel.textColor = kTextColorNormal;
        self.descLabel.numberOfLines = 0;
    }else {
        
        CQTRemoveFromSuperViewSafely(_descLabel);
    }
}

/* 创建一个副标题 */
- (void)createSubtitleIfNeeded {
    
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[CQTLabel alloc] init];
        self.subTitleLabel.font = kMidFont;
        self.subTitleLabel.textColor = kTextColorNormal;
        self.subTitleLabel.numberOfLines = 0;
    }else {
        
        CQTRemoveFromSuperViewSafely(_subTitleLabel);
    }
}

/* 创建一个副标题 */
- (void)createSubtitle2IfNeeded {
    
    if (!_subTitleLabel_2) {
        
        _subTitleLabel_2 = [[CQTLabel alloc] init];
        self.subTitleLabel_2.font = kMidFont;
        self.subTitleLabel_2.textColor = HEX_RGB(0x434242);
        self.subTitleLabel_2.numberOfLines = 0;
    }else {
        
        CQTRemoveFromSuperViewSafely(_subTitleLabel_2);
    }
}

- (void)createReserveButtonIfNeeded {
    
    if (!_reserveBtn) {
        
        _reserveBtn = [CQTCustomButton buttonWithType:UIButtonTypeCustom];
    }else {
        
        CQTRemoveFromSuperViewSafely(_reserveBtn);
    }
}

- (void)createRightButtonIfNeeded {
    
    if (!_rightBtn ) {
        
        _rightBtn = [CQTCustomButton buttonWithType:UIButtonTypeCustom];
        
    }else {
        
        CQTRemoveFromSuperViewSafely(_rightBtn);
    }
}

- (void)createLeftButtonIfNeeded {
    
    if (!_LeftBtn ) {
        
        _LeftBtn = [CQTCustomButton buttonWithType:UIButtonTypeCustom];
        
    }else {
        
        CQTRemoveFromSuperViewSafely(_LeftBtn);
    }
}

- (void)createBackgroundButtonIfNeeded {
    
    if (!_bgBtn) {
        
        _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgBtn.frame = self.bounds;
    }else {
        
        CQTRemoveFromSuperViewSafely(_bgBtn);
    }
}
#pragma mark - | ***** public Methods ***** |

- (void)loadSubViews:(NSArray *)keys {
    
    if (!validAry(keys)) {
        
        return;
    }
    
    UIView *fatherView = self.contentView;
    if (self.contentBgView) {
        
        fatherView = self.contentBgView;
    }
    
    for (NSString *key in keys) {
        
        if ([key isEqualToString:BaseCellImgView]) {
            
            [self createImgViewIfNeeded];
            [fatherView addSubview:self.imgView];
        }else if ([key isEqualToString:BaseCellTitleLabel]) {
            
            [self createTitleLabelIfNeeded];
            [fatherView addSubview:self.titleLabel];
        }else if ([key isEqualToString:BaseCellSubTitleLabel]) {
            
            [self createSubtitleIfNeeded];
            [fatherView addSubview:self.subTitleLabel];
        }else if ([key isEqualToString:BaseCellSubTitleLabel_2]) {
            
            [self createSubtitle2IfNeeded];
            [fatherView addSubview:self.subTitleLabel_2];
        }else if ([key isEqualToString:BaseCellDescLabel]) {
            
            [self createDescInfoIfNeeded];
            [fatherView addSubview:self.descLabel];
        }else if ([key isEqualToString:BaseCellLeftBtn]) {
            
            [self createLeftButtonIfNeeded];
            [fatherView addSubview:self.LeftBtn];
        }else if ([key isEqualToString:BaseCellRightBtn]) {
            
            [self createRightButtonIfNeeded];
            [fatherView addSubview:self.rightBtn];
        }else if ([key isEqualToString:BaseCellReveserBtn]) {
            
            [self createReserveButtonIfNeeded];
            [fatherView addSubview:self.reserveBtn];
        }else if ([key isEqualToString:BaseCellBgBtn]) {
            
            [self createBackgroundButtonIfNeeded];
            [fatherView addSubview:self.bgBtn];
        }
    }
}

/* 子类继承这个方法去释放controller中custom view使用block注册事件 */
- (void)releaseGlobalBlocks {
    
    if (_globalBlocksAry != nil && [_globalBlocksAry count]>0) {
        
        for (id btn in _globalBlocksAry) {
            
            if ([btn isKindOfClass:[UIButton class]]) {
                
                [(UIButton*)btn removeGlobalBlocks];
            }
        }
        
        [_globalBlocksAry removeAllObjects];
    }
}

/* 增加一个Action */
- (void)handleTouchUpInside:(void (^)(UIButton *btn))block {
    
    [self createBackgroundButtonIfNeeded];
    
    [self.contentView insertSubview:_bgBtn atIndex:1];
    
    [self handleObject:_bgBtn event:UIControlEventTouchUpInside block:^(id sender) {
        
        block(sender);
    }];
}

/* IDa所有ViewControllerbutton事件处理的注册方法 */
- (void)handleObject:(UIButton *)button event:(UIControlEvents)event block:(void(^)(UIButton * sender))block {
    
    [self createGlobalBlocksArrayIfNeeded];
    
    if (![_globalBlocksAry containsObject:button]) {
        
        [_globalBlocksAry addObject:button];
    }
    [button A9_handleEvent:UIControlEventTouchUpInside handle:^(UIButton *sender) {
        
        block(sender);
    }];
}

- (void)needContentBgView:(BOOL)need {
    
    if (need) {
        
        [self createContentBgViewIfNeeded];
        
        [self.contentView addSubview:_contentBgView];
    }else {
        
        [self createContentBgViewIfNeeded];
        A9_ObjectReleaseSafely(_contentBgView);
    }
}

+ (CGFloat)cellNeedHeight {
    
    return 44.;
}

- (CGFloat)cellNeedHeight {
    
    return [CQTBaseTableViewCell cellNeedHeight];
}

+ (CGFloat)cellNeedHeightWithDic:(NSDictionary *)atrDic {
    
    return 44.;
}

- (void)addSingleLineWithTop:(BOOL)top buttom:(BOOL)buttom {
    
    self.topLine = top;
    self.bottomLine = buttom;
    
    [super addSingleLineWithTop:top buttom:buttom];
}

- (void)resetSubViewsGUI {
    
    //建议每一个App,写一个类别方法来重载此方法,以满足不同的UI需求.
}


#pragma mark - | ***** private methods ***** |
- (void)createGlobalBlocksArrayIfNeeded {
    
    if (!_globalBlocksAry) {
        
        CQT_CreateMutableArray(_globalBlocksAry);
    }
}

@end

//
//  CQTAlertView.m
//  CQTIda
//
//  Created by ANine on 5/7/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTAlertView.h"
#import "CQTBlurView.h"


#define CQTAlertViewTagOffSet 98752

#define timeLengthDefault 1.5f

#define KColorRedNormal HEX_RGB(0xff4200)
#define KColorRedSelected HEX_RGB(0xd33700)

@interface CQTAlertView (){
    
    UIView *_bgView;
    
    int _funcBtnCnt;
    
    UITapGestureRecognizer *_tapGesture;
}

@property (nonatomic,retain,readwrite)CQTLabel *titleLabel;

@property (nonatomic,retain,readwrite)CQTLabel *subTitleLabel;

@property (nonatomic,retain,readwrite)NSString *message;

@property (nonatomic,assign,readwrite)BOOL dissMissed;

@property (nonatomic,copy,readwrite) void (^completionBlock)(void);

@end
@implementation CQTAlertView


#pragma mark - | ***** super Methods ***** |

+ (void)showTipsWithTitle:(NSString *)message {
    
    [CQTAlertView showTipsWithTitle:nil subTitle:message];
}

+ (void)showTipsWithTitle:(NSString *)message completionBlock:(void (^)(void))block {
    
    [CQTAlertView showTipsWithTitle:nil subTitle:message timerLength:timeLengthDefault completionBlock:block];
}

+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    
    [CQTAlertView showTipsWithTitle:title subTitle:subTitle timerLength:timeLengthDefault];
}

+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle completionBlock:(void (^)(void))block {
    
    [CQTAlertView showTipsWithTitle:title subTitle:subTitle timerLength:timeLengthDefault completionBlock:block];
}

+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle timerLength:(CGFloat)timerLength {
    
    [CQTAlertView showTipsWithTitle:title subTitle:subTitle timerLength:timerLength completionBlock:nil];
}


+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle timerLength:(CGFloat)timerLength completionBlock:(void (^)(void))block {
    
    [CQTAlertView showTipsWithTitle:title subTitle:subTitle timerLength:timerLength completionBlock:block key:cqt_alertview_normal_key];
}

+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle key:(NSString *)key {
    
    [CQTAlertView showTipsWithTitle:title subTitle:subTitle timerLength:timeLengthDefault completionBlock:nil key:key];
}
+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle completionBlock:(void (^)(void))block key:(NSString *)key {
    
    [CQTAlertView showTipsWithTitle:title subTitle:subTitle timerLength:timeLengthDefault completionBlock:block key:key];
}
+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle timerLength:(CGFloat)timerLength completionBlock:(void (^)(void))block key:(NSString *)key {
    
    if ([CQTAlertManager sharedManager].showingAlertView && [[CQTAlertManager sharedManager].showingAlertView.ALERT_KEY isEqualToString:cqt_alertview_most_important_key]) {
        
        return;
    }
    
    if ([CQTResourceBrige sharedBrige].forbiddenAlertView) {
        
        return;
    }
    
    UIFont *font = AvenirBoldFont(15);
    UIFont *subFont = AvenirFont(14);
    
    
    if ((!subTitle || !subTitle.length) && title && title.length) {
        
        subTitle = title;
        
        subFont = AvenirFont(14);
        
        title = nil;
    }
    
    if ([CQTAlertView importantInfoDidShow]) {
        
        return;
    }
    
    [CQTAlertView keepImportantOnlyOne:key];
    
    CQTAlertView *alert = nil;
    
    if (!alert) {
        
        alert = [[CQTAlertView alloc] initWithTitle:title subTitle:subTitle cancelBtn:nil OtherBtn:nil key:key];
    }
    
    alert.titleLabel.font = font;
    alert.subTitleLabel.font = subFont;
    
    alert.titleLabel.textColor = HEX_RGBA(0xff4200, 1.);
    alert.subTitleLabel.textColor = HEX_RGBA(0x303030, 1);
    
    alert.completionBlock = CQT_BLOCK_COPY(block);
    
    alert.message = subTitle;
    
    [[CQTAlertManager sharedManager] enQueueAlertView:alert];
    
    timerLength = timerLength < 1.5f ? 1.5f : timerLength;
    timerLength = timerLength > 30 ? 30 : timerLength;
    
    alert.showTimeLength = timerLength;
}



- (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle timerLength:(CGFloat)timerLength {
    
    if ([CQTAlertManager sharedManager].showingAlertView && [[CQTAlertManager sharedManager].showingAlertView.ALERT_KEY isEqualToString:cqt_alertview_most_important_key]) {
        
        return;
    }
    
    if ([CQTResourceBrige sharedBrige].forbiddenAlertView) {
        
        return;
    }
    
    UIFont *font = AvenirBoldFont(15);
    UIFont *subFont = AvenirFont(14);
    
    if ((!subTitle || !subTitle.length) && title && title.length) {
        
        subTitle = title;
        
        subFont = AvenirFont(14);
        
        title = nil;
    }
    
    self.titleLabel.font = font;
    self.subTitleLabel.font = subFont;
    
    self.message = subTitle;
    
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    
    timerLength = timerLength < 0. ? 0. : timerLength;
    timerLength = timerLength > 30 ? 30 : timerLength;
    
    self.showTimeLength = timerLength;
    
    [[CQTAlertManager sharedManager] enQueueAlertView:self];
}

- (void)dismissAlertView {
    
    self.dissMissed = YES;
    
    CGRect foo = _bgView.frame;
    
    CGFloat offset = 1.;
    
    foo.origin.x -= offset;
    foo.origin.y -= offset;
    foo.size.width += offset *2;
    foo.size.height += offset * 2;
    
    __unsafe_unretained __block void (^weakBlock)(void) = _completionBlock;
    
    [UIView animateWithDuration:0.02f animations:^{
        
        _bgView.frame = foo;
    }completion:^(BOOL finished) {
        
        if (weakBlock) {
            
            weakBlock();
        }
        
        [self unloadView];
    }];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initial];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelBtn:(NSString *)cancelName OtherBtn:(NSArray *)array {
    
    return [self initWithTitle:title subTitle:subTitle cancelBtn:cancelName OtherBtn:array key:cqt_alertview_normal_key];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelBtn:(NSString *)cancelName OtherBtn:(NSArray *)array key:(NSString *)key {
    
    if ([CQTAlertManager sharedManager].showingAlertView && [[CQTAlertManager sharedManager].showingAlertView.ALERT_KEY isEqualToString:cqt_alertview_most_important_key]) {
        
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        
        _titleLabel.text = title;
        _subTitleLabel.text = subTitle;
        
        if (cancelName) {
            
            [self loadCancelBtn:cancelName];
        }
        
        [self loadOtherBtns:array];
        
        [CQTAlertView keepImportantOnlyOne:key];
        
        self.ALERT_KEY = key;
    }
    return self;
}

- (void)initial {
    
    CQT_RETAIN(self);
    
    [self createBgViewIfNeeded];
    [self addSubview:_bgView];
    
    [self createTitleLabelIfNeeded];
    [_bgView addSubview:_titleLabel];
    
    
    [self createSubTitleLabelIfNeeded];
    [_bgView addSubview:_subTitleLabel];
    
    
    self.backgroundColor = HEX_RGBA(0x000000, .5);
    // Initialization code
    
    self.message = nil;
    
    [self loadGesture:YES];
    
    self.needGesture = YES;
    
    self.dissMissed = NO;
    
    [self createCloseBtnIfNeeded];
    [_bgView addSubview:_closeBtn];
    _closeBtn.hidden = YES;
    
}

- (void)loadGesture:(BOOL)load {
    
    @synchronized(self) {
        
        if (load) {
            
            if (!_tapGesture) {
                
                _tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture
                                                                                                  )];
            }
            
            if (_tapGesture.view == self) {
                
                [self removeGestureRecognizer:_tapGesture];
            }
            
            [self addGestureRecognizer:_tapGesture];
        }else {
            
            if (_tapGesture) {
                
                [self removeGestureRecognizer:_tapGesture];
            }
        }

    }
}

- (void)handleTapGesture {
    
    if (!self.needGesture) {
        
        return;
    }
    
    [self dismissAlertView];
}

- (void)dismiss {
    
    [self dismissAlertView];
}

- (void)shouldShow {
    
    int length = self.showTimeLength;
    
    if (length <= 0 || length > 30) {
     
        length = 3.;
    }
    
    if (self.messageImportant || [self.ALERT_KEY isEqualToString:cqt_alertview_most_important_key]) {
        
        length = INT_MAX;
    }
    
    if (![self.ALERT_KEY isEqualToString:cqt_alertview_most_important_key]) {
        
         [self performSelector:@selector(dismissAlertView) withObject:nil afterDelay:length];
    }
    
    if (![[CQTAlertManager sharedManager].showingAlertView isEqual:self]) {
        
        [self internalShowInView:[[UIApplication sharedApplication] keyWindow] delegate:self.delegate completionBlock:self.completionBlock];
    }
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size,CGSizeZero)) {
        return;
    }
    //do something.
}
- (void)unloadView {
    
    if (_completionBlock) {
        
        CQT_BLOCK_RELEASE(_completionBlock);
    }
    
    A9_ObjectReleaseSafely(_titleLabel);
    A9_ObjectReleaseSafely(_subTitleLabel);
    A9_ObjectReleaseSafely(_bgView);
    
    A9_ObjectReleaseSafely(_tapGesture);
    CQTRemoveFromSuperViewSafely(self);
    
    id obj = self;
    
    CQT_RELEASE(obj);
}

- (void)dealloc {
    
    CQTDebugLog(@"AlertView Dealloc....");
    
    [self unloadView];
    
    CQT_SUPER_DEALLOC();
}
#pragma mark - | ***** create Views ***** |
- (void)createBgViewIfNeeded {
    
    if (!_bgView) {
        
        if (iOS_IS_UP_VERSION(7.0)) {
            
            _bgView =(UIView *)[[CQTBlurView alloc] init];
            
        }else {
            
            _bgView = [[CQTView alloc] init];
            _bgView.backgroundColor = HEX_RGBA(0xffffff, .88);
        }
        
        //        _bgView.backgroundColor = HEX_RGBA(0xffffff, .9);
    }else {
        
        CQTRemoveFromSuperViewSafely(_bgView);
    }
}

- (void)createTitleLabelIfNeeded {
    
    if (!self.titleLabel) {
        
        self.titleLabel = [[CQTLabel alloc] init];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.font = AvenirBoldFont(15);
        self.titleLabel.textColor = HEX_RGBA(0xff4200, 1.);
        self.titleLabel.userInteractionEnabled = NO;
    }else {
        
        CQTRemoveFromSuperViewSafely(self.titleLabel);
    }
}

- (void)createSubTitleLabelIfNeeded {
    
    if (!self.subTitleLabel) {
        
        self.subTitleLabel = [[CQTLabel alloc] init];
        self.subTitleLabel.textAlignment = UITextAlignmentCenter;
        self.subTitleLabel.font = AvenirFont(14);
        self.subTitleLabel.textColor = HEX_RGBA(0x303030, 1);
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.adjustsFontSizeToFitWidth = NO;
        self.subTitleLabel.userInteractionEnabled = NO;
    }else {
        
        CQTRemoveFromSuperViewSafely(self.subTitleLabel);
    }
}

- (void)loadCancelBtn:(NSString *)cancelName {
    
    CQTCustomButton *cancelBtn = (CQTCustomButton *)[_bgView viewWithTag:CQTAlertViewTagOffSet];
    
    if (!cancelBtn) {
        
        cancelBtn = [CQTCustomButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.label.font = AvenirFont(16);
        [cancelBtn addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.backgroundColor = [UIColor redColor];
        [_bgView addSubview:cancelBtn];
    }
    
    cancelBtn.tag = CQTAlertViewTagOffSet + 0;
    
    cancelBtn.label.text = cancelName;
    
    [self IDaVersion2_0ButtonFilterNormal:cancelBtn];
    
    _funcBtnCnt = 1;
}

- (void)loadOtherBtns:(NSArray *)array {
    
    if (array) {
        
        int index = 1;
        
        for (NSString *title in array) {
            
            CQTCustomButton *btn = (CQTCustomButton *)[_bgView viewWithTag:CQTAlertViewTagOffSet + index];
            if (!btn) {
                
                btn = [CQTCustomButton buttonWithType:UIButtonTypeCustom];
                btn.label.font = AvenirFont(16);
                [btn addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
                
                [_bgView addSubview:btn];
            }
            
            [self IDaVersion2_0ButtonFilterNormal:btn];
            
            btn.tag = CQTAlertViewTagOffSet + index;
            
            btn.label.text = title;
            
            index ++;
            
            //A9  目前只支持一个.
            break;
        }
        _funcBtnCnt += (array.count > 1  ? 1 : array.count);
        //        _funcBtnCnt = 2;//目前支持两个
    }
}

- (void)createCloseBtnIfNeeded {
    
    if (!_closeBtn) {
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close_btn_white.png"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"close_btn_red.png"] forState:UIControlStateHighlighted];
        [_closeBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.showsTouchWhenHighlighted = YES;
    }else {
        
        CQTRemoveFromSuperViewSafely(_closeBtn);
    }
}
#pragma mark - | ***** public methods ***** |

- (void)setALERT_KEY:(NSString *)ALERT_KEY {
    
    if (![_ALERT_KEY isEqual:ALERT_KEY]) {
        
        _ALERT_KEY = ALERT_KEY;
    }
}

- (void)setDissMissed:(BOOL)dissMissed {
    
    _dissMissed = dissMissed;
}

- (void)setMessageImportant:(BOOL)messageImportant {
    
    if (_messageImportant != messageImportant) {
        
        _messageImportant = messageImportant;
        
        [self setNeedGesture:!messageImportant];
    }
}

- (void)setNeedGesture:(BOOL)needGesture {
    
    if (_needGesture != needGesture) {
        
        _needGesture = needGesture;
        
        [self loadGesture:needGesture];
    }
}

- (CQTCustomButton *)buttonWithIndex:(int)index {
    
    return (CQTCustomButton *)[self viewWithTag:CQTAlertViewTagOffSet + index];
}


- (void)showInView:(UIView *)view delegate:(id <CQTAlertViewDelegate>)delegate {
    
    [self showInView:view delegate:delegate completionBlock:nil];
}

- (void)showInView:(UIView *)view delegate:(id<CQTAlertViewDelegate>)delegate completionBlock:(void (^)(void))block {
    
    self.delegate = delegate;
    
    self.frame = view.bounds;
    
    if (block) {
        
        self.completionBlock = CQT_AUTORELEASE([block copy]);
    }
    
    [[CQTAlertManager sharedManager] enQueueAlertView:self];
}

- (void)internalShowInView:(UIView *)view delegate:(id<CQTAlertViewDelegate>)delegate completionBlock:(void (^)(void))block {
    
    self.delegate = delegate;
    
    self.frame = view.bounds;
    
    if (block) {
        
        self.completionBlock = CQT_AUTORELEASE([block copy]);
    }
    
    @synchronized(view) {
        
        UIView *subView = (UIView *)[view viewWithTag:self.tag];
        
        if (!subView || ![subView isEqual:self]) {
            
            [view addSubview:self];
        }
    }
    
    [self updateSubviewsGUI];
    
}
#pragma mark - | *****  private methods ***** |
+ (void)keepImportantOnlyOne:(NSString *)key {
    
    if ([key isEqualToString:cqt_alertview_most_important_key]) {
        
        [[CQTAlertManager sharedManager] removeAllAlertView];
    }
}

+ (BOOL)importantInfoDidShow {
    
    BOOL importantInfo = NO;
    
    CQTAlertView *alert = [CQTAlertManager sharedManager].showingAlertView;
    
    if ([alert.ALERT_KEY isEqualToString:cqt_alertview_most_important_key]) {
        
        importantInfo = YES;
    }
    
    return importantInfo;
}

- (void)handleButton:(CQTCustomButton *)btn {
    
    long index = btn.tag - CQTAlertViewTagOffSet;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:respondButtonAtIndex:title:)]) {
        
        [self.delegate alertView:self respondButtonAtIndex:(int)index title:btn.label.text];
    }
    
    if (![self.ALERT_KEY isEqualToString:cqt_alertview_most_important_key]) {
        
        [self dismissAlertView];
    }
}

- (void)updateSubviewsGUI {
    
    if (self.message) {
        
        [self configureMessagesGUI];
        
        return;
    }
    
    CGFloat seperate = 5.;
    CGFloat totalHeight = seperate * 3;
    CGFloat titleHeight = 20.;
    
    CGSize size = [self.subTitleLabel.text sizeWithFont:self.subTitleLabel.font constrainedToSize:CGSizeMake(ViewWidth(self) - 10 * seperate, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat subTitleHeight = size.height;
    
    CGFloat buttonHeight = 33.;
    if (self.titleLabel && self.titleLabel.text.length) {
        
        totalHeight += titleHeight;
    }
    
    if (self.subTitleLabel && self.subTitleLabel.text.length) {
        totalHeight +=  2 * seperate;
        totalHeight += subTitleHeight;
    }
    
    totalHeight += (buttonHeight + seperate * 9);
    
    _bgView.layer.cornerRadius = 10.f;
    
    _bgView.frame = ViewRect(2 *seperate,
                             (ViewHeight(self) - totalHeight ) / 2,
                             ViewWidth(self)-4 *seperate,
                             totalHeight);
    
    _closeBtn.frame = ViewRect(ViewWidth(_bgView) - seperate - 4 *seperate ,
                               seperate,
                               4*seperate ,
                               4 *seperate);
    _closeBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    if (self.titleLabel && self.titleLabel.text.length) {
        
        self.titleLabel.hidden = NO;
        self.titleLabel.frame = ViewRect(3 * seperate,
                                         seperate *3,
                                         ViewWidth(_bgView) - 6 *seperate,
                                         20);
    }else {
        
        self.titleLabel.hidden = YES;
        self.titleLabel.frame = ViewRect(0, seperate * 3, 0, 0);
    }
    
    if (self.subTitleLabel && self.subTitleLabel.text.length) {
        
        self.subTitleLabel.hidden = NO;
        self.subTitleLabel.frame = ViewRect(3 * seperate,
                                            ViewBottom(self.titleLabel) + 2 *seperate,
                                            ViewWidth(_bgView)- 6 *seperate,
                                            subTitleHeight);
        
    }else {
        
        self.subTitleLabel.hidden = YES;
        self.subTitleLabel.frame = ViewRect(3 *seperate,
                                            ViewBottom(self.titleLabel) + 2 *seperate,
                                            0,
                                            0);
        
    }
    
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    
    self.subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    
    for (UIView *subView in _bgView.subviews) {
        
        if ([subView isKindOfClass:[CQTCustomButton class]]) {
            
            int index = (int)subView.tag - CQTAlertViewTagOffSet;
            
            CQTCustomButton *btn = (CQTCustomButton *)subView;
            
            if (_funcBtnCnt == 2) {
                if (index) {
                    
                    subView.frame = ViewRect(ViewWidth(_bgView) - 2 *seperate -  (ViewWidth(_bgView) - seperate * 9 ) / _funcBtnCnt,
                                             ViewHeight(_bgView) - buttonHeight - 3 * seperate,
                                             (ViewWidth(_bgView) - seperate * 11 ) / _funcBtnCnt,
                                             buttonHeight);
                    
                    
                    [self IDaVersion2_0ButtonFilterEmphsis:btn];
                }
                else {
                    
                    subView.frame = ViewRect(seperate * 2,
                                             ViewHeight(_bgView) - buttonHeight - 3* seperate,
                                             (ViewWidth(_bgView) - seperate * 11 ) / 2,
                                             buttonHeight);
                    
                    [self IDaVersion2_0ButtonFilterNormal:btn];
                }
            }
            else {
                
                if (index) {
                    
                    subView.frame = ViewRect(ViewWidth(_bgView) - 2 *seperate -  (ViewWidth(_bgView) - seperate * 12 ) / _funcBtnCnt,
                                             ViewHeight(_bgView) - buttonHeight - 3 * seperate,
                                             (ViewWidth(_bgView) - seperate * 12 ) / _funcBtnCnt,
                                             buttonHeight);
                    
                    [self IDaVersion2_0ButtonFilterNormal:btn];
                }
                else {
                    subView.frame = ViewRect((ViewWidth(_bgView) - (ViewWidth(_bgView) - seperate * 10 ) / 2 )/2,
                                             ViewHeight(_bgView) - buttonHeight - 3* seperate,
                                             (ViewWidth(_bgView) - seperate * 10 ) / 2,
                                             buttonHeight);
                    
                    [self IDaVersion2_0ButtonFilterEmphsis:btn];
                }
            }
        }
    }
}


- (void)configureMessagesGUI {
    
    CGFloat widthBase = 90.;
    
    CGFloat seperate = 5.f;
    
    CGFloat totalHeight = 6 * seperate;
    
    if (self.titleLabel.text && self.titleLabel.text.length) {
        
        totalHeight += ( 20. + seperate * 2);
    }
    CGFloat subTitleWidth = 0.;
    
    if (self.message) {
        
        int cnt = (int)self.subTitleLabel.text.length;
        
        if (cnt < 6) {
            
            subTitleWidth = widthBase;
        }else {
            
            subTitleWidth = widthBase + 18 *(cnt - 6);
            
            subTitleWidth = subTitleWidth > ViewWidth(self) - 8 * seperate ? ViewWidth(self) - 8 * seperate  : subTitleWidth;
        }
        
        CGSize size = [_subTitleLabel.text sizeWithFont:_subTitleLabel.font constrainedToSize:CGSizeMake(subTitleWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        
        totalHeight += size.height;
        
        totalHeight = totalHeight < widthBase ? widthBase : totalHeight;
        
        _bgView.layer.cornerRadius = 10.f;
        
        _bgView.frame = ViewRect((ViewWidth(self) - subTitleWidth - 6 * seperate) / 2,
                                 (ViewHeight(self) -totalHeight ) / 2,
                                 subTitleWidth + 6 * seperate ,
                                 totalHeight);
        _closeBtn.frame = ViewRect(ViewWidth(_bgView) - seperate - 4 *seperate ,
                                   seperate,
                                   4*seperate ,
                                   4 *seperate);
        
        _closeBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
        if (!self.titleLabel || !self.titleLabel.text.length) {
            
            _subTitleLabel.frame = ViewRect(3 *seperate,
                                            ( ViewHeight(_bgView) - size.height ) /2,
                                            ViewWidth(_bgView) - 6 *seperate,
                                            size.height);
        }else {
            
            CGSize titleSize = [self.titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(ViewWidth(_bgView) - 6 *seperate, 20) lineBreakMode:NSLineBreakByWordWrapping];
            
            _titleLabel.frame = ViewRect((ViewWidth(_bgView) - titleSize.width ) / 2,
                                         3 * seperate,
                                         titleSize.width,
                                         20);
            
            self.subTitleLabel.frame = ViewRect((ViewWidth(_bgView) - size.width )/2,ViewHeight(_bgView) - 3 * seperate - size.height, size.width,size.height);
        }
    }
}

- (void)IDaVersion2_0ButtonFilterNormal:(CQTCustomButton *)btn {
    
    btn.backgroundColor = HEX_RGB(0xffffff);
    btn.bgHighLightColor = KColorRedSelected;
    btn.layer.cornerRadius = ViewHeight(btn)/2;
    btn.layer.borderWidth = 1.;
    btn.layer.borderColor = KColorRedNormal.CGColor;
    btn.textNormalColor = KColorRedNormal;
    btn.textSelectedColor = HEX_RGB(0xffffff);
}

- (void)IDaVersion2_0ButtonFilterEmphsis:(CQTCustomButton *)btn {
    
    btn.backgroundColor = KColorRedNormal;
    btn.bgHighLightColor = KColorRedSelected;
    btn.layer.cornerRadius = ViewHeight(btn) / 2;
    btn.layer.borderWidth = 1.;
    btn.layer.borderColor = kClearColor.CGColor;
    btn.textNormalColor = [UIColor whiteColor];
    btn.label.textColor = btn.textNormalColor;
    btn.textSelectedColor = btn.textNormalColor;
}

@end


@interface CQTAlertManager(){
    
}

@property (nonatomic,retain,readwrite)NSMutableArray *alertQueue;
@property (nonatomic,retain,readwrite)CQTAlertView *showingAlertView;

@end
@implementation CQTAlertManager

+ (instancetype)sharedManager {
    
    static CQTAlertManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[CQTAlertManager alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initial];
    }
    
    return self;
}

- (void)initial {
    
    if (!_alertQueue) {
        
        _alertQueue = [[NSMutableArray alloc] init];
    }
}

- (void)dealloc {
    
    A9_ObjectReleaseSafely(_alertQueue);
    
    CQT_SUPER_DEALLOC();
    
}

- (void)enQueueAlertView:(CQTAlertView *)alert {
    
    if (![self.alertQueue containsObject:alert]) {
        
        [_alertQueue addObject:alert];
        
        [alert addObserver:self forKeyPath:@"dissMissed" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    
    @synchronized(self) {
        
        if (!_showingAlertView || [_showingAlertView isEqual:alert]) {
            
            [self alertViewNeedShow:alert];
        }
    }
}

- (void)alertViewNeedShow:(CQTAlertView *)view {
    
    [view shouldShow];
    
    self.showingAlertView = view;
    
    [view updateSubviewsGUI];
}

- (void)removeAlertView:(CQTAlertView *)alert {
    
    if ([_alertQueue containsObject:alert]) {
        
        [_alertQueue removeObject:alert];
    }
}

- (void)removeAllAlertView {
    
    CQTAlertView *alert = self.showingAlertView;
    
    [alert dismissAlertView];
    
    CQT_RELEASE(_showingAlertView);
    
    _showingAlertView = nil;
    
    if (!_alertQueue) return;
    
    if ([_alertQueue respondsToSelector:@selector(removeAllObjects)]) {
        
        [_alertQueue removeAllObjects];
    }
}

#pragma mark - | ***** NSKeyValueObserving ***** |

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([object isKindOfClass:[CQTAlertView class]]) {
        
        CQTAlertView *alert = (CQTAlertView *)object;
        
        [alert removeObserver:self forKeyPath:@"dissMissed"];
        
        [self removeAlertView:alert];
        
        CQT_RELEASE(_showingAlertView);
        
        self.showingAlertView = nil;
        
        CQTAlertView *willShowAlert = [_alertQueue firstObject];
        
        if (willShowAlert && [willShowAlert isKindOfClass:[CQTAlertView class]]) {
            
            @synchronized(self) {
                
                [self alertViewNeedShow:willShowAlert];
            }
        }
    }
}
@end



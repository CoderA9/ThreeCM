//
//  CQTAlertView.h
//  CQTIda
//
//  Created by ANine on 5/7/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTView.h"
#import "CQTCustomButton.h"

/* 网络请求提示Key */
static NSString *cqt_alertview_network_key = @"CQTAlertViewNetworkKey";

/* LocalPush提示Key */
static NSString *cqt_alertview_localPush_key = @"CQTAlertViewLocalPushKey";

/* 通用提示框Key */
static NSString *cqt_alertview_normal_key = @"CQTAlertViewNormalKey";

/* 版本升级提示Key */
static NSString *cqt_alertview_update_key = @"CQTAlertViewVersionUpdateKey";

/* 强制升级提示Key */
static NSString *cqt_alertview_most_important_key = @"CQTAlertViewMostImportantKey";

/**
 @brief 警告弹出框.
 
 @discussion <#some problem description with this class#>
 */

@protocol CQTAlertViewDelegate;

@interface CQTAlertView : CQTView

@property (nonatomic,retain)NSString *ALERT_KEY;

@property (nonatomic,retain)UIView *bgView;

@property (nonatomic,assign)int  showTimeLength;

@property (nonatomic,retain,readonly)CQTLabel *titleLabel;

@property (nonatomic,retain)UIButton *closeBtn;

@property (nonatomic,retain,readonly)CQTLabel *subTitleLabel;

@property (nonatomic,retain,readonly)NSString *message;
//供外部传递文本信息.
@property (nonatomic,retain,retain)NSString *info;

@property (nonatomic,copy,readonly) void (^completionBlock)(void);

@property (nonatomic,assign)id <CQTAlertViewDelegate>delegate;

@property (nonatomic,assign)BOOL needGesture;

@property (nonatomic,retain)id infoBody;

@property (nonatomic,assign,readonly)BOOL dissMissed;

//if messageImportan is true , the Tapgesture will remove from self , default is false.
@property (nonatomic,assign)BOOL messageImportant;
- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelBtn:(NSString *)cancelName OtherBtn:(NSArray *)array;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelBtn:(NSString *)cancelName OtherBtn:(NSArray *)array key:(NSString *)key;

- (CQTCustomButton *)buttonWithIndex:(int)index;

- (void)showInView:(UIView *)view delegate:(id <CQTAlertViewDelegate>)delegate;
- (void)showInView:(UIView *)view delegate:(id<CQTAlertViewDelegate>)delegate completionBlock:(void (^)(void))block;
+ (void)showTipsWithTitle:(NSString *)message;
+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle timerLength:(CGFloat)timerLength;
- (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle timerLength:(CGFloat)timerLength;

+ (void)showTipsWithTitle:(NSString *)message completionBlock:(void (^)(void))block;
+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle completionBlock:(void (^)(void))block;
+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle timerLength:(CGFloat)timerLength completionBlock:(void (^)(void))block;

+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle key:(NSString *)key;
+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle completionBlock:(void (^)(void))block key:(NSString *)key;
+ (void)showTipsWithTitle:(NSString *)title subTitle:(NSString *)subTitle timerLength:(CGFloat)timerLength completionBlock:(void (^)(void))block key:(NSString *)key;

- (void)dismiss;

- (void)createCloseBtnIfNeeded ;


@end

@protocol CQTAlertViewDelegate <NSObject>

- (void)alertView:(CQTAlertView *)alertView respondButtonAtIndex:(int)index title:(NSString *)title;
@end



@interface CQTAlertManager : NSObject

/* AlertView的队列,保证每一时刻只有一个alertView正在显示. */
@property (nonatomic,retain,readonly)NSMutableArray *alertQueue;

@property (nonatomic,retain,readonly)CQTAlertView *showingAlertView;

+ (instancetype)sharedManager;

- (void)enQueueAlertView:(CQTAlertView *)alert;

- (void)removeAlertView:(CQTAlertView *)alert;

- (void)removeAllAlertView;
@end
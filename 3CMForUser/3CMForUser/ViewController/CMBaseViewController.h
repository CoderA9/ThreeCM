//
//  CMBaseViewController.h
//  3CMForUser
//
//  Created by ANine on 7/28/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @brief ViewController的基类
 
 @discussion
 */

/* 视图控制器被加载的方式. */
typedef enum _ViewControllerLoadingType {
    
    ViewControllerLoadingRootVC = 0 ,
    ViewControllerLoadingPushVC = 1 ,
    ViewControllerLoadingPresentVC = 2,
    
}ViewControllerLoadingType;

/* NavigationBar默认高度 */
static const float HEAD_VIEW_HEIGHT = 44.f;
/* TABBAR默认高度 */
#define TAB_BAR_HEIGHT  heightBaseiPhone5(45.f)

@interface CMBaseViewController : UIViewController < UIActionSheetDelegate, UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CQTAlertViewDelegate > {
    
    /* 头部View */
    UIView *_headView;
    
    /* navigationBar左边按钮 */
    CQTCustomButton *_leftNavBtn;
    
    /* navigationBar右边按钮 */
    CQTCustomButton *_rightNavBtn;
    
    /* 试图标题Label */
    UILabel *_titleLabel;
    
    /* 具有点击事件功能的标题 */
    CQTCustomButton *_titleLabelBtn;
 
    /* 内存警告的标志位 */
    BOOL _isMemoryWarnning;
    
    /* 多媒体管理器*/
    CQTMediaManager *_manager;
    
    CGFloat statusHeight;
}

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) CQTCustomButton *leftNavBtn;

@property (nonatomic, strong) CQTCustomButton *rightNavBtn;

@property (nonatomic, assign) BOOL needRequestData;

/* 方便子类创建navigationBar上面的控件 */
- (void)createTitleLabelIfNeeded:(NSString *)title;
- (void)createTitleLabelBtnIfNeeded:(NSString *)title;
- (void)createLeftNavBtnIfNeededWithTitle:(NSString *)title handle:(void (^)(id sender))block;
- (void)createRightNavBtnIfNeededWithTitle:(NSString *)title handle:(void (^)(id sender))block;

/* 加载视图 */
- (void)configVisualSubviews;

/* 内存吃紧回调方法 */
- (void)unloadView;

/* 创建当前控制器需要的数组 */
- (void)createContainersIfNeeded;

/* 创建当前控制器需要用到的数据模型 */
- (void)createModelsIfNeeded;

/* notification */
- (void)handleNotification:(NSNotification *)notify;

/* 加载需要的数据 */
- (void)loadNeedData;


/* 需要登录 */
- (BOOL)needLogin;

/* 需要注销 */
- (void)needLogout;

/* 需要获取单张图片相片 */
- (void)needPhotoWithSuccessedBlock:(pickImageSuccessedBlock)sBlock
                      failuredBlock:(pickImageErrorBlock)fBlock;

/* 需要多张图片 */
- (void)needPhotoswithAtMostPictures:(NSInteger)count
                            selected:(NSArray *)assets
                      successedBlock:(pickImageSuccessedBlock)sBlock
                       failuredBlock:(pickImageErrorBlock)fBlock;
/* 需要拍照 */
- (void)needTakePhoto;

/* 上传成功的回调方法. */
- (void)upLoadImageSuccessedWithInfo:(NSDictionary *)info;

/* alertView */
- (void)showCQTAlertViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelBtn:(NSString *)cancelBtn OtherBtn:(NSArray *)array;
- (void)showCQTAlertViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelBtn:(NSString *)cancelBtn OtherBtn:(NSArray *)array messageImportant:(BOOL)messageImportant ;
- (void)showCQTAlertViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelBtn:(NSString *)cancelBtn OtherBtn:(NSArray *)array messageImportant:(BOOL)messageImportant completionBlock:(void (^)(void))block;

@end

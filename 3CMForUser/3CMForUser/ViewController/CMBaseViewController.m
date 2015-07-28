//
//  CMBaseViewController.m
//  3CMForUser
//
//  Created by ANine on 7/28/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CMBaseViewController.h"

@interface CMBaseViewController ()

@end

@implementation CMBaseViewController

/* 创建当前控制器需要的数组 */
- (void)createContainersIfNeeded {

}

/* 创建当前控制器需要用到的数据模型 */
- (void)createModelsIfNeeded {

}

/* 内存吃紧回调方法 */
- (void)unloadView {
    
    if([self isViewLoaded] && ![[self view] window] && _isMemoryWarnning) {
        
        [self setView:nil];
    }
    
    A9_ViewReleaseSafely(_titleLabel);
    _isMemoryWarnning = NO;
}

- (void)configVisualSubviews {}

/* 加载需要的数据 */
- (void)loadNeedData {

}

#pragma mark - | ***** CreateViews ***** |

- (void)createHeaderViewIfNeeded {
    
    if (!_headView) {
    
        _headView = [[UIView alloc] init];
        _headView.frame = ViewRect(0, statusHeight, SCREEN_WIDTH, HEAD_VIEW_HEIGHT);
    
    }else {
        [_headView removeFromSuperview];
    }
}

- (void)createLeftNavBtnIfNeededWithTitle:(NSString *)title handle:(void (^)(id sender))aBlock {
    
    if (!_leftNavBtn) {
        
        _leftNavBtn = [CQTCustomButton buttonWithType:UIButtonTypeCustom];
        
        _leftNavBtn.label.adjustsFontSizeToFitWidth = YES;
        _leftNavBtn.frame = ViewRect(0,ViewHeight(_headView) - HEAD_VIEW_HEIGHT , 60, HEAD_VIEW_HEIGHT);
        
        CGFloat imgWidth = 24;
        _leftNavBtn.imgView.frame = ViewRect(15, (HEAD_VIEW_HEIGHT - imgWidth) / 2, imgWidth, imgWidth);
        _leftNavBtn.label.text = title;
        
        _leftNavBtn.imgView.contentMode = UIViewContentModeScaleAspectFit;
        _leftNavBtn.imgViewNormalImg = [UIImage imageNamed:__TEXT(back_btn_normal)];
        _leftNavBtn.imgViewSelectedImg = [UIImage imageNamed:__TEXT(back_btn_highlight)];
        
        [[_leftNavBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^ (UIButton *sender) {
            
            aBlock(sender);
        }];
    }else {
        [_leftNavBtn removeFromSuperview];
    }
}

- (void)createRightNavBtnIfNeededWithTitle:(NSString *)title handle:(void (^)(id sender))aBlock {
    
    if (!_rightNavBtn) {
        
        _rightNavBtn = [CQTCustomButton buttonWithType:UIButtonTypeCustom];
        _rightNavBtn.label.adjustsFontSizeToFitWidth = YES;
        _rightNavBtn.frame = ViewRect(ViewWidth(self.view) - 60  , ViewHeight(_headView) - HEAD_VIEW_HEIGHT , 60, HEAD_VIEW_HEIGHT);
        
        CGFloat imgWidth = 26;
        _rightNavBtn.imgView.frame = ViewRect(ViewWidth(_rightNavBtn) - imgWidth - 15, (HEAD_VIEW_HEIGHT - imgWidth) /2, imgWidth, imgWidth);
        
        _rightNavBtn.imgView.contentMode = UIViewContentModeScaleAspectFit;
        _rightNavBtn.label.text = title;
        _rightNavBtn.label.textColor = [UIColor whiteColor];
        _rightNavBtn.label.font = BoldFont(14.);
        
        [[_rightNavBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^ (UIButton *sender) {
            
            aBlock(sender);
        }];
        
    }else {
        
        CQTRemoveFromSuperViewSafely(_rightNavBtn);
    }
}

- (void)createTitleLabelIfNeeded:(NSString *)title {
    
    if (![self.title isEqualToString:title]) {
        
        self.title = title;
    }
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:ViewRect(80, ViewHeight(_headView) - HEAD_VIEW_HEIGHT + 10, ViewWidth(self.headView) - 80 * 2 ,HEAD_VIEW_HEIGHT - 10*2)];
        setClearColor(_titleLabel);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = self.title;
        _titleLabel.textColor = kTextColorHenvy;
        _titleLabel.font = AvenirFont(19);//Font(20);
    }else {
        
        CQTRemoveFromSuperViewSafely(_titleLabel);
    }
    _titleLabel.text = self.title;
}
- (void)createTitleLabelBtnIfNeeded:(NSString *)title {
    
    if (![self.title isEqualToString:title]) {
        
        self.title = title;
    }
    
    if (!_titleLabelBtn) {
        
        _titleLabelBtn = [CQTCustomButton buttonWithType:UIButtonTypeCustom];
        _titleLabelBtn.bgHighLightColor = kClearColor;
        _titleLabelBtn.label.frame = _titleLabelBtn.bounds;
        _titleLabelBtn.label.textAlignment = NSTextAlignmentCenter;
        _titleLabelBtn.label.text = self.title;
        _titleLabelBtn.textNormalColor = kTextColorHenvy;
        _titleLabelBtn.textSelectedColor = [UIColor redColor];
        _titleLabelBtn.label.font = AvenirFont(19);
    }else {
        
        CQTRemoveFromSuperViewSafely(_titleLabelBtn);
    }
    _titleLabelBtn.frame = ViewRect(80,ViewHeight(_headView) - HEAD_VIEW_HEIGHT + 10, ViewWidth(self.headView) - 80 * 2 ,HEAD_VIEW_HEIGHT - 10*2);
}

#pragma mark - | ***** Public Methods ***** |



/* 需要登录 */
- (BOOL)needLogin {
    
    return YES;
}

/* 需要注销 */
- (void)needLogout {
    
}

/* 需要获取单张图片相片 */
- (void)needPhotoWithSuccessedBlock:(pickImageSuccessedBlock)sBlock
                      failuredBlock:(pickImageErrorBlock)fBlock {

    if (!_manager) {
        
        _manager = [[CQTMediaManager alloc] init];
    }
    
    [_manager needPhotoWithSuccessedBlock:^(NSDictionary *imageInfo) {
        
        if (sBlock) {
            
            sBlock(imageInfo);
        }
        
        if (_manager) {
            
            CQT_RELEASE(_manager);
        }
        
    } failuredBlock:^(NSDictionary *errorInfo) {
        
        if (fBlock) {
            
            fBlock(errorInfo);
        }
        
        if (_manager) {
            
            CQT_RELEASE(_manager);
        }
        
    } willShowPickerBlock:^{
        
    } targetViewController:self];
}

/* 需要多张图片 */
- (void)needPhotoswithAtMostPictures:(NSInteger)count
                            selected:(NSArray *)assets
                      successedBlock:(pickImageSuccessedBlock)sBlock
                       failuredBlock:(pickImageErrorBlock)fBlock {
    
    if (!_manager) {
        
        _manager = [[CQTMediaManager alloc] init];
    }
    
    [_manager needPhotosCount:count selected:assets SuccessedBlock:^(NSDictionary *imageInfo) {
        
        if (sBlock) {
            
            sBlock(imageInfo);
        }
        
        if (_manager) {
            
            CQT_RELEASE(_manager);
        }
        
    } failuredBlock:^(NSDictionary *errorInfo) {
        
        if (fBlock) {
            
            fBlock(errorInfo);
        }
        
        if (_manager) {
            
            CQT_RELEASE(_manager);
        }
    } willShowPickerBlock:^{
        
    } targetViewController:self];
}
/* 需要拍照 */
- (void)needTakePhoto {
    
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
        CQTTakePictureController *picker = [[CQTTakePictureController alloc] initWithType:sourceType];
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
        CQT_RELEASE(picker);
    }
}

/* 上传成功的回调方法. */
- (void)upLoadImageSuccessedWithInfo:(NSDictionary *)info {

}

#pragma mark - | ***** AlertView ***** |
- (void)showCQTAlertViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelBtn:(NSString *)cancelBtn OtherBtn:(NSArray *)array {
    
    [self showCQTAlertViewWithTitle:title subTitle:subTitle cancelBtn:cancelBtn OtherBtn:array messageImportant:NO];
    
}

- (void)showCQTAlertViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelBtn:(NSString *)cancelBtn OtherBtn:(NSArray *)array messageImportant:(BOOL)messageImportant {
    
    [self showCQTAlertViewWithTitle:title subTitle:subTitle cancelBtn:cancelBtn OtherBtn:array messageImportant:messageImportant completionBlock:nil];
}

- (void)showCQTAlertViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelBtn:(NSString *)cancelBtn OtherBtn:(NSArray *)array messageImportant:(BOOL)messageImportant completionBlock:(void (^)(void))block {
    
    CQTAlertView *alertView = [[CQTAlertView alloc] initWithTitle:title subTitle:subTitle cancelBtn:cancelBtn OtherBtn:array];
    alertView.messageImportant = YES;
    alertView.needGesture = !messageImportant;
    alertView.showTimeLength = INT_MAX;
    
    [alertView showInView:self.view delegate:self completionBlock:block];
    
    CQT_RELEASE(alertView);
}

#pragma mark - | ***** Notification ***** |

- (void)handleNotification:(NSNotification *)notify {
    
}

@end

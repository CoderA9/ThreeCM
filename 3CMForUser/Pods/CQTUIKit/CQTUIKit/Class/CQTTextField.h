//
//  CQTTextField.h
//  CQTTextFieldDemo
//
//  Created by ANine on 3/20/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  UITextField(custom)
- (void)willShow;
@property (nonatomic,retain)UIFont *placeHoldFont;
@property (nonatomic,retain)UIColor *placeHoldTextColor;
@end

@class CQTBlurView;

typedef void(^textFieldDidReturnBlock)(UITextField *textField);
typedef void(^textFieldDidChangedBlock)(UITextField *textField);

@protocol CQTTextFieldDelegate;

@interface CQTTextField : UITextField <UITextFieldDelegate,UITextViewDelegate>

/* 键盘弹起时显示在顶部的输入文本框. */
@property (nonatomic,retain)UITextView *showTextView;

/* 键盘弹起时的背景View. */
@property (nonatomic,retain)UIView *bgView;

/* 父视图,default = Application.keyWindow */
@property (nonatomic,assign)UIView *fatherView;

/* y坐标的平移,默认= 0 */
@property (nonatomic,assign)CGFloat yoffset;

/* textView的高度,默认为50 */
@property (nonatomic,assign)CGFloat showTextViewHeight;

- (void)observerFieldReturn:(textFieldDidReturnBlock)block;
- (void)observerFieldDidChange:(textFieldDidChangedBlock)block;
/* 如果要启用该文本框输入请在- (BOOL)textFieldShouldBeginEditing中调用此方法. */
- (void)willShow;

/* 加载leftView */
- (void)loadLeftImgViewFrame:(CGRect)foo imageName:(NSString *)name;

@property (nonatomic,assign) BOOL statusBarIsHidden;
@end

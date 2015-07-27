//
//  CQTTextField.m
//  CQTTextFieldDemo
//
//  Created by ANine on 3/20/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CQTTextField.h"

#import "CQTBlurView.h"
#import "CQTViewConstants.h"

@interface CQTTextField() {
    
    textFieldDidReturnBlock _endEditorBlock;
    textFieldDidChangedBlock _changeBlock;
}

@end

@implementation CQTTextField

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initial];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initial];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initial];
    }
    
    return self;
}

- (void)initial {
    
    self.showTextViewHeight = 50.;
    self.yoffset = 0.;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor colorWithWhite:0. alpha:.5f];
    
    _showTextView = [[UITextView alloc] init];
    _showTextView.delegate = self;
    _showTextView.backgroundColor = [UIColor redColor];
    _showTextView.layer.borderColor = [UIColor whiteColor].CGColor;
    _showTextView.layer.borderWidth = 1.5f;
//    _showTextView.clear_on_insertion(YES);
    _showTextView.font = AvenirFont(16);
    _showTextView.backgroundColor = _bgView.backgroundColor;
    _showTextView.textColor = [UIColor whiteColor];
    
    [_bgView addSubview:_showTextView];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
    [_bgView addGestureRecognizer:tap];
    
    self.fatherView = window;
    
}

- (void)dealloc {
    
    _showTextView = nil;
    _bgView = nil;
    _fatherView = nil;
    
    CQT_BLOCK_RELEASE(_endEditorBlock);
}
#pragma mark - | ***** publicMethod ***** |
- (void)setPlaceHoldFont:(UIFont *)placeHoldFont {

    [self setValue:placeHoldFont forKeyPath:@"_placeholderLabel.font"];
}

- (void)setPlaceHoldTextColor:(UIColor *)placeHoldTextColor {
    
    [self setValue:placeHoldTextColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)observerFieldReturn:(textFieldDidReturnBlock)endEditorBlock {
    
    if (_endEditorBlock) {
        
        CQT_BLOCK_RELEASE(_endEditorBlock);
    }
    
    if (_endEditorBlock != endEditorBlock) {
        
        _endEditorBlock = CQT_BLOCK_COPY(endEditorBlock);
    }
}

- (void)observerFieldDidChange:(textFieldDidChangedBlock)block {

    if (_changeBlock) {
        
        CQT_BLOCK_RELEASE(_changeBlock);
    }
    
    if (_changeBlock != block) {
        
        _changeBlock = CQT_BLOCK_COPY(block);
    }
}

#pragma mark - | ***** private ***** |
- (void)setFatherView:(UIView *)fatherView {
    
    if (_fatherView != fatherView) {
        
        _fatherView = fatherView;
        
        [_fatherView addSubview:_bgView];
        [_fatherView sendSubviewToBack:_bgView];
        _bgView.alpha = 0.;
        _bgView.frame = _fatherView.bounds;
        
        CGRect foo = [self getShowTextFrame];
        foo.origin.y -= foo.size.height;
        
        _showTextView.frame = foo;
    }
}

- (void)willShow {
    
    _bgView.alpha = 1.;
    _showTextView.returnKeyType = self.returnKeyType;
    _showTextView.keyboardType =self.keyboardType;
    _showTextView.text = self.text;
    
    self.statusBarIsHidden = [UIApplication sharedApplication].statusBarHidden;
    
    CGRect foo = [self getShowTextFrame];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        _showTextView.frame = foo;
        [_fatherView bringSubviewToFront:_bgView];
        
    }completion:^(BOOL finished) {
        
        [_showTextView performSelector:@selector(becomeFirstResponder)];
    }];
}

/* 加载leftView */
- (void)loadLeftImgViewFrame:(CGRect)foo imageName:(NSString *)name {
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:ImageWithStr(name)];
    imgView.frame = foo;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = CQT_AUTORELEASE(imgView);
}

- (CGRect)getShowTextFrame {
    
    CGFloat showHeight = self.showTextViewHeight;
    
    return CGRectMake(0, self.yoffset
                      , CGRectGetWidth(_fatherView.frame), showHeight);
}

- (void)textFieldWillHidden {
    
    _bgView.alpha = 0.;
    self.text = _showTextView.text;
    
    CGRect foo = [self getShowTextFrame];
    foo.size.height += 10.;
    [UIView animateWithDuration:.1 delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _showTextView.frame = foo;
        
        [[UIApplication sharedApplication] setStatusBarHidden:self.statusBarIsHidden];
    } completion:^(BOOL finished) {
        
        CGRect foo = [self getShowTextFrame];
        foo.size.height = 0.;
        
        [UIView animateWithDuration:.2 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _showTextView.frame = foo;
            
            if (_endEditorBlock) {
                
                _endEditorBlock(self);
            }
            
            [_fatherView sendSubviewToBack:_bgView];
            
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)oneTap:(UITapGestureRecognizer *)tap {
    
    if (_showTextView && [_showTextView isFirstResponder]) {
        
        [_showTextView resignFirstResponder];
    }
}
#pragma mark - | ***** UITextFieldDelegate ***** |

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

#pragma mark - | ***** UITextViewDelegate ***** |

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    [self textFieldWillHidden];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.text = textView.text;
    
    if (_changeBlock) {
        
        _changeBlock(self);
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    
    return YES;
}

@end

@implementation UITextField(custom)

- (void)willShow {
}
@end


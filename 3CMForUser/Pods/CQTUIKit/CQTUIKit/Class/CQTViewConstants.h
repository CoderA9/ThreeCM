//
//  CQTViewConstants.h
//  CQTIda
//
//  Created by ANine on 4/9/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

/**
 @brief 每个项目都能用到的一些固定的关于UIView的简化集合.
 #import "CQTViewConstants.h"
 @discussion <#some problem description with this class#>
 */

#if __has_feature(objc_arc)

#define CQT_PROP_RETAIN					strong
#define CQT_RETAIN( x )					(x)
#define CQT_RELEASE( x )                (x) = nil;
#define CQT_AUTORELEASE( x )			(x)
#define CQT_BLOCK_COPY( x )				(x)
#define CQT_BLOCK_RELEASE( x )
#define CQT_SUPER_DEALLOC()
#define CQT_AUTORELEASE_POOL_START()	@autoreleasepool {
#define CQT_AUTORELEASE_POOL_END()		}


#define CQT_DISPATCH_RELEASE(x) ({dispatch_object_t _o = (x); \
_dispatch_object_validate(_o); _o = nil;})


#else

#define CQT_PROP_RETAIN					retain
#define CQT_RETAIN( x )					[(x) retain]
#define CQT_RELEASE( x )				[(x) release];(x) = nil;
#define CQT_AUTORELEASE( x )			[(x) autorelease]
#define CQT_BLOCK_COPY( x )				Block_copy( x )
#define CQT_BLOCK_RELEASE( x )			Block_release( x )
#define CQT_SUPER_DEALLOC()				[super dealloc]
#define CQT_AUTORELEASE_POOL_START()	NSAutoreleasePool * __pool = [[NSAutoreleasePool alloc] init];
#define CQT_AUTORELEASE_POOL_END()		[__pool release];

#define CQT_DISPATCH_RELEASE(x) ({dispatch_object_t _o = (x); \
_dispatch_object_validate(_o); [_o release]; _o = nil;})

#endif

/* 判断当前设备是否是IPHONE5 */
#define DEVICE_IS_IPHONE5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define EVENTS_DEFAULT UIControlEventTouchUpInside

//
#define AvenirFont(f)         [UIFont fontWithName:@"Avenir-Light" size:f]
#define AvenirBoldFont(f)     [UIFont fontWithName:@"Avenir-Heavy" size:f]

#define kBigBoldFont      AvenirBoldFont(16.)
#define kMidBoldFont      AvenirBoldFont(14.)
#define kSmallBoldFont    AvenirBoldFont(12.)
#define kBigFont          AvenirFont(16.)
#define kMidFont          AvenirFont(14.)
#define kSmallFont        AvenirFont(12.)

#define CQTButton_UIEdgeInsetsIdentity  UIEdgeInsetsMake(0, 0, 0, 0)
#ifndef kCellSpace
#define kCellSpace 10.
#endif

# define ResignFstResponder(__obj) \
if([__obj isKindOfClass:[UITextField class]] || [__obj isKindOfClass:[UIDatePicker class]]) {\
    if ([__obj isFirstResponder]) {\
        [__obj resignFirstResponder];\
    }\
}

#define delegateRespond(__obj,__method)  (nil != __obj && [__obj respondsToSelector:@selector(__method)])

static NSString *kAlertEmptNickname = @"昵称不能为空.";
static NSString *kAlertEmptUsername = @"用户名不能为空.";
static NSString *kAlertEmptPassword = @"密码不能为空.";
static NSString *kAlertEmptTelePhone = @"手机号不能为空.";
static NSString *kAlertEmptVerifyCode = @"验证码不能为空.";
static NSString *kAlertOldPasswordError = @"旧密码不对噢.";
static NSString *kAlertErrorVerifyCode = @"验证码错误.";
static NSString *kAlertDifferentPassword = @"两次输入的密码不一致,请再确认一下喔";
static NSString *kAlertPasswordSoslarm = @"密码长度为6-20位噢";

#define CQTViewAutoresizingMaskAll \
UIViewAutoresizingFlexibleBottomMargin | \
UIViewAutoresizingFlexibleHeight | \
UIViewAutoresizingFlexibleLeftMargin | \
UIViewAutoresizingFlexibleRightMargin | \
UIViewAutoresizingFlexibleTopMargin | \
UIViewAutoresizingFlexibleWidth;



#pragma mark - | ***** UIImage ***** |
#define Image(__key) [UIImage imageNamed:@#__key]
#define ImageWithStr(__key) [UIImage imageNamed:(__key)]
#define PlaceHolderImage ImageWithStr(__TEXT(placehold_image))
#define PlaceHolderImageName __TEXT(placehold_image)

#define ColorWithImage(__key)  [UIColor colorWithPatternImage:[UIImage imageNamed:@#__key]]

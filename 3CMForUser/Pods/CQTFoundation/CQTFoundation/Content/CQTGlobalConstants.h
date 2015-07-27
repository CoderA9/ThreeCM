//
//  CQTGlobalConstants.h
//  CQTIda
//
//  Created by ANine on 4/10/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

// #import "CQTGlobalConstants.h"

/**
 @brief 每个项目都能用到的一些拥有属性和宏定义  就放在这个文件
 
 @discussion <#some problem description with this class#>
 */

#import <UIKit/UIKit.h>
#import "Bee_Precompile.h"
/* iOS系统版本判断 */
#define iOS_IS_UP_VERSION(__cnt)    ([[[UIDevice currentDevice] systemVersion] floatValue] >=__cnt)

#define iOS_IS_DOWN_VERSION(__cnt)  ([[[UIDevice currentDevice] systemVersion] floatValue] < __cnt)

#define DEVICE_IS_IPHONE5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define CQT_CreateMutableArray(__Obj) \
if (!__Obj) {\
    __Obj = [[NSMutableArray alloc] initWithCapacity:0];\
}

#define CQT_CreateMutableDictionary(__Obj) \
if (!__Obj) {\
    __Obj = [[NSMutableDictionary alloc] initWithCapacity:0];\
}

#define numFromInt(x) [NSNumber numberWithInt:x]
#define numFromFloat(x) [NSNumber numberWithFloat:x]
#define numFromDouble(x) [NSNumber numberWithDouble:x]
#define numFromBool(x) [NSNumber numberWithBool:x]
#define numFromInteger(x)[NSNumber numberWithInteger:x]
#define numFromChar(x) [NSNumber numberWithChar:x]
#define numFromLong(x) [NSNumber numberWithLong:x]


#define NSStringFromInt(x) [NSString stringWithFormat:@"%d",x]
#define NSStringFromInteger(x) [NSString stringWithFormat:@"%ld",x]
#define NSStringFromInt02d(x) [NSString stringWithFormat:@"%02d",x]
#define NSStringFromFloat(x) [NSString stringWithFormat:@"%f",x]
#define NSStringFromFloat02f(x) [NSString stringWithFormat:@"%.2f",x]
#define NSStringFromBool(x) [NSString stringWithFormat:@"%d",x]


//#define ApplicationCallPhoneNum(__x) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSStringFormat(@"tel://%@",(__x))]];
#define ApplicationSendEmail(__x)  \
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSStringFormat(@"mailto://%@",(__x))]];

#define ApplicationSendSMS(__x) \
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSStringFormat(@"sms://%@",(__x))]];
#define ApplicationStartSafari(__x)\
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSStringFormat(@"%@",(__x))]];

#define ApplicationCallPhoneNum(__x) \
    UIWebView*callWebview =[[UIWebView alloc] init] ;\
\
    NSURL *telURL =[NSURL URLWithString:NSStringFormat(@"tel://%@",(__x))];\
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];\
\
    [[[UIApplication sharedApplication] keyWindow] addSubview:callWebview];\
    callWebview = nil;


/* 该方法仅适用于iOS8以后 */
#define ApplicationEnterSetting \
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];\
    if ([[UIApplication sharedApplication] canOpenURL:url]) {\
    [[UIApplication sharedApplication] openURL:url];\
    }\


#define NSStringFormat(firstarg, ...) ([NSString stringWithFormat:@"%@",[NSString stringWithFormat:firstarg, ##__VA_ARGS__ ]])


#define  getClassName(__obj) [NSString stringWithUTF8String:object_getClassName(__obj)]


#define LXAutomaticlyLoadImagePreference      @"image_autoload_in_cellular_preference"


#define APP_LOCAL_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APP_SHORT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 是否支持retina显示
#define CQT_SUPPORT_RETINA() \
[[UIScreen mainScreen] respondsToSelector:@selector(scale)] \
&& [[UIScreen mainScreen] scale] == 2.0

// user defaults的值对应 key
#define CQT_USERDEFAULTS_VALUE(key) \
[[NSUserDefaults standardUserDefaults] objectForKey:key];

static NSString *regexPhoneNum = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,1,5-9])|(17[0,1,5-9]))\\d{8}$";
//TODO:A9.     上线前请修改.同时将setting.bundle从工程中移除.
#if DEBUG

#define APP_IS_DEBUG  1

#else

#define APP_IS_DEBUG  0

#endif

#define FTP_FILE_PREFIX @"CQTIda"

#define APP_CURRENT_VERSION [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:(NSString*)kCFBundleVersionKey]]

/*
 * About va_list va_start va_end,please read this page http://www.cnblogs.com/hanyonglu/archive/2011/05/07/2039916.html
 *
 */
static inline id _CQTObject(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(v, UIEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

#define CQTObject(value) _CQTObject(@encode(__typeof__((value))), (value))



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


//#define _CQT_RELEASE(__view) CQT_RELEASE(__view)




#define CQTRemoveFromSuperViewSafely(__View) \
if ([__View.superview isKindOfClass:[UIView class]]) {\
[__View removeFromSuperview];\
}\


#define A9ViewReleaseSafely(view) \
if (view) {\
CQTRemoveFromSuperViewSafely(view)\
CQT_RELEASE(view);\
}\
view = nil;



#define A9ContainerReleaseSafely(Obj) \
if(Obj) { \
\
if([Obj isKindOfClass:[NSMutableArray class]]) { \
\
[Obj removeAllObjects];\
}\
\
CQT_RELEASE(Obj);\
}\
Obj = nil;


#define A9ObjectReleaseSafely(Obj) \
if(Obj) {\
CQT_RELEASE(Obj);\
}\
Obj = nil;


typedef enum _A9_ReleaseType{
    A9ReleaseCString,
    A9ReleaseView,
    A9ReleaseContainer,
}A9_ReleaseType;

/* 安全释放对象. */
#define A9_ObjectReleaseSafely(Obj)    A9ObjectReleaseSafely(Obj)
/* UIView安全释放. */
#define A9_ViewReleaseSafely(Obj)      A9ViewReleaseSafely(Obj)
/* 可变容器 安全释放. */
#define A9_ContainerReleaseSafely(Obj) A9ContainerReleaseSafely(Obj)
/* 安全释放一系列View. */
#define A9_ViewsRelease(size, ...) \
A9Release(A9ReleaseView, size, __VA_ARGS__)
/* 安全释放一系列Container. */
#define A9_ContainersRelease(size, ...) \
A9Release(A9ReleaseContainer,size, __VA_ARGS__)

static void A9Release(A9_ReleaseType  type, int size, ...) {
    
    int i = 0;
    va_list arg_ptr;
    void** _val = NULL;
    
    va_start(arg_ptr, size);
    switch (type) {
        case A9ReleaseCString: {
            for (i = 0; i< size; i++) {
                _val = (void**)va_arg(arg_ptr, char**);
                if (*_val) {
                    free(*_val);
                    *_val = nil;
                }
            }
        }break;
        case A9ReleaseView: {
            for (i = 0; i< size; i++) {
                _val = (void **)va_arg(arg_ptr, char**);
                if (*_val) {
                    //                    UIView *view = (__bridge UIView *)(*_val);
                    //                    for (__strong UIView *subView in view.subviews) {
                    //                        A9_ViewReleaseSafely(subView);
                    //                    }
                    [(__bridge UIView*)(*_val) removeFromSuperview];
#if !__has_feature(objc_arc)
                    [(__bridge UIView*)(*_val) release];
#endif
                    *_val = nil;
                }
            }
        }break;
        case A9ReleaseContainer: {
            for (i = 0; i< size; i++) {
                _val = (void **)va_arg(arg_ptr, char**);
                if (*_val) {
                    if ([(__bridge id)(* _val) respondsToSelector:@selector(removeAllObjects)]) {
                        [(__bridge id)(*_val) removeAllObjects];
                    }
#if !__has_feature(objc_arc)
                    [(__bridge id)(*_val) release];
#endif
                    *_val = nil;
                }
            }
        }break;
        default:
            break;
    }
    va_end(arg_ptr);
    return;
}

/* 通过RGB和Alpha值来获取UIColor对象 */
#define HEX_RGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

/* 通过RGB来获取UIColor对象 */
#define HEX_RGB(rgbValue) HEX_RGBA(rgbValue, 1)

#undef	RGB
#define RGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef	RGBA
#define RGBA(R,G,B,A)	[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

/* 角度转弧度 */
#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)
// 弧度转角度
#define RADIANS_TO_DEGREES(__DEGREE) ((__DEGREE / M_PI) * 180.f)

// 是否支持retina显示
#define DEVICE_SUPPORT_RETINA() \
[[UIScreen mainScreen] respondsToSelector:@selector(scale)] \
&& [[UIScreen mainScreen] scale] == 2.0


/* CGRect方法太多，用自定义的rect能够快速定义到想要的方法,以提高效率 */
#define ViewRect(FloatX,FloatY,FloatWidth,FloatHeight)   CGRectMake(FloatX, FloatY, FloatWidth, FloatHeight)

/* statusBar高度 */
#define STATUS_BAR_HEIGHT  CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])

/* view宽度 */
#define ViewWidth(__v)  CGRectGetWidth(__v.frame)

/* view高度 */
#define ViewHeight(__v)  CGRectGetHeight(__v.frame)

/* view的X点坐标 */
#define ViewX(__v)                      (__v).frame.origin.x

/* view的Y点坐标 */
#define ViewY(__v)                      (__v).frame.origin.y

/* view的底部Y坐标 */
#define ViewBottom(__v)                 (ViewY(__v) + ViewHeight(__v))

/* view的最右边X坐标 */
#define ViewRight(__v)                    (ViewX(__v) + ViewWidth(__v))

/* 屏幕宽度 */
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

/* 屏幕高度 */
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

/* 透明色 */
#define kClearColor [UIColor clearColor]


/* 灰显色 */
#define kDisableColor HEX_RGB(0x7F7E81)

/* 设置view的背景色颜色为无色 */
#define setClearColor(View)  View.backgroundColor = kClearColor

/* 设置系统字体 */

#define Font(__f) [UIFont systemFontOfSize:__f]

/* 设置系统粗体 */
#define BoldFont(__f) [UIFont boldSystemFontOfSize:__f]

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


# define ResignFstResponder(__obj) \
if([__obj isKindOfClass:[UITextField class]] || [__obj isKindOfClass:[UIDatePicker class]]) {\
if ([__obj isFirstResponder]) {\
[__obj resignFirstResponder];\
}\
}

#define delegateRespond(__obj,__method)  (nil != __obj && [__obj respondsToSelector:@selector(__method)])



#pragma mark - | ***** Notification ***** |

#define POST_NOTIFICATION(__key) [[NSNotificationCenter defaultCenter] postNotificationName:__key object:nil]

#define POST_NOTIFICATION_OBJ(__key,__obj) [[NSNotificationCenter defaultCenter] postNotificationName:__key object:__obj]





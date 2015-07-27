//
//  Util.h
//  CQTMemberCenter
//
//  Created by  sky on 11-5-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#pragma mark -
#pragma mark Math

#pragma mark -
#pragma mark Colors

#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]

#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#define UIColorFromRGB(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define kInvalidICharacters0     @"&"
#define kSpaceCharacter          @" "
#define kSingleQuoteCharacter    @"'"
#define kEnterChacter            @"\n"
//deivece
#define kDeviceSimulator  @"simulator"
#define kDeviceiPodTouch  @"iPod Touch"
#define kDeviceiPodTouch3 @"iPod Touch 3"
#define kDeviceiPhone2    @"iPhone2-"
#define kDeviceiPhone3    @"iPhone 3G"
#define kDeviceiPhone3GS  @"iPhone 3GS"
#define kDeviceiPhone4    @"iPhone 4"
#define kDeviceiPad1      @"iPad 1"
#define kUniversalUserUDIDKey            @"universalUserUDID"


#define kDateFormate0                    @"yyyyMMddHHmmss"
#define kDateFormate1                    @"yyyy-MM-dd HH:mm:ss"
#define kDateFormate2                    @"yyyy/MM/dd HH:mm:ss"
#define kDateFormate3                    @"yyyyMMdd"
#define kDateFormate4                    @"yyyy/MM/dd HH:mm:ss"
#define kDateFormate5                    @"yyyy-MM-dd HH:mm:ss.SSS"
#define kDateFormate6                    @"yyyy-MM-dd HH:mm"
#define kDateFormate7                    @"yyyy-MM-dd"
#define kDateFormate8                    @"HH:mm"

#define kBorderColor                  [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f]
#define boldFontColor                 [UIColor colorWithRed:0.290f green:0.149f blue:0.027 alpha:1.0f]
#define normalFontColor               [UIColor colorWithRed:0.612f green:0.435f blue:0.208f alpha:1.0f]

#define kNoConetent                    @""
#define kSeparator                     @","

#define kSizeB                         @"b"
#define kSizeKB                        @"KB"
#define kSizeMB                        @"M"
#define kSizeUnit                      1024
#define kSize100KB                     100*kSizeUnit
#define kSize250KB                     250*kSizeUnit
#define kSize350KB                     350*kSizeUnit
#define kSize300kB                     300*kSizeUnit
#define kSize600kB                     600*kSizeUnit
#define kSize1MB                       1024*kSizeUnit	
#define kSize3MB                       3*1024*kSizeUnit	
#define kSize5MB                       5*1024*kSizeUnit	


// Fuction
CGFloat DegreesToRadians(CGFloat degrees);
CGFloat RadiansToDegrees(CGFloat radians);
void CQTContextDrawTiledImage(CGContextRef context, CGRect rect, UIImage *img);
void CQTContextDrawImageInRect(CGContextRef context, UIImage *img, CGRect rect);
void CQTContextDrawImageInRectBlendAlpha(CGContextRef context, UIImage *img, CGRect rect, CGBlendMode bm, CGFloat alpha);
NSString* NBShortDateString(NSDate* dt);
UIImage *createGrayCopy(UIImage *source);
UIImage* createRoundImage4Sky(UIImage* soure, CGRect rect, float rounderBorderWidth);

@interface NSDictionary(Private)

- (NSString*)value4KeyPath:(NSString*)keyPath;
- (NSString*)value4Key:(NSObject*)key;
@end


@interface Util : NSObject {

}

//Device
+ (NSString*)deviceMACAddress;
+ (NSString*)currentDeviceVersion;

// View
+ (void)clipContext:(CGContextRef)context toRoundRect:(CGRect)rrect withRadius:(CGFloat)radius;
+ (void)roundedRectView:(UIView*)sourceView;
+ (void)changeFont4Segment:(UIView*)aView size:(CGSize)size font:(UIFont*)font;
+ (void)roundedRectView:(UIView*)sourceView withColor: (UIColor*)acColor;
+ (void)roundedRectView:(UIView*)sourceView withColor: (UIColor*)acColor borderColor: (UIColor*)acBorderColor;
+ (void)addButtonBorder:(UIButton*)acbutton withCornerRadius: (CGFloat)afCornerRadius andShowRadius: (CGFloat)afShowRadius;
+ (void)roundedRectView:(UIView *)sourceView withCornerRadius:(CGFloat)afCornerRadius andColor:(UIColor*)acColor;
+ (void)normlizeButton: (UIButton*)acbutton;
+ (void)addTextFieldLine:(CGRect)aframe container:(UIView*)aView offset4Y:(CGFloat)afOffset4Y;
+ (UIImage*)makeRoundCornerImage:(UIImage*)img :(int)cornerWidth :(int)cornerHeight;
//
+ (NSString*)webParamEncode:(NSString*)s;
+ (NSString*)filterInvaliedCharacters:(NSString*)strSource;  
+ (NSString*)filterCharacter:(NSString*)beFiltered strSource:(NSString*)strSource;
+ (NSString*)escapeSpecialChars: (NSString*)acstrInput;
+ (NSString*)stringFromDate:(NSDate*)date widthFormat:(NSString*)formate;
+ (NSString*)stringFromDate: (NSDate*)date type: (NSString*)dateFomatType;
+ (NSString*)appDocumentsDirectory; 
+ (NSString*)stringFromFileSizePath:(NSString*)path;
+ (NSString*)stringFromFileSize:(unsigned long long)number;
+ (unsigned long long)fileSizeWithPath:(NSString*)path; 
+ (NSString*)stringByCountInterval:(NSTimeInterval)interval;
+ (NSString*)shortDateTime:(NSString*)strDate withFormatter:(NSString*)formate;
+ (NSDate*)dateFromSecondsInterval:(NSTimeInterval)interval;
+ (NSDate*)dateFromString:(NSString*)strDate srcFormate:(NSString*)strSrcFormate;
+ (NSDate*)currentOriginDate:(NSDate*)date;
+ (NSString*)stringFromInterval:(NSTimeInterval)interval type:(NSInteger)type;
+ (NSString*)stringFromNumberTrim:(long long)number;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
+ (NSDictionary*)readPlist:(NSString*)filePath;
+ (NSString*)escapeSpcialCharacters:(NSString*)strSouce;
+ (NSString*)checkHttpPrefix:(NSString*)url;
+ (NSString*)thumbnailImageURL:(NSString*)url;

// Notify
+ (void)showNetworkIndicator;
+ (void)hideNetworkIndicator;
+ (void)alertNotOftenWithTitle:(NSString*)title andMessage:(NSString*)msg;
+ (void)alertWithTitle:(NSString*)title andMessage:(NSString*)msg;
+ (UILabel*)labelWithFont:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)bgColor alignmnet:(NSTextAlignment)alignment;
//+ (void)reportMsg:(NSString*)strMsg containerView:(UIView*)containerView shutdown:(BOOL)bShowdown;

// Image
+ (UIImage*)imageInRect4Sky:(CGRect)rect image:(UIImage*)img ;
+ (UIImage *)createImage: (CGImageRef) image width: (int) pixelWidth height: (int) pixelHeight;
+ (UIImage*)createRoundImage:(CGImageRef)image withWidth:(int)pixelWidth withHeight:(int)pixelHeight withRadius:(int)radius;
+ (UIImage*)createRoundImage:(CGImageRef)image withImgX:(int)imgX withImgY:(int)imgY withImgW:(int)imgW withImgH:(int)imgH withWidth:(int)pixelWidth withHeight:(int)pixelHeight withRadius:(int)radius;
+ (UIImage*)createImagesShadowImage:(CGImageRef)image
						   withImgX:(int)imgX
						   withImgY:(int)imgY
						   withImgW:(int)imgW
						   withImgH:(int)imgH
					withNewImgWidth:(int)pixelWidth 
				   withNewImgHeight:(int)pixelHeight 
					 withShadowOffX:(int)ShadowOffX
					 withShadowOffY:(int)ShadowOffY 
					withShadowWidth:(int)shadowWidth
					withShadowColor:(CGColorRef)shadowColor;
+ (UIImage *)scaleImage:(UIImage*)image toSize:(CGSize)limit;
+ (UIImage *)rotateImage:(UIImage *)image imageOrientation:(UIImageOrientation)imageOrientation;
+ (UIImage *)shotImageFrameView:(UIView*)view shotSize:(CGSize)size;

// Log
+ (void)LogDictionary:(NSDictionary*)dic;
+ (void)LogSystemFonts;

+ (void)dialPhoneNumber:(NSString*)strPhoneNumber;
+ (void)guideRoute:(NSString*)strSourceCoordinate  toCoodinate:(NSString*)strToDestinationCoordinate;

//备用函数（应急）：如果后台不能直接将图片重新指定尺寸，则用此函数本地进行处理
+ (NSString *)reFormatHTMLImage:(NSString *)strHTML;
+ (void) getInterfaceBytes;
+(void)wobbleView:(UIView*)view wobble:(BOOL)wobble;

@end

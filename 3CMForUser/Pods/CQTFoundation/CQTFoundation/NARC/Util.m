//
//  Util.m
//  CQTMemberCenter
//
//  Created by  sky on 11-5-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#import "Def.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "RegexKitLite.h"
#include <ifaddrs.h>
#include <net/if.h>
#include <sqlite3.h>

#import "CQTGlobalConstants.h"
#import <UIKit/UIKit.h>
#import "CQTLog.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
CGContextRef MyCreateBitmapContext (int pixelsWide,int pixelsHigh);


void CQTContextDrawTiledImage(CGContextRef context, CGRect rect, UIImage *img) {
	CGContextSaveGState(context);
	CGRect brect = CGContextGetClipBoundingBox(context);
	CGContextTranslateCTM(context, 0, brect.size.height + brect.origin.y*2);
	CGContextScaleCTM(context, 1, -1);
	rect.origin.y = brect.origin.y*2 - CGRectGetMinY(rect);
	CGContextDrawTiledImage(context, rect, img.CGImage);
	CGContextRestoreGState(context);
}

void CQTContextDrawImageInRect(CGContextRef context, UIImage *img, CGRect rect) {
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, 0, rect.size.height + rect.origin.y*2);
	CGContextScaleCTM(context, 1, -1);
	CGContextDrawImage(context, rect, img.CGImage);
	CGContextRestoreGState(context);
}

void CQTContextDrawImageInRectBlendAlpha(CGContextRef context, UIImage *img, CGRect rect, CGBlendMode bm, CGFloat alpha) {
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, 0, rect.size.height + rect.origin.y*2);
	CGContextScaleCTM(context, 1, -1);
	CGContextSetAlpha(context, alpha);
	CGContextSetBlendMode(context, bm);
	CGContextDrawImage(context, rect, img.CGImage);
	CGContextRestoreGState(context);
}

UIImage *createGrayCopy(UIImage *source) {
    
    UIImage *grayImage = nil;
	int width = source.size.width;
	int height = source.size.height;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  kCGImageAlphaNone);
	CGColorSpaceRelease(colorSpace);
	if (context != NULL) {

        CGContextDrawImage(context, CGRectMake(0, 0, width, height), source.CGImage);
        grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
        CGContextRelease(context);
	}

	return grayImage;
}

UIImage* createRoundImage4Sky(UIImage* soures, CGRect rect, float rounderBorderWidth) {
    
    // Drawing code
    UIImage *destImage = nil;
    if (soures != nil) {
    
//  UIImage *ssImage = [Util scaleImage:soures toSize:rect.size];
    UIImage *ssImage  = soures;
    
    CGFloat colors[6] = {1.f, 0.75f, 1.f, 0.f, 0.f, 0.f};
    CGFloat colorStops[3] = {1.f, 0.35f, 0.f};
    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
    CGGradientRef alphaGradient = CGGradientCreateWithColorComponents(grayColorSpace, colors, colorStops, 3);
    CGColorSpaceRelease(grayColorSpace);
    
    // Image rect
    CGRect imageRect = CGRectMake(rounderBorderWidth, rounderBorderWidth ,
                                  (int)(rect.size.width - 2*rounderBorderWidth), (int)(rect.size.height -2*rounderBorderWidth));
    
    // Start working with the mask
    CGColorSpaceRef maskColorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef mainMaskContextRef = CGBitmapContextCreate(NULL,
                                                            rect.size.width,
                                                            rect.size.height,
                                                            8,
                                                            rect.size.width,
                                                            maskColorSpaceRef,
                                                            0);
    CGContextRef shineMaskContextRef = CGBitmapContextCreate(NULL,
                                                             rect.size.width,
                                                             rect.size.height,
                                                             8,
                                                             rect.size.width,
                                                             maskColorSpaceRef,
                                                             0);
    CGColorSpaceRelease(maskColorSpaceRef);
    CGContextSetFillColorWithColor(mainMaskContextRef, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(shineMaskContextRef, [UIColor blackColor].CGColor);
    CGContextFillRect(mainMaskContextRef, rect);
    CGContextFillRect(shineMaskContextRef, rect);
    CGContextSetFillColorWithColor(mainMaskContextRef, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(shineMaskContextRef, [UIColor whiteColor].CGColor);
    
    // Create main mask shape
    CGContextMoveToPoint(mainMaskContextRef, 0, 0);
    CGContextAddEllipseInRect(mainMaskContextRef, imageRect);
    CGContextFillPath(mainMaskContextRef);
    
    // Create shine mask shape
    CGContextTranslateCTM(shineMaskContextRef, -(rect.size.width / 4), rect.size.height / 4 * 3);
    CGContextRotateCTM(shineMaskContextRef, -45.f);
    CGContextMoveToPoint(shineMaskContextRef, 0, 0);
    CGContextFillRect(shineMaskContextRef, CGRectMake(0,
                                                      0,
                                                      rect.size.width / 8 * 5,
                                                      rect.size.height));
    
    CGImageRef mainMaskImageRef = CGBitmapContextCreateImage(mainMaskContextRef);
    CGImageRef shineMaskImageRef = CGBitmapContextCreateImage(shineMaskContextRef);
    CGContextRelease(mainMaskContextRef);
    CGContextRelease(shineMaskContextRef);
    // Done with mask context
    
    //modify by sky
    CGContextRef contextRef = MyCreateBitmapContext(rect.size.width, rect.size.height);
    CGContextSaveGState(contextRef);
   
    CGImageRef imageRef = CGImageCreateWithMask(ssImage.CGImage, mainMaskImageRef);
    
    //
//    CGContextTranslateCTM(contextRef, 0, rect.size.height);
//    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    CGContextSaveGState(contextRef);
    
    // Draw image
    CGContextDrawImage(contextRef, rect, imageRef);
    
    CGContextRestoreGState(contextRef);
    CGContextSaveGState(contextRef);
    
    // Clip to shine's mask
    CGContextClipToMask(contextRef, rect, mainMaskImageRef);
    CGContextClipToMask(contextRef, rect, shineMaskImageRef);
    CGContextSetBlendMode(contextRef, kCGBlendModeLighten);
    CGContextDrawLinearGradient(contextRef, alphaGradient, CGPointMake(0, 0), CGPointMake(0, rect.size.height), 0);
    
    CGImageRelease(mainMaskImageRef);
    CGImageRelease(shineMaskImageRef);
    CGImageRelease(imageRef);
    // Done with image
    
    CGContextRestoreGState(contextRef);
    
    CGContextSetLineWidth(contextRef,2.0f);
    CGContextSetStrokeColorWithColor(contextRef,[UIColor whiteColor].CGColor);
    CGContextMoveToPoint(contextRef, 0, 0);
    CGContextAddEllipseInRect(contextRef, imageRect);
    // Drop shadow
    CGContextSetShadowWithColor(contextRef,CGSizeMake(0, 0),2.0f, [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:.75f].CGColor);
    CGContextStrokePath(contextRef);
    CGContextRestoreGState(contextRef);
    
    //
    CGImageRef myRef = CGBitmapContextCreateImage (contextRef);
    destImage = [UIImage imageWithCGImage:myRef];
    free(CGBitmapContextGetData(contextRef));
    CGContextRelease(contextRef);
    CGImageRelease(myRef);
    
    }
    return destImage;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


//
NSString* NBShortDateString(NSDate* dt) {
	
	if(!dt) return @"";
	
	NSTimeInterval ti = - [dt timeIntervalSinceNow];
	if(ti < 60)
		return @"less than 1m";
	else if(ti < 60 * 60)
		return [NSString stringWithFormat:@"%dm", (int)(ti/60)];
	else if(ti < 60 * 60 * 24)
		return [NSString stringWithFormat:@"%dh", (int)(ti/3600)];
	else if(ti < 60 * 60 * 24 * 30)
		return [NSString stringWithFormat:@"%dd", (int)(ti/3600/24)];
	else if(ti < 60 * 60 * 24 * 30 * 12)
		return [NSString stringWithFormat:@"%dmo", (int)(ti/3600/24/30)];
	else
		return [NSString stringWithFormat:@"%dy", (int)(ti/3600/24/30/12)];
}

@implementation NSDictionary(Private)

- (NSString*)value4KeyPath:(NSString*)keyPath {
    
    NSString *value = [self valueForKeyPath:keyPath];
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        
        value = @"";
    }
    else if([value isKindOfClass:[NSNumber class]]) {
    
        value = [NSString stringWithFormat:@"%@", value];
    }
    
    return value;
}

- (NSString*)value4Key:(NSString*)key {

    NSString *value = [self valueForKey:key];
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        
        value = @"";
    }
    return value;
}
@end

@implementation Util

#pragma mark -
#pragma draw

+ (void)clipContext:(CGContextRef)context toRoundRect:(CGRect)rrect withRadius:(CGFloat)radius {
	
	CGFloat minx = (int)CGRectGetMinX(rrect);
	CGFloat midx = (int)CGRectGetMidX(rrect);
	CGFloat maxx = (int)CGRectGetMaxX(rrect);
	CGFloat miny = (int)CGRectGetMinY(rrect);
	CGFloat midy = (int)CGRectGetMidY(rrect);
	CGFloat maxy = (int)CGRectGetMaxY(rrect);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextClip(context);
}

#pragma mark -

+ (void)roundedRectView:(UIView*)sourceView {
	
	if ([(NSObject*)sourceView isKindOfClass:[UIButton class]])
		[(UIButton*)sourceView setTitleColor:boldFontColor forState:UIControlStateNormal];
//	sourceView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
	sourceView.layer.cornerRadius = 6.0f;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) sourceView.layer.borderWidth = 2.0f;
	else sourceView.layer.borderWidth = 2.0f;
	sourceView.layer.masksToBounds = YES;
	sourceView.clipsToBounds = YES;
}

+ (void)roundedRectView:(UIView*)sourceView withColor: (UIColor*)acColor{
	
	sourceView.backgroundColor = acColor;
	sourceView.layer.borderColor = [[UIColor whiteColor] CGColor];
	sourceView.layer.cornerRadius = 5.0f;
	sourceView.layer.borderWidth = 2.0f;
	sourceView.layer.masksToBounds = YES;
	sourceView.clipsToBounds = YES;
}

+ (void)roundedRectView:(UIView*)sourceView withColor: (UIColor*)acColor borderColor: (UIColor*)acBorderColor {
	
	sourceView.backgroundColor = acColor;
	sourceView.layer.borderColor = [acBorderColor CGColor];
	sourceView.layer.cornerRadius = 3.0f;
	sourceView.layer.borderWidth = 1.0f;
	sourceView.layer.masksToBounds = YES;
	sourceView.clipsToBounds = YES;
}

+ (void)addButtonBorder: (UIButton*)acbutton withCornerRadius: (CGFloat)afCornerRadius andShowRadius: (CGFloat)afShowRadius{
	acbutton.layer.cornerRadius = afCornerRadius;
	//self.layer.frame = CGRectInset(self.layer.frame, 20, 20);
	acbutton.layer.shadowOffset = CGSizeMake(0, 1);
	acbutton.layer.shadowRadius = afShowRadius;
	acbutton.layer.shadowColor = [UIColor whiteColor].CGColor;
	acbutton.layer.shadowOpacity = 1.0f;
	
	acbutton.layer.borderColor = [UIColor whiteColor].CGColor;
	acbutton.layer.borderWidth = 2.0f;
}

+ (void)roundedRectView:(UIView *)sourceView withCornerRadius:(CGFloat)afCornerRadius andColor:(UIColor*)acColor{
	sourceView.layer.cornerRadius = afCornerRadius;	
	sourceView.layer.borderColor = acColor.CGColor;
	sourceView.layer.borderWidth = 1.0f;
}

+ (void)normlizeButton: (UIButton*)acbutton {
	[acbutton setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forState:UIControlStateNormal];
	acbutton.titleLabel.font = [UIFont boldSystemFontOfSize:17];  
	acbutton.titleLabel.shadowColor = [UIColor darkGrayColor];
	acbutton.titleLabel.shadowOffset = CGSizeMake(0, -1);
	acbutton.layer.borderColor = [[UIColor grayColor] CGColor];
	acbutton.layer.cornerRadius = 5.0f;
	acbutton.layer.borderWidth = 1.0f;
	acbutton.layer.masksToBounds = YES;
	acbutton.clipsToBounds = YES;	
}

+ (void)addTextFieldLine:(CGRect)aframe container:(UIView*)aView offset4Y:(CGFloat)afOffset4Y{
	
	aframe.origin.y += aframe.size.height-afOffset4Y;
	aframe.size.height = 1.0f;
	UILabel * lineLabel = [[UILabel alloc] initWithFrame:aframe];
	lineLabel.backgroundColor = kBorderColor;//tableCellSeparatorColor;
	[aView addSubview:lineLabel];
	[lineLabel release];
	
}

+ (NSString*)webParamEncode:(NSString*)s {
	
	return [(NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)s, NULL, (CFStringRef)@"&, +，", kCFStringEncodingUTF8) autorelease];
}

#pragma mark charactersFilter

+ (NSString*)stringTrimSpaceWithString:(NSString*)strSource {
    
	NSString *str = [NSString stringWithFormat:@"%@", strSource];
    NSRange range = [str rangeOfString:kSpaceCharacter];
    if (range.location == 0) {
        
        NSRange r = {0, 1};
        str = [str stringByReplacingCharactersInRange:r withString:kNoConetent];
        return [Util stringTrimSpaceWithString:str];
    }
	NSString *strDest = [NSString stringWithFormat:@"%@", str];
	return strDest;
}

+ (NSString*)filterInvaliedCharacters:(NSString*)strSource {
	
	NSString *strToFilter = [NSString stringWithFormat:@"%@", strSource];
	if ([strToFilter length]>0) {
		
		strToFilter = [Util stringTrimSpaceWithString:strToFilter];
		if ([strToFilter length]>0) {
			
			NSArray *invidCharacters = [kInvalidICharacters0 componentsSeparatedByString:@"|"];
			for (int i=0; i<[invidCharacters count]; i++) {
				
				strToFilter = [Util filterCharacter:[invidCharacters objectAtIndex:i] strSource:strToFilter];
			}
		}
	}
    
	return strToFilter;
}

+ (NSString*)filterCharacter:(NSString*)beFiltered strSource:(NSString*)strSource {
	
	NSString *strToFilter = [NSString stringWithFormat:@"%@", strSource];	
	if ([strToFilter length]>0) {
        
		strToFilter = [strToFilter stringByReplacingOccurrencesOfString:beFiltered withString:kNoConetent];
	}
	
	return strToFilter;
}

#pragma mark -

#pragma mark -

+ (void)changeFont4Segment:(UIView*)aView size:(CGSize)size font:(UIFont*)font {
    
    if ([aView isKindOfClass:[UILabel class]]) {
        
        UILabel *lb = (UILabel *)aView;
        [lb setTextAlignment:NSTextAlignmentCenter];
        [lb setFrame:CGRectMake(0, 0, size.width, size.height)];
        [lb setFont:font];
    }
    
    NSArray *na = [aView subviews];
    NSEnumerator *ne = [na objectEnumerator];
    UIView *subView;
    while (subView = [ne nextObject]) {
        
        [Util changeFont4Segment:subView size:size font:font];
    }
}

+ (NSString*)escapeSpecialChars: (NSString*)acstrInput {
    if (acstrInput == nil ) {
        return nil;
    }	
	acstrInput = [acstrInput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	acstrInput = [acstrInput stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
	NSCharacterSet* ccharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"';\"&%%\\"];
	return [acstrInput stringByTrimmingCharactersInSet:ccharacterSet];
}

+ (NSString*)stringFromDate:(NSDate*)date widthFormat:(NSString*)formate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formate];
	NSString *strDate = [[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:date]];
	[dateFormatter release];
    return  [strDate autorelease];
}

+ (NSString *)deviceMACAddress {
	
    NSString *outstring = [[NSUserDefaults standardUserDefaults] objectForKey:kUniversalUserUDIDKey];
    if (outstring == nil || [outstring length]==0) {
    
        int                    mib[6];
        size_t                len;
        char                *buf;
        unsigned char        *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl    *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex("en0")) == 0) {
            
            printf("Error: if_nametoindex error/n");
            return NULL;
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            
            printf("Error: sysctl, take 1/n");
            return NULL;
        }
        
        if ((buf = malloc(len)) == NULL) {
            
            printf("Could not allocate memory. error!/n");
            return NULL;
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            
            printf("Error: sysctl, take 2");
            free(buf);
            return NULL;
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        free(buf);
    }
    
    return [outstring uppercaseString];
}

/*
 *  get the information of the device and system
 *  "i386"          simulator
 *  "iPod1,1"       iPod Touch
 *  "iPhone1,1"     iPhone
 *  "iPhone1,2"     iPhone 3G
 *  "iPhone2,1"     iPhone 3GS
 *  "iPad1,1"       iPad
 *  "iPhone3,1"     iPhone 4
 *  @return null
 */
+ (NSString*)currentDeviceVersion {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *strDeviceVersion = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	
	//	CQTKeyTimeLog(@"strDeviceVersion= %@", strDeviceVersion);	
	//    if (strDeviceVersion != nil) {
	//        
	//        if ([strDeviceVersion isEqualToString:@"i386"] || [strDeviceVersion isEqualToString:@"x86_64"]) {
	//            
	//            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceSimulator];
	//        }else if([strDeviceVersion isEqualToString:@"iPod1,1"]){
	//            
	//            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPodTouch];
	//        } 
	//        else if([strDeviceVersion isEqualToString:@"iPod2,1"]){
	//            
	//            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPodTouch3];
	//        }
	//        else if([strDeviceVersion isEqualToString:@"iPhone1,1"]){
	//            
	//            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPhone2];
	//        }
	//        else if([strDeviceVersion isEqualToString:@"iPhone1,2"]){
	//            
	//            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPhone3];
	//        }
	//        else if([strDeviceVersion isEqualToString:@"iPhone2,1"]){
	//            
	//            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPhone3GS];
	//        }
	//        else if([strDeviceVersion isEqualToString:@"iPhone3,1"]){
	//              
	//        }
	//        else if([strDeviceVersion isEqualToString:@"iPad1,1"]){
	//            
	//            strDeviceVersion = [NSString stringWithFormat:@"%@", kDeviceiPad1];
	//        }else {
	//            
	//            strDeviceVersion = @"Other Device";
	//        }
	//    }else {
	//        
	//        strDeviceVersion = @"unknow device";
	//    }
	
	if ([strDeviceVersion rangeOfString:@"iPhone"].location != NSNotFound || [strDeviceVersion rangeOfString:@"iPod"].location != NSNotFound) {
		
		strDeviceVersion = [NSString stringWithFormat:@"iphone"];
	}
    else if([strDeviceVersion rangeOfString:@"iPad"].location != NSNotFound) {
		
		strDeviceVersion = [NSString stringWithFormat:@"ipad"];
	}else {
		
        strDeviceVersion = [NSString stringWithFormat:@"iphone"];
    }
    
    return strDeviceVersion;
}

+ (NSString*)appDocumentsDirectory {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];;
}

//file size
+ (NSString*)stringFromFileSizePath:(NSString*)path {
	
	NSArray *paths = [path componentsSeparatedByString:@","];
	NSString *strFileSize = nil;
	NSString* cstrMediaFullPath = nil;
    unsigned long long totalSize = 0;
	for (NSString *str in paths) {
		
		NSError *error = nil;
		NSDictionary *fileDic = [[NSFileManager defaultManager] attributesOfItemAtPath:cstrMediaFullPath error:&error];
		if (error == nil) {			
			unsigned long long  size = [fileDic fileSize];
			totalSize += size;
		}
		cstrMediaFullPath = nil;
	}
	
	strFileSize = [[NSString alloc] initWithFormat:@"%@", [Util stringFromFileSize:totalSize]];
	//	CQTKeyTimeLog(@"strFileSize = %@", strFileSize);
	return [strFileSize autorelease];
}

+ (NSString*)stringFromFileSizePathWithoutPrefix:(NSString*)path {
	
	NSArray *paths = [path componentsSeparatedByString:@","];
	NSString *strFileSize = nil;
    unsigned long long totalSize = 0;
	for (NSString *str in paths) {
		NSError *error = nil;
		NSDictionary *fileDic = [[NSFileManager defaultManager] attributesOfItemAtPath:str error:&error];
		if (error == nil) {
			
			unsigned long long  size = [fileDic fileSize];
			totalSize += size;
		}
	}
	
	strFileSize = [[NSString alloc] initWithFormat:@"%@", [Util stringFromFileSize:totalSize]];
	//	CQTKeyTimeLog(@"strFileSize = %@", strFileSize);
	return [strFileSize autorelease];
}

+ (NSString*)stringFromFileSize:(unsigned long long)number {
	
	NSString *strFileSize = nil;
	if (number<(kSizeUnit*kSizeUnit)) {
		
		if (number<kSizeUnit) {
			
			strFileSize = [[NSString alloc] initWithFormat:@"%.f%@", (float)number, kSizeB];
		}
		else {
			
			strFileSize = [[NSString alloc] initWithFormat:@"%i%@", (int)(number/kSizeUnit), kSizeKB];
		}
	}
	else {
		strFileSize = [[NSString alloc] initWithFormat:@"%.1f%@", (double)number/(kSizeUnit*kSizeUnit), kSizeMB];
	}	
	return [strFileSize autorelease];
}

+ (unsigned long long)fileSizeWithPath:(NSString*)path {
	
	NSError *error = nil;
	unsigned long long  size = 0;
	if (path != nil) {
		
		NSDictionary *fileDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
		if (error == nil) {
			
			size = [fileDic fileSize];
		}
	}
	return size;
}

//date
+ (NSString*)stringFromDate:(NSDate*)date type:(NSString*)dateFomatType {
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle :NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle: NSDateFormatterShortStyle];
	[dateFormatter setDateFormat: dateFomatType];
	NSString* stringDate = [dateFormatter stringFromDate: date];
    stringDate = (stringDate == nil)?@"":stringDate;
	[dateFormatter release];
	return  stringDate;
}

+ (NSString*)stringByCountInterval:(NSTimeInterval)interval {
	
	NSString *strTime = kNoConetent;
	long long hour = (int)(floor(interval+0.5))/3600;
	long long min = (int)(floor(interval+0.5))%3600/60;
    long long sec = (int)(floor(interval+0.5))%3600%60;
    if (hour>0) {
        
        strTime = [strTime stringByAppendingFormat:@"%lld%@", hour, @"小时"];
    }
    if (min>0) {
     
        strTime = [strTime stringByAppendingFormat:@"%lld%@", min, @"分"];
    }
    if (sec>0 || (hour==0 && min == 0)) {
        
        strTime = [strTime stringByAppendingFormat:@"%lld%@", sec, @"秒"];
    }
    
	return strTime;
}

+ (NSDate*)dateFromSecondsInterval:(NSTimeInterval)interval {
    
	NSDate * date = [[[NSDate alloc] initWithTimeIntervalSince1970:interval] autorelease];
	return date;
}

+ (NSString*)shortDateTime:(NSString*)strDate withFormatter:(NSString*)formate {
	
	NSString *strTipDate = nil;
	NSString *strToday = @"今天";
	NSString *strYearsterday = @"昨天";
    NSString *strJustNow = @"刚刚";
	NSString *strBeforeYesterday = @"前天";
	if (strDate != nil && formate != nil) {
		
		strDate = [strDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:formate];
		NSDate *thatDate = [dateFormatter dateFromString:strDate];
	
		long long interval =  (long long)[[NSDate date] timeIntervalSinceDate:thatDate];
		if (interval<10) {
			
			strTipDate = [[[NSString alloc] initWithFormat:@"%@", strJustNow] autorelease];
		}
		else if(interval<60) {
			
			strTipDate = [[[NSString alloc] initWithFormat:@"%lld秒前", interval] autorelease];
		}
		else if(interval<60*60) {
			
			strTipDate = [[[NSString alloc] initWithFormat:@"%lld分钟前", interval/60] autorelease];
		}
		else if(interval<2*60*60) {
			
			strTipDate = [[[NSString alloc] initWithFormat:@"%lld小时前", interval/60/60] autorelease];
		}
		else {
			
			thatDate = [Util currentOriginDate:thatDate];
			NSDate *todayDate = [Util currentOriginDate:[NSDate date]];
			if ([thatDate isEqualToDate:todayDate]) {
				
				NSRange range = {11, 5}; //HH:mm
				strTipDate = [[[NSString alloc] initWithFormat:@"%@%@", strToday, [strDate substringWithRange:range]] autorelease];
			}
			else {
				
				interval =  (long long)[todayDate timeIntervalSinceDate:thatDate];
				if (interval == 24*60*60) {
					
					NSRange range = {11, 5}; //HH:mm
					strTipDate = [[[NSString alloc] initWithFormat:@"%@%@", strYearsterday,[strDate substringWithRange:range]] autorelease];
				}
				else if(interval == 2*24*60*60) {
					
					NSRange range = {11, 5}; //HH:mm
					strTipDate = [[[NSString alloc] initWithFormat:@"%@%@", strBeforeYesterday,[strDate substringWithRange:range]] autorelease];
				}
				else {
					
					NSRange range = {0, 10}; //yyyy-MM-dd
					strTipDate = [[[NSString alloc] initWithFormat:@"%@",[strDate substringWithRange:range]] autorelease];
				}
			}
		}
		
		[dateFormatter release];
	}
	
	return strTipDate;
}

+ (NSDate*)currentOriginDate:(NSDate*)date {
	
	NSLocale* locale   = [NSLocale systemLocale];
	NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
	[calendar setLocale: locale];
	NSInteger unitFlags = NSYearCalendarUnit |
	NSMonthCalendarUnit |
	NSDayCalendarUnit |
	NSWeekdayCalendarUnit|
	NSHourCalendarUnit |
	NSMinuteCalendarUnit |
	NSSecondCalendarUnit;
	NSDateComponents *comps = [calendar components: unitFlags fromDate:date];
	[comps setHour: 00];
	[comps setMinute: 00];
	[comps setSecond: 00];
	NSDate* thatDate = [calendar dateFromComponents: comps];
	return thatDate;
}

+ (NSDate*)dateFromString:(NSString*)strDate srcFormate:(NSString*)strSrcFormate {
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:strSrcFormate];
	NSDate *toDate = [dateFormatter dateFromString:strDate];
	[dateFormatter release];
	return toDate;
}

+ (NSString*)stringFromInterval:(NSTimeInterval)interval type:(NSInteger)type {
	
	NSInteger hour = 0;
	NSInteger min = 0;
	NSInteger sec = 0;
	NSString *strZero = @"0";
	NSString *strSeparator = @":";
	NSString *strTime = kNoConetent;
	hour = (int)(floor(interval+0.5))/3600;
	min = (int)(floor(interval+0.5))%3600/60;
	sec = (int)(floor(interval+0.5))%3600%60;;
	
	if (type == 0) {
		
		NSString *strHour = [NSString stringWithFormat:@"%i",hour];
		NSString *strMin = [NSString stringWithFormat:@"%i",min];
		NSString *strSec = [NSString stringWithFormat:@"%i",sec];
		
		if(hour<10){
			
			strHour = [NSString stringWithFormat:@"%@%i", strZero, hour];
		}
		
		if(min<10){
			
			strMin = [NSString stringWithFormat:@"%@%i", strZero, min];
		}
		
		if(sec<10){
			
			strSec = [NSString stringWithFormat:@"%@%i", strZero, sec];
		}
		
		strTime = [NSString stringWithFormat:@"%@%@%@%@%@", strHour,strSeparator, strMin, strSeparator, strSec];
	}
	else {
		
		if (hour>0) {
			
			strTime = [NSString stringWithFormat:@"%i%@", hour, strSeparator];
			if (min>=10) {
				
				strTime = [strTime stringByAppendingFormat:@"%i%@", min, strSeparator];
			}
			else {
				
				strTime = [strTime stringByAppendingFormat:@"%@%i%@", strZero, min, strSeparator];
			}
			
			if (sec>=10) {
				
				strTime = [strTime stringByAppendingFormat:@"%i", sec];
			}
			else {
				
				strTime = [strTime stringByAppendingFormat:@"%@%i", strZero, sec];
			}
		}
		else {
			if (min>=10) {
				
				strTime = [strTime stringByAppendingFormat:@"%i%@%i%@", hour, strSeparator, min, strSeparator];
			}
			else {
				
				strTime = [strTime stringByAppendingFormat:@"%i%@", min, strSeparator];
			}
			
			if (sec>=10) {
				
				strTime = [strTime stringByAppendingFormat:@"%i", sec];
			}
			else {
				
				strTime = [strTime stringByAppendingFormat:@"%@%i", strZero, sec];
			}
		}
	}
	
	NSString *str = [[[NSString alloc] initWithFormat:@"%@", strTime] autorelease];
	return str;
}

+ (NSString*)stringFromNumberTrim:(long long)number {
	
	long long l = number;
	NSString *strMillion = @"%d百万+";
	NSString *strBillion = @"%d亿+";
	NSString *strDestination = kNoConetent;
	long long mil = 10000*100;
	if (l>(mil*100)) {
		
		strDestination = [[[NSString alloc] initWithFormat:strBillion, l/(mil*100)] autorelease];
	}
	else {
		
		if (l>mil) {
			
			strDestination = [[[NSString alloc] initWithFormat:strMillion, l/mil] autorelease];
		}
		else {
			
		    strDestination = [[[NSString alloc] initWithFormat:@"%lld", l] autorelease];
		}
	}
	
	//	CQTDebugLog(@"string=%@ k=%d",strDestination, l);
	return strDestination;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    NSLog(@"fixOrientation.......");
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (NSDictionary*)readPlist:(NSString*)filePath {

//  NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"listFileName" ofType:@"plist"];
//  NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    return [dictionary autorelease];
}

+ (NSString*)escapeSpcialCharacters:(NSString*)strSouce {
	
	NSString *str = kNoConetent;
	if ([strSouce length]>0) {
		
		str = strSouce;
		char *zSQL = sqlite3_mprintf("%q", [str cStringUsingEncoding:NSUTF8StringEncoding]);
		str = [NSString stringWithCString:zSQL encoding:NSUTF8StringEncoding];
//		str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"\\/"];
//		str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
//		str = [str stringByReplacingOccurrencesOfString:@"[" withString:@"\\["];
//		str = [str stringByReplacingOccurrencesOfString:@"]" withString:@"\\]"];
//		str = [str stringByReplacingOccurrencesOfString:@"%" withString:@"\\%"];
//		str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"\\&"];
//		str = [str stringByReplacingOccurrencesOfString:@"_" withString:@"\\_"];
//		str = [str stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
//		str = [str stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
	}
	return str;
}

+ (NSString*)checkHttpPrefix:(NSString*)url {

    NSString *newURL = kNoConetent;
    if (url != nil) {
        
        newURL = ([url rangeOfString:@"http://"].location == NSNotFound)?[NSString stringWithFormat:@"%@%@",@"http://",url]:url;
    }
    return newURL;
}

+ (NSString*)thumbnailImageURL:(NSString*)url {

    NSString *thumbnailURL = kNoConetent;
    if (([url rangeOfString:kHttpPrevfix].location != NSNotFound)) {
        
        NSString *tail = [url lastPathComponent];
        NSArray *array = [tail componentsSeparatedByString:@"."];
        if ([array count]==2) {
            
           NSRange rang = [url rangeOfString:tail];
            if (rang.location != NSNotFound) {
             
                thumbnailURL = [NSString stringWithFormat:@"%@%@_s.%@",[url substringToIndex:rang.location], array[0],array[1]];
            }
        }
    }
    return thumbnailURL;
}

#pragma mark -
#pragma mark Net

static int _networkIndicatorRetainCount = 0;

+ (void)showNetworkIndicator {
	
	_networkIndicatorRetainCount++;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void)hideNetworkIndicator {
	if(_networkIndicatorRetainCount > 0)
		_networkIndicatorRetainCount--;
	if(_networkIndicatorRetainCount <= 0)
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark alert

static BOOL alertViewShown = NO;
static NSString *alertMsgText = nil;
static NSTimeInterval alertInterval;

+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	alertViewShown = NO;
}

+ (void)alertWithTitle:(NSString*)title andMessage:(NSString*)msg {
	
    NSString *prodName =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(title == nil)?prodName : title
													message:msg
												   delegate:[self class]
										  cancelButtonTitle:@"OK!"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)alertNotOftenWithTitle:(NSString*)title andMessage:(NSString*)msg {	
	
	NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
	if(ti - alertInterval < 3) {
		
		if(alertViewShown || [msg isEqualToString:alertMsgText]) return;
	}
	alertViewShown = YES;
	alertMsgText = [msg copy];
	alertInterval = ti;
	
    NSString *prodName =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(title == nil) ? prodName : title
													message:msg
												   delegate:[self class]
										  cancelButtonTitle:@"OK!"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (UILabel*)labelWithFont:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)bgColor alignmnet:(NSTextAlignment)alignment  {
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.textAlignment = alignment;
	label.backgroundColor = (bgColor!=nil)? bgColor:[UIColor clearColor];
	label.font = font;
	label.textColor = textColor;
	return  [label autorelease];
}


#pragma mark -
#pragma mark Log

+ (void)LogDictionary:(NSDictionary*)dic {
	
	for (NSString *strkey in [dic allKeys]) {
		
		id value = [dic valueForKey:strkey];
		CQTDebugLog(@"%@:%@", strkey, value);
	}
}

+ (void)LogSystemFonts {

    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames) {
        
        CQTDebugLog(@"------------------[%@]----------------", familyName);
        NSArray *fontNames4Family = [UIFont fontNamesForFamilyName:familyName];
        for (NSString *fontName in fontNames4Family) {
            
            CQTDebugLog(@"fontName=%@", fontName);
        }
    }
}

#pragma mark -

// MyCreateBitmapContext: Source based on Apple Sample Code
CGContextRef MyCreateBitmapContext (int pixelsWide,int pixelsHigh){
	CGContextRef	context = NULL;
	CGColorSpaceRef colorSpace;
	void *		  bitmapData;
	int			 bitmapByteCount;
	int			 bitmapBytesPerRow;
	
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount	 = (bitmapBytesPerRow * pixelsHigh);
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedLast);
	if (context== NULL)
	{
		free (bitmapData);
		CGColorSpaceRelease( colorSpace );
		fprintf (stderr, "Context not created!");
		return NULL;
	}
	CGColorSpaceRelease( colorSpace );
	
	return context;
}

// Draw the image into a pixelsWide x pixelsHigh bitmap and use that bitmap to 
// create a new UIImage 
+ (UIImage *)createImage: (CGImageRef) image width: (int) pixelWidth height: (int) pixelHeight { 
	// Set the size of the output image 
	CGRect aRect = CGRectMake(0.0f, 0.0f, pixelWidth, pixelHeight); 
	// Create a bitmap context to store the new thumbnail 
	CGContextRef context = MyCreateBitmapContext(pixelWidth, pixelHeight); 
	// Clear the context and draw the image into the rectangle 
	CGContextClearRect(context, aRect); 
	CGContextDrawImage(context, aRect, image); 
	// Return a UIImage populated with the new resized image 
	CGImageRef myRef = CGBitmapContextCreateImage (context); 
	
	UIImage *img = [UIImage imageWithCGImage:myRef];
	
	free(CGBitmapContextGetData(context)); 
	CGContextRelease(context);
	CGImageRelease(myRef);
	
	return img; 
} 

+ (UIImage*)createRoundImage:(CGImageRef)image withWidth:(int)pixelWidth withHeight:(int)pixelHeight withRadius:(int)radius {
	
    // Set the size of the output image
	CGRect aRect = CGRectMake(0.0f, 0.0f, (int)pixelWidth, (int)pixelHeight);
	
    // Create a bitmap context to store the new thumbnail
	CGContextRef context = MyCreateBitmapContext((int )pixelWidth, (int)pixelHeight);
	
    // Clear the context and draw the image into the rectangle
	CGContextClearRect(context, aRect);
	[Util clipContext:context toRoundRect:aRect withRadius:radius];
	CGContextDrawImage(context, aRect, image); 
	
    // Return a UIImage populated with the new resized image
	CGImageRef myRef = CGBitmapContextCreateImage (context);
	
	UIImage *img = [UIImage imageWithCGImage:myRef];
	
	free(CGBitmapContextGetData(context)); 
	CGContextRelease(context);
	CGImageRelease(myRef);
	
	return img; 
}

+ (UIImage*)imageInRect4Sky:(CGRect)rect image:(UIImage*)img {
	
	CGImageRef cg_subImage = CGImageCreateWithImageInRect(img.CGImage, rect);
	UIImage *subImage = [UIImage imageWithCGImage:cg_subImage];
	CGImageRelease(cg_subImage);	
	return subImage;
}

+ (UIImage*)createRoundImage:(CGImageRef)image withImgX:(int)imgX withImgY:(int)imgY withImgW:(int)imgW withImgH:(int)imgH withWidth:(int)pixelWidth withHeight:(int)pixelHeight withRadius:(int)radius {
	// Set the size of the output image 
	CGRect aRect = CGRectMake(0.0f, 0.0f, pixelWidth, pixelHeight); 
	CGRect bRect = CGRectMake(imgX, imgY, imgW, imgH);
	// Create a bitmap context to store the new thumbnail 
	CGContextRef context = MyCreateBitmapContext(pixelWidth, pixelHeight); 
	// Clear the context and draw the image into the rectangle 
	CGContextClearRect(context, aRect);
	[Util clipContext:context toRoundRect:aRect withRadius:radius];
	CGContextDrawImage(context, bRect, image); 
	// Return a UIImage populated with the new resized image 
	CGImageRef myRef = CGBitmapContextCreateImage (context); 
	
	UIImage *img = [UIImage imageWithCGImage:myRef];
	
	free(CGBitmapContextGetData(context)); 
	CGContextRelease(context);
	CGImageRelease(myRef);
	
	return img; 
}

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
					withShadowColor:(CGColorRef)shadowColor
{
	// Set the size of the output image 
	CGRect aRect = CGRectMake(0, 0, pixelWidth, pixelHeight); 
	CGRect bRect = CGRectMake(imgX, imgY, imgW, imgH); 
	CGSize shadowOffset = CGSizeMake(ShadowOffX, ShadowOffY);
	// Create a bitmap context to store the new thumbnail 
	CGContextRef context = MyCreateBitmapContext(pixelWidth, pixelHeight); 
	// Clear the context and draw the image into the rectangle 
	CGContextClearRect(context, aRect);
	CGContextSetShadowWithColor(context, shadowOffset, shadowWidth, shadowColor);
	CGContextDrawImage(context, bRect, image); 
	// Return a UIImage populated with the new resized image 
	CGImageRef myRef = CGBitmapContextCreateImage (context); 
	
	UIImage *img = [UIImage imageWithCGImage:myRef];
	
	free(CGBitmapContextGetData(context)); 
	CGContextRelease(context);
	CGImageRelease(myRef);
	
	return img; 	
	
	
}

+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)limit {
	if(!image) return nil;
	
	CGFloat width = image.size.width;
	CGFloat height = image.size.height;
	if(width > limit.width || height > limit.height)
	{
		if(1.0*height/width > 1.0*limit.height/limit.width)
			limit.width = 1.0*limit.height*width/height;
		else
			limit.height = 1.0*limit.width*height/width;
	}
	
	return [Util createImage:[image CGImage] width:(int)(limit.width) height:(int)(limit.height)];
}

+ (UIImage *)rotateImage:(UIImage *)image imageOrientation:(UIImageOrientation)imageOrientation{ 
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	switch(imageOrientation) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

+ (UIImage *)shotImageFrameView:(UIView*)view shotSize:(CGSize)size {

    if (iOS_IS_UP_VERSION(8.0)) {
        
        return nil;
    }
    
    if(UIGraphicsBeginImageContextWithOptions != NULL) {
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    }else {
        
        UIGraphicsBeginImageContext(size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

+ (UIImage*)makeRoundCornerImage:(UIImage*)img :(int)cornerWidth :(int)cornerHeight {
    
    UIImage * newImage = nil;
    if( nil != img)
    {
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        int w = img.size.width;
        int h = img.size.height;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
        
        CGContextBeginPath(context);
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
        CGContextClosePath(context);
        CGContextClip(context);
        
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
        
        CGImageRef imageMasked = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        newImage = [[UIImage imageWithCGImage:imageMasked] retain];
        // 上面如果不retain ,会被释放掉！！
        CGImageRelease(imageMasked);
        
        [pool release];
    }
    
    return [newImage autorelease];
}

+ (void)dialPhoneNumber:(NSString*)strPhoneNumber {
	
	if (strPhoneNumber != nil) {
		
		NSString *phoneNumber = [NSString stringWithFormat:@"%@", strPhoneNumber];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
		NSString *strURL = [NSString stringWithFormat:@"tel://%@", phoneNumber];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
	}
}

+ (void)guideRoute:(NSString*)strSourceCoordinate  toCoodinate:(NSString*)strToDestinationCoordinate {
	
	if ([strSourceCoordinate length]>0 && [strToDestinationCoordinate length]>0) {
		
		NSString *strURL = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=%@", 
							strSourceCoordinate, strToDestinationCoordinate];
		//		CQTDebugLog(@"strURL=%@", strURL);
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
	}
}

+ (NSString *)reFormatHTMLImage:(NSString *)strHTML{
	
	NSString * cstrContent = strHTML;
    cstrContent = [cstrContent stringByReplacingOccurrencesOfRegex:@"width=\"[+/-]?[0-9]+\"" withString:@"width=\"100%%\""];
	cstrContent = [cstrContent stringByReplacingOccurrencesOfRegex:@"height=\"[+/-]?[0-9]+\"" withString:@""];
	cstrContent = [cstrContent stringByReplacingOccurrencesOfRegex:@">http+:[^\\s]*<" withString:@">详情>><"];//过滤url超链接
	return cstrContent;
}

+ (void) getInterfaceBytes {
    
	struct ifaddrs *ifa_list = 0, *ifa;
	if (getifaddrs(&ifa_list) == -1) {
        
		return;
	}
	
	uint32_t iBytes = 0;
	uint32_t oBytes = 0;
	for (ifa=ifa_list; ifa; ifa=ifa->ifa_next) {
        
		if (AF_LINK != ifa->ifa_addr->sa_family)
			continue;
		
		if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
			continue;
		
		if (ifa->ifa_data == 0)
			continue;
		
		/* Not a loopback device. */
		if (strncmp(ifa->ifa_name, "lo", 2)) {
            
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
			
			iBytes += if_data->ifi_ibytes;
			oBytes += if_data->ifi_obytes;
			
		}
	}
	NSLog(@"iBytes = %d",iBytes);
	NSLog(@"oBytes = %d",oBytes);
    freeifaddrs(ifa_list);
}

+(void)wobbleView:(UIView*)view wobble:(BOOL)wobble {
    
    if (wobble){
        view.transform = CGAffineTransformMakeRotation(DegreesToRadians(-2));
        [UIView animateWithDuration:0.12 delay:0.0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveLinear animations:^{
            view.transform = CGAffineTransformMakeRotation(DegreesToRadians(2));
        } completion:nil];
    }
    else{
        view.transform = CGAffineTransformMakeRotation(DegreesToRadians(-2));
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{view.transform =CGAffineTransformIdentity;} completion:nil];
        
    }
}

@end

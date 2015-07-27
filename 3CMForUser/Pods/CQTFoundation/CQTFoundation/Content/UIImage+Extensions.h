//
//  UIImage+Extensions.h
//  CQTIda
//
//  Created by ANine on 4/11/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNotifiCationWillBeginGetScreenShot  @"kNotifiCationWillBeginGetScreenShot"
#define kNotifiCationFinishGetScreenShot     @"kNotifiCationFinishGetScreenShot"

@interface UIImage (Extensions)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize ToFill:(BOOL)fill canChangeImageSize:(BOOL)change
;

- (UIImage*)imageTestByScalingAndCroppingForSize:(CGSize)targetSize ToFill:(BOOL)fill canChangeImageSize:(BOOL)change;

/* 颜色完全覆盖. */
- (UIImage *)imageWithOverlayColor:(UIColor *)color;

+ (UIImage *)grayImage:(UIImage *)sourceImage;


- (UIImage *)imageWithTintColor:(UIColor *)tintColor ;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

// get the current view screen shot
+ (UIImage *)capture;

/**
 *	@brief	Create a partially displayed image
 *
 *	@param 	percentage 	This defines the part to be displayed as original
 *	@param 	vertical 	If YES, the image is displayed bottom to top; otherwise left to right
 *	@param 	grayscaleRest 	If YES, the non-displaye part are in grayscale; otherwise in transparent
 *
 *	@return	A generated UIImage instance
 */
- (UIImage *)partialImageWithPercentage:(float)percentage vertical:(BOOL)vertical grayscaleRest:(BOOL)grayscaleRest;

@end

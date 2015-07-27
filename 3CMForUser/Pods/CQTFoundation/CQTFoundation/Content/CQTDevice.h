//
//  CQTDevice.h
//  CQTIda
//
//  Created by ANine on 12/3/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief 关于一些设备的类
 
 @discussion <#some notes or alert with this class#>
 */

@interface CQTDevice : NSObject

/* 是否可以使用相机 */
+ (BOOL)canUseCamera;

/* 是否可以使用相册 */
+ (BOOL)canUseAlbum;


@end

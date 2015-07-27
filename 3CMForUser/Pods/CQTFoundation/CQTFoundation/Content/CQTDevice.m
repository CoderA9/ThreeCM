//
//  CQTDevice.m
//  CQTIda
//
//  Created by ANine on 12/3/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTDevice.h"

#import "CQTGlobalConstants.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CQTDevice

+ (BOOL)canUseCamera {
    
    BOOL canUseCamera = YES;
    
    if(iOS_IS_UP_VERSION(7.0))
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted )
        {
            canUseCamera = NO;
        }
    }else {
        
        canUseCamera = YES;
    }
    
    return canUseCamera;
}

/* 是否可以使用相册 */
+ (BOOL)canUseAlbum {
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined) {
        
        return YES;
    }
    
    return NO;
}

@end

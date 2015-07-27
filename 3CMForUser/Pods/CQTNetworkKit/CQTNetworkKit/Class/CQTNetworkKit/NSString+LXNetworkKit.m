//
//  NSString+LXNetworkKit.m
//  LifeixNetworkKit
//
//  Created by James Liu on 1/27/12.
//  Copyright 2012 Lifeix. All rights reserved.
//  
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import "NSString+LXNetworkKit.h"

#import "CQTGlobalConstants.h"
#import "NSDate+BeeExtension.h"

@implementation NSString (LXNetworkKit)


+ (NSString *)installationId:(NSString *)preferencesKey {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *installId = [prefs stringForKey:preferencesKey];
    
    if(installId == nil)
    {
        installId = [NSString stringWithNewUUID];
    }
    
    // Store the newly generated installId
    [prefs setObject:installId forKey:preferencesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return installId;
}

+ (NSString*)stringWithNewUUID {
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    // Get the string representation of the UUID
    NSString *newUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    
    return newUUID;
}


+ (NSString *)prefixWithSize:(CGSize)imageSize retinaSupport:(BOOL)retinaSupport mode:(LXImageCacheMode)mode watermark:(BOOL)watermark {
    
    NSString *prefix = PHOTO_PREFIX;
    
    int width = imageSize.width;
    int height = imageSize.height;
    if (retinaSupport) {
        width *= 2;
        height *= 2;
    }
    
    NSString *cacheSizeMode = [NSString stringWithFormat:PHOTO_ICON_SIZE_MODE, width, height, mode, watermark];
    prefix = [prefix stringByAppendingString:cacheSizeMode];
    
    return prefix;
}

+ (NSString *)prefixWithType:(LXImageURLType)atype retinaSupport:(BOOL)flag {
    NSString *prefix = @"";
    
    switch ((int)atype) {
        case LXImageURLAvatar50:
            prefix = AVATAR_50_PREFIX;
            break;
            
        case LXImageURLAvatar90:
            prefix = AVATAR_90_PREFIX;
            break;
            
        case LXImageURLAvatar200:
            prefix = AVATAR_200_PREFIX;
            break;
        case LXImageURLAvatar700:
            prefix = AVATAR_700_PREFIX;
            break;
        case LXImageURLPhotoIcon:
            prefix = PHOTO_ICON_PREFIX;
            break;
            
        case LXImageURLPhotoThumbnail:
            prefix = PHOTO_THUMBNAIL_PREFIX;
            break;
            
        case LXImageURLPhotoCommon:
            prefix = PHOTO_COMMON_PREFIX;
            break;
            
        case LXImageURLPhotoLarge:
            prefix = PHOTO_LARGE_PREFIX;
            break;
            
        case LXImageURLPhotoSource:
            prefix = PHOTO_SOURCE_PREFIX;
            break;
            
        case LXImageURLEatIcon:
            prefix = EAT_ICON_PREFIX;
            break;
            
        case LXImageURLEatThumbnail:
            prefix = EAT_THUMBNAIL_PREFIX;
            break;
            
        case LXImageURLEatCommon:
            prefix = EAT_COMMON_PREFIX;
            break;
            
        case LXImageURLEatLarge:
            prefix = EAT_LARGE_PREFIX;
            break;
            
        case LXImageURLEatSource:
            prefix = EAT_SOURCE_PREFIX;
            break;
            
        case LXImageURLMedia50:
            prefix = MEDIA_50_PREFIX;
            break;
            
        case LXImageURLMedia70:
            prefix = MEDIA_70_PREFIX;
            break;
            
        case LXImageURLMedia100:
            prefix = MEDIA_100_PREFIX;
            break;
    }
    
    if (flag && CQT_SUPPORT_RETINA()) {
        switch ((int)atype) {
            case LXImageURLAvatar50:
                prefix = AVATAR_90_PREFIX;
                break;
                
            case LXImageURLAvatar90:
                prefix = AVATAR_200_PREFIX;
                break;
                
            case LXImageURLPhotoIcon:
                prefix = PHOTO_ICONx2_PREFIX;
                break;
                
            case LXImageURLPhotoThumbnail:
                prefix = PHOTO_COMMON_PREFIX;
                break;
                
            case LXImageURLPhotoCommon:
                prefix = PHOTO_LARGE_PREFIX;
                break;
                
            case LXImageURLPhotoLarge:
                prefix = PHOTO_SOURCE_PREFIX;
                break;
                
            case LXImageURLEatIcon:
                prefix = EAT_THUMBNAIL_PREFIX;
                break;
                
            case LXImageURLEatThumbnail:
                prefix = EAT_COMMON_PREFIX;
                break;
                
            case LXImageURLEatCommon:
                prefix = EAT_LARGE_PREFIX;
                break;
                
            case LXImageURLEatLarge:
                prefix = EAT_SOURCE_PREFIX;
                break;
                
            case LXImageURLEatSource:
                prefix = EAT_SOURCE_PREFIX;
                break;
                
            case LXImageURLMedia50:
                prefix = MEDIA_100_PREFIX;
                break;
                
            case LXImageURLMedia70:
                prefix = MEDIA_140_PREFIX;
                break;
                
            case LXImageURLMedia100:
                prefix = MEDIA_200_PREFIX;
                break;
        }
    }
    
    return prefix;
}

+ (NSString *)debugPrefixWithSize:(CGSize)imageSize retinaSupport:(BOOL)retinaSupport mode:(LXImageCacheMode)mode watermark:(BOOL)watermark {
    
    NSString *prefix = PHOTO_DEV_PREFIX;
    
    int width = imageSize.width;
    int height = imageSize.height;
    if (retinaSupport) {
        width *= 2;
        height *= 2;
    }
    
    NSString *cacheSizeMode = [NSString stringWithFormat:PHOTO_ICON_SIZE_MODE, width, height, mode, watermark];
    prefix = [prefix stringByAppendingString:cacheSizeMode];
    
    return prefix;
}

+ (NSString *)debugPrefixWithType:(LXImageURLType)atype retinaSupport:(BOOL)flag {
    NSString *prefix = @"";

    
    return prefix;
}


+ (NSString *)imageURL:(NSString *)path type:(LXImageURLType)atype retinaSupport:(BOOL)flag {
    NSString *prefix = nil;
    
    NSNumber *kDBPhotoPrefixNumber = CQT_USERDEFAULTS_VALUE(@"db_debug_photo_prefix");
    int useLocalPhotoPrefix = [kDBPhotoPrefixNumber intValue];
    
    if (useLocalPhotoPrefix) {
        prefix = [NSString debugPrefixWithType:atype retinaSupport:flag];
    }
    else {
        prefix = [NSString prefixWithType:atype retinaSupport:flag];
    }
    
    
    return [NSString stringWithFormat:@"%@%@" , prefix, path];
}

+ (NSString *)imageURL:(NSString *)path imageSize:(CGSize)size retinaSupport:(BOOL)retinaSupport mode:(LXImageCacheMode)mode watermark:(BOOL)watermark {
    NSString *prefix = nil;
    
    NSNumber *kDBPhotoPrefixNumber = CQT_USERDEFAULTS_VALUE(@"db_debug_photo_prefix");
    int useLocalPhotoPrefix = [kDBPhotoPrefixNumber intValue];
    
    if (useLocalPhotoPrefix) {
        prefix = [NSString debugPrefixWithSize:size retinaSupport:retinaSupport mode:mode watermark:watermark];
    }
    else {
        prefix = [NSString prefixWithSize:size retinaSupport:retinaSupport mode:mode watermark:watermark];
    }
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@" , prefix, path];
    
    return imagePath;
}

/**
 通过类型获取IM_FILE_PATH地址
 @param path 后缀路径
 */
+ (NSString *)imFilePath:(NSString *)path {
    NSString *prefix = nil;
    
    NSNumber *kDBPhotoPrefixNumber = CQT_USERDEFAULTS_VALUE(@"db_debug_photo_prefix");
    int useLocalPhotoPrefix = [kDBPhotoPrefixNumber intValue];
    
    if (useLocalPhotoPrefix) {
        
    }
    else {
        prefix = IM_FILE_PATH;
    }
    
    return [NSString stringWithFormat:@"%@%@", prefix, path];
}

+ (NSString *)audioFilePath:(NSString *)path {
    
    NSString *prefix = nil;
    
    NSNumber *kDBPhotoPrefixNumber = CQT_USERDEFAULTS_VALUE(@"db_debug_photo_prefix");
    int useLocalPhotoPrefix = [kDBPhotoPrefixNumber intValue];
    
    if (useLocalPhotoPrefix) {
        
    }
    else {
        prefix = TIMELINE_AUDIO_FILE_PATH;
    }
    
    return [NSString stringWithFormat:@"%@%@", prefix, path];
}

+ (NSString *)locaVideoFilePath:(NSString *)path {
    
    NSString *prefix = nil;
    
    NSNumber *kDBPhotoPrefixNumber = CQT_USERDEFAULTS_VALUE(@"db_debug_photo_prefix");
    int useLocalPhotoPrefix = [kDBPhotoPrefixNumber intValue];
    
    if (useLocalPhotoPrefix) {
        
    }
    else {
        prefix = TIMELINE_VIDEO_FILE_PATH;
    }
    
    return [NSString stringWithFormat:@"%@%@", prefix, path];
}


+ (NSString *)generateKey:(NSString *)path {
    
    if (!path || path.length <= 1) {
        return @"";
    }
    NSDate *date = [NSDate date];
    NSInteger day = date.day;
    
    NSString *action = [[path componentsSeparatedByString:@"&a="] lastObject];
    
    action = [[action componentsSeparatedByString:@"&"] firstObject];
    char header = [action characterAtIndex:0];
    NSString *headerStr = [NSString getOctal:header];
    NSString *footerStr = [NSString getOctal:[action characterAtIndex:action.length - 1]];
    NSString *key = [NSString stringWithFormat:@"%@", headerStr];
    
    for (int index = 0; index < action.length; index ++) {
        
        char echo = [action characterAtIndex:index];
        key = [key stringByAppendingFormat:@"%@",[NSString getHex:echo + (int)day]];
    }
    
    return [key stringByAppendingString:footerStr];
}

+ (NSString *)getOctal:(int)cnt {
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    while (cnt != 0 ) {
        
        [resultStr insertString:[NSString stringWithFormat:@"%d",cnt % 8] atIndex:0];
        cnt /= 8;
    }
    return CQT_AUTORELEASE(resultStr);
}

+ (NSString *)getHex:(int)cnt {
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    while (cnt != 0 ) {
        
        int surplus = cnt % 16;
        static NSString *subStr = nil;
        switch (surplus) {
            case 10:
                subStr = @"a";
                break;
            case 11:
                subStr = @"b";
                break;
            case 12:
                subStr = @"c";
                break;
            case 13:
                subStr = @"d";
                break;
            case 14:
                subStr = @"e";
                break;
            case 15:
                subStr = @"f";
                break;
            default:
                subStr = [NSString stringWithFormat:@"%d",surplus];
                break;
        }
        [resultStr insertString:subStr atIndex:0];
        
        cnt /= 16;
    }
    return CQT_AUTORELEASE(resultStr);
}

@end

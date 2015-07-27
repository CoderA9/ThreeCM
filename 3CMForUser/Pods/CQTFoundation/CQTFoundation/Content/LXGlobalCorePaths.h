//
//  LXGlobalCorePaths.h
//  LifeixNetworkKit
//
//  Created by James Liu on 1/17/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import <UIKit/UIKit.h>

#ifndef __LXGlobalCorePaths__
#define __LXGlobalCorePaths__


#if defined __cplusplus
extern "C" {
#endif
    
    BOOL LXIsBundleURL(NSString* URL);
    
    BOOL LXIsDocumentsURL(NSString* URL);
    
    void LXSetDefaultBundle(NSBundle* bundle);
    
    NSBundle* LXGetDefaultBundle();
    
    NSString* CQTPathForBundleResource(NSString* relativePath);
    
    NSString* CQTPathForDocumentsResource(NSString* relativePath);
    
    NSString* CQTPathForCachesResource(NSString* relativePath);
    
#if defined __cplusplus
};
#endif



#define LXAutomaticlyLoadImagePreference      @"image_autoload_in_cellular_preference"


//#define         PHOTO_DEV_PREFIX  @"http://photo.cqtimes.com/"
#define         PHOTO_DEV_PREFIX  @"http://proxy.dev.xy.cqtimes.com/image.php?type=photo&ifile="
// 飞鸽图片前缀
#define         PHOTO_PREFIX      @"http://photo.cqtimes.com/"

// 头像前缀
#define			AVATAR_50_PREFIX			@"http://avatar.cqtimes.com/50x50/"
#define			AVATAR_90_PREFIX			@"http://avatar.cqtimes.com/90x90/"
#define			AVATAR_200_PREFIX			@"http://avatar.cqtimes.com/200x222/"
#define			AVATAR_700_PREFIX			@"http://avatar.cqtimes.com/700/"

#define         PHOTO_ICON_SIZE_MODE             @"cache-%dx%d-%d%d/"  // 宽 & 高 & mode & watermark


// 立方网图片前缀
#define         LIFEIX_PHOTO_PREFIX      @"http://static.cqtimes.com/"

// 踩点图片前缀
#define         CHECKIN_PHOTO_PREFIX      @"http://photo.cqtimes.com/dove/200x200/"

// if - before php-image-resizer
//#define         PHOTO_ICON_PREFIX      @"http://photo.cqtimes.com/icon/"          // 100*100
#define         PHOTO_THUMBNAIL_PREFIX      @"http://photo.cqtimes.com/thumbnail/"  // 140*140
#define         PHOTO_COMMON_PREFIX      @"http://photo.cqtimes.com/common/"        // 300*300
#define         PHOTO_LARGE_PREFIX      @"http://photo.cqtimes.com/bigger/"         // 590*590
#define         PHOTO_SOURCE_PREFIX      @"http://photo.cqtimes.com/source/"        // 原图大小
// else - use php-image-resizer
#define         PHOTO_ICON_PREFIX      @"http://photo.cqtimes.com/cache-100x100-00/"
#define         PHOTO_ICONx2_PREFIX      @"http://photo.cqtimes.com/cache-200x200-00/"
//#define         PHOTO_THUMBNAIL_PREFIX @"http://photo.cqtimes.com/cache-140x140-00/"
//#define         PHOTO_COMMON_PREFIX    @"http://photo.cqtimes.com/cache-300x300-00/"
//#define         PHOTO_LARGE_PREFIX     @"http://photo.cqtimes.com/cache-590x590-00/"
//#define         PHOTO_SOURCE_PREFIX    @"http://photo.cqtimes.com/source/"

// 没体分类图标前缀
#define			MEDIA_50_PREFIX			@"http://static.cqtimes.com/skin/lifeix/images/register/media/50x50/"
#define			MEDIA_70_PREFIX			@"http://static.cqtimes.com/skin/lifeix/images/register/media/70x70/"
#define			MEDIA_100_PREFIX			@"http://static.cqtimes.com/skin/lifeix/images/register/media/100x100/"
#define			MEDIA_140_PREFIX			@"http://static.cqtimes.com/skin/lifeix/images/register/media/140x140/"
#define			MEDIA_200_PREFIX			@"http://static.cqtimes.com/skin/lifeix/images/register/media/200x200/"

// 吃货图片前缀
// wong.forapi - 上线后的地址
#define         EAT_PREFIX      @"http://eat.xy.cqtimes.com/"
#define         EAT_ICON_PREFIX      @"http://eat.xy.cqtimes.com/100x100/"
#define         EAT_THUMBNAIL_PREFIX      @"http://eat.xy.cqtimes.com/140x140/"
#define         EAT_COMMON_PREFIX      @"http://eat.xy.cqtimes.com/300x300/"
#define         EAT_LARGE_PREFIX      @"http://eat.xy.cqtimes.com/590x590/"
#define         EAT_SOURCE_PREFIX      @"http://eat.xy.cqtimes.com/source/"

#define         IM_FILE_PATH      @"http://video.cqtimes.com/nyx/file/"

#define         TIMELINE_AUDIO_FILE_PATH      @"http://audio.cqtimes.com/"
#define         TIMELINE_VIDEO_FILE_PATH      @"http://video.cqtimes.com/"




// wong. settings 可将debug打开后, 用本地的图片路径
#define			AVATAR_50_PREFIX_Local			@"http://proxy.dev.xy.cqtimes.com/image.php?type=avatar50&ifile="
#define			AVATAR_90_PREFIX_Local			@"http://proxy.dev.xy.cqtimes.com/image.php?type=avatar90&ifile="
#define			AVATAR_200_PREFIX_Local			@"http://proxy.dev.xy.cqtimes.com/image.php?type=avatar200&ifile="
#define			AVATAR_700_PREFIX_Local			@"http://proxy.dev.xy.cqtimes.com/image.php?type=avatar700&ifile="
#define         PHOTO_PREFIX_Local      @"http://proxy.dev.xy.cqtimes.com/image.php?type=photo&ifile="
#define         PHOTO_ICON_PREFIX_Local      @"http://proxy.dev.xy.cqtimes.com/image.php?type=photo&ifile=icon/"
#define         PHOTO_THUMBNAIL_PREFIX_Local      @"http://proxy.dev.xy.cqtimes.com/image.php?type=photo&ifile=thumbnail/"
#define         PHOTO_COMMON_PREFIX_Local      @"http://proxy.dev.xy.cqtimes.com/image.php?type=photo&ifile=common/"
#define         PHOTO_LARGE_PREFIX_Local      @"http://proxy.dev.xy.cqtimes.com/image.php?type=photo&ifile=bigger/"
#define         PHOTO_SOURCE_PREFIX_Local      @"http://proxy.dev.xy.cqtimes.com/image.php?type=photo&ifile=source/"
#define         PHOTO_DEV_PREFIX_Local  @"http://photo.cqtimes.com/"
#define			MEDIA_50_PREFIX_Local			@"http://static.cqtimes.com/skin/lifeix/images/register/media/50x50/"
#define			MEDIA_70_PREFIX_Local			@"http://static.cqtimes.com/skin/lifeix/images/register/media/70x70/"
#define			MEDIA_100_PREFIX_Local			@"http://static.cqtimes.com/skin/lifeix/images/register/media/100x100/"
#define			MEDIA_140_PREFIX_Local			@"http://static.cqtimes.com/skin/lifeix/images/register/media/140x140/"
#define			MEDIA_200_PREFIX_Local			@"http://static.cqtimes.com/skin/lifeix/images/register/media/200x200/"

#define         EAT_PREFIX_Local      @"http://eat.xy.cqtimes.com/"
#define         EAT_ICON_PREFIX_Local      @"http://eat.xy.cqtimes.com/source/"
#define         EAT_THUMBNAIL_PREFIX_Local      @"http://eat.xy.cqtimes.com/source/"
#define         EAT_COMMON_PREFIX_Local      @"http://eat.xy.cqtimes.com/source/"
#define         EAT_LARGE_PREFIX_Local      @"http://eat.xy.cqtimes.com/source/"
#define         EAT_SOURCE_PREFIX_Local      @"http://eat.xy.cqtimes.com/source/"

#define         IM_FILE_PATH_Local      @"http://proxy.dev.xy.cqtimes.com/image.php?type=nyx&ifile="

#define         TIMELINE_AUDIO_FILE_PATH_Local      @"http://audio.dev.xy.cqtimes.com/"

#define         TIMELINE_VIDEO_FILE_PATH_Local      @"http://video.dev.xy.cqtimes.com/"

#endif
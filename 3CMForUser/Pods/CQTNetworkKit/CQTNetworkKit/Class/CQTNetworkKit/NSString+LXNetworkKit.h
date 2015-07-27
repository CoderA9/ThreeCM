//
//  NSString+LXNetworkKit.h
//  LifeixNetworkKit
//
//  Created by James Liu on 1/27/12.
//  Copyright 2012 Lifeix. All rights reserved.
//  
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import <Foundation/Foundation.h>



typedef enum _LXImageURLType {
    LXImageURLAvatar50  =   0,  // 50x56 的头像
    LXImageURLAvatar90, // 90x100的头像
    LXImageURLAvatar200,    // 200x222的头像
    LXImageURLAvatar700,    
    LXImageURLPhotoIcon,    // icon级别的照片
    LXImageURLPhotoThumbnail,   // 缩略图级别的照片
    LXImageURLPhotoCommon, // 300宽的图片
    LXImageURLPhotoLarge,   // 照片大图
    LXImageURLPhotoSource,  // 照片原图
    LXImageURLEatIcon,
    LXImageURLEatThumbnail,
    LXImageURLEatCommon,
    LXImageURLEatLarge,
    LXImageURLEatSource,
    LXImageURLMedia50,      // 没体分类的图标
    LXImageURLMedia70,      // 没体分类的图标
    LXImageURLMedia100,      // 没体分类的图标
} LXImageURLType;


typedef enum {
    LXImageCacheModeProportional = 0,       // 等比例缩放
    LXImageCacheModeCut = 1,                // 截取
    LXImageCacheModeCompress = 2,           // 压缩
} LXImageCacheMode;

@interface NSString (LXNetworkKit)

+ (NSString *)installationId:(NSString *)preferencesKey;

/**
 Create a new universally unique identifier.
 @return uuid
 */
+ (NSString*)stringWithNewUUID;

/**
 通过类型获取图片地址
 @param path 图片路径
 @param atype 图片类型
 @param flag 是否支持retina显示
 */
+ (NSString *)imageURL:(NSString *)path type:(LXImageURLType)atype retinaSupport:(BOOL)flag;

/**
 通过给定的图片尺寸获取图片地址
 @param path 图片路径
 @param imageSize 图片尺寸
 @param retinaSupport 是否高清图片
 @param mode 图片的缩放裁剪模式
 @param watermark 是否加水印     // wong.v5.1 - 现还不支持这个属性, 所以统一传0
 */
+ (NSString *)imageURL:(NSString *)path imageSize:(CGSize)size retinaSupport:(BOOL)retinaSupport mode:(LXImageCacheMode)mode watermark:(BOOL)watermark;


/**
 通过类型获取IM_FILE_PATH地址
 @param path 后缀路径
 */
+ (NSString *)imFilePath:(NSString *)path;

/**
 通过类型获取本地音频地址
 @param path 后缀路径
 */
+ (NSString *)audioFilePath:(NSString *)path;

/**
 通过类型获取本地视频地址
 @param path 后缀路径
 */
+ (NSString *)locaVideoFilePath:(NSString *)path;

/**
 生成ida密匙
 @param path 连接路径
 */
+ (NSString *)generateKey:(NSString *)path;
@end

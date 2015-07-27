//
//  CQTArchive.h
//  Robot
//
//  Created by A9 on 2/17/14.
//  Copyright (c) 2014 A9. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQTArchive : NSObject
/**
 将内容存放在caches下，其中带有时间记录.
 */

+ (BOOL)archiveUseTimeData:(id)dataObj inCacheDirectory:(NSString *)dir filename:(NSString *)filename;
/**
 取出带有时间的caches下地数据.
 */
+ (id)unarchiveObjectUseTimeFromCacheDirectory:(NSString *)dir filename:(NSString *)filename;
/**
 将内容存储在caches目录下的某个文件夹中
 @param dataObj 需要存储的对象
 @param dir 放在cache下的文件夹名称
 @param filename 存储的文件名称
 */
+ (BOOL)archiveData:(id)dataObj inCacheDirectory:(NSString *)dir filename:(NSString *)filename;

/**
 从archive文件中取出对象(缓存目录)
 
 @param dir 放在cache下的文件夹名称
 @param filename 文件名称
 */
+ (id)unarchiveObjectFromCacheDirectory:(NSString *)dir filename:(NSString *)filename;

/**
 将内容存储在caches目录下
 @param dataObj 需要存储的对象
 @param filename 存储的文件名称
 */
+ (BOOL)archiveData:(id)dataObj inCacheDirectory:(NSString *)filename;

+ (void)archiveData:(id)dataObj inCacheDirectory:(NSString *)filename
            success:(void (^)())successBlock failure:(void (^)(NSError *error))failureBlock;

/* 从caches目录下删除文件. */
+ (BOOL)removeObjectFromCacheDirectory:(NSString *)dir filename:(NSString *)filename;

/**
 从archive文件中取出对象(缓存目录)
 @param filename 文件名称
 */
+ (id)unarchiveObjectFromCacheDirectory:(NSString *)filename;
/**
 从archive文件中取内容.
 @param filename 文件名称
 @param dir 文件目录
 @param firstInterval 目前取得的历史消息第一条的发送时间戳.
 */
+ (id)unarchiveObjectUseTimeFromCacheDirectory:(NSString *)dir filename:(NSString *)filename interval:(NSString *)firstInterval;
/**
 将内容存储在documents目录下
 @param dataObj 需要存储的对象
 @param filename 存储的文件名称
 */
+ (BOOL)archiveData:(id)dataObj inDocumentDirectory:(NSString *)filename;

+ (void)archiveData:(id)dataObj inDocumentDirectory:(NSString *)filename
            success:(void (^)())successBlock failure:(void (^)(NSError *error))failureBlock;

+ (void)archiveData:(id)dataObj inDocumentDirectory:(NSString *)filename useMainThread:(BOOL)mainThread
            success:(void (^)())successBlock failure:(void (^)(NSError *error))failureBlock;

/**
 从archive文件中取出对象(文档目录)
 @param filename 文件名称
 */
+ (id)unarchiveObjectFromDocumentDirectory:(NSString *)filename;

/**
 将archive文件从document中移除
 
 @param filename 文件名称
 */
+ (BOOL)removeArchiveDataFromDocumentDirectory:(NSString *)filename;



/**
 将内容存储到指定路径(绝对路径)
 @param dataObj 需要存储的对象
 @param path 文件存放的路径
 */
+ (BOOL)archiveData:(id)dataObj intoPath:(NSString *)path;

/**
 从archive文件中取出对象(指定路径)
 @param filename 文件名称
 */
+ (id)unarchiveObjectFromPath:(NSString *)path;


/* 从指定路径中删除缓存 */
+ (BOOL)removeArchiveFromPath:(NSString *)path;

@end

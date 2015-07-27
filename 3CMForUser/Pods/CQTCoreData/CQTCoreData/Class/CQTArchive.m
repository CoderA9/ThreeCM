//
//  CQTArchive.m
//  Robot
//
//  Created by A9 on 2/17/14.
//  Copyright (c) 2014 A9. All rights reserved.
//

#import "CQTArchive.h"

#import "LXGlobalCorePaths.h"

#import "NSArray+BeeExtension.h"

static dispatch_queue_t cqt_archive_processing_queue;
static dispatch_queue_t archive_processing_queue() {
    
    if (cqt_archive_processing_queue == NULL) {
        
        cqt_archive_processing_queue = dispatch_queue_create("com.chongqingTimes.archive.processing", 0);
    }
    
    return cqt_archive_processing_queue;
}

static        NSString* kLXEtagCacheDirectoryName = @"etag";
#define ChatMessageArchiveTimeInterval   60 * 60 * 24 * 7.f
#define ChatMessageCountMax  100
@implementation CQTArchive

+ (NSString *)pathInCacheDirectory:(NSString *)dir filename:(NSString *)filename {
    
    NSString *dirPath = [CQTArchive cachePathWithName:dir];
    
    NSString *path = [dirPath stringByAppendingString:filename];
    
    return path;
}

+ (BOOL)archiveUseTimeData:(id)dataObj inCacheDirectory:(NSString *)dir filename:(NSString *)filename {
    NSMutableArray *existAry = [CQTArchive unarchiveObjectFromCacheDirectory:dir filename:filename];
    if (!existAry) {
        existAry = [[NSMutableArray alloc] init];
    }else {
        
    }
    if (existAry.count >= ChatMessageCountMax) {
        [existAry removeObjectAtIndex:0];
        
        [existAry removeDataWithTimeInterval:ChatMessageArchiveTimeInterval];
    }
    [existAry addObject:dataObj];
    return [CQTArchive archiveData:existAry inCacheDirectory:dir filename:filename];
}

+ (BOOL)archiveData:(id)dataObj inCacheDirectory:(NSString *)dir filename:(NSString *)filename {
    
    NSString *path = [CQTArchive pathInCacheDirectory:dir filename:filename];
    
    return [CQTArchive archiveData:dataObj intoPath:path];
}

+ (id)unarchiveObjectFromCacheDirectory:(NSString *)dir filename:(NSString *)filename {
    
    NSString *path = [CQTArchive pathInCacheDirectory:dir filename:filename];
    
    return [CQTArchive unarchiveObjectFromPath:path];
}

+ (id)unarchiveObjectUseTimeFromCacheDirectory:(NSString *)dir filename:(NSString *)filename {
    
    NSString *path = [CQTArchive pathInCacheDirectory:dir filename:filename];
    NSMutableArray *ary = [CQTArchive unarchiveObjectFromPath:path];
    
    [CQTArchive archiveData:ary inCacheDirectory:dir filename:filename];
    NSMutableArray *resultAry = [[NSMutableArray alloc] init];
    if (ary && [ary count]) {
        for (id obj in ary) {
            [resultAry addObject:obj];
        }
    }
    return resultAry;
}

+ (id)unarchiveObjectUseTimeFromCacheDirectory:(NSString *)dir filename:(NSString *)filename interval:(NSString *)firstInterval {
    
    NSMutableArray *ary =[[NSMutableArray alloc] initWithArray:[CQTArchive unarchiveObjectUseTimeFromCacheDirectory:dir filename:filename]];
    
    if (ary && ary.count >= ChatMessageCountMax) {
        ary = [ary removeDataWithTimeInterval:ChatMessageArchiveTimeInterval];
    }
    NSMutableArray *operAry = [ary copy];
    if (operAry && operAry.count) {
        if (firstInterval) {
            for (int index = [operAry count] -1 ; index >= 0 ; index --) {
                id obj = [operAry objectAtIndex:index];
                if ([obj respondsToSelector:@selector(createTime)]) {
                    NSString *time = [obj performSelector:@selector(createTime)];
                    [ary removeObject:obj];
                    if ([time isEqualToString:firstInterval]) {
                        break;
                    }
                }
            }
        }
        operAry = nil;
        if (ary.count >= 20) {
            return [ary objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(ary.count -20, 20)]];
        }else {
            return ary;
        }
    }
    return nil;
}


+ (BOOL)archiveData:(id)dataObj inCacheDirectory:(NSString *)filename {
    
    NSString *path = CQTPathForCachesResource(filename);
    
    return [CQTArchive archiveData:dataObj intoPath:path];
}

+ (void)archiveData:(id)dataObj inCacheDirectory:(NSString *)filename
            success:(void (^)())successBlock failure:(void (^)(NSError *error))failureBlock {
    
    NSString *path = CQTPathForCachesResource(filename);
    
    dispatch_async(archive_processing_queue(), ^{
        
        BOOL saved = [CQTArchive archiveData:dataObj intoPath:path];
        
        if (saved && successBlock) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                successBlock();
            });
            return ;
        }
        
        if (failureBlock) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                failureBlock(nil);
            });
        }
    });
}

+ (id)unarchiveObjectFromCacheDirectory:(NSString *)filename {
    
    NSString *path = CQTPathForCachesResource(filename);
    
    return [CQTArchive unarchiveObjectFromPath:path];
}

+ (BOOL)archiveData:(id)dataObj inDocumentDirectory:(NSString *)filename {
    
    NSString *path = CQTPathForDocumentsResource(filename);
    
    return [CQTArchive archiveData:dataObj intoPath:path];
}

+ (void)archiveData:(id)dataObj inDocumentDirectory:(NSString *)filename
            success:(void (^)())successBlock failure:(void (^)(NSError *error))failureBlock {
    
    [CQTArchive archiveData:dataObj inDocumentDirectory:filename useMainThread:NO success:successBlock failure:failureBlock];
}

+ (void)archiveData:(id)dataObj inDocumentDirectory:(NSString *)filename useMainThread:(BOOL)mainThread
            success:(void (^)())successBlock failure:(void (^)(NSError *error))failureBlock {
    
    NSString *path = CQTPathForDocumentsResource(filename);
    
    if (mainThread) {
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            BOOL saved = [CQTArchive archiveData:dataObj intoPath:path];
            
            if (saved && successBlock) {
                
                successBlock();
                
                return ;
            }
            
            if (failureBlock) {
                
                failureBlock(nil);
            }
            
        });
    }else {
        
        dispatch_async( archive_processing_queue(), ^{
            
            BOOL saved = [CQTArchive archiveData:dataObj intoPath:path];
            
            if (saved && successBlock) {
                
                successBlock();
                
                return ;
            }
            
            if (failureBlock) {
                
                failureBlock(nil);
            }
        });
        
    }
}

+ (id)unarchiveObjectFromDocumentDirectory:(NSString *)filename {
    
    NSString *path = CQTPathForDocumentsResource(filename);
    
    return [CQTArchive unarchiveObjectFromPath:path];
    
}

+ (BOOL)removeArchiveDataFromDocumentDirectory:(NSString *)filename {
    
    NSString *path = CQTPathForDocumentsResource(filename);
    return [CQTArchive removeArchiveFromPath:path];
}


+ (BOOL)removeObjectFromCacheDirectory:(NSString *)dir filename:(NSString *)filename {
    
    NSString *path = [CQTArchive pathInCacheDirectory:dir filename:filename];
    
    return [CQTArchive removeArchiveFromPath:path];
}

+ (BOOL)removeArchiveFromPath:(NSString *)path {
    
    @synchronized(path) {
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        return [fileManager removeItemAtPath:path error:nil];
    }
}


+ (BOOL)archiveData:(id)dataObj intoPath:(NSString *)path {
    
    if (!path || !dataObj) {
        
        return NO;
    }
    BOOL result;
    
    @synchronized(path) {
        
        result = [NSKeyedArchiver archiveRootObject:dataObj
                                             toFile:path];
    }
    return result;
}

+ (id)unarchiveObjectFromPath:(NSString *)path {
    
    if (!path) {
        
        return nil;
    }
    
    
    id obj = nil;
    @synchronized(path) {
        
        obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    return obj;
}

+ (NSString*)cachePathWithName:(NSString*)name {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString* cachesPath = [paths objectAtIndex:0];
    
    if ([name length] == 0)
        
        return cachesPath;
    
    NSString* cachePath;
    
    if ([name rangeOfString:cachesPath].length > 0) {
        
        cachePath = name;
    }else {
        
        cachePath = [cachesPath stringByAppendingPathComponent:name];
    }
    
    
    [self createPathIfNecessary:cachesPath];
    [self createPathIfNecessary:cachePath];
    
    return cachePath;
}


+ (BOOL)createPathIfNecessary:(NSString*)path {
    
    BOOL succeeded = YES;
    
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        succeeded = [fm createDirectoryAtPath: path
                  withIntermediateDirectories: YES
                                   attributes: nil
                                        error: nil];
    }
    
    BOOL existed = [fm fileExistsAtPath:path];
    
    if (existed) {
        
        
    }
    
    return succeeded;
}

@end

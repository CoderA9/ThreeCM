//
//  CQTCache.h
//  CQTMemberShip
//
//  Created by sky on 12-3-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kInvalidDate  30*24*3600L
#define kDocDir                         [(NSArray*)NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] 
#define kCacheDir                       [(NSArray*)NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kImagesDir                      [kCacheDir  stringByAppendingPathComponent:@"images"]
#define kOthersDir                      [kCacheDir  stringByAppendingPathComponent:@"others"]
#define kDataDir                        [kOthersDir stringByAppendingPathComponent:@"Data"]
#define kBigDataDir                     [kOthersDir stringByAppendingPathComponent:@"bigData"]
#define kDirString                      @"/"

#define KNotificationDidClearCache @"KNotificationDidClearCache"

typedef enum  {
	
	CQTDownloadFileTypeImages,
	CQTDownloadFileTypeOthers
}
CQTDownloadFileType;

@interface CQTCache : NSObject {

}

+ (CQTCache *)CQTSharedInstance;

- (void)createCacheDirsIfNeeded;

/* 清除缓存 */
- (BOOL)removeCacheDirs;

- (void)emptyCache;
- (void)deleteAllFilesInDir:(NSString*)path;

- (NSString*)trimURL:(NSString*)fileURL;
- (BOOL)fileIsExist:(NSString*)fileURL;
- (BOOL)fileIsExpirateDate:(NSString*)filePath;
- (NSDate*)fileCreateDate:(NSString*)filePath;
- (void)removeFileExperiateDate;
- (void)removeFileExperiateAtPath:(NSString*)path;

- (UIImage*)image4URL:(NSString*)imageURL cacheFileType:(CQTDownloadFileType)fileType;
- (NSData*)data4ImageURL:(NSString*)imageURL cacheFileType:(CQTDownloadFileType)fileType;
- (BOOL)cacheImage4URL:(NSString*)imageURL imageData:(NSData*)imageData cacheFileType:(CQTDownloadFileType)fileType;
- (BOOL)removeCacheFileWithURL:(NSString*)imageURL cacheFileType:(CQTDownloadFileType)fileType;


@end

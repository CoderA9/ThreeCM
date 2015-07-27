//
//  CQTCache.m
//  CQTMemberShip
//
//  Created by sky on 12-3-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CQTCache.h"
#import "Util.h"

static CQTCache * _cache = nil;

#pragma mark -
@implementation CQTCache

+ (CQTCache *)CQTSharedInstance {
	if(_cache){
		
		return _cache;
	}
	
	@synchronized([CQTCache class]){
		
		if(_cache == nil){
			
			_cache = [[CQTCache alloc] init];
		   [_cache createCacheDirsIfNeeded];
			[_cache removeFileExperiateDate];
		}
	}
	return _cache;
}

- (void)createCacheDirsIfNeeded {
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:kImagesDir]) {
		
		[[NSFileManager defaultManager] createDirectoryAtPath:kImagesDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
	if (![[NSFileManager defaultManager] fileExistsAtPath:kOthersDir]) {
		
		[[NSFileManager defaultManager] createDirectoryAtPath:kOthersDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
}

- (BOOL)removeCacheDirs {
    
    BOOL removed = YES;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:kImagesDir]) {
        
        NSError *error;
        
        [[NSFileManager defaultManager] removeItemAtPath:kImagesDir error:&error];
        
        if (error) {
            removed = NO;
            NSLog(@"description: %@",error.description);
        }
	}
	if ([[NSFileManager defaultManager] fileExistsAtPath:kOthersDir]) {
		
        NSError *error;
        
        [[NSFileManager defaultManager] removeItemAtPath:kOthersDir error:&error];
        
        if (error) {
            removed = NO;
            NSLog(@"description: error");
        }
	}
    
    [self createCacheDirsIfNeeded];
    
    return removed;
}

- (void)deleteAllFilesInDir:(NSString*)path {
	
	NSError* err=nil;
	NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&err];
	if (err!=nil) {
		return; 
	}
	for (NSString* file in files) {
		
		NSString* filepath = [path stringByAppendingPathComponent:file];
	    if ([self fileIsExpirateDate:filepath]) {
            
            CQTDebugLog(@"删除文件:%@", filepath);
            
	       [[NSFileManager defaultManager] removeItemAtPath:filepath error:&err];
            
            if (err) {
                
            
            }
		}
	}
}

- (void)emptyCache {
	
    [self removeCacheDirs];
//	[self deleteAllFilesInDir:kImagesDir];
//	[self deleteAllFilesInDir:kOthersDir];
}

//file create?
- (NSDate*)fileCreateDate:(NSString*)filePath {

	NSDate *date = nil;
	NSError *err = nil;
	NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&err];
	if (err != nil || fileAttributes== nil) {
		
	}
	else {
		
		date = [fileAttributes fileModificationDate];
	}
	return date;
}

//file exist?
- (BOOL)fileIsExist:(NSString*)fileURL {

	BOOL bExist = [[NSFileManager defaultManager] fileExistsAtPath:fileURL];
	if(bExist){
	
		if ([self fileIsExpirateDate:fileURL]) {
			
     		CQTDebugLog(@"fileIsExist:删除文件:%@", fileURL);
            
			[[NSFileManager defaultManager] removeItemAtPath:fileURL error:nil];
			bExist = NO;
		}
	}
	return bExist;
}

//file experateDate?
- (BOOL)fileIsExpirateDate:(NSString*)filePath {
	
	NSDate *fileDate = [self fileCreateDate:filePath];
	NSDate *date = [NSDate date];
	NSDate *experateDate = [fileDate dateByAddingTimeInterval:kInvalidDate];
//	CQTDebugLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
//	CQTDebugLog(@"fileDate=%@\n experateDate=%@\n date=%@d", [fileDate descriptionWithLocale:[NSLocale currentLocale]], 
//															   [experateDate descriptionWithLocale:[NSLocale currentLocale]],
//															   [date descriptionWithLocale:[NSLocale currentLocale]]);
//	CQTDebugLog(@"-------------------------------------------------------------");
	return ([date compare:experateDate] !=  NSOrderedAscending);
}

//remove directorr
- (void)removeFileExperiateAtPath:(NSString*)path {
	
    @autoreleasepool {
        
        NSError* err=nil;
        NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&err];
        if (err!=nil || [files count]==0) {
            
            return;
        }
        else {
            
            for (NSString* file in files) {
                
                @autoreleasepool {
                    
                    NSString* filepath = [path stringByAppendingPathComponent:file];
                    if ([self fileIsExpirateDate:filepath]) {
                        
                        CQTDebugLog(@"删除文件:%@", filepath);
                        [[NSFileManager defaultManager] removeItemAtPath:filepath error:&err];
                    }
                }
            }
        }
    }
}

//remove all cache directors
- (void)removeFileExperiateDate {
	
	[self removeFileExperiateAtPath:kImagesDir];
	[self removeFileExperiateAtPath:kOthersDir];
}

- (NSString*)trimURL:(NSString*)fileURL {
	
	NSString *strName = [fileURL lastPathComponent];
	NSRange range;
	range.location = 0;
	range.length = [fileURL length]-[strName length];
	NSString *trimedURL = [fileURL substringWithRange:range];
    trimedURL =  [trimedURL stringByReplacingOccurrencesOfString:@"." withString:@""];
	trimedURL =[trimedURL stringByReplacingOccurrencesOfString:@"/" withString:@""];
	trimedURL =[trimedURL stringByReplacingOccurrencesOfString:@":" withString:@""];
	trimedURL = [trimedURL stringByAppendingString:strName];
//	CQTDebugLog(@"fileURL=%@\ntrimedURL=%@", fileURL, trimedURL);
	return trimedURL;
}

- (UIImage*)image4URL:(NSString*)imageURL cacheFileType:(CQTDownloadFileType)fileType {

	UIImage *image  = nil;
	NSString *path = @"";
	if (fileType == CQTDownloadFileTypeImages) {
		
		path = kImagesDir;
	}
	else if(fileType == CQTDownloadFileTypeOthers) {
		
		path = kOthersDir;
	}
	path = [path stringByAppendingPathComponent:[self trimURL:imageURL]];
	BOOL bExist = [self fileIsExist:path];
	if(bExist) {
	
        NSData *imagedata = [NSData dataWithContentsOfFile:path];
        image = [UIImage imageWithData:imagedata];
	}
	return image;
}

- (NSData*)data4ImageURL:(NSString*)imageURL cacheFileType:(CQTDownloadFileType)fileType {
    
	NSData *imagedata = [NSData data];
	NSString *path = @"";
	if (fileType == CQTDownloadFileTypeImages) {
		
		path = kImagesDir;
	}
	else if(fileType == CQTDownloadFileTypeOthers) {
		
		path = kOthersDir;
	}
	path = [path stringByAppendingPathComponent:[self trimURL:imageURL]];
	BOOL bExist = [self fileIsExist:path];
	if(bExist) {
        
        imagedata = [NSData dataWithContentsOfFile:path];
	}
	return imagedata;
}

- (BOOL)removeCacheFileWithURL:(NSString*)imageURL cacheFileType:(CQTDownloadFileType)fileType {
    
    BOOL b = NO;
    if ([imageURL length]>0) {
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *path = @"";
        if (fileType == CQTDownloadFileTypeImages) {
            
            path = kImagesDir;
        }
        else if(fileType == CQTDownloadFileTypeOthers) {
            
            path = kOthersDir;
        }
        
        path = [path stringByAppendingPathComponent:[self trimURL:imageURL]];
        if ([fileMgr fileExistsAtPath:path]) {
            
            b =[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        CQTDebugLog(@"removeCacheFileWithURL=%@", imageURL);
    }

    return b;
}

- (BOOL)cacheImage4URL:(NSString*)imageURL imageData:(NSData*)imageData cacheFileType:(CQTDownloadFileType)fileType {

	NSString *path = @"";
	NSData *data = [NSData dataWithData:imageData];

	if (fileType == CQTDownloadFileTypeImages) {
		
		path = kImagesDir;
	}
	else if(fileType == CQTDownloadFileTypeOthers) {
		
		path = kOthersDir;
	}
	
	path = [path stringByAppendingPathComponent:[self trimURL:imageURL]];
	BOOL bSuccess = [data writeToFile:path options:NSDataWritingFileProtectionNone error:nil];
	if (bSuccess) {
		
	}
	else {
		
	}

	return NO;
}

- (void)dealloc {

	if(_cache == self) _cache = nil;
	[[NSRunLoop mainRunLoop] cancelPerformSelectorsWithTarget:self];
	CQT_SUPER_DEALLOC();
}

@end

	//
//  CQTNetModel.m
//  CQTMemberShip
//
//  Created by sky on 12-3-3.
//  Copyright 2012 CQTimes.cn. All rights reserved.
//

#import "CQTNetModel.h"
//#import "Def.h"
#import "Util.h"
#import "NetDef.h"
#import "CQTCache.h"

#define kZIP						@"zip"

#define kRequestFailedOrException       @"网络故障或请求失败!"

@implementation CQTNetModel
@synthesize httpRequest;
@synthesize strURL;
@synthesize strAction;
@synthesize isDownload;
@synthesize fileType;
@synthesize modelDelegate;
@synthesize specialTxt;
@synthesize progressDelegate;

#pragma mark -

- (id)init {

	self = [super init];
	if (self) {
		
        httpRequest = [[CQTHttpRequest alloc] init];
		httpRequest.delegate = self;
	}
	return self;
}

- (id)initWithModelDelegate:(id)dlt {
    
	self = [self init];
	if (self) {
		
		self.modelDelegate = dlt;
	}
	return self;
}

- (void)dealloc {

    modelDelegate = nil;
	progressDelegate = nil;
    
    A9_ObjectReleaseSafely(strURL);
    A9_ObjectReleaseSafely(strAction);
//    [strOutFilePath release];
	if (httpRequest != nil) {
		
		[self modelCanel];
	}
    
//	CQTDebugLog(@"CQTNetModel delloc------------------->");
	
}

- (void)modelCanel {

	if (httpRequest != nil) {
	
		httpRequest.delegate = nil;
        httpRequest.progressDelegate = nil;
		[httpRequest cancel];
        
        A9_ObjectReleaseSafely(httpRequest);
		httpRequest = nil;
	}
}

+ (BOOL)isRequestSuccess:(NSString*)strCode {

    BOOL bOk = NO;
    if ([strCode isKindOfClass:[NSNumber class]]) {
        
        bOk = [[(NSNumber*)strCode stringValue] isEqualToString:kRequestStatusCodeOK1];
    }
    else if([strCode isKindOfClass:[NSString class]]) {
    
        bOk = [strCode isEqualToString:kRequestStatusCodeOK1];
    }
	return bOk;
}

+ (BOOL)isRequestSuccess4AppStoreInfo:(NSDictionary*)info {

	BOOL bSuccess = NO;
	NSNumber *resultCount = [info valueForKey:kWhereIsAppInAppstoreResultCountKey];
	NSDictionary *dic = [info valueForKey:kWhereIsAppInAppstoreResultsKey];
	if (resultCount != nil && dic!= nil && [resultCount isKindOfClass:[NSNumber class]]) {
	
		 if ([resultCount intValue]==1) {
			 
			 bSuccess = YES;
		 }
	}
	return bSuccess;
}

+ (BOOL)isRequestSuccess4UploadTocken:(NSString*)strCode {
    
    BOOL bOk = NO;
    if ([strCode isKindOfClass:[NSNumber class]]) {
        
        bOk = [[(NSNumber*)strCode stringValue] isEqualToString:kRequestStatusCodeOK4UploadToken];
    }
    else if([strCode isKindOfClass:[NSString class]]) {
        
        bOk = [strCode isEqualToString:kRequestStatusCodeOK4UploadToken];
    }
    return bOk;
}


#pragma mark -
#pragma mark Parse

- (NSDictionary*)fitForDictionary:(NSDictionary*)srcDic withTransformDic:(NSDictionary*)tansformDic {
	
	NSMutableDictionary *destInfo = nil;
	if (srcDic != nil && tansformDic != nil) {
		
		destInfo = CQT_AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:0]);
		NSArray *allKeys = [tansformDic allKeys];
		for (NSString *strKey in allKeys) {
			
			NSString *str = [tansformDic valueForKeyPath:strKey];
			id obj = [srcDic valueForKeyPath:str];
			if ([obj isKindOfClass:[NSNumber class]]) {
				
				obj = [(NSNumber*)obj stringValue];
			}
			[destInfo setObject:obj forKey:strKey];
		}
	}
	return destInfo;
}

- (void)handleAfterParse:(NSDictionary*)afterParseInfo {
	
    if (self.isDownload) {
        
        if(modelDelegate != nil && [modelDelegate respondsToSelector:@selector(netModel:downloadFinishedWithInfo:)]) {
            
           [modelDelegate netModel:self downloadFinishedWithInfo:afterParseInfo];
        }
    }
	else {
        
      if(modelDelegate != nil && [modelDelegate respondsToSelector:@selector(netModel:requestFinishedWithInfo:)]) {
		
           [modelDelegate netModel:self requestFinishedWithInfo:afterParseInfo];
       }
	}
}

- (void)handleParseError {

	[self requestFailed:self.httpRequest error:nil];
}

- (void)parseReceiveData:(NSData*)receiveData {

	@autoreleasepool {

        NSString* stringToParse = CQT_AUTORELEASE([[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding]);
        NSDictionary *pareseDic = (NSDictionary*)[stringToParse JSONValue];
    //    CQTDebugLog(@"pareseDic msg=%@", [pareseDic value4KeyPath:kRequestMsgKey]);
        if (pareseDic != nil) {
        
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary: pareseDic];
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            BOOL bSucess = ([self.strAction isEqualToString:kUploadTokenAction])? [CQTNetModel isRequestSuccess4UploadTocken:[info valueForKeyPath:kRequestCodeKey]]:[CQTNetModel isRequestSuccess:[info valueForKeyPath:kRequestCodeKey]];
            
            if (!bSucess) {
                
                bSucess = [CQTNetModel isRequestSuccess:[info valueForKey:kStatusKey]];
            }
            if ([self.strAction isEqualToString:kWhereIsAppInAppstoreAction]) {
                
                [resultDic setObject:[NSNumber numberWithBool:YES] forKey:kRequestStatusKey];
            }else {
                if (bSucess){
                    
                    [resultDic setObject:[NSNumber numberWithBool:bSucess] forKey:kRequestStatusKey];
                }
                else {
                    
                    [resultDic setObject:[NSNumber numberWithInt:kRequestStatus_1] forKey:kRequestStatusKey];
                    CQTDebugLog(@"request success but return error---->>");
                }

            }
                    
            
            [resultDic setObject:[pareseDic value4KeyPath:kRequestMsgKey] forKey:kRequestMsgKey];
            [resultDic setObject:self.strAction forKey:kRequestActionKey];
            [resultDic setObject:self.strURL forKey:kRequestURLKey];
            [resultDic setObject:info forKey:kRequestResultKey];
            [self performSelectorOnMainThread:@selector(handleAfterParse:) withObject:resultDic waitUntilDone:NO];
            
            CQT_RELEASE(resultDic);

        }
        else {
            
            CQTDebugLog(@"handleParseError---->>==nil: %@", self.strURL);
            [self performSelectorOnMainThread:@selector(handleParseError) withObject:nil waitUntilDone:NO];
        }
    }
}

//ZIP
//+ (BOOL)UnzipFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
//    
//	BOOL ret = NO;
//	ZipArchive* zip = [[ZipArchive alloc] init];
//	ret = [zip UnzipOpenFile:fromPath];
//	if(ret){
//		
//		ret = [zip UnzipFileTo:toPath overWrite:YES bNeedOriginDate:NO];
//		if(!ret ){
//			
//			NSLog(@"UnZip failed");
//		}
//		[zip UnzipCloseFile];
//	}
//	[zip release];
//    
//	return ret;
//}

- (void)saveFileToLocal:(NSData*)receiveData {
    
	@autoreleasepool {
        
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //write File
        NSData *data = [[NSData alloc] initWithData:receiveData];
        BOOL ret = [[CQTCache CQTSharedInstance] cacheImage4URL:self.strURL imageData:data cacheFileType:self.fileType];
        
        //
        NSNumber *statusId = [NSNumber numberWithInt:ret?YES:kRequestOK];
        [resultDic setObject:statusId forKey:kRequestStatusKey];
        [resultDic setObject:self.strAction forKey:kRequestActionKey];
        [resultDic setObject:self.strURL forKey:kRequestURLKey];
        [self performSelectorOnMainThread:@selector(handleAfterParse:) withObject:resultDic waitUntilDone:NO];
        
        
        A9_ObjectReleaseSafely(data);
        A9_ObjectReleaseSafely(resultDic);
    }
}

- (void)downloadFileFromURL:(NSString*)url fileType:(CQTDownloadFileType)ft {
    
	strAction = [[NSString alloc] initWithFormat:@"%@", url];
	strURL = [[NSString alloc] initWithFormat:@"%@", url];
    self.fileType  = ft;
    self.isDownload = YES;
	if (httpRequest != nil) {
		
		httpRequest.needProgress = YES;
		[httpRequest requestGET:self.strURL];
	}
}

#pragma mark -
#pragma mark CQTHttpRequestDelegate

- (void)requestSucceeded:(CQTHttpRequest*)request {
    
	if (request.contentTypeImgOrJsonOrXmlOrTextFlag == CQTContentTypeFile) {
		
//		CQTDebugLog(@"---->>DownloadSucceeded :%@", self.strURL);
		[NSThread detachNewThreadSelector:@selector(saveFileToLocal:) toTarget:self withObject:request.receivedData];
	}
	else if (request.contentTypeImgOrJsonOrXmlOrTextFlag == CQTContentTypeJson) {
        
//		CQTDebugLog(@"---->>requestSucceeded: %@", self.strURL);
		[NSThread detachNewThreadSelector:@selector(parseReceiveData:) toTarget:self withObject:request.receivedData];
	}
	else {
		
//		CQTDebugLog(@"---->>contentType is not Json or File :%@", self.strURL);
        [self performSelectorOnMainThread:@selector(handleParseError) withObject:nil waitUntilDone:NO];
	}
}

- (void)requestFailed:(CQTHttpRequest*)request error:(NSError*)error {
    
	CQTDebugLog(@"------>requestFailed :%@", self.strURL);
	NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:0];
	NSNumber *statusId = [NSNumber numberWithInt:kRequestStatusError];
	[resultDic setObject:statusId forKey:kRequestStatusKey];
	[resultDic setObject:self.strAction forKey:kRequestActionKey];
	[resultDic setObject:self.strURL forKey:kRequestURLKey];
    [resultDic setObject:kRequestFailedOrException forKey:kRequestMsgKey];
//	CQTDebugLog(@"resultDic=%@", resultDic);
	[self handleAfterParse:resultDic];
	
    A9_ObjectReleaseSafely(resultDic);
}

- (void)request:(CQTHttpRequest*)request didReceiveData:(NSData*)data {
    
}

- (void)request:(CQTHttpRequest*)request progressTotalGot:(NSNumber*)total {
    
	if (request.needProgress && progressDelegate != nil && [progressDelegate respondsToSelector:@selector(netModel:requestProgressTotalGot:)]) {
		
		[progressDelegate performSelector:@selector(netModel:requestProgressTotalGot:) withObject:self withObject:total];
	}
}

- (void)request:(CQTHttpRequest*)request progressNewGot:(NSNumber*)newGot {
    
	if (request.needProgress && progressDelegate != nil && [progressDelegate respondsToSelector:@selector(netModel:requestProgressNewGot:)]) {
		
		[progressDelegate performSelector:@selector(netModel:requestProgressNewGot:) withObject:self withObject:newGot];
	}
}

#pragma mark -

@end


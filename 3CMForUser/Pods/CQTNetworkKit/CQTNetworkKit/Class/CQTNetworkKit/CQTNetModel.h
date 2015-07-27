//
//  CQTNetModel.h
//  CQTMemberShip
//
//  Created by sky on 12-3-3.
//  Copyright 2012 CQTimes.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQTHttpRequest.h"
#import "NSString+SBJSON.h"
#import "SBJsonBase.h"
#import "LocalDef.h"
#import "NetDef.h"
#import "CQTCache.h"

typedef enum {
    CQTHTTPRequestGETMethod  =   0,
    CQTHTTPRequestPOSTMethod,
    CQTHTTPRequestPutMethod,
    CQTHTTPRequestDELETEMethod
} CQTHTTPRequestMethodType;

@protocol CQTNetModelDelegate;

@interface CQTNetModel : NSObject<CQTHttpRequestDelegate> {
	
	CQTHttpRequest *httpRequest;
	NSString *strURL;
	NSString *strAction;
    CQTDownloadFileType fileType;
    BOOL isDownload;
	
	__unsafe_unretained id <CQTNetModelDelegate> modelDelegate;
    __unsafe_unretained id <CQTNetModelDelegate> progressDelegate;
    NSString *specialTxt;
}

@property (nonatomic, retain) CQTHttpRequest *httpRequest;
@property (nonatomic, retain) NSString *strURL;
@property (nonatomic, retain) NSString *strAction;
@property (nonatomic, assign) id <CQTNetModelDelegate> modelDelegate;
@property (nonatomic, assign) CQTDownloadFileType fileType;
@property (nonatomic, assign) BOOL isDownload;
@property (nonatomic, assign) id <CQTNetModelDelegate> progressDelegate;
@property (nonatomic, retain) NSString *specialTxt;

- (id)initWithModelDelegate:(id)dlt;
- (void)modelCanel;
- (void)parseReceiveData:(NSData*)receiveData;

//Download File
- (void)downloadFileFromURL:(NSString*)url fileType:(CQTDownloadFileType)fileType;

@end


@protocol CQTNetModelDelegate<NSObject>

@required
- (void)netModel:(CQTNetModel*)netModel requestFinishedWithInfo:(NSDictionary*)requestInfo;
- (void)netModel:(CQTNetModel*)netModel downloadFinishedWithInfo:(NSDictionary*)requestInfo;
- (void)netModel:(CQTNetModel*)netModel requestProgressTotalGot:(NSNumber*)total;
- (void)netModel:(CQTNetModel*)netModel requestProgressNewGot:(NSNumber*)newGot;

@end


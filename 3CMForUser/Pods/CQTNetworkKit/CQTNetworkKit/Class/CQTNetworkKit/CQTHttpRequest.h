//
//  CQTHttpRequest.h
//  CQTMemberShip
//
//  Created by sky on 12-2-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPostURL    @"url"
#define kPostInfo   @"info"
#define K_CN_ENC  CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
#define RETRY_INTERVAL           2.f
#define TIMEOUT_SEC              20.f
#define RUNNING_LIMIT_COUNT      15
#define MULTI_FORM_BOUNDARY     @"S0SOS"

typedef enum 
{
  CQTContentTypeNone=-1,
  CQTContentTypeText,
  CQTContentTypeImage,
  CQTContentTypeJson,
  CQTContentTypeXml,
  CQTContentTypeFile
}
CQTContentType;

@protocol CQTHttpRequestDelegate;

@interface CQTHttpRequest : NSObject {

	__unsafe_unretained id<CQTHttpRequestDelegate> delegate;
    __unsafe_unretained id progressDelegate;
	NSURLConnection *connection;
	NSMutableData *receivedData;
	int statusCode;
	id extraData;
	long long dataLength;
	
	// spinner notify state NO - init, YES - show
	NSUInteger contentTypeImgOrJsonOrXmlOrTextFlag;
	BOOL noCheckResponse;
	BOOL noShowNetworkIndicator;
    BOOL needProgress;
    BOOL bGB2312Encode;
}

@property (assign) id<CQTHttpRequestDelegate> delegate; //5.3
@property (assign) id progressDelegate; //5.3
@property (readonly) NSMutableData *receivedData;
@property (readonly) int statusCode;
@property (retain) id extraData;
@property (assign) BOOL noCheckResponse;
@property (assign) long long dataLength;
@property (assign) BOOL noShowNetworkIndicator;
@property (assign) NSUInteger contentTypeImgOrJsonOrXmlOrTextFlag;
@property (assign) BOOL needProgress;
@property (assign) BOOL bGB2312Encode;

//
- (id)initWithDelegate:(id)del andExtraData:(id)data;
+ (void)cancelAllRunningRequests;
+ (void)currentRequest;
- (void)cancel;
+ (NSString*)makeBody:(NSDictionary*)params; 
- (void)requestGET:(NSString*)url;
- (void)requestPOST:(NSDictionary*)info;
- (void)requestPOST4MultiForm:(NSDictionary*)params;

@end

@protocol CQTHttpRequestDelegate<NSObject>

@required
- (void)requestSucceeded:(CQTHttpRequest*)request;
- (void)requestFailed:(CQTHttpRequest*)request error:(NSError*)error;

@optional
- (void)request:(CQTHttpRequest*)request didReceiveData:(NSData*)data;
- (void)request:(CQTHttpRequest*)request progressTotalGot:(NSNumber*)total;
- (void)request:(CQTHttpRequest*)request progressNewGot:(NSNumber*)total;

@end

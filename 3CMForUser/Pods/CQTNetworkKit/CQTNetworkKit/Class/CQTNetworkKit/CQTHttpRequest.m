//
//  CQTHttpRequest.m
//  CQTMemberShip
//
//  Created by sky on 12-2-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CQTHttpRequest.h"
#import "CQTReachability.h"
#import "Util.h"

#define kContentTypeImageJPEG  @"image/jpeg"
#define BOUNDARY @"------------0x0x0x0x0x0x0x0x"




@implementation CQTHttpRequest
@synthesize delegate, progressDelegate, receivedData, statusCode, extraData, noCheckResponse, dataLength;
@synthesize contentTypeImgOrJsonOrXmlOrTextFlag;
@synthesize noShowNetworkIndicator;
@synthesize needProgress;
@synthesize bGB2312Encode;

// if the total requests count less then 24, return a request, else return nil;
static NSMutableArray *_requestPool = nil;

- (void)placeIntoPool {
	
	if(!_requestPool) {
	
		_requestPool = [NSMutableArray new];
	}
	
	[_requestPool addObject:self];
}

- (BOOL)canRun{

	static BOOL niceTold = NO;
//	BOOL well = [Reachability isNetworkWell];
	
//    BOOL well = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).hostActive;
    BOOL well = [CQTNetState sharedState].currentNetStatus == CQTNotReachable ? NO : YES;
    
	if(!niceTold && !well) {
		
//		[Util alertNotOftenWithTitle:@"" andMessage:@"网络不可用!"];
		niceTold = YES;
	}
	return [_requestPool indexOfObject:self] < RUNNING_LIMIT_COUNT;
}

- (void)removeFromPool {

	[_requestPool removeObject:self];
}

+ (void)cancelAllRunningRequests {

	// not use _requestPool array so that won't cause modified when emurated exception
	NSArray *array = [NSArray arrayWithArray:_requestPool];
	for(CQTHttpRequest *req in array) {
		
		[req cancel];
	}
}

+ (void)currentRequest {

	NSArray *array = [NSArray arrayWithArray:_requestPool];
	int i = 1;
	for(CQTHttpRequest *req in array) {
		
		CQTDebugLog(@"Request%i= %@  URL= %@", i, req, req.extraData);
		 i++;
	}
}

- (id)init {
	
    self = [super init];
    if (self) {
      
        receivedData = [[NSMutableData alloc] init];
        self.noCheckResponse = NO;
        [self placeIntoPool];
    }
	return self;
}

- (id)initWithDelegate:(id)dlt andExtraData:(id)data {
    
    self = [self init];
    if (self) {
        
        self.delegate = dlt;
        self.extraData = data;
    }
	return self;
}

- (void)dealloc {

	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self removeFromPool];
//	[CQTHttpRequest currentRequest];
	self.delegate = nil;
    self.progressDelegate = nil;
	self.extraData = nil;
    CQT_RELEASE(connection);
	receivedData = nil;
	
}

- (void)cancel{

	[connection cancel];
	if([_requestPool indexOfObject:self] != NSNotFound)
	{        
		if ([delegate respondsToSelector:@selector(requestFailed:error:)])
			[delegate requestFailed:self error:nil];
		[self removeFromPool];
	}
	[Util hideNetworkIndicator];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
	statusCode = [(NSHTTPURLResponse*)response statusCode];
    
	contentTypeImgOrJsonOrXmlOrTextFlag = CQTContentTypeNone;
	NSDictionary *header = [(NSHTTPURLResponse*)response allHeaderFields];
    NSString *content_type = [header objectForKey:@"Content-Type"];
    CQTDebugLog(@"statusCode: %d content_type: %@", statusCode, content_type);
	if(statusCode == 200)	 {
		
        dataLength = [(NSString*)[header objectForKey:@"Content-Length"] integerValue];
		if (content_type) {
			
			if ([content_type rangeOfString:@"image"].location != NSNotFound)
				contentTypeImgOrJsonOrXmlOrTextFlag = CQTContentTypeFile;
			
			else if([content_type rangeOfString:@"text/javascript"].location != NSNotFound)
				contentTypeImgOrJsonOrXmlOrTextFlag = CQTContentTypeJson;
			
			else if([content_type rangeOfString:@"text"].location != NSNotFound)
				contentTypeImgOrJsonOrXmlOrTextFlag = CQTContentTypeText;
			
			else if([content_type rangeOfString:@"json"].location != NSNotFound)
				contentTypeImgOrJsonOrXmlOrTextFlag = CQTContentTypeJson;
			
			else if([content_type rangeOfString:@"xml"].location != NSNotFound)
				contentTypeImgOrJsonOrXmlOrTextFlag = CQTContentTypeXml;
			
			else if([content_type rangeOfString:@"zip"].location != NSNotFound)
				contentTypeImgOrJsonOrXmlOrTextFlag = CQTContentTypeFile;
			
			else if([content_type rangeOfString:@"image"].location != NSNotFound)
				contentTypeImgOrJsonOrXmlOrTextFlag = CQTContentTypeFile;
		}
	}
    
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [receivedData setLength:0];
	
	if(statusCode == 200 && needProgress && delegate != nil && [delegate respondsToSelector:@selector(request:progressTotalGot:)]) {
		
		NSNumber *total = [NSNumber numberWithLongLong:[[header valueForKey:@"Content-Length"] longLongValue]];
		[delegate performSelector:@selector(request:progressTotalGot:) withObject:self withObject:total];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
	[receivedData appendData:data];
	if(delegate!= nil && [delegate respondsToSelector:@selector(request:didReceiveData:)]) {
        
		[delegate request:self didReceiveData:data];
	}
    
	if(statusCode == 200 && needProgress && delegate != nil && [delegate respondsToSelector:@selector(request:progressNewGot:)]){
		
		[delegate performSelector:@selector(request:progressNewGot:) withObject:self withObject:[NSNumber numberWithLongLong:[receivedData length]]];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*) error {
    
	if (!noShowNetworkIndicator)[Util hideNetworkIndicator];
	[self removeFromPool];
	if (delegate!= nil && [delegate respondsToSelector:@selector(requestFailed:error:)]){
        
		[delegate requestFailed:self error:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {

//    NSLog(@"connectionDidFinishLoading requestGET....url");
	if((!noCheckResponse && (contentTypeImgOrJsonOrXmlOrTextFlag==CQTContentTypeNone)) ||
       (contentTypeImgOrJsonOrXmlOrTextFlag == CQTContentTypeFile && dataLength !=  [receivedData length])) {
       
		[self connection:conn didFailWithError:nil];
	}
	else {
    
		[Util hideNetworkIndicator];
		[self removeFromPool];
		if (delegate!= nil && [delegate respondsToSelector:@selector(requestSucceeded:)]) {
            
			[delegate requestSucceeded:self];
		}
	}

//    NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    CQTDebugLog(@"returnString =%@", returnString);
//    [returnString release];
}

#pragma mark -
#pragma mark Request 

- (NSMutableURLRequest*)makeRequest:(NSString*)url {
	
	NSString *encodedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)url, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8));
	NSMutableURLRequest *request = CQT_AUTORELEASE([[NSMutableURLRequest alloc] init]);
	[request setURL:[NSURL URLWithString:encodedUrl]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setTimeoutInterval:TIMEOUT_SEC];
	[request setHTTPShouldHandleCookies:FALSE];
	[request setValue:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_5; en-us) AppleWebKit/526.11 (KHTML, like Gecko)" forHTTPHeaderField:@"User-Agent"];
    
    CQT_RELEASE(encodedUrl);

	return request;
}

+ (NSString*)makeBody:(NSDictionary*)params {
	
	if (nil == params || [params count] == 0)
		return nil;
	
	NSMutableString *postString = CQT_AUTORELEASE([[NSMutableString alloc] init]);
	NSArray* allKeys = [params allKeys];
	NSUInteger allKeysCount = [allKeys count];
	NSString* paramName = nil;
	for(NSUInteger i = 0; i < allKeysCount - 1; ++i) {
		
		paramName = [allKeys objectAtIndex:i];
        NSString *value = [params objectForKey:paramName];
        if ([value isKindOfClass:[NSNumber class]]) {
            
            value = [(NSNumber*)value stringValue];
        }
        value = [Util webParamEncode:value];
		[postString appendFormat:@"%@=%@&", paramName, value];
	}
	
	paramName = [allKeys lastObject];
	[postString appendFormat:@"%@=%@", paramName, [params objectForKey:paramName]];
//    CQTDebugLog(@"postString=%@", postString);
	return postString;
}

+ (NSData*)makeMultiFormBody:(NSDictionary*)params dataFileName:(NSString*)filename dataContentType:(NSString*)dataContentType {
    
	if (nil == params || [params count] == 0)
		return nil;
    
	//adding the body:
	NSMutableData *postBody = [NSMutableData data];
	for( __strong NSString *key in [params allKeys])
	{
		id obj = [params objectForKey:key];
		key = [Util webParamEncode:key];
		if([obj isKindOfClass:[NSString class]])
		{
			[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", MULTI_FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
								  dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
		}
		else if([obj isKindOfClass:[NSData class]])
		{
			[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", MULTI_FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, filename] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", dataContentType] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:obj];
		}
		[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n",MULTI_FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	return postBody;
}

+ (NSData*)makeMultiFormBody:(NSDictionary*)params dataContentType:(NSString*)dataContentType {
    
    NSMutableData *postBody = nil;
	if (params != nil && [params count] > 0)  {
        
        postBody = [NSMutableData data];
        NSString *imageKey = nil;
        for(NSString *key in [params allKeys]) {
            
            id obj = [params objectForKey:key];
            if([obj isKindOfClass:[NSString class]]) {
                
                [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", MULTI_FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
                                      dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else if([obj isKindOfClass:[NSArray class]]) {
                
                imageKey = [NSString stringWithFormat:@"%@", key];
              
            }
            
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // Image
        if (imageKey != nil) {
        
            id obj = [params objectForKey:imageKey];
            if ([obj isKindOfClass: [NSArray class]]) {
                
                int i=0;
                for (id value in (NSArray*)obj) {
                    
                    if([value isKindOfClass:[NSData class]]) {
                        
                        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", MULTI_FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
                        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", imageKey];
                        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", imageKey, fileName]
                                              dataUsingEncoding:NSUTF8StringEncoding]];
                        [postBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", dataContentType] dataUsingEncoding:NSUTF8StringEncoding]];
                        [postBody appendData:value];
                        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        i++;
                    }
                }
            }
        }
        
        //
        [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n",MULTI_FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    }
	return postBody;
}

- (void)requestGET:(NSString*)url {

//    NSLog(@"requestGET....url=%@", url);
	if([self canRun]) {
		
		if (!noShowNetworkIndicator)[Util showNetworkIndicator];
		NSMutableURLRequest *request = [self makeRequest:url];
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        
//        [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            
//            NSLog(@"resonse:%@ data:%@,error:%@",response,data,connectionError);
//        }];
	}
	else {
		 
		[self performSelector:_cmd withObject:url afterDelay:RETRY_INTERVAL];
//		CQTDebugLog(@"RETRY_INTERVAL...");
	}
}

- (void)requestPOST:(NSDictionary*)info{

	if([self canRun]) {
		
        [Util showNetworkIndicator];
		NSString *url = [info valueForKeyPath:kPostURL];
		NSDictionary *paras = [info valueForKeyPath:kPostInfo];
		NSMutableURLRequest *request = [self makeRequest:url];
		NSString *body = [CQTHttpRequest makeBody:paras];
//      NSData *body = [CQTHttpRequest makeMultiFormBody:paras];
		[request setHTTPMethod:@"POST"];
		if (body) {
			[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
			[request setValue:[NSString stringWithFormat:@"%d", (int)[body length]] forHTTPHeaderField:@"Content-Length"];
			[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//          NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", MULTI_FORM_BOUNDARY];
//			[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//			[request setHTTPBody:body];
//			[request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
		}
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	}
	else {
		
//		CQTDebugLog(@"!-------------------------------CanRUn");
		//retry
		[self performSelector:@selector(requestPOST:) 
				   withObject:info
				   afterDelay:RETRY_INTERVAL];
	}
}

- (void)requestPOST4MultiForm:(NSDictionary*)info  {
    
	if([self canRun]) {
        
        [Util showNetworkIndicator];
		NSString *url = [info valueForKeyPath:kPostURL];
		NSDictionary *paras = [info valueForKeyPath:kPostInfo];
		NSMutableURLRequest *request = [self makeRequest:url];
		NSData *body = [CQTHttpRequest makeMultiFormBody:paras dataContentType:kContentTypeImageJPEG];
		[request setHTTPMethod:@"POST"];
		if(body) {
            
			NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", MULTI_FORM_BOUNDARY];
			[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
			[request setHTTPBody:body];
			[request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
		}
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	}
	else {
        
		[self performSelector:@selector(requestPOST4MultiForm:)
				   withObject:info
				   afterDelay:RETRY_INTERVAL];
	}
}

#pragma mark -

@end
//
//  LXJSONRequestOperation.m
//  LifeixNetworkKit
//
//  Created by James Liu on 1/15/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import "LXJSONRequestOperation.h"

#import "LXJSONUtilities.h"

#import "JSON.h"

static dispatch_queue_t lx_json_request_operation_processing_queue;
static dispatch_queue_t json_request_operation_processing_queue() {
    if (lx_json_request_operation_processing_queue == NULL) {
        lx_json_request_operation_processing_queue = dispatch_queue_create("com.cqtimes.networking.json-request.processing", 0);
    }
    
    return lx_json_request_operation_processing_queue;
}

@interface LXJSONRequestOperation()
@property (readwrite, nonatomic, strong) id responseJSON;
@property (readwrite, nonatomic, strong) NSError *JSONError;

+ (NSSet *)defaultAcceptableContentTypes;
+ (NSSet *)defaultAcceptablePathExtensions;
@end

@implementation LXJSONRequestOperation
@synthesize responseJSON = _responseJSON;
@synthesize JSONError = _JSONError;

+ (LXJSONRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success 
                                                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure {
    LXJSONRequestOperation *requestOperation = [[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(LXHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request , operation.response , responseObject);
        }
    } failure:^(LXHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request , operation.response , error , [(LXJSONRequestOperation *)operation responseJSON]);
        }
    }];
    
    return requestOperation;
}

+ (NSSet *)defaultAcceptableContentTypes {
//    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
//    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain" , @"text/html", nil];
}

+ (NSSet *)defaultAcceptablePathExtensions {
    return [NSSet setWithObjects:@"json", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [[self defaultAcceptableContentTypes] containsObject:[request valueForHTTPHeaderField:@"Accept"]] || [[self defaultAcceptablePathExtensions] containsObject:[[request URL] pathExtension]];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    if (!self) {
        return nil;
    }
    self.acceptableContentTypes = [[self class] defaultAcceptableContentTypes];
    
    return self;
}


- (id)responseJSON {
    
    if (!_responseJSON && [self isFinished]) {
        NSError *error = nil;

        if ([self.responseData length] == 0) {
            self.responseJSON = nil;
        } else {
//            self.responseJSON = LXJSONDecode(self.responseData, &error);
            NSString* stringToParse = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
            NSDictionary *pareseDic = (NSDictionary*)[stringToParse JSONValue];
            
            self.responseJSON = pareseDic;
        }
        
        self.JSONError = error;
    }
    
    return _responseJSON;
}

- (NSError *)error {
    if (_JSONError) {
        return _JSONError;
    } else {
        return [super error];
    }
}

- (void)setCompletionBlockWithSuccess:(void (^)(LXHTTPRequestOperation *, id))success
                              failure:(void (^)(LXHTTPRequestOperation *, NSError *))failure {
    
    __block LXJSONRequestOperation *selfReference = self;
    self.completionBlock = ^ {
        if ([selfReference isCancelled] || !selfReference) {
            return ;
        } 
        
        if (selfReference.error) {
            
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    failure(selfReference , selfReference.error);
                });
            }
        } else {
            // Parsing responseData into responseJSON in "JSON processing" queue
            // Then dispatch UI changes in main queue
            dispatch_async(json_request_operation_processing_queue(), ^{
                
                id JSON = selfReference.responseJSON;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (selfReference.JSONError) {
                        if (failure) {
                            failure(selfReference , selfReference.JSONError);
                        }
                    } else {
                        if (success) {
                            success(selfReference , JSON);
                        }
                    }
                });
            });
        }
    };
}

@end

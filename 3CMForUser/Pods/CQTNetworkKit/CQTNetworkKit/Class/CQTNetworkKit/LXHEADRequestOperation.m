//
//  LXHEADRequestOperation.m
//  LifeixNetworkKit
//
//  Created by James Liu on 3/15/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//

#import "LXHEADRequestOperation.h"

@implementation LXHEADRequestOperation

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    if (!self) {
        return nil;
    }
    
    return self;
}


+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return YES;
}

+ (LXHEADRequestOperation *)headRequestOperationWithRequest:(NSURL *)url success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response))success {
    return [self headRequestOperationWithRequest:url success:success failure:nil];
}

+ (LXHEADRequestOperation *)headRequestOperationWithRequest:(NSURL *)url
                                                    success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response))success
                                                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"HEAD"];
    
    LXHEADRequestOperation *operation = [[LXHEADRequestOperation alloc] initWithRequest:urlRequest];
    [operation setCompletionBlockWithSuccess:^
     (LXHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(operation.request , operation.response);
         }
    } failure:^
     (LXHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(operation.request, operation.response, error);
         }
     }];
    
    return operation;
}

@end

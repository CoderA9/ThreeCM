//
//  LXHEADRequestOperation.h
//  LifeixNetworkKit
//
//  Created by James Liu on 3/15/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//

#import "LXHTTPRequestOperation.h"

@interface LXHEADRequestOperation : LXHTTPRequestOperation {
}

+ (LXHEADRequestOperation *)headRequestOperationWithRequest:(NSURL *)url success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response))success ;

+ (LXHEADRequestOperation *)headRequestOperationWithRequest:(NSURL *)url
                                                      success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response))success
                                                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

@end

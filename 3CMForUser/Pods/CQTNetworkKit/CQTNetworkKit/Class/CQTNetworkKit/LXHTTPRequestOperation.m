//
//  LXHTTPRequestOperation.m
//  LifeixNetworkKit
//
//  Created by James Liu on 1/9/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import "LXHTTPRequestOperation.h"
#import "NSString+LXNetworkKit.h"


@interface LXHTTPRequestOperation(/** Private Methods */)
@property (readwrite, nonatomic, strong) NSError *HTTPError;
@property (readonly, nonatomic, assign) BOOL hasContent;
@property (readwrite, nonatomic, strong) NSString *uniqueId;
@end

@implementation LXHTTPRequestOperation
@synthesize acceptableStatusCodes = _acceptableStatusCodes;
@synthesize acceptableContentTypes = _acceptableContentTypes;
@synthesize HTTPError = _HTTPError;
@dynamic freezable;
@synthesize uniqueId = _uniqueId; // freezable operations have a unique id
@synthesize returnHTTPError = _returnHTTPError;

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    if (!self) {
        return nil;
    }
    
    self.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
    
    return self;
}


- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)[super response];
}

- (NSError *)error {
    // check Status Code and Content-Type
    if (self.response && !self.HTTPError) {
        if (![self hasAcceptableStatusCode]) {
            NSInteger statusCode = [self.response statusCode];
            NSString *localizedStringForStatusCode = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:[NSString stringWithFormat:NSLocalizedString(@"Expected status code %@, got %d (%@)", nil), self.acceptableStatusCodes, statusCode , localizedStringForStatusCode] forKey:NSLocalizedDescriptionKey];
            [userInfo setValue:[self.request URL] forKey:NSURLErrorFailingURLErrorKey];
            
            if (_returnHTTPError) {
                [userInfo setValue:self.responseData forKey:NSLocalizedDescriptionKey];
                self.HTTPError = [[NSError alloc] initWithDomain:NSURLErrorDomain code:statusCode userInfo:userInfo];
            } else {
                self.HTTPError = [[NSError alloc] initWithDomain:LXNetworkErrorDomain code:NSURLErrorBadServerResponse userInfo:userInfo];
            }
        } else if ([self hasContent] && ![self hasAcceptableContentType]) { // Don't invalidate content type if there is no content
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:[NSString stringWithFormat:NSLocalizedString(@"Expected content type %@, got %@", nil), self.acceptableContentTypes, [self.response MIMEType]] forKey:NSLocalizedDescriptionKey];
            [userInfo setValue:[self.request URL] forKey:NSURLErrorFailingURLErrorKey];
            
            self.HTTPError = [[NSError alloc] initWithDomain:LXNetworkErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
        }
    }
    
    
    if (_HTTPError) {
        return _HTTPError;
    } else {
        return [super error];
    } 
}

- (BOOL)hasContent {
    return [self.responseData length] > 0;
}

- (BOOL)hasAcceptableStatusCode {
    return !self.acceptableStatusCodes || [self.acceptableStatusCodes containsIndex:[self.response statusCode]];
}

- (BOOL)hasAcceptableContentType {
    return !self.acceptableContentTypes || [self.acceptableContentTypes containsObject:[self.response MIMEType]];
}

- (BOOL)freezable {
    return _freezable;
}

- (void)setFreezable:(BOOL)flag {
    // get method cannot be frozen. 
    // No point in freezing a method that doesn't change server state.
    if([self.request.HTTPMethod isEqualToString:@"GET"] && flag) return;
    _freezable = flag;
    
    if(_freezable && self.uniqueId == nil)
        self.uniqueId = [NSString stringWithNewUUID];
}


// main queue?
- (void)setCompletionBlockWithSuccess:(void (^)(LXHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(LXHTTPRequestOperation *operation, NSError *error))failure
{
    
    __block LXHTTPRequestOperation *selfReference = self;
    self.completionBlock = ^ {
        
        if ([selfReference isCancelled]) {
            return;
        }
        
        if (selfReference.error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    failure(selfReference, selfReference.error);
                });
            }
        } else {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(selfReference, selfReference.responseData);
                });
            }
        }
    };
}

#pragma mark - LXHTTPClientOperation

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return YES;
}     



@end

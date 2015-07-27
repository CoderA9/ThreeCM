//
//  LXImageRequestOperation.m
//  LifeixNetworkKit
//
//  Created by James Liu on 1/15/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$
#import <objc/runtime.h>

#import "LXImageRequestOperation.h"
//#import "LXImageCache.h"
#import <ImageIO/ImageIO.h>

static dispatch_queue_t cqt_image_request_operation_processing_queue;

static dispatch_queue_t image_request_operation_processing_queue() {
    
    if (cqt_image_request_operation_processing_queue == NULL) {
        
        cqt_image_request_operation_processing_queue = dispatch_queue_create("com.cqt.networking.image-request.processing", 0);
    }
    
    return cqt_image_request_operation_processing_queue;
}

@interface LXImageRequestOperation()

@property (readwrite, nonatomic, strong) UIImage *responseImage;

+ (NSSet *)defaultAcceptableContentTypes;

+ (NSSet *)defaultAcceptablePathExtensions;

@end

@implementation LXImageRequestOperation
@synthesize responseImage = _responseImage;
//@synthesize imageScale = _imageScale;

+ (LXImageRequestOperation *)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest                
                                                      success:(void (^)(UIImage *image))success
{
    return [self imageRequestOperationWithRequest:urlRequest imageProcessingBlock:nil cacheName:nil success:^(NSURLRequest __unused *request, NSHTTPURLResponse __unused *response, UIImage *image) {
        if (success) {
            success(image);
        }
    } failure:nil];
}

+ (LXImageRequestOperation *)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                         imageProcessingBlock:(UIImage *(^)(id))imageProcessingBlock
                                                    cacheName:(NSString *)cacheNameOrNil
                                                      success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                                                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    LXImageRequestOperation *requestOperation = [[LXImageRequestOperation alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(LXHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            UIImage *image = responseObject;
            
            if (imageProcessingBlock) {
                image = imageProcessingBlock(image);
            }
            
            success(operation.request, operation.response, image);
        }
    } failure:^(LXHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error);
        }
    }];
    
    
    return requestOperation;
}


+ (NSSet *)defaultAcceptableContentTypes {
    return [NSSet setWithObjects:@"image/tiff", @"image/jpeg", @"image/jpg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon" @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];
}

+ (NSSet *)defaultAcceptablePathExtensions {
    return [NSSet setWithObjects:@"tif", @"tiff", @"jpg", @"jpeg", @"gif", @"png", @"ico", @"bmp", @"cur", nil];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [[self class] defaultAcceptableContentTypes];
    
//    self.imageScale = [[UIScreen mainScreen] scale];
    
    return self;
}


- (UIImage *)responseImage {
    if (!_responseImage && [self isFinished]) {
        UIImage *image = [UIImage imageWithData:self.responseData];
        
        self.responseImage = image;
    }
    
    return _responseImage;
    
//    if (!_imageResponse && [self isFinished]) {
//        self.imageResponse = [LXImageResponse imageResponseWithData:self.responseData MIMEType:self.response.MIMEType];
//    }
//    return _imageResponse;
    
//    if (!_responseImage && [self isFinished]) {
//        //TODO how about scale?
//        UIImage *image = [UIImage imageWithData:self.responseData MIMEType:self.response.MIMEType];
//        
//        self.responseImage = image;
//        
////        UIImage *image = [UIImage imageWithData:self.responseData];
////        self.responseImage = [UIImage imageWithCGImage:[image CGImage] scale:self.imageScale orientation:image.imageOrientation];
//    }
//    
//    return _responseImage;
}

//- (void)setImageScale:(CGFloat)imageScale {
//    if (imageScale == _imageScale) {
//        return;
//    }
//    
//    [self willChangeValueForKey:@"imageScale"];
//    _imageScale = imageScale;
//    [self didChangeValueForKey:@"imageScale"];
//    
//    self.responseImage = nil;
//}

#pragma mark - LXHTTPClientOperation

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [[self defaultAcceptableContentTypes] containsObject:[request valueForHTTPHeaderField:@"Accept"]] || [[self defaultAcceptablePathExtensions] containsObject:[[request URL] pathExtension]];
}

+ (LXHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(id object))success 
                                                    failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure
{
    return [self imageRequestOperationWithRequest:urlRequest imageProcessingBlock:nil cacheName:nil success:^(NSURLRequest __unused *request, NSHTTPURLResponse __unused *response, UIImage *image) {
        success(image);
    } failure:^(NSURLRequest __unused *request, NSHTTPURLResponse *response, NSError *error) {
        failure(response, error);
    }];
}

- (void)setCompletionBlockWithSuccess:(void (^)(LXHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(LXHTTPRequestOperation *operation, NSError *error))failure
{
    __block LXImageRequestOperation *selfReference = self;
    self.completionBlock = ^ {
        if ([selfReference isCancelled]) {
            return;
        }
        
        dispatch_async(image_request_operation_processing_queue(), ^(void) {
            if (selfReference.error) {
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        failure(selfReference, selfReference.error);
                    });
                }
            } else {                
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        success(selfReference, selfReference.responseData);
                    });
                }
            }
        });        
    };  
}


@end

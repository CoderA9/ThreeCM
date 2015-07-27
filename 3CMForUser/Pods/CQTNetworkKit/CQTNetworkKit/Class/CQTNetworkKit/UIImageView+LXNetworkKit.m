//
//  UIImageView+LXNetworkKit.m
//  LifeixNetworkKit
//
//  Created by James Liu on 1/15/12.
//  Copyright 2012 Lifeix. All rights reserved.
//  
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$
#import <objc/runtime.h>

#import "UIImageView+LXNetworkKit.h"
//#import "LXURLCache.h"
#import "LXImageRequestOperation.h"
//#import "LXNetworkKitLog.h"
#import <ImageIO/ImageIO.h>

static char kLXImageRequestOperationObjectKey;

@interface UIImageView (_LXNetworkKit)
@property (readwrite, nonatomic, retain, setter = lx_setImageRequestOperation:) LXImageRequestOperation *lx_imageRequestOperation;
@end

@implementation UIImageView (_LXNetworkKit)
@dynamic lx_imageRequestOperation;
@end

#pragma mark -

@implementation UIImageView (LXNetworkKit)

- (LXHTTPRequestOperation *)lx_imageRequestOperation {
    return (LXHTTPRequestOperation *)objc_getAssociatedObject(self , &kLXImageRequestOperationObjectKey);
}

- (void)lx_setImageRequestOperation:(LXImageRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kLXImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)lx_sharedImageRequestOperationQueue {
    static NSOperationQueue *_imageRequestOperationQueue = nil;
    
    // Donwload up to 8 pics concurrently.
    if (!_imageRequestOperationQueue) {
        
        _imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        
        [_imageRequestOperationQueue setMaxConcurrentOperationCount:10];
    }
    
    return _imageRequestOperationQueue;
}

#pragma mark -
- (void)setImageAndAdjustSize:(UIImage *)aimage {
    
    if ([aimage isKindOfClass:[UIImage class]]) {
        
        self.image = aimage;
    }

    //TODO
}

- (void)setImageWithURL:(NSURL *)url {
    
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url 
       placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:UI_IMAGE_REQUEST_TIMEOUT_INTERVAL];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest 
              placeholderImage:(UIImage *)placeholderImage 
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    if (![urlRequest URL] || (![self.lx_imageRequestOperation isCancelled] && [[urlRequest URL] isEqual:[[self.lx_imageRequestOperation request] URL]])) {
        return;
    } else {
        [self cancelImageRequestOperation];
    }
    
    UIImage *cachedImage = [[CQTCache CQTSharedInstance] image4URL:[[urlRequest URL] absoluteString] cacheFileType:CQTDownloadFileTypeImages];
    if (cachedImage) {
//        self.image = cachedImage;
        [self setImageAndAdjustSize:cachedImage];
        self.lx_imageRequestOperation = nil;
        
        if (success) {
            success(nil, nil, cachedImage);
        }
        
        
    } else {

//        self.image = placeholderImage;
        [self setImageAndAdjustSize:placeholderImage];
        LXImageRequestOperation *requestOperation = [[LXImageRequestOperation alloc] initWithRequest:urlRequest];
        [requestOperation setCompletionBlockWithSuccess:^(LXHTTPRequestOperation *operation, id responseObject) {
            if ([[urlRequest URL] isEqual:[[self.lx_imageRequestOperation request] URL]]) {
//                self.image = responseObject;
                [self setImageAndAdjustSize:responseObject];
            } else {
//                self.image = placeholderImage;
                [self setImageAndAdjustSize:placeholderImage];
            }
            
            if (success) {
                success(operation.request, operation.response, responseObject);
            }

//            [[LXURLCache sharedCache] storeImageInDisk:responseObject forURL:[[urlRequest URL] absoluteString]];
            [[CQTCache CQTSharedInstance] cacheImage4URL:[[urlRequest URL] absoluteString] imageData:responseObject cacheFileType:CQTDownloadFileTypeImages];
        } failure:^(LXHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(operation.request, operation.response, error);
            }
        }];
        
        self.lx_imageRequestOperation = requestOperation;
        
        // fix crash(crashlytics): #143 - 如果operation已经被添加, 则不需要重复添加, 以免crash
        if ([self.lx_imageRequestOperation isExecuting]
            || [self.lx_imageRequestOperation isFinished]
            || [self.lx_imageRequestOperation isCancelled]) {
            return;
        }
        // fix crash(crashlytics): #146 - 如果operation已经被添加, 则不需要重复添加, 以免crash
        if ([[[self class] lx_sharedImageRequestOperationQueue].operations containsObject:self.lx_imageRequestOperation]) {
            return;
        }
        
        [[[self class] lx_sharedImageRequestOperationQueue] addOperation:self.lx_imageRequestOperation];
    }
}

- (void)cancelImageRequestOperation {
    [self.lx_imageRequestOperation cancel];
}


@end

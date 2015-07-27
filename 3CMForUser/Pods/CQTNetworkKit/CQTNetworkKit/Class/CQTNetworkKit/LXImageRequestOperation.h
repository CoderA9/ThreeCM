//
//  LXImageRequestOperation.h
//  LifeixNetworkKit
//
//  Created by James Liu on 1/15/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import <Foundation/Foundation.h>
#import "LXHTTPRequestOperation.h"
#import <UIKit/UIKit.h>

@interface LXImageRequestOperation : LXHTTPRequestOperation {
@private
    UIImage *_responseImage;
//    CGFloat _imageScale;
}

/**
 An image constructed from the response data. If an error occurs during the request, `nil` will be returned, and the `error` property will be set to the error.
 */
@property (readonly, nonatomic, strong) UIImage *responseImage;

/**
 The scale factor used when interpreting the image data to construct `responseImage`. Specifying a scale factor of 1.0 results in an image whose size matches the pixel-based dimensions of the image. Applying a different scale factor changes the size of the image as reported by the size property. This is set to the value of `[[UIScreen mainScreen] scale]` by default, which automatically scales images for retina displays, for instance.
 */
//@property (nonatomic, assign) CGFloat imageScale;

/**
 Creates and returns an `LXImageRequestOperation` object and sets the specified success callback.
 
 @param urlRequest The request object to be loaded asynchronously during execution of the operation.
 @param success A block object to be executed when the request finishes successfully. This block has no return value and takes a single arguments, the image created from the response data of the request.
 
 @return A new image request operation
 */
+ (LXImageRequestOperation *)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest                
                                                      success:(void (^)(UIImage *image))success;

/**
 Creates and returns an `LXImageRequestOperation` object and sets the specified success callback.
 
 @param urlRequest The request object to be loaded asynchronously during execution of the operation.
 @param imageProcessingBlock A block object to be executed after the image request finishes successfully, but before the image is returned in the `success` block. This block takes a single argument, the image loaded from the response body, and returns the processed image.
 @param cacheName The cache name to be associated with the image. `AFImageCache` associates objects by URL and cache name, allowing for multiple versions of the same image to be cached.
 @param success A block object to be executed when the request finishes successfully, with a status code in the 2xx range, and with an acceptable content type (e.g. `image/png`). This block has no return value and takes three arguments: the request object of the operation, the response for the request, and the image created from the response data.
 @param failure A block object to be executed when the request finishes unsuccessfully. This block has no return value and takes three arguments: the request object of the operation, the response for the request, and the error associated with the cause for the unsuccessful operation.
 
 @return A new image request operation
 */
+ (LXImageRequestOperation *)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                         imageProcessingBlock:(UIImage *(^)(id))imageProcessingBlock
                                                    cacheName:(NSString *)cacheNameOrNil
                                                      success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                                                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;




@end

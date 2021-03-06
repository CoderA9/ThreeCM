//
//  UIImageView+LXNetworkKit.h
//  LifeixNetworkKit
//
//  Created by James Liu on 1/15/12.
//  Copyright 2012 Lifeix. All rights reserved.
//  
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import <UIKit/UIKit.h>




#define UI_IMAGE_REQUEST_TIMEOUT_INTERVAL           30.f



@interface UIImageView (LXNetworkKit) 

/**
 Creates and enqueues an image request operation, which asynchronously downloads the image from the specified URL, and sets it the request is finished. If the image is cached locally, the image is set immediately, otherwise, the image is set once the request is finished.
 
 @discussion By default, url requests have a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set to use HTTP pipelining, and not handle cookies. To configure url requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
 
 @param url The URL used for the image request.
 */
- (void)setImageWithURL:(NSURL *)url;

/**
 Creates and enqueues an image request operation, which asynchronously downloads the image from the specified URL. If the image is cached locally, the image is set immediately. Otherwise, the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
 
 @param url The URL used for the image request.
 @param placeholderImage The image to be set initially, until the image request finishes. If `nil`, the image view will not change its image until the image request finishes.
 
 @discussion By default, url requests have a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set to use HTTP pipelining, and not handle cookies. To configure url requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
 */
- (void)setImageWithURL:(NSURL *)url 
       placeholderImage:(UIImage *)placeholderImage;

/**
 Creates and enqueues an image request operation, which asynchronously downloads the image with the specified url request object. If the image is cached locally, the image is set immediately. Otherwise, the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
 
 @param urlRequest The url request used for the image request.
 @param placeholderImage The image to be set initially, until the image request finishes. If `nil`, the image view will not change its image until the image request finishes.
 @param success A block to be executed when the image request operation finishes successfully, with a status code in the 2xx range, and with an acceptable content type (e.g. `image/png`). This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the image created from the response data of request. If the image was returned from cache, the request and response parameters will be `nil`.
 @param failure A block object to be executed when the image request operation finishes unsuccessfully, or that finishes successfully. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the error object describing the network or parsing error that occurred.
 
 @discussion By default, url requests have a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set to use HTTP pipelining, and not handle cookies. To configure url requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:` 
 */
- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest 
              placeholderImage:(UIImage *)placeholderImage 
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

- (void)cancelImageRequestOperation;


@end

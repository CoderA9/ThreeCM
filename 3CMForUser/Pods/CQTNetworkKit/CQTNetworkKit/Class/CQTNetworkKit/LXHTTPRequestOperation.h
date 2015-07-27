//
//  LXHTTPRequestOperation.h
//  LifeixNetworkKit
//
//  Created by James Liu on 1/9/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import <Foundation/Foundation.h>
#import "LXURLConnectionOperation.h"

@interface LXHTTPRequestOperation : LXURLConnectionOperation {
@private
    NSIndexSet *_acceptableStatusCodes;
    NSSet *_acceptableContentTypes;
    NSError *_HTTPError;
    
    BOOL _returnHTTPError;
    BOOL _freezable;
}

///----------------------------------------------
/// @name Getting HTTP URL Connection Information
///----------------------------------------------

/**
 The last HTTP response received by the operation's connection.
 */
@property (readonly, nonatomic, strong) NSHTTPURLResponse *response;


///----------------------------------------------------------
/// @name Managing And Checking For Acceptable HTTP Responses
///----------------------------------------------------------

/**
 Returns an `NSIndexSet` object containing the ranges of acceptable HTTP status codes. When non-`nil`, the operation will set the `error` property to an error in `AFErrorDomain`. See http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
 
 By default, this is the range 200 to 299, inclusive.
 */
@property (nonatomic, strong) NSIndexSet *acceptableStatusCodes;

/**
 A Boolean value that corresponds to whether the status code of the response is within the specified set of acceptable status codes. Returns `YES` if `acceptableStatusCodes` is `nil`.
 */
@property (readonly) BOOL hasAcceptableStatusCode;

/**
 Returns an `NSSet` object containing the acceptable MIME types. When non-`nil`, the operation will set the `error` property to an error in `AFErrorDomain`. See http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17 
 
 By default, this is `nil`.
 */
@property (nonatomic, strong) NSSet *acceptableContentTypes;

/**
 A Boolean value that corresponds to whether the MIME type of the response is among the specified set of acceptable content types. Returns `YES` if `acceptableContentTypes` is `nil`.
 */
@property (readonly) BOOL hasAcceptableContentType;

/**
 Freezable operations are serialized when the network goes down and restored when the connectivity is up again.
 Only POST, PUT and DELETE operations are freezable.
 In short, any operation that changes the state of the server are freezable, creating a tweet, checking into a new location etc., Operations like fetching a list of tweets (think readonly GET operations) are not freezable.
 LXNetworkKit doesn't freeze (readonly) GET operations even if they are marked as freezable
 */
@property (nonatomic, assign) BOOL freezable;

/**
 Return HTTP Error if status code is not acceptable.
 Default: NO.
 */
@property (nonatomic, assign) BOOL returnHTTPError;

/**
 Record This operation Url‘s API key.
 Default: nil.
 */
@property (nonatomic, strong) NSString * APIKey;

/**
 A Boolean value determining whether or not the class can process the specified request. For example, `AFJSONRequestOperation` may check to make sure the content type was `application/json` or the URL path extension was `.json`.
 
 @param urlRequest The request that is determined to be supported or not supported for this class.
 */
+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest;



///-----------------------------------------------------------
/// @name Setting Completion Block Success / Failure Callbacks
///-----------------------------------------------------------

/**
 Sets the `completionBlock` property with a block that executes either the specified success or failure block, depending on the state of the request on completion. If `error` returns a value, which can be caused by an unacceptable status code or content type, then `failure` is executed. Otherwise, `success` is executed.
 
 @param success The block to be executed on the completion of a successful request. This block has no return value and takes two arguments: the receiver operation and the object constructed from the response data of the request.
 @param failure The block to be executed on the completion of an unsuccessful request. This block has no return value and takes two arguments: the receiver operation and the error that occured during the request.
 
 @discussion This method should be overridden in subclasses in order to specify the response object passed into the success block.
 */
- (void)setCompletionBlockWithSuccess:(void (^)(LXHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(LXHTTPRequestOperation *operation, NSError *error))failure;

@end

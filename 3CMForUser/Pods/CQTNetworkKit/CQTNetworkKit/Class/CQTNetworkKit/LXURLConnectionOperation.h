//
//  LXURLConnectionOperation.h
//  LifeixNetworkKit
//
//  Created by James Liu on 1/9/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

/**
 Domain of errors occurred in LXNetworkKit.
 
 @discussion Error codes for LXNetworkErrorDomain correspond to codes in NSURLErrorDomain.
 */
extern NSString * const LXNetworkErrorDomain;

/**
 Posted when an operation begins executing.
 */
extern NSString * const LXNetworkOperationDidStartNotification;

/**
 Posted when an operation finishes.
 */
extern NSString * const LXNetworkOperationDidFinishNotification;

/**
 Define a block for operation progress.
 */
typedef void (^LXURLConnectionOperationProgressBlock)(NSInteger bytes, NSInteger totalBytes, NSInteger totalBytesExpected);

/**
 @warning Subclasses are strongly discouraged from overriding `setCompletionBlock:`, as `LXURLConnectionOperation`'s implementation includes a workaround to mitigate retain cycles, and what Apple rather ominously refers to as "The Deallocation Problem" (See http://developer.apple.com/library/ios/technotes/tn2109/_index.html#//apple_ref/doc/uid/DTS40010274-CH1-SUBSECTION11) 
 
 */
@interface LXURLConnectionOperation : NSOperation {
@private
    NSSet *_runLoopModes;
    
    NSURLConnection *_connection;
    NSURLRequest *_request;
    NSHTTPURLResponse *_response;
    NSError *_error;
    
    NSData *_responseData;
    NSInteger _totalBytesRead;
    NSMutableData *_dataAccumulator;
    NSOutputStream *_outputStream;
    
    // 最后一次 start 时的时间戳
    NSTimeInterval _lastStartTimestamp;
    NSTimeInterval _operationTime;
}

///-------------------------------
/// @name Accessing Run Loop Modes
///-------------------------------

/**
 The run loop modes in which the operation will run on the network thread. By default, this is a single-member set containing `NSRunLoopCommonModes`.
 */
@property (nonatomic, strong) NSSet *runLoopModes;

///-----------------------------------------
/// @name Getting URL Connection Information
///-----------------------------------------
/**
 The request used by the operation's connection.
 */
@property (readonly, nonatomic, strong) NSURLRequest *request;

/**
 The last response received by the operation's connection.
 */
@property (readonly, nonatomic, strong) NSURLResponse *response;

/**
 The error, if any, that occured in the lifecycle of the request.
 */
@property (readonly, nonatomic, strong) NSError *error;

///----------------------------
/// @name Getting Response Data
///----------------------------

/**
 The data received during the request. 
 */
@property (readonly, nonatomic, strong) NSData *responseData;

/**
 The string representation of the response data.
 
 @discussion This method uses the string encoding of the response, or if UTF-8 if not specified, to construct a string from the response data.
 */
@property (readonly, nonatomic, copy) NSString *responseString;

///------------------------
/// @name Accessing Streams
///------------------------

/**
 The input stream used to read data to be sent during the request. 
 
 @discussion This property acts as a proxy to the `HTTPBodyStream` property of `request`.
 */
@property (nonatomic, strong) NSInputStream *inputStream;

/**
 The output stream that is used to write data received until the request is finished.
 
 @discussion By default, data is accumulated into a buffer that is stored into `responseData` upon completion of the request. When `outputStream` is set, the data will not be accumulated into an internal buffer, and as a result, the `responseData` property of the completed request will be `nil`.
 */
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, assign) NSTimeInterval operationTime;

///------------------------------------------------------
/// @name Initializing an AFURLConnectionOperation Object
///------------------------------------------------------

/**
 Initializes and returns a newly allocated operation object with a url connection configured with the specified url request.
 
 @param urlRequest The request object to be used by the operation connection.
 
 @discussion This is the designated initializer.
 */
- (id)initWithRequest:(NSURLRequest *)urlRequest;

///---------------------------------
/// @name Setting Progress Callbacks
///---------------------------------


/**
 Sets a callback to be called when an undetermined number of bytes have been downloaded from the server.
 
 @param block A block object to be called when an undetermined number of bytes have been downloaded from the server. This block has no return value and takes three arguments: the number of bytes written since the last time the upload progress block was called, the total bytes written, and the total bytes expected to be written during the request, as initially determined by the length of the HTTP body. This block may be called multiple times.
 
 @see setDownloadProgressBlock
 */
- (void)setUploadProgressBlock:(void (^)(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))block;

/**
 Sets a callback to be called when an undetermined number of bytes have been uploaded to the server.
 
 @param block A block object to be called when an undetermined number of bytes have been uploaded to the server. This block has no return value and takes three arguments: the number of bytes read since the last time the upload progress block was called, the total bytes read, and the total bytes expected to be read during the request, as initially determined by the expected content size of the `NSHTTPURLResponse` object. This block may be called multiple times.
 
 @see setUploadProgressBlock
 */
- (void)setDownloadProgressBlock:(void (^)(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead))block;

@end

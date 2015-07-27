//
//  LXHTTPEngine.h
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

#import "LXCodecUtilities.h"

#import "NSString+LXNetworkKit.h"

#import "CQTReachabilityManager.h"


#define kLXPreferenceUUID       @"com.cqt.preference.uuid"

#define DB_APP_UUID() \
[NSString installationId:kLXPreferenceUUID]

@interface LXMultipartFile : NSObject <NSCoding , NSCopying> {
    NSString *_name;
    NSString *_fileName;
    NSString *_contentType;
    NSData  *_fileData;
}

@property (nonatomic , strong) NSString *name, *fileName , *contentType;
@property (nonatomic , strong) NSData *fileData;

+ (id)multipartFileWithName:(NSString *)aname fileName:(NSString *)afileName contentType:(NSString *)acontentType fileData:(NSData *)afileData;
- (id)initWithName:(NSString *)aname fileName:(NSString *)afileName contentType:(NSString *)acontentType fileData:(NSData *)afileData;

@end


@class LXHTTPRequestOperation;
@protocol LXHTTPEngineOperation;
@protocol LXMultipartFormData;

#define LXNETWORKCACHE_DEFAULT_DIRECTORY @"LXNetworkKitCache"

/**
 Returns a query string constructed by a set of parameters, using the specified encoding.
 
 @param parameters The parameters used to construct the query string
 @param encoding The encoding to use in constructing the query string. If you are uncertain of the correct encoding, you should use UTF-8 (NSUTF8StringEncoding), which is the encoding designated by RFC 3986 as the correct encoding for use in URLs.
 
 @discussion Query strings are constructed by collecting each key-value pair, URL-encoding the string value of the key and value (by sending `-description` to each), constructing a string in the form "key=value", and then joining the components with "&". The constructed query string does not include the ? character used to delimit the query component.
 
 @return A URL-encoded query string
 */
extern NSString * LXQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding encoding);

/**
 `LXHTTPEngine` captures the common patterns of communicating with an web application over HTTP. It encapsulates information like base URL, authorization credentials, and HTTP headers, and uses them to construct and manage the execution of HTTP request operations.
 
 ## Automatic Content Parsing
 
 Instances of `LXHTTPEngine` may specify which types of requests it expects and should handle by registering HTTP operation classes for automatic parsing. Registered classes will determine whether they can handle a particular request, and then construct a request operation accordingly in `enqueueHTTPRequestOperationWithRequest:success:failure`. See `LXHTTPEngineOperation` for further details.
 
 ## Subclassing Notes
 
 In most cases, one should create an `LXHTTPEngine` subclass for each website or web application that your application communicates with. It is often useful, also, to define a class method that returns a singleton shared HTTP client in each subclass, that persists authentication credentials and other configuration across the entire application.
 
 ## Methods to Override
 
 To change the behavior of all url request construction for an `LXHTTPEngine` subclass, override `requestWithMethod:path:parameters`.
 
 To change the behavior of all request operation construction for an `LXHTTPEngine` subclass, override `enqueueHTTPRequestOperationWithRequest:success:failure`.
 
 ## Default Headers
 
 By default, `LXHTTPEngine` sets the following HTTP headers:
 
 - `Accept-Encoding: gzip`
 - `Accept-Language: ([NSLocale preferredLanguages]), en-us;q=0.8`
 - `User-Agent: (generated user agent)`
 
 You can override these HTTP headers or define new ones using `setDefaultHeader:value:`.
 
 ## URL Construction Using Relative Paths
 
 Both `requestWithMethod:path:parameters` and `multipartFormRequestWithMethod:path:parameters:constructingBodyWithBlock:` construct URLs from the path relative to the `baseURL`, using `NSURL +URLWithString:relativeToURL:`. Below are a few examples of how `baseURL` and relative paths interract:
 
 NSURL *baseURL = [NSURL URLWithString:@"http://example.com/v1/"];
 [NSURL URLWithString:@"foo" relativeToURL:baseURL];                     // http://example.com/v1/foo
 [NSURL URLWithString:@"foo?bar=baz" relativeToURL:baseURL];             // http://example.com/v1/foo?bar=baz
 [NSURL URLWithString:@"/foo" relativeToURL:baseURL];                    // http://example.com/foo
 [NSURL URLWithString:@"foo/" relativeToURL:baseURL];                    // http://example.com/v1/foo
 [NSURL URLWithString:@"/foo/" relativeToURL:baseURL];                   // http://example.com/foo/
 [NSURL URLWithString:@"http://example2.com/" relativeToURL:baseURL];    // http://example2.com/
 
 */




typedef void (^LXAPIClientSuccessBlock) (id dataBody);
typedef void (^LXAPIClientFailureBlock) (NSError *error);
typedef void (^LXAPIClientUploaderBlock) (NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);




typedef enum _LXConnectionRequestType {
    LXConnectionRequestTypeBindContestWithContestId = 250120,
    LXConnectionRequestTypeBindContestWithDashboardId,
    LXConnectionRequestTypeUploadPhoto,
    LXConnectionRequestTypeUploadAudio,
    LXConnectionRequestTypeUploadVideo,
} LXConnectionRequestType;


typedef enum {
    LXHTTPRequestGETMethod  =   0,
    LXHTTPRequestPOSTMethod,
    LXHTTPRequestPutMethod,
    LXHTTPRequestDELETEMethod
} LXHTTPRequestMethodType;





#define API_REQUEST_TIMEOUT_INTERVAL        20.f





@interface LXHTTPEngine : NSObject {
    NSMutableDictionary *_defaultHeaders;
    BOOL _compatiblePOSTParameters;
    
@private
    NSURL *_baseURL;
    NSString *_clientSourceKey;
    NSStringEncoding _stringEncoding;
    
    NSMutableArray *_registeredHTTPOperationClassNames;
    NSOperationQueue *_operationQueue;
    
    // 负责处理返回的数据中的自定义
    NSString *_registeredLXErrorParser;
    
    BOOL _enableViewControllerTracking;
    NSMutableDictionary *_viewControllerURLRequestCalls;
    
    BOOL _returnHTTPError;
    
    
}

///---------------------------------------
/// @name Accessing HTTP Engine Properties
///---------------------------------------


/**
 The url used as the base for paths specified in methods such as `getPath:parameteres:success:failure`
 */
@property (nonatomic, strong) NSURL *baseURL;

/**
 当前客户端的标识
 */
@property (nonatomic, strong) NSString *clientSourceKey;

@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

/**
 The string encoding used in constructing url requests. This is `NSUTF8StringEncoding` by default.
 */
@property (nonatomic, assign) NSStringEncoding stringEncoding;

/**
 是否以GET的方式传递POST表单参数提交，主要是兼容W06/A06 API
 */
@property (nonatomic, assign) BOOL compatiblePOSTParameters;
//default = NO.
@property (nonatomic, assign) BOOL adjustODPramaters;
//当网络异常时,需要冻结的api集合,以逗号隔开.
@property (nonatomic, strong) NSString *freezenAPISerialString;
/**
 是否需要加服务端的k识别
 */
@property (nonatomic, assign) BOOL needKeyVerify;

/**
 如果POST参数在Url中可见,不可见参数集合.
 */
@property (nonatomic, retain) NSArray *uncompatiblePOSTParameters;
/**
 The operation queue which manages operations enqueued by the HTTP engine.
 */
@property (readonly, nonatomic, strong) NSOperationQueue *operationQueue;

@property (readwrite, nonatomic, strong) NSString *registeredLXErrorParser;

/**
 是否打开ViewContrtoller的请求tracking，以便cancel
 */
@property (nonatomic, assign) BOOL enableViewControllerTracking;

/**
 ViewController的匹配正则
 */
@property (readwrite, nonatomic, strong) NSString *viewControllerRegexPattern;

/**
 Return HTTP Error if status code is not acceptable.
 Default: NO.
 */
@property (nonatomic, assign) BOOL returnHTTPError;

///---------------------------------------------
/// @name Creating and Initializing HTTP Clients
///---------------------------------------------

/**
 Creates and initializes an `LXHTTPEngine` object with the specified base URL.
 
 @param url The base URL for the HTTP engine. This argument must not be nil.
 
 @return The newly-initialized HTTP engine
 */
+ (LXHTTPEngine *)engineWithBaseURL:(NSURL *)url;

/**
 默认的User-Agent信息
 */
+ (NSString *)defaultUserAgent;

/**
 Initializes an `LXHTTPEngine` object with the specified base URL.
 
 @param url The base URL for the HTTP engine. This argument must not be nil.
 
 @discussion This is the designated initializer.
 
 @return The newly-initialized HTTP engine
 */
- (id)initWithBaseURL:(NSURL *)url;

/**
 Attempts to register a subclass of `LXHTTPRequestOperation`, adding it to a chain to automatically generate request operations from a URL request.
 
 @param The subclass of `LXHTTPRequestOperation` to register
 
 @return `YES` if the registration is successful, `NO` otherwise. The only failure condition is if `operationClass` does is not a subclass of `LXHTTPRequestOperation`.
 
 @discussion When `enqueueHTTPRequestOperationWithRequest:success:failure` is invoked, each registered class is consulted in turn to see if it can handle the specific request. The first class to return `YES` when sent a `canProcessRequest:` message is used to create an operation using `initWithURLRequest:` and do `setCompletionBlockWithSuccess:failure:`. There is no guarantee that all registered classes will be consulted. Classes are consulted in the reverse order of their registration. Attempting to register an already-registered class will move it to the top of the list.
 
 @see `LXHTTPEngineOperation`
 */
- (BOOL)registerHTTPOperationClass:(Class)operationClass;

/**
 Unregisters the specified subclass of `LXHTTPRequestOperation`.
 
 @param The class conforming to the `LXHTTPClientOperation` protocol to unregister
 
 @discussion After this method is invoked, `operationClass` is no longer consulted when `requestWithMethod:path:parameters` is invoked.
 */
- (void)unregisterHTTPOperationClass:(Class)operationClass;

///----------------------------------
/// @name Managing HTTP Header Values
///----------------------------------

/**
 Returns the value for the HTTP headers set in request objects created by the HTTP client.
 
 @param header The HTTP header to return the default value for
 
 @return The default value for the HTTP header, or `nil` if unspecified
 */
- (NSString *)defaultValueForHeader:(NSString *)header;

/**
 Sets the value for the HTTP headers set in request objects made by the HTTP client. If `nil`, removes the existing value for that header.
 
 @param header The HTTP header to set a default value for
 @param value The value set as default for the specified header, or `nil
 */
- (void)setDefaultHeader:(NSString *)header value:(NSString *)value;

/**
 Sets the "Authorization" HTTP header set in request objects made by the HTTP client to a basic authentication value with Base64-encoded username and password. This overwrites any existing value for this header.
 
 @param username The HTTP basic auth username
 @param password The HTTP basic auth password
 */
- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password;

/**
 Sets the "Authorization" HTTP header set in request objects made by the HTTP client to a token-based authentication value, such as an OAuth access token. This overwrites any existing value for this header.
 
 @param token The authentication token
 */
- (void)setAuthorizationHeaderWithToken:(NSString *)token;

/**
 Clears any existing value for the "Authorization" HTTP header.
 */
- (void)clearAuthorizationHeader;

///-------------------------------
/// @name Creating Request Objects
///-------------------------------

/**
 Creates an `NSMutableURLRequest` object with the specified HTTP method and path. By default, this method scans through the registered operation classes (in reverse order of when they were specified), until finding one that can handle the specified request.
 
 If the HTTP method is `GET`, the parameters will be used to construct a url-encoded query string that is appended to the request's URL. Otherwise, the parameters will be encoded according to the value of the `parameterEncoding` property, and set as the request body.
 
 @param method The HTTP method for the request, such as `GET`, `POST`, `PUT`, or `DELETE`.
 @param path The path to be appended to the HTTP client's base URL and used as the request URL.
 @param parameters The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 
 @return An `NSMutableURLRequest` object
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters;


/**
 Creates an `NSMutableURLRequest` object with the specified HTTP method and path, and constructs a `multipart/form-data` HTTP body, using the specified parameters and multipart form data block. See http://www.w3.org/TR/html4/interact/forms.html#h-17.13.4.2
 
 @param method The HTTP method for the request. Must be either `POST`, `PUT`, or `DELETE`.
 @param path The path to be appended to the HTTP client's base URL and used as the request URL.
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param block A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `LXMultipartFormData` protocol. This can be used to upload files, encode HTTP body as JSON or XML, or specify multiple values for the same parameter, as one might for array values.
 
 @discussion The multipart form data is constructed synchronously in the specified block, so in cases where large amounts of data are being added to the request, you should consider performing this method in the background. Likewise, the form data is constructed in-memory, so it may be advantageous to instead write parts of the form data to a file and stream the request body using the `HTTPBodyStream` property of `NSURLRequest`.
 
 @warning An exception will be raised if the specified method is not `POST`, `PUT` or `DELETE`.
 
 @return An `NSMutableURLRequest` object
 */
- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                                   path:(NSString *)path
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <LXMultipartFormData> formData))block;

///-------------------------------
/// @name Creating HTTP Operations
///-------------------------------

/**
 Creates an `LXHTTPRequestOperation`
 
 In order to determine what kind of operation is created, each registered subclass conforming to the `LXHTTPEngine` protocol is consulted in turn to see if it can handle the specific request. The first class to return `YES` when sent a `canProcessRequest:` message is used to generate an operation using `HTTPRequestOperationWithRequest:success:failure:`.
 
 @param request The request object to be loaded asynchronously during execution of the operation.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (LXHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(LXHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(LXHTTPRequestOperation *operation, NSError *error))failure;

///----------------------------------------
/// @name Managing Enqueued HTTP Operations
///----------------------------------------

/**
 Enqueues an `LXHTTPRequestOperation` to the HTTP client's operation queue.
 
 @param operation The HTTP request operation to be enqueued.
 */
- (void)enqueueHTTPRequestOperation:(LXHTTPRequestOperation *)operation;

/**
 Cancels all operations in the HTTP client's operation queue that match the specified HTTP method and URL.
 
 @param method The HTTP method to match for the cancelled requests, such as `GET`, `POST`, `PUT`, or `DELETE`.
 @param url The URL to match for the cancelled requests.
 */
- (void)cancelHTTPOperationsWithMethod:(NSString *)method andURL:(NSURL *)url;

/**
 Cancels all operations in the HTTP client's operation queue that match the spcified HTTP method.
 @param method The HTTP method to match for the cancelled requests, such as `GET`, `POST`, `PUT`, or `DELETE`.
 */
- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method;

/**
 Cancels all operations in the HTTP client's operation.
 */
- (void)cancelAllHTTPOperations;

///---------------------------
/// @name Making HTTP Requests
///---------------------------

/**
 Creates an `AFHTTPRequestOperation` with a `GET` request, and enqueues it to the HTTP client's operation queue.
 
 @param path The path to be appended to the HTTP client's base URL and used as the request URL.
 @param parameters The parameters to be encoded and appended as the query string for the request URL.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 
 @see HTTPRequestOperationWithRequest:success:failure
 */
- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(LXHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(LXHTTPRequestOperation *operation, NSError *error))failure;

/**
 Creates an `LXHTTPRequestOperation` with a `POST` request, and enqueues it to the HTTP client's operation queue.
 
 @param path The path to be appended to the HTTP client's base URL and used as the request URL.
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 
 @see HTTPRequestOperationWithRequest:success:failure
 */
- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(LXHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(LXHTTPRequestOperation *operation, NSError *error))failure;

/**
 上传文件
 @param path The path to be appended to the HTTP client's base URL and used as the request URL.
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param ublock A block object to be executed when the request operation is uploading.
 @files array of files to upload , `LXMultipartFile`
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 
 */
- (void)uploadPath:(NSString *)path
        parameters:(NSDictionary *)parameters
             files:(NSArray *)files
uploadProgressBlock:(void (^)(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))ublock
           success:(void (^)(LXHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(LXHTTPRequestOperation *operation, NSError *error))failure;

/**
 Creates an `AFHTTPRequestOperation` with a `PUT` request, and enqueues it to the HTTP client's operation queue.
 
 @param path The path to be appended to the HTTP client's base URL and used as the request URL.
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 
 @see HTTPRequestOperationWithRequest:success:failure
 */
- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(LXHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(LXHTTPRequestOperation *operation, NSError *error))failure;

/**
 Creates an `AFHTTPRequestOperation` with a `DELETE` request, and enqueues it to the HTTP client's operation queue.
 
 @param path The path to be appended to the HTTP client's base URL and used as the request URL.
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the resonse data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 
 @see HTTPRequestOperationWithRequest:success:failure
 */
- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(LXHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(LXHTTPRequestOperation *operation, NSError *error))failure;

/**
 Parse response data for error code.
 @param error
 @param response data
 */
- (void)parseResponseDataForError:(NSError **)outError withData:(id)data;

- (void)untrackViewController:(NSString *)viewControllerName;

/**
 组织url
 @param param 参数
 @param aPath API地址
 @param aurl 域名
 @param NSURL 组织完成的url
 */
- (NSURL *)organiseUrl:(NSDictionary *)param path:(NSString *)aPath url:(NSURL *)aurl;

/**
 加密  需要加密的话，在外层重载次函数加密
 @param queryStr 加密前参数串
 @result NSString 加密后字符串
 */
- (NSString *)encryptGetParameters:(NSString *)queryStr;



#pragma mark - subclass use

- (void)trackViewControllerURLRequest:(NSURL *)URL method:(NSString *)method;

@end

#pragma mark -

/**
 The `AFMultipartFormData` protocol defines the methods supported by the parameter in the block argument of `multipartFormRequestWithMethod:path:parameters:constructingBodyWithBlock:`.
 
 @see `LXHTTPEngine -multipartFormRequestWithMethod:path:parameters:constructingBodyWithBlock:`
 */
@protocol LXMultipartFormData

/**
 Appends HTTP headers, followed by the encoded data and the multipart form boundary.
 
 @param headers The HTTP headers to be appended to the form data.
 @param body The data to be encoded and appended to the form data.
 */
- (void)appendPartWithHeaders:(NSDictionary *)headers body:(NSData *)body;

/**
 Appends the HTTP headers `Content-Disposition: form-data; name=#{name}"`, followed by the encoded data and the multipart form boundary.
 
 @param data The data to be encoded and appended to the form data.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 */
- (void)appendPartWithFormData:(NSData *)data name:(NSString *)name;

/**
 Appends the HTTP header `Content-Disposition: file; filename=#{filename}; name=#{name}"` and `Content-Type: #{mimeType}`, followed by the encoded file data and the multipart form boundary.
 
 @param data The data to be encoded and appended to the form data.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 @param mimeType The MIME type of the specified data. (For example, the MIME type for a JPEG image is image/jpeg.) For a list of valid MIME types, see http://www.iana.org/assignments/media-types/. This parameter must not be `nil`.
 @param filename The filename to be associated with the specified data. This parameter must not be `nil`.
 */
- (void)appendPartWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

/**
 Appends the HTTP header `Content-Disposition: file; filename=#{generated filename}; name=#{name}"` and `Content-Type: #{generated mimeType}`, followed by the encoded file data and the multipart form boundary.
 
 @param fileURL The URL corresponding to the file whose content will be appended to the form.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 @param error If an error occurs, upon return contains an `NSError` object that describes the problem.
 
 @return `YES` if the file data was successfully appended, otherwise `NO`.
 
 @discussion The filename and MIME type for this data in the form will be automatically generated, using `NSURLResponse` `-suggestedFilename` and `-MIMEType`, respectively.
 */
- (BOOL)appendPartWithFileURL:(NSURL *)fileURL name:(NSString *)name error:(NSError **)error;

/**
 Appends encoded data to the form data.
 
 @param data The data to be encoded and appended to the form data.
 */
- (void)appendData:(NSData *)data;

/**
 Appends a string to the form data.
 
 @param string The string to be encoded and appended to the form data.
 */
- (void)appendString:(NSString *)string;


@end



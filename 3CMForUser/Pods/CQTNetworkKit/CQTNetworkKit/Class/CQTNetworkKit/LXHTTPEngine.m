//
//  LXHTTPEngine.m
//  LifeixNetworkKit
//
//  Created by James Liu on 1/9/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$
#import <objc/runtime.h>
#import "LXHTTPEngine.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "CQTReachability.h"
#import <CFNetwork/CFNetwork.h>
#import <sys/sysctl.h>
//#import "CQTReachability.h"
#import "LXJSONUtilities.h"

static NSString * const kLXMultipartFormLineDelimiter = @"\r\n"; // CRLF
static NSString * const kLXMultipartFormBoundary = @"Boundary+0xAbCdEfGbOuNdArY";
static NSString * const kLXFreezableOperationExtension = @"lxnetworkkitfrozenoperation";



@interface LXMultipartFormData : NSObject <LXMultipartFormData> {
@private
    NSStringEncoding _stringEncoding;
    NSMutableData *_mutableData;
}

@property (weak, readonly) NSData *data;

- (id)initWithStringEncoding:(NSStringEncoding)encoding;

@end

#pragma mark -

static NSUInteger const kLXHTTPEngineDefaultMaxConcurrentOperationCount = 4;

NSString * LXQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding encoding) {
    
    NSMutableArray *mutableParameterComponents = [NSMutableArray array];
    
    for (id key in [parameters allKeys]) {
        NSString *component = [NSString stringWithFormat:@"%@=%@", LXURLEncodedStringFromStringWithEncoding([key description], encoding), LXURLEncodedStringFromStringWithEncoding([[parameters valueForKey:key] description], encoding)];
        
        
        NSLog(@"%@",parameters[key]);
        component = [NSString stringWithFormat:@"%@=%@",key,parameters[key]];
        
        [mutableParameterComponents addObject:component];
    }

    return [mutableParameterComponents componentsJoinedByString:@"&"];
}

@implementation LXMultipartFile
@synthesize name = _name , fileName = _fileName , contentType = _contentType , fileData = _fileData;

+ (id)multipartFileWithName:(NSString *)aname
                   fileName:(NSString *)afileName
                contentType:(NSString *)acontentType
                   fileData:(NSData *)afileData {
    return [[self alloc] initWithName:aname fileName:afileName contentType:acontentType fileData:afileData];
}
- (id)initWithName:(NSString *)aname
          fileName:(NSString *)afileName
       contentType:(NSString *)acontentType
          fileData:(NSData *)afileData {
    if (self = [super init]) {
        self.name = aname;
        self.fileName = afileName;
        self.contentType = acontentType;
        self.fileData = afileData;
    }
    return self;
}


- (NSMutableString *)appendDescriptionString:(NSMutableString *)string WithClass:(Class)aClass {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        NSString *selector = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding] ;
        
        SEL sel = sel_registerName([selector UTF8String]);
        
        const char *attr = property_getAttributes(properties[i]);
        //TODO DO NOT print NSData object
        switch (attr[1]) {
            case '@':
                [string appendString:[NSString stringWithFormat:@"%s : %@\n", property_getName(properties[i]), objc_msgSend(self, sel)]];
                break;
            case 'i':
                [string appendString:[NSString stringWithFormat:@"%s : %i\n", property_getName(properties[i]), objc_msgSend(self, sel)]];
                break;
            case 'f':
                [string appendString:[NSString stringWithFormat:@"%s : %f\n", property_getName(properties[i]), objc_msgSend(self, sel)]];
                break;
            default:
                break;
        }
    }
    
    free(properties);
    
    if (![NSStringFromClass([aClass superclass]) isEqualToString:@"NSObject"]) {
        string = [self appendDescriptionString:string WithClass:[aClass superclass]];
    }
    
    return string;
}

// Overriding
- (NSString *)description
{
    NSMutableString *string = [NSMutableString stringWithString:@""];
    string = [self appendDescriptionString:string WithClass:[self class]];
    return string;
}

#pragma mark - NSCoding & NSCopying

- (void)encodeWithCoder:(NSCoder *)aCoder withClass:(Class)aClass {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        NSString *selector = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding] ;
        SEL sel = sel_registerName([selector UTF8String]);
        
        [aCoder encodeObject:objc_msgSend(self, sel) forKey:selector];
    }
    
    free(properties);
    
    // 如果继承的基类不是NSObject，则继续
    if (![NSStringFromClass([aClass superclass]) isEqualToString:@"NSObject"]) {
        [self encodeWithCoder:aCoder withClass:[aClass superclass]];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self encodeWithCoder:aCoder withClass:[self class]];
}

- (void)performSetterWithDecoder:(NSCoder *)aDecoder withClass:(Class)aClass {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        NSString *properyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding] ;
        NSString *selector =[NSString stringWithFormat:@"set%@:" ,
                             [properyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[properyName  substringToIndex:1] capitalizedString]]];
        SEL sel = sel_registerName([selector UTF8String]);
        
        [self performSelector:sel withObject:[aDecoder decodeObjectForKey:properyName]];
    }
    
    free(properties);
    
    if (![NSStringFromClass([aClass superclass]) isEqualToString:@"NSObject"]) {
        [self performSetterWithDecoder:aDecoder withClass:[aClass superclass]];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self performSetterWithDecoder:aDecoder withClass:[self class]];
    
    return self;
}

- (void)performPropertyCopy:(id)theCopy withClass:(Class)aClass {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        NSString *properyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding] ;
        NSString *setterName =[NSString stringWithFormat:@"set%@:" ,
                               [properyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[properyName  substringToIndex:1] capitalizedString]]];
        SEL getterSel = sel_registerName([properyName UTF8String]);
        SEL setterSel = sel_registerName([setterName UTF8String]);
        
        id getterObj = [[self performSelector:getterSel] copy];
        [theCopy performSelector:setterSel withObject:getterObj];

    }
    
    free(properties);
    
    
    if (![NSStringFromClass([aClass superclass]) isEqualToString:@"NSObject"]) {
        [self performPropertyCopy:theCopy withClass:[aClass superclass]];
    }
}

- (id)copyWithZone:(NSZone *)zone {
    id theCopy = [[[self class] allocWithZone:zone] init]; // use designated initializer
    
    [self performPropertyCopy:theCopy withClass:[self class]];
    
    return theCopy;
}

@end


@interface LXHTTPEngine()
//@property (readwrite, nonatomic, retain) NSURL *baseURL;
@property (readwrite, nonatomic, strong) NSMutableArray *registeredHTTPOperationClassNames;
@property (readwrite, nonatomic, strong) NSMutableDictionary *defaultHeaders;
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@property (readwrite, nonatomic, strong) NSString *hostName;
//@property (readwrite, nonatomic, strong) CQTReachability *reachability;

-(void) freezeOperations;
-(void) checkAndRestoreFrozenOperations;

-(BOOL) isCacheEnabled;
@end

@implementation LXHTTPEngine
@synthesize baseURL = _baseURL, clientSourceKey = _clientSourceKey;
@synthesize stringEncoding = _stringEncoding;
//@synthesize parameterEncoding = _parameterEncoding;
@synthesize registeredHTTPOperationClassNames = _registeredHTTPOperationClassNames;
@synthesize defaultHeaders = _defaultHeaders;
@synthesize operationQueue = _operationQueue;
@synthesize registeredLXErrorParser = _registeredLXErrorParser;
@synthesize hostName = _hostName;
//@synthesize reachability = _reachability;
@synthesize compatiblePOSTParameters = _compatiblePOSTParameters;
@synthesize enableViewControllerTracking = _enableViewControllerTracking;
@synthesize viewControllerRegexPattern = _viewControllerRegexPattern;
@synthesize returnHTTPError = _returnHTTPError;

+ (LXHTTPEngine *)engineWithBaseURL:(NSURL *)url {
    return [[self alloc] initWithBaseURL:url];
}

+ (NSString *)defaultUserAgent {
    //TODO unknown in user-agent
    // bundleIdentifier/version (unknow, systemName systemVersion, model, Scale/scaleNumber)
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    NSString *identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    char *buffer[256] = { 0 };
	size_t size = sizeof(buffer);
    sysctlbyname("hw.machine", buffer, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:(const char*)buffer
											encoding:NSUTF8StringEncoding];
    
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@, %@ %@, %@, Scale/%.1f)", identifier , version, build, systemName , systemVersion , platform , ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0)];
    
    return userAgent;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.returnHTTPError = NO;
    
    self.baseURL = url;
    
    self.stringEncoding = NSUTF8StringEncoding;
    
    self.registeredHTTPOperationClassNames = [NSMutableArray array];
    
    self.defaultHeaders = [NSMutableDictionary dictionary];
    
    // Accept-Encoding HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3
	[self setDefaultHeader:@"Accept-Encoding" value:@"gzip"];
    
	// Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
	NSString *preferredLanguageCodes = [[NSLocale preferredLanguages] componentsJoinedByString:@", "];
	[self setDefaultHeader:@"Accept-Language" value:[NSString stringWithFormat:@"%@, en-us;q=0.8", preferredLanguageCodes]];
    
    NSString *userAgent = [LXHTTPEngine defaultUserAgent];
    [self setDefaultHeader:@"User-Agent" value:userAgent];
    
    
    self.operationQueue = [[NSOperationQueue alloc] init];
	[self.operationQueue setMaxConcurrentOperationCount:kLXHTTPEngineDefaultMaxConcurrentOperationCount];
    
    self.hostName = [self.baseURL host];
    
    [self startNetworkMonitoring];
    //self.reachability = [CQTReachability reachabilityWithHostName:self.hostName];
    
    //__unused BOOL notifierStarted = [self.reachability startNotifier];
    
    _viewControllerURLRequestCalls = [[NSMutableDictionary alloc] init];
    
    // Cache Directory
    //    NSString *cacheDirectory = [self cacheDirectoryName];
    //    BOOL isDirectory = YES;
    //    BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory] && isDirectory;
    //
    //    if (!folderExists)
    //    {
    //        NSError *error = nil;
    //        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    //    }
    
    return self;
}

- (void)setBaseURL:(NSURL *)baseURL {
    
    _baseURL = baseURL;

    self.hostName = [_baseURL host];
}

- (void)dealloc {

}

#pragma mark -

- (BOOL)registerHTTPOperationClass:(Class)operationClass {
    if (![operationClass isSubclassOfClass:[LXHTTPRequestOperation class]]) {
        return NO;
    }
    
    NSString *className = NSStringFromClass(operationClass);
    [self.registeredHTTPOperationClassNames removeObject:className];
    [self.registeredHTTPOperationClassNames insertObject:className atIndex:0];
    
    return YES;
}

- (void)unregisterHTTPOperationClass:(Class)operationClass {
    NSString *className = NSStringFromClass(operationClass);
    [self.registeredHTTPOperationClassNames removeObject:className];
}

#pragma mark -

- (NSString *)defaultValueForHeader:(NSString *)header {
    return [self.defaultHeaders valueForKey:header];
}

- (void)setDefaultHeader:(NSString *)header value:(NSString *)value {
    [self.defaultHeaders setValue:value forKey:header];
}

- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password {
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@" , username , password];
    [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@" , LXBase64EncodedStringFromString(basicAuthCredentials)]];
}

- (void)setAuthorizationHeaderWithToken:(NSString *)token {
    [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Token token=\"%@\"", token]];
}

- (void)clearAuthorizationHeader {
    [self.defaultHeaders removeObjectForKey:@"Authorization"];
}

#pragma mark -

#define kLXEngineURLRequestMethod   @"method"
#define kLXEngineURLRequestURL   @"URL"

- (void)trackViewControllerURLRequest:(NSURL *)URL method:(NSString *)method {
    if (!_enableViewControllerTracking || !_viewControllerRegexPattern) {
        return;
    }
    if (URL == nil || method == nil) {
        NSLog(@"URL == nil || method == nil");
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:URL, method, nil] forKeys:[NSArray arrayWithObjects:kLXEngineURLRequestURL, kLXEngineURLRequestMethod, nil]];
    // find vc
    NSError *error = nil;
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:self.viewControllerRegexPattern options:NSRegularExpressionCaseInsensitive error:&error];
    for (NSString *methodCallInfo in [NSThread callStackSymbols]) {
        NSArray *matches = [exp matchesInString:methodCallInfo options:NSMatchingWithTransparentBounds range:NSMakeRange(0, [methodCallInfo length])];
        if (!matches || [matches count] <= 0) {
            continue;
        }
        
        NSTextCheckingResult *result = [matches lastObject];
        NSString *vcName = [methodCallInfo substringWithRange:result.range];
        //        NSLog(@"Call Method from ViewController: %@" , vcName);
        NSMutableArray *infosArray = [_viewControllerURLRequestCalls objectForKey:vcName];
        if (!infosArray) {
            infosArray = [[NSMutableArray alloc] init];
        }
        [infosArray addObject:dic];
        [_viewControllerURLRequestCalls setObject:infosArray forKey:vcName];
        
        break;
    }
    
}

- (void)untrackViewController:(NSString *)viewControllerName {
    if (!viewControllerName) {
        return;
    }
    NSArray *infosArray = [_viewControllerURLRequestCalls objectForKey:viewControllerName];
    if (!infosArray || [infosArray count] <= 0) {
        return;
    }
    
    for (NSDictionary *dic in infosArray) {
        NSURL *URL = [dic objectForKey:kLXEngineURLRequestURL];
        NSString *method = [dic objectForKey:kLXEngineURLRequestMethod];
        
        [self cancelHTTPOperationsWithMethod:method andURL:URL];
    }
    
    [_viewControllerURLRequestCalls removeObjectForKey:viewControllerName];
}

- (NSURL *)organiseUrl:(NSDictionary *)param path:(NSString *)aPath url:(NSURL *)aurl method:(NSString *)methods {
    
    NSMutableDictionary *dic = CQT_AUTORELEASE([param mutableCopy]);
    
    if ([methods isEqualToString:@"POST"] && self.compatiblePOSTParameters == YES) {
        
        for (NSString *key in self.uncompatiblePOSTParameters) {
            
            if (key && [key isKindOfClass:[NSString class]]) {
                
                [dic removeObjectForKey:key];
            }
        }
        
        self.uncompatiblePOSTParameters = nil;
    }

    return [self organiseUrl:dic path:aPath url:aurl];
}

- (NSURL *)organiseUrl:(NSDictionary *)param path:(NSString *)aPath url:(NSURL *)aurl {
    
    NSURL *newUrl;
    
    if (_needKeyVerify == YES) {
        
        [param setValue:[NSString generateKey:aurl.absoluteString] forKey:@"k"];
    }
    
    NSString *paramUrl = LXQueryStringFromParametersWithEncoding(param, self.stringEncoding);
    
    paramUrl = [self encryptGetParameters:paramUrl];
    
    NSString *string = [aurl absoluteString];
    
    NSString *filePath = [string stringByAppendingFormat:[aPath rangeOfString:@"?"].location == NSNotFound ? @"&%@" : @"&%@", paramUrl];
    
    filePath = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    newUrl = [NSURL URLWithString:filePath];
    
    return newUrl;
}

- (NSString *)encryptGetParameters:(NSString *)queryStr {
    return queryStr;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
    
     if ([method isEqualToString:@"POST"] && _needKeyVerify == YES) {
         
        NSString *keyStr = [NSString generateKey:path];
        path = [NSString stringWithFormat:@"%@&k=%@",path,keyStr];
     }
//    NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseURL];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.baseURL,path]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.timeoutInterval = API_REQUEST_TIMEOUT_INTERVAL;
    [request setHTTPMethod:method];
    [request setAllHTTPHeaderFields:self.defaultHeaders];
    
    if (parameters) {
        
        if ([method isEqualToString:@"GET"]) {
        
            url = [self organiseUrl:parameters path:path url:url];
            
            [request setURL:url];
        } else {
            
            if (_compatiblePOSTParameters) {
            
                url = [self organiseUrl:parameters path:path url:url method:@"POST"];
                
                [request setURL:url];
            }
                
            NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
            //TODO parameter encoding
            [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
            
            NSString *bodyStr = LXQueryStringFromParametersWithEncoding(parameters, self.stringEncoding);
            
            NSData *bodyData = [bodyStr dataUsingEncoding:self.stringEncoding];
            
            if (self.adjustODPramaters) {
            
                [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
                
                bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
            }
            
            [request setHTTPBody:bodyData];
        }
    }
	CQTDebugLog(@"REQUEST_URL:%@",url);
//    [self trackViewControllerURLRequest:url method:method];
    
    
    return request;
}

NSString * LXQueryStringFromParameters(NSDictionary *parameters) {
    
    NSMutableArray *mutableParameterComponents = [NSMutableArray array];
    
    for (id key in [parameters allKeys]) {
        
        NSString *component = [NSString stringWithFormat:@"%@=%@",key,parameters[key]];
        
        [mutableParameterComponents addObject:component];
    }
    
    return [mutableParameterComponents componentsJoinedByString:@"&"];
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id<LXMultipartFormData>))block {
    
    if (!([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"] || [method isEqualToString:@"DELETE"])) {
        [NSException raise:@"Invalid HTTP Method" format:@"%@ is not supported for multipart form requests; must be either POST, PUT, or DELETE", method];
        return nil;
    }
    NSMutableURLRequest *request;
    if (self.compatiblePOSTParameters) {
        request = [self requestWithMethod:method path:path parameters:parameters];
    } else {
        request = [self requestWithMethod:method path:path parameters:nil];
    }
    
    __block LXMultipartFormData *formData = [[LXMultipartFormData alloc] initWithStringEncoding:self.stringEncoding];
    
    id key = nil;
    NSEnumerator *enumerator = [parameters keyEnumerator];
    while ((key = [enumerator nextObject])) {
        id value = [parameters valueForKey:key];
        NSData *data = nil;
        
        if ([value isKindOfClass:[NSData class]]) {
            data = value;
        } else {
            data = [[value description] dataUsingEncoding:self.stringEncoding];
        }
        
        [formData appendPartWithFormData:data name:[key description]];
    }
    
    if (block) {
        block(formData);
    }
    
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@" , kLXMultipartFormBoundary] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[formData data]];
    
    
    [self trackViewControllerURLRequest:[request URL] method:method];
    
    return request;
}

- (LXHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest success:(void (^)(LXHTTPRequestOperation *, id))success failure:(void (^)(LXHTTPRequestOperation *, NSError *))failure {
    
    LXHTTPRequestOperation *operation = nil;
    
    NSString *className = nil;
    
    NSEnumerator *enumerator = [self.registeredHTTPOperationClassNames reverseObjectEnumerator];
    
    if (0) {
        
        NSString *url = urlRequest.URL.absoluteString;
        if ([url rangeOfString:@"c=goods&a=goodsinfo"].length) {
            
            NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/goodsInfo.plist"];
            NSArray * array = [NSArray arrayWithContentsOfFile:filePath];
            NSMutableArray *mAry = CQT_AUTORELEASE([array mutableCopy]);
            
            if (!mAry) {
                
                mAry = [[NSMutableArray alloc] init];
            }
            
            [mAry addObject:url];
            
            if([mAry writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"tmp/goodsInfo.plist"] atomically:YES]){
                      NSLog(@"保存啊   成功>");
            }else {
                
                NSLog(@"保存啊   失败>");
            }
            
            CQT_RELEASE(mAry);
        }
    }
    
    while (!operation && (className = [enumerator nextObject])) {
    
        Class class = NSClassFromString(className);
        
        if (class && [class canProcessRequest:urlRequest]) {
        
            operation = [(LXHTTPRequestOperation *)[class alloc] initWithRequest:urlRequest];
        }
    }
    
    if (!operation) {
        
        operation = [[LXHTTPRequestOperation alloc] initWithRequest:urlRequest];
    }
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    operation.returnHTTPError = self.returnHTTPError;
    
    return operation;
}

- (void)enqueueHTTPRequestOperation:(LXHTTPRequestOperation *)operation {
    
//    // fix crash(crashlytics): #30 - 如果operation已经被添加, 则不需要重复添加, 以免crash
//    if (![operation isReady])
//        return;
    // fix crash(crashlytics): #143 - 如果operation已经被添加, 则不需要重复添加, 以免crash
    if ([operation isExecuting]
        || [operation isFinished]
        || [operation isCancelled]) {
        return;
    }
    // fix crash(crashlytics): #146 - 如果operation已经被添加, 则不需要重复添加, 以免crash
    if ([self.operationQueue.operations containsObject:operation]) {
        return;
    }
    
    [self.operationQueue addOperation:operation];
//TODO: A9.这里需要做一个冻结操作.对于需要冻结的API.
    if([[CQTReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        
        //如果冻结的APIKey序列中包含了APIKey则冻结.
        if (validStr(self.freezenAPISerialString) &&
            [[self.freezenAPISerialString componentsSeparatedByString:@","] containsObject:operation.APIKey]) {
            
            [self freezeOperations];
        }
    }
}

- (void)cancelHTTPOperationsWithMethod:(NSString *)method andURL:(NSURL *)url {
    for (LXHTTPRequestOperation *operation in [self.operationQueue operations]) {
        //        NSString *requestMethod = [[operation request] HTTPMethod];
        //        NSURL *requestURL = [[operation request] URL];
        //        NSLog(@"operation URL %@ , url %@" , [[[operation request] URL] relativeString], [url relativeString]);
        if ([[[operation request] HTTPMethod] isEqualToString:method] && [[[[operation request] URL] absoluteString] isEqualToString:[url absoluteString]]) {
            [operation cancel];
        }
    }
}

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method {
    for (LXHTTPRequestOperation *operation in [self.operationQueue operations]) {
        if ([[[operation request] HTTPMethod] isEqualToString:method]) {
            [operation cancel];
        }
    }
}

- (void)cancelAllHTTPOperations {
    [self cancelAllHTTPOperationsWithMethod:@"GET"];
    [self cancelAllHTTPOperationsWithMethod:@"PUT"];
}

#pragma mark -

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(LXHTTPRequestOperation *, id))success
        failure:(void (^)(LXHTTPRequestOperation *, NSError *))failure {
    NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    
    LXHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    operation.APIKey = path;
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(LXHTTPRequestOperation *, id))success
         failure:(void (^)(LXHTTPRequestOperation *, NSError *))failure {
    NSURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    LXHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    // freezable for POST method
    [operation setFreezable:YES];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)uploadPath:(NSString *)path
        parameters:(NSDictionary *)parameters
             files:(NSArray *)files
uploadProgressBlock:(void (^)(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))ublock
           success:(void (^)(LXHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(LXHTTPRequestOperation *operation, NSError *error))failure {
    
    NSURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:^(id<LXMultipartFormData> formData) {
        for (id file in files) {
            if (![file isKindOfClass:[LXMultipartFile class]]) {
                continue;
            }
            
            LXMultipartFile *fileToUpload = (LXMultipartFile *)file;
            [formData appendPartWithFileData:fileToUpload.fileData name:fileToUpload.name fileName:fileToUpload.fileName mimeType:fileToUpload.contentType];
        }
    }];
    LXHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [operation setUploadProgressBlock:ublock];
    
    // freezable for POST method
    [operation setFreezable:YES];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(LXHTTPRequestOperation *, id))success
        failure:(void (^)(LXHTTPRequestOperation *, NSError *))failure {
    NSURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters];
    LXHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(LXHTTPRequestOperation *, id))success
           failure:(void (^)(LXHTTPRequestOperation *, NSError *))failure {
    NSURLRequest *request = [self requestWithMethod:@"DELETE" path:path parameters:parameters];
    LXHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)parseResponseDataForError:(NSError **)outError withData:(id)data {
    
    if (_registeredLXErrorParser) {
        
        Class parserClass = NSClassFromString(_registeredLXErrorParser);
        
        SEL parserSelector = @selector(parseResponseDataForError:withData:);
        
        if (parserClass && [parserClass respondsToSelector:parserSelector]) {
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[parserClass methodSignatureForSelector:parserSelector]];
            
            invocation.target = parserClass;
            
            invocation.selector = parserSelector;
            
            // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
            [invocation setArgument:&outError atIndex:2];
            __unsafe_unretained id temp = data;
            [invocation setArgument:&temp atIndex:3];
            
            [invocation invoke];
        }
    }
    
}



#pragma mark - Reachability related

/*!
 * 监听网络状态
 */
- (void)startNetworkMonitoring{
    
    CQTReachabilityManager *afNetworkReachabilityManager = [CQTReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];//开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                CQTDebugLog(@"当前网络:无网络");
                [self freezeOperations];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                CQTDebugLog(@"当前网络:WIFI");
                [_operationQueue setMaxConcurrentOperationCount:8];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                CQTDebugLog(@"当前网络:WWAN");
                 [_operationQueue setMaxConcurrentOperationCount:4];
                break;
            }
                
            default:
                break;
        }
        
        self.networkStatus = status;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NNKEY_networkStatusDidChanged object:@(self.networkStatus)];
    }];
}


/**
 冻结operations
 */
- (void)freezeOperations {
    
        if (![self isCacheEnabled])
            return;
    
        for (LXHTTPRequestOperation *operation in _operationQueue.operations) {
            // freeze only freeable operations.
            if(![operation freezable]) continue;
    
            // freeze only operations that belong to this server
            if([[[[operation request] URL] absoluteString] rangeOfString:self.hostName].location == NSNotFound) continue;
    
            NSString *archivePath = [[[self cacheDirectoryName] stringByAppendingPathComponent:@"test"]
                                     stringByAppendingPathExtension:kLXFreezableOperationExtension];
//            LXLOGBYCONDITION(LXFLAG_REACHABILITY, @"try to archive operation to %@", archivePath);
            [NSKeyedArchiver archiveRootObject:operation toFile:archivePath];
            [operation cancel];
        }
}

-(void) checkAndRestoreFrozenOperations {
    
}

#pragma mark - Cache related

/**
 缓存目录名称
 */
- (NSString*)cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:LXNETWORKCACHE_DEFAULT_DIRECTORY];
    return cacheDirectoryName;
}

/**
 缓存是否打开，如果缓存目录存在则返回YES，反之为NO
 */
- (BOOL)isCacheEnabled {
    BOOL isDir = NO;
    BOOL isCachingEnabled = [[NSFileManager defaultManager] fileExistsAtPath:[self cacheDirectoryName] isDirectory:&isDir];
    return isCachingEnabled;
}

@end


#pragma mark -

static inline NSString *LXMultipartFormInitialBoundary() {
    return [NSString stringWithFormat:@"--%@%@" , kLXMultipartFormBoundary, kLXMultipartFormLineDelimiter];
}

static inline NSString *LXMultipartFormEncapsulationBoundary() {
    return [NSString stringWithFormat:@"%@--%@%@" , kLXMultipartFormLineDelimiter , kLXMultipartFormBoundary , kLXMultipartFormLineDelimiter];
}

static inline NSString *LXMultipartFormFinalBoundary() {
    return [NSString stringWithFormat:@"%@--%@--" , kLXMultipartFormLineDelimiter, kLXMultipartFormBoundary];
}

@interface LXMultipartFormData()
@property (readwrite, nonatomic, assign) NSStringEncoding stringEncoding;
@property (readwrite, nonatomic, strong) NSMutableData *mutableData;
@end

@implementation LXMultipartFormData
@synthesize stringEncoding = _stringEncoding;
@synthesize mutableData = _mutableData;

- (id)initWithStringEncoding:(NSStringEncoding)encoding {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.stringEncoding = encoding;
    self.mutableData = [NSMutableData dataWithLength:0];
    
    return self;
}


- (NSData *)data {
    NSMutableData *finalizedData =[NSMutableData dataWithData:self.mutableData];
    [finalizedData appendData:[LXMultipartFormFinalBoundary() dataUsingEncoding:self.stringEncoding]];
    return finalizedData;
}

#pragma mark - LXMultipartFormData

- (void)appendPartWithHeaders:(NSDictionary *)headers body:(NSData *)body {
    if ([self.mutableData length] == 0) {
        [self appendString:LXMultipartFormInitialBoundary()];
    } else {
        [self appendString:LXMultipartFormEncapsulationBoundary()];
    }
    
    for (NSString *field in [headers allKeys]) {
        [self appendString:[NSString stringWithFormat:@"%@: %@%@" , field , [headers valueForKey:field] , kLXMultipartFormLineDelimiter]];
    }
    
    [self appendString:kLXMultipartFormLineDelimiter];
    [self appendData:body];
}

- (void)appendPartWithFormData:(NSData *)data name:(NSString *)name {
    NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
    [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"" , name] forKey:@"Content-Disposition"];
    
    
    [self appendPartWithHeaders:mutableHeaders body:data];
}

- (void)appendPartWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
    [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"" , name , fileName] forKey:@"Content-Disposition"];
    [mutableHeaders setValue:mimeType forKey:@"Content-Type"];
    
    [self appendPartWithHeaders:mutableHeaders body:data];
}

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL name:(NSString *)name error:(NSError **)error {
    if (![fileURL isFileURL]) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:fileURL forKey:NSURLErrorFailingURLErrorKey];
        [userInfo setValue:NSLocalizedString(@"Expected URL to be a file URL", nil)  forKey:NSLocalizedFailureReasonErrorKey];
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:LXNetworkErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
        }
        
        return NO;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL];
    [request setCachePolicy:NSURLCacheStorageNotAllowed];
    
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    
    if (response && !error) {
        [self appendPartWithFileData:data name:name fileName:[response suggestedFilename] mimeType:[response MIMEType]];
        
        return YES;
    } else {
        return NO;
    }
}

- (void)appendData:(NSData *)data {
    [self.mutableData appendData:data];
}

- (void)appendString:(NSString *)string {
    [self appendData:[string dataUsingEncoding:self.stringEncoding]];
}


@end

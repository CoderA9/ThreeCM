//
//  LXURLConnectionOperation.m
//  LifeixNetworkKit
//
//  Created by James Liu on 1/9/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import "LXURLConnectionOperation.h"

static NSUInteger const kLXHTTPMinimumInitialDataCapacity = 1024;
static NSUInteger const kLXHTTPMaximumInitialDataCapacity = 1024 * 1024 * 8;

// Should there be a cancelled state? or something similar.
typedef enum {
    LXNetworkOperationStateReady = 1,
    LXNetworkOperationStateExecuting = 2,
    LXNetworkOperationStateFinished = 3
} LXNetworkOperationState;

NSString * const LXNetworkErrorDomain = @"com.cqtimes.networking.error";

NSString * const LXNetworkOperationDidStartNotification = @"com.cqtimes.networking.operation.start";
NSString * const LXNetworkOperationDidFinishNotification = @"com.cqtimes.networking.operation.finish";

static inline NSString * LXKeyPathFromOperationState(LXNetworkOperationState state) {
    switch (state) {
        case LXNetworkOperationStateReady:
            return @"isReady";
        case LXNetworkOperationStateExecuting:
            return @"isExecuting";
        case LXNetworkOperationStateFinished:
            return @"isFinished";
        default:
            return @"state";
    }
}

@interface LXURLConnectionOperation(/** Private Methods */)
@property (readwrite, nonatomic, assign) LXNetworkOperationState state;
@property (readwrite, nonatomic, assign, getter = isCancelled) BOOL cancelled;
@property (readwrite, nonatomic, strong) NSURLConnection *connection;       // wong. - James, 原来这里是"assign"的? 会crash哦
@property (readwrite, nonatomic, strong) NSURLRequest *request;
@property (readwrite, nonatomic, strong) NSURLResponse *response;
@property (readwrite, nonatomic, strong) NSError *error;
@property (readwrite, nonatomic, strong) NSData *responseData;
@property (readwrite, nonatomic, copy) NSString *responseString;
@property (readwrite, nonatomic, assign) NSInteger totalBytesRead;
@property (readwrite, nonatomic, strong) NSMutableData *dataAccumulator;
@property (readwrite, nonatomic, copy) LXURLConnectionOperationProgressBlock uploadProgress;
@property (readwrite, nonatomic, copy) LXURLConnectionOperationProgressBlock downloadProgress;

- (BOOL)shouldTransitionToState:(LXNetworkOperationState)state;
- (void)operationDidStart;
- (void)finish;
@end

@implementation LXURLConnectionOperation

@synthesize state = _state;
@synthesize cancelled = _cancelled;
@synthesize  connection = _connection;
@synthesize runLoopModes = _runLoopModes;
@synthesize  request = _request;
@synthesize response = _response;
@synthesize error = _error;
@synthesize  responseData = _responseData;
@synthesize responseString = _responseString;
@synthesize totalBytesRead = _totalBytesRead;
@synthesize dataAccumulator = _dataAccumulator;
@dynamic inputStream;
@synthesize outputStream = _outputStream;
@synthesize uploadProgress = _uploadProgress;
@synthesize downloadProgress = _downloadProgress;
@synthesize operationTime = _operationTime;

+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    do {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//        [[NSRunLoop currentRunLoop] run];
//        [pool drain];
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] run];
        }
    } while (YES);
}

+ (NSThread *)networkRequestThread {
    
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    
    return _networkRequestThread;
}

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    
    self = [super init];
    
    if (!self)
        
        return nil;
    
    self.runLoopModes = [NSSet setWithObject:NSRunLoopCommonModes];
    
    self.request = urlRequest;
    
    self.state = LXNetworkOperationStateReady;
    
    _lastStartTimestamp = -1.f;
    
    self.operationTime = -1.f;
    
    return self;
}


- (void)setCompletionBlock:(void (^)(void))block {
    if (!block) {
        [super setCompletionBlock:nil];
    } else {
        __weak id _blockSelf = self;
        [super setCompletionBlock:^ {
            block();
            [_blockSelf setCompletionBlock:nil];
        }];
    }
}

- (NSInputStream *)inputStream {
    return self.request.HTTPBodyStream;
}

- (void)setInputStream:(NSInputStream *)inputStream {
    NSMutableURLRequest *mutableRequest = [self.request mutableCopy];
    mutableRequest.HTTPBodyStream = inputStream;
    self.request = mutableRequest;
}

- (void)setUploadProgressBlock:(void (^)(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))block {
    self.uploadProgress = block;
}

- (void)setDownloadProgressBlock:(void (^)(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))block {
    self.downloadProgress = block;
}

- (void)setState:(LXNetworkOperationState)state {
    if (![self shouldTransitionToState:state]) {
        return;
    }
    
    NSString *oldStateKey = LXKeyPathFromOperationState(self.state);
    NSString *newStateKey = LXKeyPathFromOperationState(state);
    
    [self willChangeValueForKey:newStateKey];
    [self willChangeValueForKey:oldStateKey];
    _state = state;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
    
    switch (state) {
        case LXNetworkOperationStateReady:
            
            break;
            
        case LXNetworkOperationStateExecuting:
            [[NSNotificationCenter defaultCenter] postNotificationName:LXNetworkOperationDidStartNotification object:self];
            break;
            
        case LXNetworkOperationStateFinished:[[NSNotificationCenter defaultCenter] postNotificationName:LXNetworkOperationDidFinishNotification object:self];
            break;
            
        default:
            break;
    }
}

- (BOOL)shouldTransitionToState:(LXNetworkOperationState)state {
    /**
     default YES.
     ready->executing YES
     executing->finished YES
     */
    
    switch (self.state) {
        case LXNetworkOperationStateReady:
            switch (state) {
                case LXNetworkOperationStateExecuting:
                    return YES;
                default:
                    return NO;
            }
        case LXNetworkOperationStateExecuting:
            switch (state) {
                case LXNetworkOperationStateFinished:
                    return YES;
                default:
                    return NO;
            }
        case LXNetworkOperationStateFinished:
            return NO;
        default:
            return YES;
    }
}

- (void)setCancelled:(BOOL)cancelled {
    [self willChangeValueForKey:@"isCancelled"];
    _cancelled = cancelled;
    [self didChangeValueForKey:@"isCancelled"];
    
    if ([self isCancelled]) {
        self.state = LXNetworkOperationStateFinished;
    }
}

- (NSString *)responseString {
    /**
     If there's a text encoding name in reponse , then use it , otherwise use UTF8 as default.
     */
    if (!_responseString && self.response && self.responseData) {
        NSStringEncoding textEncoding = NSUTF8StringEncoding;
        if (self.response.textEncodingName) {
            textEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)self.response.textEncodingName));
        }
        
        self.responseString = [[NSString alloc] initWithData:self.responseData encoding:textEncoding];
    }
    
    return _responseString;
}

#pragma mark -
#pragma mark NSOperation

- (BOOL)isReady {
    return self.state == LXNetworkOperationStateReady && [super isReady];
}

- (BOOL)isExecuting {
    return self.state == LXNetworkOperationStateExecuting;
}

- (BOOL)isFinished {
    return self.state == LXNetworkOperationStateFinished;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)start {
    if (![self isReady]) {
        return;
    }
    
    self.state = LXNetworkOperationStateExecuting;
    
    [self performSelector:@selector(operationDidStart) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:YES modes:[self.runLoopModes allObjects]];
}

- (void)operationDidStart {
    
    _lastStartTimestamp = [[NSDate date] timeIntervalSince1970];
    
    if ([self isCancelled]) {
        [self finish];
        return;
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    for (NSString *runLoopMode in self.runLoopModes) {
        [self.connection scheduleInRunLoop:runLoop forMode:runLoopMode];
        [self.outputStream scheduleInRunLoop:runLoop forMode:runLoopMode];
    }
    
    [self.connection start];
}

- (void)finish {
    if (_lastStartTimestamp > 0.f) {
        self.operationTime = [[NSDate date] timeIntervalSince1970] - _lastStartTimestamp;
    }

    _lastStartTimestamp = -1.f;
    
    self.state = LXNetworkOperationStateFinished;
}

- (void)cancel {
    if ([self isFinished]) {
        return;
    }
    
    [super cancel];
    
    self.cancelled = YES;
    
    if(self.connection != nil)
    {
        [self.connection cancel];
    }
}

#pragma mark -
#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)__unused connection 
didSendBodyData:(NSInteger)bytesWritten 
totalBytesWritten:(NSInteger)totalBytesWritten 
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.uploadProgress) {
        self.uploadProgress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)connection:(NSURLConnection *)__unused connection 
didReceiveResponse:(NSURLResponse *)response 
{
    self.response = (NSHTTPURLResponse *)response;
    
    if (self.outputStream) {
        [self.outputStream open];
    } else {
        NSUInteger maxCapacity = MAX((NSUInteger)llabs(response.expectedContentLength), kLXHTTPMinimumInitialDataCapacity);
        NSUInteger capacity = MIN(maxCapacity, kLXHTTPMaximumInitialDataCapacity);
        self.dataAccumulator = [NSMutableData dataWithCapacity:capacity];
    }
}

- (void)connection:(NSURLConnection *)__unused connection 
didReceiveData:(NSData *)data 
{
    self.totalBytesRead += [data length];
    
    if (self.outputStream) {
        if ([self.outputStream hasSpaceAvailable]) {
            const uint8_t *dataBuffer = [data bytes];
            [self.outputStream write:&dataBuffer[0] maxLength:[data length]];
        }
    } else {
        [self.dataAccumulator appendData:data];
    }
    
    if (self.downloadProgress) {
        self.downloadProgress([data length], self.totalBytesRead, (NSInteger)self.response.expectedContentLength);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)__unused connection {
    
    if (self.outputStream) {
    
        [self.outputStream close];
    } else {
        
        self.responseData = [NSData dataWithData:self.dataAccumulator];
        _dataAccumulator = nil;
    }
    
    [self finish];
}

- (void)connection:(NSURLConnection *)__unused connection 
didFailWithError:(NSError *)error 
{      
    self.error = error;
    
    if (self.outputStream) {
   
        [self.outputStream close];
    } else {
        
        _dataAccumulator = nil;
    }
    
    [self finish];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)__unused connection 
willCacheResponse:(NSCachedURLResponse *)cachedResponse 
{
    if ([self isCancelled]) {
        
        return nil;
    }
    
    return cachedResponse;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//        if ([trustedHosts containsObject:challenge.protectionSpace.host])
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
//    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end

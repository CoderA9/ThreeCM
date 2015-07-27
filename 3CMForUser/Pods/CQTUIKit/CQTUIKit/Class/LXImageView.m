//
//  LXImageView.m
//  LifeixNetworkKit
//
//  Created by James Liu on 2/6/12.
//  Copyright 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import <objc/runtime.h>
#import "LXImageView.h"
#import <ImageIO/ImageIO.h>
#import "LXHEADRequestOperation.h"
//#import "LXURLCache.h"
#import "CQTReachability.h"
#import "LXGlobalCorePaths.h"
#import "LXHTTPEngine.h"
#import "UIView+custom.h"



static char kLXImageRequestOperationObjectKey;
static char kLXHeadRequestOperationObjectKey;

@interface LXImageView()
- (void)setGIFImage:(NSData *)data;
- (void)playGIF;
- (void)startLoading;
- (void)stopLoading;
- (void)setImageAndAdjustSize:(id)aimage;
- (void)cancelHeadRequestOperation;
- (void)cancelImageRequestOperation;

- (NSString *)sizeStringWithBytes:(int)bytesCount;

- (void)generateImageWithURLRequest:(NSURLRequest *)urlRequest 
				   placeholderImage:(UIImage *)placeholderImage 
							success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
							failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;
@end

@interface LXImageView (_LXNetworkKit)
@property (readwrite, nonatomic, retain, setter = lx_setImageRequestOperation:) LXImageRequestOperation *lx_imageRequestOperation;
@property (readwrite, nonatomic, retain, setter = lx_setHeadRequestOperation:) LXHEADRequestOperation *lx_headRequestOperation;
@end

@implementation LXImageView (_LXNetworkKit)
@dynamic lx_imageRequestOperation;
@dynamic lx_headRequestOperation;
@end

@implementation LXImageView
@synthesize enableGIFPlay = _enableGIFPlay, disableGIFFlag = _disableGIFFlag;
@synthesize state = _state;
@synthesize enableLoadingIndicator = _enableLoadingIndicator, disableLoadingProccess = _disableLoadingProccess;
@synthesize contentType = _contentType, viewTag = _viewTag;
@synthesize indicatorStyle = _indicatorStyle;
@synthesize autoLoad = _autoLoad;



#pragma mark - private

- (LXHTTPRequestOperation *)lx_imageRequestOperation {
    return (LXHTTPRequestOperation *)objc_getAssociatedObject(self , &kLXImageRequestOperationObjectKey);
}

- (LXHEADRequestOperation *)lx_headRequestOperation {
    return (LXHEADRequestOperation *)objc_getAssociatedObject(self , &kLXHeadRequestOperationObjectKey);
}

- (void)lx_setImageRequestOperation:(LXImageRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kLXImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lx_setHeadRequestOperation:(LXHEADRequestOperation *)headRequestOperation {
    objc_setAssociatedObject(self, &kLXHeadRequestOperationObjectKey, headRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

+ (NSOperationQueue *)lx_sharedHeadRequestOperationQueue {
    
    static NSOperationQueue *_headRequestOperationQueue = nil;
    
    // Donwload up to 8 pics concurrently.
    if (!_headRequestOperationQueue) {
        
        _headRequestOperationQueue = [[NSOperationQueue alloc] init];
        
        [_headRequestOperationQueue setMaxConcurrentOperationCount:10];
    }
    
    return _headRequestOperationQueue;
}



- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initial];
    }
    return self;
}

- (void)initial {
    
    setClearColor(self);
    
    self.userInteractionEnabled = NO;
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    self.clipsToBounds = YES;
    
    _disableLoadingProccess = NO;
    
    self.indicatorStyle = UIActivityIndicatorViewStyleGray;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self updateSingleLine];
}
//Lide 初始化GIF状态
- (id)init {
    
    self = [super init];
    
    if(self != nil) {
        
        [self initial];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self != nil) {
        
        [self initial];
    }
    return self;
}

- (void)dealloc {
    
    [self.lx_imageRequestOperation cancel];
    self.lx_imageRequestOperation = nil;
    [self.lx_headRequestOperation cancel];
    self.lx_headRequestOperation = nil;
    
    [_playBtn removeFromSuperview],_playBtn = nil;
    [_statusButton removeFromSuperview],_statusButton = nil;
    [_indicatorView stopAnimating];
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        
        return;
    }
    
    _statusButton.frame = CGRectMake(0, (self.frame.size.height - 20.f) / 2.f, self.frame.size.width, 20.f);
    
    _playBtn.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect {

}

- (void)setGIFImage:(NSData *)adata {
    if (!adata) {
        return;
    }
    
    UIImage *image = [UIImage imageWithData:adata];
    [self setImageAndAdjustSize:image];
    
    self.contentType = LXImageViewContentTypeGIF;
    
    NSMutableArray *imagesArr = [NSMutableArray array];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)adata, NULL);
    NSDictionary* properties = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyProperties(source, NULL));
    NSDictionary* gifProperties = [properties objectForKey:(NSString*)kCGImagePropertyGIFDictionary];
    size_t count = CGImageSourceGetCount(source);
    
    /** 数量的判断放在后面if ([imagesArr count] > 1). 因为1帧的gif也要显示"gif标识", 所以不能在这里判断, 然后不给gif播放的按钮
    if (count <= 1) {
        
        self.contentType = LXImageViewContentTypeImage;
        
        if (_playBtn) {
            _playBtn.hidden = YES;
        }
        CFRelease(source);
        
        return;
    }
     */
    
    // _playBtn
    if ((self.enableGIFPlay == NO && self.disableGIFFlag == YES)) {
        _playBtn.hidden = YES;
    }
    else {
        if (!_playBtn) {
            _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _playBtn.showsTouchWhenHighlighted = NO;
            [_playBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
            [_playBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [_playBtn setImage:[UIImage imageNamed:@"item_gif.png"] forState:UIControlStateDisabled];
            [_playBtn setImage:[UIImage imageNamed:@"item_gif.png"] forState:UIControlStateNormal];
//            [_playBtn addTarget:self action:@selector(playGIF) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_playBtn];
        }
        //    CGRect foo = _playBtn.frame;
        //    foo.origin.x = self.frame.size.width - foo.size.width;
        //    foo.origin.y = self.frame.size.height - foo.size.height;
        //    _playBtn.frame = foo;
        _playBtn.frame = self.bounds;
        _playBtn.hidden = NO;
        _playBtn.enabled = NO;      // enabled不能为YES, 这样会造成只要是gif就可以播放, 而我们飞鸽有些地方的gif是不能直接播放, 需要点击大图的
    }
    
    if (!_enableGIFPlay) {
        CFRelease(source);
        return;
    }
    
    NSTimeInterval duration = [[gifProperties objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
    if (!duration) {
        int cnt  = count;
        cnt = cnt > 80 ? 80:cnt;
        duration = cnt >10 ?(1.0f/10.0f)*cnt:0.5*cnt;
        
        self.animationDuration = duration;
    }
    
    CGFloat scale = count;
    if (count >50) {
        scale /= 50;
        count = 50;
    }else{
        scale = 1;
    }
    
    for (int  i = 0; i < count; i++) {
        int j = i;
        if (scale > 1) {
            j *= scale;
        }
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, j, NULL);
        
        [imagesArr addObject:[UIImage imageWithCGImage:image]];
        
        CGImageRelease(image);
    }

    
    if ([imagesArr count] > 1) {
        _playBtn.enabled = NO;
        self.animationImages = imagesArr;
    }
    else {
//        _playBtn.hidden = YES;
    }
    
    CFRelease(source);
}

- (void)playGIF {
    if (self.isAnimating) {
        [self stopAnimating];
    } else {
        [self startAnimating];
    }
}

- (void)togglePlayGif {
    [self playGIF];
}

- (void)startLoading {
	if (!self.enableLoadingIndicator)
        return;
    
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.indicatorStyle];
        CGRect frame = _indicatorView.frame;
        CGRect foo = self.frame;
        if (foo.size.width > frame.size.width && foo.size.height > frame.size.height) {
            frame.origin.x = (foo.size.width - frame.size.width ) / 2.f;
            frame.origin.y = (foo.size.height - frame.size.height) / 2.f;
        }
        _indicatorView.frame = frame;
        [self addSubview:_indicatorView];
    }
    
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
}

- (void)stopLoading {
	if (!self.enableLoadingIndicator)
        return;
    
    [_indicatorView stopAnimating];
    _indicatorView.hidden = YES;
}

- (void)stopAnimating {
    [super stopAnimating];
    
    if (_playBtn) {
        _playBtn.hidden = self.isAnimating;
    }
}

- (void)startAnimating {
    if ([self.animationImages count] <= 1)
        return;
    
    [super startAnimating];
    
    if (_playBtn) {
        _playBtn.hidden = self.isAnimating;
    }
}

- (UIButton *)statusButton {
    if (!_statusButton && !_disableLoadingProccess) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _statusButton.frame = CGRectMake(0, (self.frame.size.height - 20.f) / 2.f, self.frame.size.width, 20.f);
        _statusButton.hidden = YES;
        _statusButton.titleLabel.font = [UIFont systemFontOfSize:8.f];
        _statusButton.titleLabel.textAlignment = UITextAlignmentCenter;
        _statusButton.titleLabel.numberOfLines = 2;
        _statusButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        [_statusButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_statusButton addTarget:self action:@selector(startLoadingImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_statusButton];
    }

    _statusButton.frame = CGRectMake(0, (self.frame.size.height - 20.f) / 2.f, self.frame.size.width, 20.f);
    
    return _statusButton;
    
//    if (!_statusLabel) {
//        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 20.f) / 2.f, self.frame.size.width, 20.f)];
//        _statusLabel.textAlignment = UITextAlignmentCenter;
//        _statusLabel.font = [UIFont systemFontOfSize:8.f];
//        _statusLabel.hidden = YES;
//        [self addSubview:_statusLabel];
//    }
//    
//    return _statusLabel;
}

- (void)showStatusMessage:(NSString *)text {
    
    [self statusButton].hidden = YES;
    
    [[self statusButton] setTitle:text forState:UIControlStateNormal];
    [[self statusButton] setTitle:text forState:UIControlStateHighlighted];
    [[self statusButton] setTitle:text forState:UIControlStateSelected];
}

- (void)updateImage:(UIImage *)image {
    
    self.image = image;

    CGSize imageSize = image.size;
    
    if (self.imageWidth != imageSize.width || self.imageHeihgt != imageSize.height ) {
        
        self.imageWidth = imageSize.width;
        self.imageHeihgt = imageSize.height;
        
        if (_imageSizechangedBlock) {
            
            _imageSizechangedBlock(self);
        }
    }
}

#pragma mark - | ***** public methods ***** |

- (void)addObserverImageSizeDidChangedWithBlock:(imageViewSizeDidChangedBlock)block {
    
    if (_imageSizechangedBlock) {
        
        CQT_BLOCK_RELEASE(_imageSizechangedBlock);
    }
    
    _imageSizechangedBlock = CQT_BLOCK_COPY(block);
}

#pragma mark -
- (void)setEnableGIFPlay:(BOOL)flag {
    if (!flag) {
        self.animationImages = nil;
        [self stopAnimating];
        
        if (_playBtn) {
            _playBtn.hidden = YES;
        }
    }
    
    _enableGIFPlay = flag;
}

- (void)setImageAndAdjustSize:(id)aimage {

	if ([aimage isKindOfClass:[UIImage class]]) {
        UIImage *image = (UIImage *)aimage;
        UIImageOrientation imageOrientation = image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp)
        {
            image = [UIImage imageWithCGImage:[image CGImage] scale:1.0
                                           orientation:UIImageOrientationUp];
        }
        
        if ([NSThread isMainThread]) {
            
            [self updateImage:image];
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self updateImage:image];
            });
        }
    }
}

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURLString:(NSString *)urlstr
             placeholderImage:(UIImage *)placeholderImage {
    
    [self setImageWithURL:[NSURL URLWithString:safelyStr(urlstr)] placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURL:(NSURL *)url 
       placeholderImage:(UIImage *)placeholderImage {
    [self setImageWithURL:url placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURL:(NSURL *)url 
       placeholderImage:(UIImage *)placeholderImage 
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:LX_IMAGE_REQUEST_TIMEOUT_INTERVAL];
    
    self.urlStr = url.absoluteString;
    
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    // user-agent
    {
        NSString *userAgent = [LXHTTPEngine defaultUserAgent];
        NSDictionary *defaultHeaders = [NSDictionary dictionaryWithObject:userAgent forKey:@"User-Agent"];
        [request setAllHTTPHeaderFields:defaultHeaders];
    }
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:success failure:failure];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage 
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
    if (![urlRequest URL]
        || (![self.lx_imageRequestOperation isCancelled] && [[urlRequest URL] isEqual:[[self.lx_imageRequestOperation request] URL]])
        || (![self.lx_headRequestOperation isCancelled] && [[urlRequest URL] isEqual:[[self.lx_headRequestOperation request] URL]])) {
        if (![urlRequest URL] && placeholderImage != nil) {
            self.image = placeholderImage;
        }
        return;
    } else {
        [self cancelImageRequestOperation];
        [self cancelHeadRequestOperation];
    }
    
    _state = LXImageViewIdle;
    [self stopAnimating];
    [self stopLoading];
    
    if (placeholderImage) {
        
        self.image = placeholderImage;
    }
    _playBtn.hidden = YES;
    self.animationImages = nil;
    [self statusButton].hidden = YES;
    
//    dispatch_queue_t getImageQ = dispatch_queue_create("GetImage", NULL);
//    dispatch_async(getImageQ, ^{
//        id cachedImage = [[LXURLCache sharedCache] imageForURL:[[urlRequest URL] absoluteString]];
        UIImage * cachedImage = [[CQTCache CQTSharedInstance] image4URL:[[urlRequest URL] absoluteString] cacheFileType:CQTDownloadFileTypeImages];
//        dispatch_async(dispatch_get_main_queue(), ^{
            if (cachedImage) {
                
                _state = LXImageViewGotImage;
                
                self.lx_imageRequestOperation = nil;
                self.lx_headRequestOperation = nil;
                
                
//                dispatch_queue_t showImageQ = dispatch_queue_create("ShowImage", NULL);
//                dispatch_async(showImageQ, ^{
                    if ([cachedImage isKindOfClass:[UIImage class]]) {
                        
                        [self setImageAndAdjustSize:cachedImage];
                        
                        if ([NSThread isMainThread]) {
                           
                            [self updateImage:cachedImage];
                        }else {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self updateImage:cachedImage];
                            });
                        }

                    }
                    else if ([cachedImage isKindOfClass:[NSData class]]) {
                        
//                        [self setGIFImage:cachedImage];
                    }
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(nil, nil, cachedImage);
                        }
//                    });
//                });
//                
//                dispatch_release(showImageQ);
                //        if ([cachedImage isKindOfClass:[UIImage class]]) {
                //            [self setImageAndAdjustSize:cachedImage];
                //        }
                //		else if ([cachedImage isKindOfClass:[NSData class]]) {
                //            [self setGIFImage:cachedImage];
                //        }
                //
                //        self.lx_imageRequestOperation = nil;
                //        self.lx_headRequestOperation = nil;
                //
                //        if (success) {
                //            success(nil, nil, cachedImage);
                //        }
            } else {
                [self startLoading];
                
                [self showImage:placeholderImage];
                //        [self setImageAndAdjustSize:placeholderImage];
                
                _state = LXImageViewGettingInfo;
                [self generateImageWithURLRequest:urlRequest
                                 placeholderImage:placeholderImage
                                          success:success
                                          failure:failure];
                
                CQTReachability *reachability = [CQTReachability reachabilityForInternetConnection];
                
                if ([reachability currentReachabilityStatus] == CQTReachableViaWiFi) {
                    
                    [self startLoadingImage];
                    
                    return;
                }
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                BOOL settingsAutoLoad = [userDefaults boolForKey:LXAutomaticlyLoadImagePreference];
                
                if (settingsAutoLoad ||
                    self.autoLoad) {
                    [self startLoadingImage];
                    
                    return;
                }
                
                __weak LXImageView *selfReference = self;
                
                LXHEADRequestOperation *headOperation = [LXHEADRequestOperation headRequestOperationWithRequest:urlRequest.URL success:^
                                                         (NSURLRequest *request, NSHTTPURLResponse *response) {
                                                             [selfReference stopLoading];
                                                             _state = LXImageViewGotInfo;
                                                             NSDictionary *headers = response.allHeaderFields;
                                                             if (!headers || ![[headers allKeys] containsObject:@"Content-Length"]) {
                                                                 [selfReference startLoadingImage];
                                                                 return;
                                                             }
                                                             
                                                             int contentLength = [[headers objectForKey:@"Content-Length"] intValue];
                                                             float lengthInKB = contentLength / 1024.f;
                                                             if (lengthInKB >= 500) {
                                                                 [selfReference showStatusMessage:[selfReference sizeStringWithBytes:contentLength]];
                                                                 return;
                                                             }
                                                             [selfReference startLoadingImage];
                                                             
                                                         } failure:^
                                                         (NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                             NSLog(@"HEAD request image failed(%@): %@, %d, %@" , [request.URL absoluteString], error.domain, error.code , error.localizedDescription);
                                                             
                                                             _state = LXImageViewNotFoundImage;
                                                             
                                                             // 强制将HEADRequest的错误返回变为HTTP标准返回，如果返回的状态码不为404，则强制开始下载图片。 //TODO 404状态码的判断应该使用系统定义枚举
                                                             if ([error.domain isEqualToString:NSURLErrorDomain] && error.code != 404) {
                                                                 _state = LXImageViewGotInfo;
                                                             }
                                                             
                                                             [selfReference stopLoading];
                                                             
                                                             if (_state == LXImageViewNotFoundImage) {
                                                                 CQTDebugLog(@"error = %@ ; request=%@", error, [request.URL absoluteString]);
                                                                 
                                                                 [selfReference showImage:[UIImage imageNamed:@"image_not_found.jpg"]];
                                                                 //                                                         [selfReference setImageAndAdjustSize:[UIImage imageNamed:@"image_not_found.jpg"]];
                                                                 if (failure) {
                                                                     failure(request, response, error);
                                                                 }
                                                             } else {
                                                                 [selfReference startLoadingImage];
                                                             }
                                                         }];
                headOperation.returnHTTPError = YES;
                
                self.lx_headRequestOperation = headOperation;
                
                // fix crash(crashlytics): #143 - 如果operation已经被添加, 则不需要重复添加, 以免crash
                if ([self.lx_headRequestOperation isExecuting]
                    || [self.lx_headRequestOperation isFinished]
                    || [self.lx_headRequestOperation isCancelled])
                    return;
                // fix crash(crashlytics): #146 - 如果operation已经被添加, 则不需要重复添加, 以免crash
                if ([[[self class] lx_sharedHeadRequestOperationQueue].operations containsObject:self.lx_headRequestOperation]) {
                    return;
                }
                
                [[[self class] lx_sharedHeadRequestOperationQueue] addOperation:self.lx_headRequestOperation];
                
            }
//        });
//    });
//    
//    dispatch_release(getImageQ);
}

- (void)startLoadingImage {
    if (_state == LXImageViewGettingImage
        || self.lx_imageRequestOperation == nil     // 解决crash日志中的一个bug(Incident Identifier: DC166BE1-EA17-4BAB-B726-47B55D188F32): 从后台返回 -> 时间轴往下滑动 -> crash
        ) {
        return;
    }
    // fix crash(crashlytics): #143 - 如果operation已经被添加, 则不需要重复添加, 以免crash
    if ([self.lx_imageRequestOperation isExecuting]
        || [self.lx_imageRequestOperation isFinished]
        || [self.lx_imageRequestOperation isCancelled])
        return;
    // fix crash(crashlytics): #146 - 如果operation已经被添加, 则不需要重复添加, 以免crash
    if ([[[self class] lx_sharedImageRequestOperationQueue].operations containsObject:self.lx_imageRequestOperation]) {
        return;
    }
    
    _state = LXImageViewGettingImage;
    [self startLoading];
    [self statusButton].hidden = YES;
    [[[self class] lx_sharedImageRequestOperationQueue] addOperation:self.lx_imageRequestOperation];
}

// image有可能是UIImage，也有可能是NSData
- (void)showImage:(UIImage *)image {
//    dispatch_queue_t showImageQ = dispatch_queue_create("ShowImage", NULL);
//    dispatch_async(showImageQ, ^{
        if ([image isKindOfClass:[NSData class]]) {
            [self setGIFImage:(NSData *)image];
        }
        else {
            [self setImageAndAdjustSize:image];
        }
//    });
//    
//    dispatch_release(showImageQ);
}

// image有可能是UIImage，也有可能是NSData
- (void)storeImage:(UIImage *)image forUrlPath:(NSString *)urlPath {
    
    dispatch_queue_t storeImageQ = dispatch_queue_create("StoreImage", NULL);
    
    UIImage *weakImage = image;
    
    dispatch_async(storeImageQ, ^{
//        [[LXURLCache sharedCache] storeImageInDisk:image forURL:urlPath];       // maybe crash? - because urlPath maybe release before this method be call (dispatch_async)
        if (_contentType == LXImageViewContentTypeGIF ) {
            
            [[CQTCache CQTSharedInstance] cacheImage4URL:urlPath imageData:[NSData dataWithData:weakImage] cacheFileType:CQTDownloadFileTypeImages];
            
        }else if(_contentType == LXImageViewContentTypeImage){
        
            [[CQTCache CQTSharedInstance] cacheImage4URL:urlPath imageData:[NSData dataWithData:UIImageJPEGRepresentation(weakImage, 1)] cacheFileType:CQTDownloadFileTypeImages];
        }
        
    });
    
    CQT_DISPATCH_RELEASE(storeImageQ);
}

- (void)generateImageWithURLRequest:(NSURLRequest *)urlRequest
                              placeholderImage:(UIImage *)placeholderImage 
                                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
    
    __weak LXImageView *selfReference = self;
    
    LXImageRequestOperation *requestOperation = [[LXImageRequestOperation alloc] initWithRequest:urlRequest];
    [requestOperation setDownloadProgressBlock:^
     (NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
         if (totalBytesExpectedToRead > totalBytesRead) {
             [selfReference showStatusMessage:[NSString stringWithFormat:@"%.2f%%" , totalBytesRead * 100.f / totalBytesExpectedToRead]];
         } else {
             [selfReference statusButton].hidden = YES;
         }

    }];
    [requestOperation setCompletionBlockWithSuccess:^(LXHTTPRequestOperation *operation, id responseObject) {
        
        selfReference.backgroundColor = [UIColor clearColor];
        [selfReference stopLoading];
        
        _state = LXImageViewGotImage;
        
//        dispatch_queue_t showImageQ = dispatch_queue_create("ShowImage", NULL);
//        dispatch_async(showImageQ, ^{
            UIImage *image = nil;
            
            // responseObject is NSData
            NSString *MIMEType = [operation.response.allHeaderFields objectForKey:@"Content-Type"];
            //NSString *MIMEType = operation.response.MIMEType; // wong. 这个MIMEType不准, 直接用"Content-Type"
            BOOL isGIF = MIMEType && [MIMEType isEqualToString:@"image/gif"];
            
            // 如果返回的是gif的话，强转为UIImage以显示第一帧
            if ([[urlRequest URL] isEqual:[[self.lx_imageRequestOperation request] URL]]) {
                if (isGIF) {
                    [selfReference setGIFImage:responseObject];
                } else {
                    image = [UIImage imageWithData:responseObject];
                    
                    [selfReference setImageAndAdjustSize:image];
                }
            } else {
                [selfReference setImageAndAdjustSize:placeholderImage];
            }
            
//            dispatch_async(dispatch_get_main_queue(), ^{
                if (success
                    && self.lx_imageRequestOperation        // fix bug: #10963 - 进入单篇, 图片没有加载出来时就返回到时间轴, 这时候图片加载成功返回后, 会crash的bug修复, 这里用self.lx_imageRequestOperation的原因是, 外部在使用LXImageView时, 移出页面会调用cancelImageRequestOperation这个方法将self.lx_imageRequestOperation=nil, 所以放在这用来做判断
                    ) {
                    success(operation.request, operation.response, image);
                }
//            });
        
            //TODO move it to another thread , not main thread, performance issue
            // if image is a gif,存储返回的NSData对象
            if (isGIF) {
                [self storeImage:responseObject forUrlPath:[[urlRequest URL] absoluteString]];
            } else {
                [self storeImage:image forUrlPath:[[urlRequest URL] absoluteString]];
            }
//        });
//        
//        dispatch_release(showImageQ);
        
    } failure:^(LXHTTPRequestOperation *operation, NSError *error) {
        
        CQTDebugLog(@"error = %@ ; request=%@", error, [operation.request.URL absoluteString]);
        
        _state = LXImageViewNotFoundImage;
        
        [selfReference stopLoading];
        
        [selfReference showImage:[UIImage imageNamed:@"image_not_found.jpg"]];
//        [selfReference setImageAndAdjustSize:[UIImage imageNamed:@"image_not_found.jpg"]];
        
        if (failure) {
            failure(operation.request, operation.response, error);
        }
    }];
    
    self.lx_imageRequestOperation = requestOperation;
}

- (void)cancelHeadRequestOperation {
    [self.lx_headRequestOperation cancel];
    self.lx_headRequestOperation = nil;
}

- (void)cancelImageRequestOperation {
    [self.lx_imageRequestOperation cancel];
    self.lx_imageRequestOperation = nil;
}

- (NSString *)sizeStringWithBytes:(int)bytesCount {
    float lengthInKB = bytesCount / 1024.f;
    NSString *format = @"%.2f KB";
    if (lengthInKB >= 1024.f) {
        format = @"%.2f MB";
        lengthInKB /= 1024.f;
    }
    format = [format stringByAppendingFormat:@"\n%@" , NSLocalizedString(@"TAP_TO_LOAD", nil)];
    
    return [NSString stringWithFormat:format , lengthInKB];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self playGIF];
    if (self.isAnimating) {
        [self playGIF];
    }
}

#pragma mark - Overriding 

- (void)setImage:(UIImage *)image {
    if (nil == image) {
        [self cancelHeadRequestOperation];
        [self cancelImageRequestOperation];
    }
	[super setImage:image];
}

@end

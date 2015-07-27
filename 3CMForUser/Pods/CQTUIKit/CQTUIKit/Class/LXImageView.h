//
//  LXImageView.h
//  LifeixNetworkKit
//
//  Created by James Liu on 2/6/12.
//  Copyright 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$
#import <UIKit/UIKit.h>

#import <AssetsLibrary/ALAssetsLibrary.h>

typedef enum _LXImageViewState {
    LXImageViewIdle =   0,  // 空闲(placeholder)
    LXImageViewGettingInfo, // 通过HEAD请求获取图片信息
    LXImageViewGotInfo, // 获取信息完毕
    LXImageViewGettingImage, // 下载图片中
    LXImageViewGotImage,    // 图片下载完毕
    LXImageViewNotFoundImage    // 未找到图片
} LXImageViewState;



typedef enum _LXImageViewContentType {
    LXImageViewContentTypeImage = 0,            // 图片
    LXImageViewContentTypeGIF,                  // GIF
    LXImageViewContentTypeVideoCapture,         // 视频截图
} LXImageViewContentType;

@class LXImageView;

typedef void(^imageViewSizeDidChangedBlock)(LXImageView *imageView);

#define LX_IMAGE_REQUEST_TIMEOUT_INTERVAL           30.f

/**
 支持GIF播放的ImageView
 Usage:
    LXImageView *foo = [[LXImageView alloc] initWithFrame:CGRectMake(0, 75, 320, 336)];
    foo.userInteractionEnabled = YES;
    foo.enableGIFPlay = YES; // 需要在setImage之前进行enableGIFPlay，不然gif无法正常播放
 */
@interface LXImageView : UIImageView {
@private
    UIButton *_playBtn;
    BOOL _enableGIFPlay;
    BOOL _disableGIFFlag;
    BOOL _enableLoadingIndicator;
    BOOL _disableLoadingProccess;
    BOOL _autoLoad;
    UIActivityIndicatorViewStyle _indicatorStyle;
    
    UIActivityIndicatorView *_indicatorView;
    UIButton *_statusButton;
    
    LXImageViewState _state;
    
    LXImageViewContentType _contentType;
    
    int _viewTag;
    
    imageViewSizeDidChangedBlock _imageSizechangedBlock;
}


/**
 是否开启GIF播放功能
 
 default NO
 */
@property (nonatomic, assign) BOOL enableGIFPlay;

/**
 是否禁用GIF标记
 
 default NO
 注: 如果enableGIFPlay属性是打开的, 那么这个属性就不管用了, 以enableGIFPlay为准
 */
@property (nonatomic, assign) BOOL disableGIFFlag;



/**
 图片类型
 */
@property (nonatomic, assign) LXImageViewContentType contentType;

/**
 是否打开loading的菊花，默认为 NO
 */
@property (nonatomic, assign) BOOL enableLoadingIndicator;

/**
 是否禁用下载进度的显示 (百分比的显示)
 */
@property (nonatomic, assign) BOOL disableLoadingProccess;


/**
 可由调用LXImageView的地方设置是否自动加载
 */
@property (nonatomic, assign) BOOL autoLoad;


@property (nonatomic, assign, readonly) LXImageViewState state;

@property (nonatomic, assign) UIActivityIndicatorViewStyle indicatorStyle;

@property (nonatomic,strong)ALAsset *asset;//记录当前view使用的图片源.

@property (nonatomic, assign) int viewTag;          // 由于有时候tag属性被第三方的控件使用, 所以到时候可能会用到viewTag这个属性

@property (nonatomic, assign) float imageWidth;

@property (nonatomic, assign) float imageHeihgt;

@property (nonatomic, strong) NSString *urlStr;

- (void)setImageWithURL:(NSURL *)url;

- (void)setImageWithURLString:(NSString *)urlstr
       placeholderImage:(UIImage *)placeholderImage;

- (void)setImageWithURL:(NSURL *)url 
       placeholderImage:(UIImage *)placeholderImage;

- (void)setImageWithURL:(NSURL *)url 
       placeholderImage:(UIImage *)placeholderImage 
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest 
              placeholderImage:(UIImage *)placeholderImage 
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

- (void)cancelImageRequestOperation;

- (void)startLoadingImage;


- (void)togglePlayGif;

- (void)addObserverImageSizeDidChangedWithBlock:(imageViewSizeDidChangedBlock)block;
@end

//
//  CQTTouchImageView.m
//  CQTIda
//
//  Created by ANine on 7/16/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTTouchImageView.h"
#import "CQTCustomButton.h"
#import "CQTFullScreenBillBoardView.h"

typedef void (^normalBlock) ( void);

@interface CQTTouchImageView () {
    
    normalBlock _tapBlock;
    
    normalBlock _longPressBlock;
    
    UITapGestureRecognizer *_oneFingerTap;
    
    UILongPressGestureRecognizer *_oneFingerLongPress;
}

@end

@implementation CQTTouchImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initial];
    }
    
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initial];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    
    if (self = [super initWithImage:image]) {
        
        [self initial];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {

    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        
        [self initial];
    }
    return self;
}

- (void)initial {
    
    self.userInteractionEnabled = YES;
    
    [self createShadowViewIfNeeded];
    [self addSubview:_shadowView];
    
    if (!_oneFingerTap) {
        
        _oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTap:)];
        [_shadowView addGestureRecognizer:_oneFingerTap];
    }
    
    if (!_oneFingerLongPress) {
        
        _oneFingerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerlongPress:)];
        
        [_shadowView addGestureRecognizer:_oneFingerLongPress];
    }
}

- (void)dealloc {
    
    A9_ObjectReleaseSafely(_oneFingerTap);
    A9_ObjectReleaseSafely(_oneFingerLongPress);
    
    if (_fsGalleryView) {
        
        CQT_RETAIN(_fsGalleryView);
    }
    
    CQT_SUPER_DEALLOC();
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        return;
    }
    _shadowView.frame = self.bounds;
}
#pragma mark - | ***** private methods ***** |


- (void)oneFingerTap:(UITapGestureRecognizer *)gestureRecognizer {
    
    if (_tapBlock) {
        
        _tapBlock();
    }else {
        
        if (self.canViewEnlarge) {
            
            [self showFullScreenGalleryfromView:self fromRect:self.frame];
        }
    }
    
}

- (void)oneFingerlongPress:(UILongPressGestureRecognizer *)gestureRecognizer {

    if (_longPressBlock) {
        
        _longPressBlock();
    }else {
        
    }
}

- (void)showFullScreenGalleryfromView:(UIView*)fromView fromRect:(CGRect)fromRect {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    CGRect foo = [[[UIApplication sharedApplication] keyWindow] convertRect:fromRect
                                                                   fromView:self];
    
    if (!_fsGalleryView) {
        
        _fsGalleryView = [[CQTFullScreenBillBoardView alloc] initWithFrame:CGRectZero];
    }
    _fsGalleryView.backgroundColor = [UIColor blackColor];
    
    _fsGalleryView.page = 0;
    _fsGalleryView.fromRect = foo;
    

    BILLBOARD *board = [[BILLBOARD alloc] init];
    board.imagePath = self.urlStr;
    
    
    _fsGalleryView.boardsAry = CQT_AUTORELEASE([@[CQT_AUTORELEASE(board)] mutableCopy]);
    
    _fsGalleryView.originViewContentModel = UIViewContentModeScaleAspectFill;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_fsGalleryView];
    
    _fsGalleryView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    [_fsGalleryView show];
    [_fsGalleryView reloadData];
    
}
#pragma mark - | ***** public Methods ***** |
- (void)addTapAction:(void (^)(void))block {
    
    if (_tapBlock ) {
    
        CQT_BLOCK_RELEASE(_tapBlock);
    }
    
    _tapBlock = CQT_BLOCK_COPY(block);
}

- (void)addLongPressAction:(void (^)(void))block {
    
    if (_longPressBlock) {
        
        CQT_BLOCK_RELEASE(_longPressBlock);
    }

    _longPressBlock = CQT_BLOCK_COPY(block);
}


- (void)createShadowViewIfNeeded {
    
    if (!_shadowView) {
        
        _shadowView =[CQTCustomButton buttonWithType:UIButtonTypeCustom];
        _shadowView.showsTouchWhenHighlighted = NO;
        _shadowView.backgroundColor = HEX_RGBA(0x000000, 0.);
    }else {
        
        CQTRemoveFromSuperViewSafely(_shadowView);
    }
}
@end

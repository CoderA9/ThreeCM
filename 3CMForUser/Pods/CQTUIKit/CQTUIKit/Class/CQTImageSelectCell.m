//
//  CQTImageSelectCell.m
//  CQTIda
//
//  Created by ANine on 12/18/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTImageSelectCell.h"

#import "CQTTouchImageView.h"
#import "CQTViewConstants.h"
#import "CQTFullScreenBillBoardView.h"
#import "UIView+custom.h"


#define kTouchImageViewTagBaseOffset -43543
#define kBtnTag  -4325


@interface CQTImageSelectCell(){
    
    
    NSMutableArray *_imgViewAry;
    
}
/* 目前加载的图片 */
@property (nonatomic,retain,readwrite)NSMutableArray *assets;

@end


@implementation CQTImageSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageCount = 1;
        self.heightForPerLine = 60;
        self.imageCountPerLine = 4;
        self.canViewEnlarge = YES;
        
        _assets = [[NSMutableArray alloc] init];
        
        self.closeBtnImage = [UIImage imageNamed:@"close_btn.png"];
        self.closeBtnHightLightImage = [UIImage imageNamed:@"close_btn_red.png"];
        
        [self createSelectPhotoBtnIfNeeded];
        [self.contentView addSubview:_selectePhotoBtn];
        
        _imgViewAry = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        return;
    }
    
    [self updateSubviewsGUI];
}

- (void)updateSubviewsGUI {

    if (!self.imageCountPerLine) {
        
        return;
    }
    
    for (int index = 0; index < _assets.count + 1; index ++) {
        
        UIView *view;
        
        if (index < _assets.count) {
            
            view = [self.contentView viewWithTag:kTouchImageViewTagBaseOffset + index];
            [view setLayerWidth:.5f color:HEX_RGB(0xf2f2f2) cornerRadius:0.];
        }else {
            
            view = self.selectePhotoBtn;
        }
        
        CGFloat H = self.heightForPerLine - kCellSpace;
        CGFloat seperate = (ViewWidth(self) - kCellSpace*2 - H * self.imageCountPerLine ) / (self.imageCountPerLine + 1);
        CGFloat baseX = kCellSpace;
        CGFloat baseY = kCellSpace;
        
        view.frame = ViewRect(baseX + (H + seperate) * (index % (self.imageCountPerLine)),
                              baseY + self.heightForPerLine * (index/self.imageCountPerLine), H, H);
    }
    
    [self.contentView bringSubviewToFront:self.selectePhotoBtn];
}

- (void)dealloc {
    
    if (_fsGalleryView) {
        
        CQT_RELEASE(_fsGalleryView);
    }
    
    if (_tapBlock) {
        
        CQT_BLOCK_RELEASE(_tapBlock);
    }
    
    A9_ContainerReleaseSafely(_imgViewAry);
    
    A9_ContainerReleaseSafely(_assets);
    
    CQT_SUPER_DEALLOC();
}


#pragma mark - | ***** create subviews ***** |
- (void)createSelectPhotoBtnIfNeeded {
    
    if (!_selectePhotoBtn) {
        
        _selectePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectePhotoBtn setImage:[UIImage imageNamed:@"btn_add_photo.png"] forState:UIControlStateNormal];
    }else {
        
        CQTRemoveFromSuperViewSafely(_selectePhotoBtn);
    }
}
#pragma mark - | ***** private methods ***** |
- (void)removeAllImages {
    
    for (int index = 0; index < _imgViewAry.count; index ++) {
        
        [self deselectedImageViewWithIndex:index];
    }
}

- (void)deselectedImageViewWithIndex:(int)index {
    
    CQTTouchImageView *imgView = (CQTTouchImageView *)_imgViewAry[index];
    
    if (imgView && [imgView isKindOfClass:[CQTTouchImageView class]]) {
        
        [imgView removeFromSuperview];
        CQT_RELEASE(imgView);
        imgView = nil;
    }
}

- (void)showFullScreenGallery:(NSArray*)images page:(NSInteger)page fromView:(UIView*)fromView fromRect:(CGRect)fromRect scrollToIndex:(int)index {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    CGRect foo = [[[UIApplication sharedApplication] keyWindow] convertRect:fromRect
                                                                   fromView:self];
    if (!_fsGalleryView) {
        
        _fsGalleryView = [[CQTFullScreenBillBoardView alloc] initWithFrame:CGRectZero];
    }
    _fsGalleryView.backgroundColor = [UIColor blackColor];
    
    _fsGalleryView.page = page;
    _fsGalleryView.fromRect = foo;
    _fsGalleryView.needShowChecked = YES;
    _fsGalleryView.needSHowStorage = NO;
    _fsGalleryView.currentIndex = index;
    
    __weak CQTImageSelectCell * weakSelf = self;
    [_fsGalleryView addSelectedPhotoResultBlock:^(NSMutableDictionary *dic) {
       
        [weakSelf doSelectedResult:dic];
    }];
    
    NSMutableArray *array = CQT_AUTORELEASE([self.assets mutableCopy]);
    
    if (array.count <= 1) {
        
        _fsGalleryView.cycleScroll = NO;
    }
    
    _fsGalleryView.boardsAry = array;
    
    _fsGalleryView.originViewContentModel = UIViewContentModeScaleAspectFill;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_fsGalleryView];
    
    _fsGalleryView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    
    [_fsGalleryView show];
    [_fsGalleryView reloadData];
    
}

- (void)doSelectedResult:(NSMutableDictionary *)dic {
    
    if (validDic(dic)) {
        
        NSMutableArray *tmpAry = CQT_AUTORELEASE([_assets mutableCopy]);
        
        int index = 0;
        for (ALAsset *asset in tmpAry) {
            
            if (![dic[@(index)] intValue]) {
                
                [_assets removeObject:asset];
                
                [self deselectedImageViewWithIndex:index];
            }
            
            index ++;
        }
    }
    
    [self loadImages:_assets];
}
#pragma mark - | ***** public methods ***** |
- (void)loadImages:(NSArray *)images {
    
    [self removeAllImages];
    
    int count = images.count;
    
    for (int index = 0 ; index < count ; index ++) {
        
        CQTTouchImageView *imgView = (CQTTouchImageView *)[self.contentView viewWithTag:kTouchImageViewTagBaseOffset + index];
        
        if (!imgView) {
            
            imgView = [[CQTTouchImageView alloc] init];
            
            [_imgViewAry addObject:imgView];
            
            __unsafe_unretained id weakSelf = self;
            __unsafe_unretained CQTTouchImageView * weakView = imgView;
            
            [imgView addTapAction:^{
                
                [weakSelf imageViewDidTap:weakView];
            }];
            
            [self.contentView addSubview:imgView];
        }
        
        imgView.tag = kTouchImageViewTagBaseOffset + index;
        
        ALAsset *asset = images[index];
        if (asset && [asset isKindOfClass:[ALAsset class]]) {
            
            imgView.image = [UIImage imageWithCGImage:asset.thumbnail];
            
            imgView.hidden = NO;
        }
    }
    
    self.assets = CQT_AUTORELEASE([images mutableCopy]);
    
    [self updateSubviewsGUI];
}

- (void)setAssets:(NSMutableArray *)assets {
    
    if (![_assets isEqual:assets]) {
        
        CQT_RELEASE(_assets);
        
        _assets = CQT_RETAIN(assets);
    }
}

/* 注册一个响应事件 */
- (void)addTapAction:(void (^)(ALAsset *asset,CQTTouchImageView *view))block {
    
    if (_tapBlock) {
        
        CQT_BLOCK_RELEASE(_tapBlock);
    }
    _tapBlock = CQT_BLOCK_COPY(block);
}

#pragma mark - | ***** CQTTouchImageViewDelegate ***** |
- (void)imageViewDidTap:(CQTTouchImageView *)view {
    
    __unsafe_unretained CQTImageSelectCell * weakSelf = self;
    
    int index = view.tag - kTouchImageViewTagBaseOffset;
    
    if (_tapBlock) {
        
        ALAsset *asset = nil;
        
        if (validAry(weakSelf.assets) && weakSelf.assets.count > index) {
            
            asset = weakSelf.assets[index];
        }
        
        _tapBlock(asset,view);
        
    }else if (weakSelf.canViewEnlarge) {
        
        [weakSelf showFullScreenGallery:weakSelf.assets page:weakSelf.assets.count fromView:weakSelf.superview fromRect:weakSelf.frame scrollToIndex:index];
    }
}



@end

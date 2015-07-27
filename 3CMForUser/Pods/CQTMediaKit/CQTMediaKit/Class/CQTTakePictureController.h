
//
//  CQTTakePictureViewController.h
//  CQTKeyTime
//
//  Created by sky on 11-12-19.
//  Copyright 2011 CQTimes.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

 #import <AssetsLibrary/AssetsLibrary.h>

@interface CQTTakePictureController : UIImagePickerController {
	
}    

- (id)initWithType:(UIImagePickerControllerSourceType)sourceType;

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end


#pragma mark - CQTAssetPickerController

@protocol CQTAssetPickerControllerDelegate;

@interface CQTAssetPickerController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, CQTAssetPickerControllerDelegate> delegate;



@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;

@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

@property (nonatomic, strong) NSPredicate *selectionFilter;

@property (nonatomic, assign) BOOL showCancelButton;

@property (nonatomic, assign) BOOL showEmptyGroups;

@property (nonatomic, assign) BOOL isFinishDismissViewController;

@end

@protocol CQTAssetPickerControllerDelegate <NSObject>

-(void)assetPickerController:(CQTAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional

-(void)assetPickerControllerDidCancel:(CQTAssetPickerController *)picker;

-(void)assetPickerController:(CQTAssetPickerController *)picker didSelectAsset:(ALAsset*)asset;

-(void)assetPickerController:(CQTAssetPickerController *)picker didDeselectAsset:(ALAsset*)asset;

-(void)assetPickerControllerDidMaximum:(CQTAssetPickerController *)picker;

-(void)assetPickerControllerDidMinimum:(CQTAssetPickerController *)picker;

@end

#pragma mark - CQTAssetViewController

@interface CQTAssetViewController : UITableViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;

@property (nonatomic,assign) NSInteger number;     //新加的，选中的张数


- (BOOL)containAsset:(ALAsset *)asset;
@end

#pragma mark - CQTVideoTitleView

@interface CQTVideoTitleView : UILabel

@end

#pragma mark - CQTTapAssetView

@protocol CQTTapAssetViewDelegate <NSObject>

-(void)touchSelect:(BOOL)select;
-(BOOL)shouldTap;

@end

@interface CQTTapAssetView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, weak) id<CQTTapAssetViewDelegate> delegate;

@end

#pragma mark - CQTAssetView

@protocol CQTAssetViewDelegate <NSObject>

-(BOOL)shouldSelectAsset:(ALAsset*)asset;
-(void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset;

@end

@interface CQTAssetView : UIView

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end

#pragma mark - CQTAssetViewCell

@protocol CQTAssetViewCellDelegate;

@interface CQTAssetViewCell : UITableViewCell

@property(nonatomic,weak)id<CQTAssetViewCellDelegate> delegate;

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX;

@end

@protocol CQTAssetViewCellDelegate <NSObject>

- (BOOL)shouldSelectAsset:(ALAsset*)asset;
- (void)didSelectAsset:(ALAsset*)asset;
- (void)didDeselectAsset:(ALAsset*)asset;

@end

#pragma mark - CQTAssetGroupViewCell

@interface CQTAssetGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end

#pragma mark - CQTAssetGroupViewController

@interface CQTAssetGroupViewController : UITableViewController

@end

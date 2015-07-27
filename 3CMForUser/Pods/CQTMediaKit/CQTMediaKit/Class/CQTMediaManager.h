//
//  CQTMediaManager.h
//  CQTIda
//
//  Created by ANine on 12/17/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <Foundation/Foundation.h>

 #import <AssetsLibrary/AssetsLibrary.h>

@class CQTTakePictureController;

@protocol CQTAssetPickerControllerDelegate;

/**
 @brief 媒体管理器
 
 @discussion <#some notes or alert with this class#>
 */

#define kImagesKey                  @"images"
#define kThumbnailImagesKey         @"thumbnailImages"
#define kAssets                     @"assets"


typedef void (^pickImageSuccessedBlock)(NSDictionary *imageInfo);
typedef void (^pickImageErrorBlock)(NSDictionary *errorInfo);

typedef void (^willShowPickerControllerBlock)(void);

@interface CQTMediaManager  : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CQTAssetPickerControllerDelegate,UIAlertViewDelegate > {
    
    pickImageSuccessedBlock                 _pickSBlock;
    
    pickImageErrorBlock                     _pickfBlock;
    
    willShowPickerControllerBlock           _willShowBlock;
    
    CQTTakePictureController *_takePicker;

}

@property (nonatomic,assign)UIViewController *targetVC;
@property (nonatomic,assign)NSInteger maxCount;

@property (nonatomic,retain)NSArray * selectedResource;

- (void)needPhotoWithSuccessedBlock:(pickImageSuccessedBlock)sBlock
                      failuredBlock:(pickImageErrorBlock)fBlock
                willShowPickerBlock:(willShowPickerControllerBlock)willShowBlock
               targetViewController:(UIViewController *)vc;

- (void)needPhotosCount:(NSInteger)count
               selected:(NSArray *)assets
         SuccessedBlock:(pickImageSuccessedBlock)sBlock
          failuredBlock:(pickImageErrorBlock)fBlock
    willShowPickerBlock:(willShowPickerControllerBlock)willShowBlock
   targetViewController:(UIViewController *)vc;


+ (UIImage *)fullResolutionImage:(ALAsset *)asset;
- (UIImage *)fullResolutionImage:(ALAsset *)asset;

+ (UIImage *)fullScreenImage:(ALAsset *)asset;
- (UIImage *)fullScreenImage:(ALAsset *)asset;

+ (UIImage *)thumbnail:(ALAsset *)asset;
- (UIImage *)thumbnail:(ALAsset *)asset;

+ (NSString *)imageURLString:(ALAsset *)asset;
- (NSString *)imageURLString:(ALAsset *)asset;

@end

//
//  CQTMediaManager.m
//  CQTIda
//
//  Created by ANine on 12/17/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTMediaManager.h"

#import "CQTTakePictureController.h"


#define k4ImagePickerActionSheetTag     777L

@implementation CQTMediaManager

- (void)dealloc {
    
    CQT_SUPER_DEALLOC();
}

#pragma mark - | ***** public methods ***** |

- (void)needPhotoWithSuccessedBlock:(pickImageSuccessedBlock)sBlock
                      failuredBlock:(pickImageErrorBlock)fBlock
                willShowPickerBlock:(willShowPickerControllerBlock)willShowBlock
               targetViewController:(UIViewController *)vc {
    
    [self needPhotosCount:1 selected:nil SuccessedBlock:sBlock failuredBlock:fBlock willShowPickerBlock:willShowBlock targetViewController:vc];
}

- (void)needPhotosCount:(NSInteger)count
               selected:(NSArray *)assets
         SuccessedBlock:(pickImageSuccessedBlock)sBlock
          failuredBlock:(pickImageErrorBlock)fBlock
    willShowPickerBlock:(willShowPickerControllerBlock)willShowBlock
   targetViewController:(UIViewController *)vc {
    
    self.targetVC = vc;
    self.maxCount = count;
    self.selectedResource = assets;
    
    if (_pickSBlock) {
        
        CQT_BLOCK_RELEASE(_pickSBlock);
    }
    _pickSBlock = CQT_BLOCK_COPY(sBlock);
    
    if (_pickfBlock) {
        
        CQT_BLOCK_RELEASE(_pickfBlock);
    }
    _pickfBlock = CQT_BLOCK_COPY(fBlock);
    
    if (_willShowBlock) {
        
        CQT_BLOCK_RELEASE(_willShowBlock);
    }
    _willShowBlock = CQT_BLOCK_COPY(willShowBlock);
    
    NSString *localImageStr = [NSString stringWithFormat:@"从相册取%ld张",count] ;
    NSString *cameraStr = @"";
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        cameraStr = @"拍一张";
    }
    
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:cameraStr,localImageStr, nil];
    as.tag = k4ImagePickerActionSheetTag;
    [as showInView:[UIApplication sharedApplication].keyWindow];
    
    CQT_RELEASE(as);

}



+ (UIImage *)fullResolutionImage:(ALAsset *)asset {

    return [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
}
- (UIImage *)fullResolutionImage:(ALAsset *)asset {
    
    return [CQTMediaManager fullResolutionImage:asset];
}

+ (UIImage *)fullScreenImage:(ALAsset *)asset {

    return [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
}
- (UIImage *)fullScreenImage:(ALAsset *)asset {

    return [CQTMediaManager fullScreenImage:asset];
}
+ (UIImage *)thumbnail:(ALAsset *)asset {

    return [UIImage imageWithCGImage:asset.thumbnail];
}
- (UIImage *)thumbnail:(ALAsset *)asset {

    return [CQTMediaManager thumbnail:asset];
}

+ (NSString *)imageURLString:(ALAsset *)asset {

    return asset.defaultRepresentation.url.absoluteString;
}

- (NSString *)imageURLString:(ALAsset *)asset {

    return [CQTMediaManager imageURLString:asset];
}

#pragma mark - UIActionSheetDelegate
#pragma mark -


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == k4ImagePickerActionSheetTag) {
        
        if (buttonIndex == 0 || buttonIndex == 1) {
            
            UIImagePickerControllerSourceType type;
            if (buttonIndex == 0) {
                
                type = UIImagePickerControllerSourceTypeCamera;
            }
            else if(buttonIndex == 1) {
                
                type = UIImagePickerControllerSourceTypePhotoLibrary;
            }

            [self showImagePicker:type];
        }
    }
}

#pragma mark - | ***** private methods ***** |
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] ) {
        
        if (_willShowBlock) {
            
            _willShowBlock();
        }
        
        if (![CQTDevice canUseAlbum] ) {
            
//            CQTAlertView *alert = CQT_AUTORELEASE([[CQTAlertView alloc] initWithTitle:@"亲" subTitle:__TEXT(user_album_alert) cancelBtn:@"好 的" OtherBtn:@[@"去更改"]]);
//            
//            [alert showInView:[UIApplication sharedApplication].keyWindow delegate:self];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲" message:<#(NSString *)#> delegate:<#(id)#> cancelButtonTitle:<#(NSString *)#> otherButtonTitles:<#(NSString *), ...#>, nil];
            
            
            return;
        };
        
        if ((sourceType == UIImagePickerControllerSourceTypeCamera ||
             self.maxCount == 1)) {
            
            if (sourceType == UIImagePickerControllerSourceTypeCamera) {
                
                if (![CQTDevice canUseCamera]) {
                    
//                    CQTAlertView *alert = CQT_AUTORELEASE([[CQTAlertView alloc] initWithTitle:@"亲" subTitle:__TEXT(user_camera_alert) cancelBtn:@"好 的" OtherBtn:@[@"去更改"]]);
//                    
//                    [alert showInView:[UIApplication sharedApplication].keyWindow delegate:self];
                    
                    return;
                };
            }
            
            CQTTakePictureController *picker = [[CQTTakePictureController alloc] initWithType:sourceType];
            
            picker.allowsEditing = YES;
            
            picker.delegate = self;
            
            picker.modalPresentationStyle = UIModalPresentationCurrentContext;
            
            [_targetVC presentViewController:picker animated:YES completion:^{
            }];
            

        }else {
            
            CQTAssetPickerController *picker = [[CQTAssetPickerController alloc]init];
            
            picker.maximumNumberOfSelection = self.maxCount;
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.showEmptyGroups = NO;
            picker.delegate = self;
            picker.indexPathsForSelectedItems = CQT_AUTORELEASE([self.selectedResource mutableCopy]);
            
            
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
                if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
                    return duration >= 5;
                }else{
                    return  YES;
                }
            }];
            
            [self.targetVC presentViewController:picker animated:YES completion:nil];
        }
    }
}

- (NSString*)imageURL {
    
    /* 罗刚 20150326 Modify */
//    NSString *url = [[AppDelegate memberInfo] value4KeyPath:kMemberIconKey];
    NSString *url =nil;
    if (url == nil || [url length] == 0) {
        
        url = @"takeImage38282398298392392";
    }
    
    return url;
}

- (void)processThread:(id)obj {
        
    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)obj];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *image = [info valueForKeyPath:UIImagePickerControllerOriginalImage];
        
        UIImage * thumbnailImage = [Util scaleImage:image toSize:CGSizeMake(300.f, 300.f)];
        
        if (_pickSBlock) {
            
            _pickSBlock(@{kImagesKey:@[image],kThumbnailImagesKey:@[thumbnailImage]});
        }
        
        CQT_RELEASE(info);
                        
        return;
    }
    
    CQT_RELEASE(info);
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    
//    NSString *msg = (error == NULL)?@"保存成功":@"保存失败";
//    
//    [CQTAlertView showTipsWithTitle:msg];
}

#pragma mark - | ***** UIImagePickerControllerDelegate ***** |
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _takePicker = (CQTTakePictureController*)picker;

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *image = [info valueForKeyPath:UIImagePickerControllerOriginalImage];
        ALAssetsLibrary *library = [CQTTakePictureController defaultAssetsLibrary];
        
        [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
            
            NSMutableArray *assets = [NSMutableArray arrayWithArray:self.selectedResource];
            
            [library assetForURL:assetURL
                     resultBlock:^(ALAsset * asset){
                         
                         [assets addObject:asset];
                         
                         if (assets && assets.count > self.maxCount) {
                             
                             [assets removeObjectAtIndex:0];
                         }
                         
                         _pickSBlock(@{kAssets:assets});
                         
                         [picker dismissViewControllerAnimated:YES completion:^{}];
                     }
                    failureBlock:^(NSError * error){
                        NSLog(@"cannot get image - %@", [error localizedDescription]);
                        
                        _pickfBlock(@{@"error":error});
                    }];
        }];
    }
}

#pragma mark - CQTAssetPickerController Delegate

-(void)assetPickerController:(CQTAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    if(_pickSBlock && [assets isKindOfClass:[NSObject class]]) {
        
        _pickSBlock(@{kAssets:assets});
    }
}

#pragma mark - | ***** UIAlertViewDelegate ***** |
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (([alertView.title isEqualToString:__TEXT(user_camera_alert)] ||
         [alertView.title isEqualToString:__TEXT(user_album_alert)]) &&
        buttonIndex == 1) {
        
        if (iOS_IS_UP_VERSION(8.0)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
            ApplicationEnterSetting;
#endif
        }
    }
}

@end

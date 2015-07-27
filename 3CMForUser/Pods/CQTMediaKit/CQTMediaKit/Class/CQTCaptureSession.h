//
//  CQTCaptureSession.h
//  CQTIda
//
//  Created by ANine on 7/14/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"

@interface CQTCaptureSession : NSObject {
    BOOL flashOn;
}

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureSession *captureSession;

@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) UIImage *stillImage;

- (void)addVideoPreviewLayer;
- (void)addStillImageOutput;
- (void)captureStillImage;
- (void)addVideoInputFromCamera;

- (void)setFlashOn:(BOOL)boolWantsFlash;
@end

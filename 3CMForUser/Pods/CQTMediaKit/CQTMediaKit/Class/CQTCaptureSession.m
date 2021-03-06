//
//  CQTCaptureSession.m
//  CQTIda
//
//  Created by ANine on 7/14/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTCaptureSession.h"

#import <ImageIO/ImageIO.h>

@implementation CQTCaptureSession
- (id)init
{
	if ((self = [super init]))
    {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
	}
	return self;
}

- (void)addVideoPreviewLayer
{
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
	[_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
}

- (void)addVideoInputFromCamera
{
    AVCaptureDevice *backCamera;
    
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            if ([device position] == AVCaptureDevicePositionBack)
            {
                backCamera = device;
                [self toggleFlash];
            }
        }
    }
    
    NSError *error = nil;
    
    AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    
    if (!error)
    {
        if ([_captureSession canAddInput:backFacingCameraDeviceInput])
        {
            [_captureSession addInput:backFacingCameraDeviceInput];
        }
    }
}

- (void)setFlashOn:(BOOL)boolWantsFlash {
    flashOn = boolWantsFlash;
    [self toggleFlash];
}

- (void)toggleFlash
{
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        
        if (device.flashAvailable) {
            
            if (flashOn) {
            
                [device lockForConfiguration:nil];
                device.flashMode = AVCaptureFlashModeOn;
                [device unlockForConfiguration];
            } else {
                [device lockForConfiguration:nil];
                device.flashMode = AVCaptureFlashModeOff;
                [device unlockForConfiguration];
            }
        }
    }
}

- (void)addStillImageOutput
{
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in [_stillImageOutput connections])
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    [_captureSession addOutput:[self stillImageOutput]];
}

- (void)captureStillImage
{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [[self stillImageOutput] connections])
    {
		for (AVCaptureInputPort *port in [connection inputPorts])
        {
			if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
				videoConnection = connection;
				break;
			}
		}
        
		if (videoConnection)
        {
            break;
        }
	}
    
	[_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                   completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         
         if (imageSampleBuffer)
         {
             CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
             if (exifAttachments)
             {
                 //NSLog(@"attachements: %@", exifAttachments);
             } else
             {
                 //NSLog(@"no attachments");
             }
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             UIImage *image = [[UIImage alloc] initWithData:imageData];
             [self setStillImage:image];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully object:nil];
         }
     }];
}

- (void)dealloc {
    
	[[self captureSession] stopRunning];
    
	_previewLayer = nil;
	_captureSession = nil;
    _stillImageOutput = nil;
    _stillImage = nil;
}


@end

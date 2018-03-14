//
//  AYScanQRCodeController.h
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AYScanQRPreView.h"

@interface AYScanQRCodeController : AYViewController <AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AYScanQRPreView * preview;
//@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@end

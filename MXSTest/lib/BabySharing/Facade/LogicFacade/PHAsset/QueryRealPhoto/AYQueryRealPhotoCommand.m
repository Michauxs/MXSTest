//
//  AYQueryRealPhotoCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryRealPhotoCommand.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImage+fixOrientation.h"
#import <objc/runtime.h>
#import "AYRemoteCallDefines.h"

@implementation AYQueryRealPhotoCommand
- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    // 缩略图和PHAsset
    PHAsset* pHAsset = [args objectForKey:@"asset"];
    
    [self beforeAsyncCall];
   
    static PHImageRequestID requestid = -1;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info) {
        if (!error) {
            NSLog(@" %@ === %f", @"progress", progress);
        }
    };
    [[PHImageManager defaultManager] cancelImageRequest:requestid];
    requestid = [[PHImageManager defaultManager] requestImageDataForAsset:pHAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (imageData != nil) {
            block(YES, (id)[[UIImage imageWithData:imageData] fixOrientation]);
        }
        
        [self endAsyncCall];
    }];
}
@end

//
//  AYDownloadUserFilesCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYDownloadUserFilesCommand.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"

@implementation AYDownloadUserFilesCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"download user image to server: %@", args);
  
    NSString* photo_name = [args objectForKey:@"image"];
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *prefix = cmd.route;
	
	[[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[prefix stringByAppendingString:photo_name]] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
		
	} completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
		if (finished) {
			if (image) {
				block(YES, (NSDictionary*)image);
			} else
				block(NO, nil);
		}
	}];
	
//    dispatch_queue_t post_queue = dispatch_queue_create("down load image", nil);
//    dispatch_async(post_queue, ^(void){
//        UIImage* img_local = [TmpFileStorageModel enumImageWithName:args withDownLoadFinishBolck:^(BOOL success, UIImage *img) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                block(success, (NSDictionary*)img);
//            });
//        }];
//        
//        if (img_local != nil) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                block(YES, (NSDictionary*)img_local);
//            });
//        }
//    });
}
@end

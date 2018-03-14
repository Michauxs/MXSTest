//
//  AYDownloadImageCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 2/3/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYDownloadImageCommand.h"
#import "RemoteInstance.h"

@implementation AYDownloadImageCommand

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
	
}
@end


//
//  AYDownloadMovieFilesCommand.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYDownloadMovieFilesCommand.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
#import "AYQueryModelDefines.h"

@implementation AYDownloadMovieFilesCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"download user image to server: %@", args);
    
    NSString* name = [args objectForKey:@"name"];
    
    dispatch_queue_t post_queue = dispatch_queue_create("down load image", nil);
    dispatch_async(post_queue, ^(void){
        NSURL* url = [TmpFileStorageModel enumFileWithName:name andType:PostPreViewMovie withDownLoadFinishBlock:^(BOOL success, NSURL *path) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(success, (NSDictionary*)path);
                });
                
            } else {
                NSLog(@"down load movie %@ failed", name);
            }
        }];
        if (url != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES, (NSDictionary*)url);
            });
        }
    });
}
@end

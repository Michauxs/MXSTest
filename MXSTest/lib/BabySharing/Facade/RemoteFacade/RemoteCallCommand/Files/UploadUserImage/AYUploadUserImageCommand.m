//
//  AYUploaduserImageCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUploadUserImageCommand.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"

#import <objc/runtime.h>
#import "AYRemoteCallDefines.h"

@implementation AYUploadUserImageCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"upload user image to server: %@", args);

    NSString* photo = [args objectForKey:@"image"];
    UIImage *image = [args objectForKey:@"upload_image"];
    
    [self beforeAsyncCall];
    
    dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
    dispatch_async(post_queue, ^(void){
		
        [RemoteInstance uploadPicture:image withName:photo toUrl:[NSURL URLWithString:self.route] callBack:^(BOOL successs, NSString *message) {
            if (successs) {
                NSLog(@"post image success");
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES, nil);
                    [self endAsyncCall];
                });

            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO, nil);
                    [self endAsyncCall];
                });
            }
        }];
    });
}


@end

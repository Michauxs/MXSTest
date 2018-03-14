//
//  AYUploadFileCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/21/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUploadFileCommand.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"

@implementation AYUploadFileCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"download user image to server: %@", args);
    
    NSURL* url = [args objectForKey:@"url"];
    
    dispatch_queue_t post_queue = dispatch_queue_create("post file queue", nil);
    dispatch_async(post_queue, ^(void) {
        NSString* fullpath = [url path];
        NSString* filename = [fullpath lastPathComponent];
        if ([[NSFileManager defaultManager]fileExistsAtPath:fullpath]) {
            NSLog(@"existing");
        }
        [RemoteInstance uploadFile:fullpath withName:filename toUrl:[NSURL URLWithString:self.route] callBack:^(BOOL successs, NSString *message) {
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:message forKey:@"message"];
            block(successs, [dic copy]);
        }];
    });
}
@end

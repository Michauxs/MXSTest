//
//  AYSaveImgLocalCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSaveImgLocalCommand.h"
#import "TmpFileStorageModel.h"
#import "AYCommandDefines.h"

@implementation AYSaveImgLocalCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    UIImage* image = [dic objectForKey:@"image"];
    NSString* img_name = [dic objectForKey:@"img_name"];
    [TmpFileStorageModel saveToTmpDirWithImage:image withName:img_name];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end

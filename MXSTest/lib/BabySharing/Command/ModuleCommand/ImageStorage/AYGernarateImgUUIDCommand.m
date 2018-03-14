//
//  AYGernarateImgUUIDCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYGernarateImgUUIDCommand.h"
#import "TmpFileStorageModel.h"
#import "AYCommandDefines.h"

@implementation AYGernarateImgUUIDCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    *obj = [TmpFileStorageModel generateFileName];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end

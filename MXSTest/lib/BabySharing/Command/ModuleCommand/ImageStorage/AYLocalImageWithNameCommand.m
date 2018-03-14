//
//  AYLocalImageWithNameCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLocalImageWithNameCommand.h"
#import "TmpFileStorageModel.h"
#import "AYCommandDefines.h"

@implementation AYLocalImageWithNameCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
//    NSString* name = [((NSDictionary*)*obj) objectForKey:@"photo"];
    *obj = [TmpFileStorageModel enumImageWithName:(NSDictionary*)*obj withDownLoadFinishBolck:nil];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end

//
//  AYAppInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAppInitCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYControllerBase.h"

@implementation AYAppInitCommand

@synthesize para = _para;

- (void)postPerform {

}

- (void)performWithResult:(NSObject**)obj {
    [self postPerform];
    NSString* desController = [self.para objectForKey:@"controller"];
    if (desController != nil) {
        id<AYCommand> cmd = CONTROLLER(@"DefaultController", desController);
        NSLog(@"cmd is : %@", cmd);
        
        *obj = cmd;
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeInit;
}
@end
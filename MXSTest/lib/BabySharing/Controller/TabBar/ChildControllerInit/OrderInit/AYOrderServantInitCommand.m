//
//  AYOrderInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 11/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderServantInitCommand.h"
#import "AYCommandDefines.h"
#import "AYNavigationController.h"
#import "AYViewController.h"
#import "AYFactoryManager.h"
#import "AppDelegate.h"

@implementation AYOrderServantInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
	
    UIViewController* controller = CONTROLLER(@"DefaultController", @"OrderServant");
	
    AYNavigationController * rootContorller = CONTROLLER(@"DefaultController", @"Navigation");
    [rootContorller pushViewController:controller animated:NO];
    [rootContorller setNavigationBarHidden:YES animated:NO];
	
    *obj = rootContorller;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end

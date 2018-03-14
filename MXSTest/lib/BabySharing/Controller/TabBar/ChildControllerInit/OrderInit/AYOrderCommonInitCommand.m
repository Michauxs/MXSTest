//
//  AYOrderCommonInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 10/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderCommonInitCommand.h"
#import "AYCommandDefines.h"
#import "AYNavigationController.h"
#import "AYViewController.h"
#import "AYFactoryManager.h"
#import "AppDelegate.h"

@implementation AYOrderCommonInitCommand
@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
	UIViewController* controller = CONTROLLER(@"DefaultController", @"OrderCommon");
	
	AYNavigationController * rootContorller = CONTROLLER(@"DefaultController", @"Navigation");
	[rootContorller pushViewController:controller animated:NO];
	[rootContorller setNavigationBarHidden:YES animated:NO];
	
	*obj = rootContorller;
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}
@end

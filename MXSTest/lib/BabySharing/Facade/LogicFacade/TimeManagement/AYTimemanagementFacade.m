//
//  AYTimemanagementFacade.m
//  BabySharing
//
//  Created by BM on 15/02/2017.
//  Copyright © 2017 Alfred Yang. All rights reserved.
//

#import "AYTimemanagementFacade.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"

@implementation AYTimemanagementFacade

@synthesize para = _para;
@synthesize commands = _commands;
@synthesize observer = _observer;

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryFacade;
}

- (void)postPerform {
    
}

@end

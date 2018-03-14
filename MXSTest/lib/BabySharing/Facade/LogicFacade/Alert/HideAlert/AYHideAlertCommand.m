//
//  AYHideAlertCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 13/10/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHideAlertCommand.h"
#import "AYAlertFacade.h"
#import "AYFactoryManager.h"

@implementation AYHideAlertCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYAlertFacade* alert_facade = FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"Alert");
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:@"HideBtmAlert:" forKey:kAYNotifyFunctionKey];
    [alert_facade performWithResult:&notify];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

@end

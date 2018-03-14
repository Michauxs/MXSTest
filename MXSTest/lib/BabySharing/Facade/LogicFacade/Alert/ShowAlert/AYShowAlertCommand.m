//
//  AYShowAlertCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 13/10/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShowAlertCommand.h"
#import "AYAlertFacade.h"
#import "AYFactoryManager.h"

@implementation AYShowAlertCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYAlertFacade* alert_facade = FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"Alert");
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:@"ShowBtmAlert:" forKey:kAYNotifyFunctionKey];
    [notify setValue:[((NSDictionary*)*obj) copy] forKey:kAYNotifyArgsKey];
    
    [alert_facade performWithResult:&notify];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

@end

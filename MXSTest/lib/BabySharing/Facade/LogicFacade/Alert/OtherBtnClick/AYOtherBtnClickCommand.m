//
//  AYOtherBtnClickCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 13/10/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOtherBtnClickCommand.h"
#import "AYAlertFacade.h"
#import "AYFactoryManager.h"

@implementation AYOtherBtnClickCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYAlertFacade* alert_facade = FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"Alert");
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:@"BtmAlertOtherBtnClick" forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [alert_facade performWithResult:&notify];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end

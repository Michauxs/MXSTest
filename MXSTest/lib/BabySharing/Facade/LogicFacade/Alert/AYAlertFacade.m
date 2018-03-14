//
//  AYAlertFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 12/10/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAlertFacade.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"

@implementation AYAlertFacade

@synthesize para = _para;
@synthesize commands = _commands;
@synthesize observer = _observer;

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryFacade;
}

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
    NSDictionary *notify_dic = ((NSDictionary*)*obj);
    NSDictionary *args = [notify_dic objectForKey:kAYNotifyArgsKey];
    
    UIViewController* cur = [Tools activityViewController];
    SEL sel = NSSelectorFromString([notify_dic objectForKey:kAYNotifyFunctionKey]);
    Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
    if (m) {
        id (*func)(id, SEL, id) = (id(*)(id, SEL, id))method_getImplementation(m);
        func(cur, sel, args);
    }
    
}

- (void)dealloc {
    
}

@end

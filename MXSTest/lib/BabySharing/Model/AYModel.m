//
//  AYModel.m
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYModel.h"
#import "AYCommandDefines.h"
#import "AYNotifyDefines.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation AYModel

@synthesize para = _para;

@synthesize commands = _commands;
@synthesize facades = _facades;

- (NSString*)getControllerName {
    //    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"Landing"] stringByAppendingString:kAYFactoryManagerControllersuffix];
    return NSStringFromClass([self class]);
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryModel;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
    NSDictionary* facades = [_para objectForKey:@"facades"];
    for (id<AYFacadeBase> cmd in facades.allValues) {
        [cmd postPerform];
    }
    
    NSLog(@"commands are : %@", self.commands);
    NSLog(@"facades are : %@", self.facades);
}

/**
 * 巨大的表驱动
 */
@end

//
//  AYPreCreateControllerFactoy.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPreCreateControllerFactoy.h"
#import "AYCommandDefines.h"
#import "AYCommand.h"
#import "AYControllerBase.h"
#import "AYNotifyDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "AYFactoryParaNode.h"

@implementation AYPreCreateControllerFactoy {
    id<AYCommand> preController;
}
@synthesize para = _para;
+ (id)factoryInstance {
        static AYPreCreateControllerFactoy* instance = nil;
        if (instance == nil) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                instance = [[self alloc]init];
            });
        }
        return instance;
//    return [[self alloc]init];
}

- (id)createInstance {
    NSLog(@"para is : %@", _para);
    
    if (preController) {
        return preController;
    }
    
    NSDictionary* cmds = [_para objectForKey:@"commands"];
    NSDictionary* facades = [_para objectForKey:@"facades"];
    NSDictionary* views = [_para objectForKey:@"views"];
    NSDictionary* delegates = [_para objectForKey:@"delegates"];
    
    id<AYControllerBase> controller = nil;
    NSString* desController = [self.para objectForKey:@"controller"];
    Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desController] stringByAppendingString:kAYFactoryManagerControllersuffix]);
    if (c == nil) {
        @throw [NSException exceptionWithName:@"error" reason:@"perform init command error" userInfo:nil];
    } else {
        controller = [[c alloc]init];
        
        if (cmds) {
            controller.commands = cmds;
        }
        
        if (facades)
            controller.facades = facades;
       
        if (views) {
            controller.views = views;
        }

        if (delegates) {
            controller.delegates = delegates;
        }

    }
    
    for (id<AYCommand> facade in facades.allValues) {
        NSMutableDictionary* reg = [[NSMutableDictionary alloc]init];
        [reg setValue:kAYNotifyActionKeyReceive forKey:kAYNotifyActionKey];
        [reg setValue:kAYNotifyFunctionKeyRegister forKey:kAYNotifyFunctionKey];
        
        NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
        [args setValue:controller forKey:kAYNotifyControllerKey];
        
        [reg setValue:[args copy] forKey:kAYNotifyArgsKey];
        
        [facade performWithResult:&reg];
    }
    
    BOOL bm = ((NSNumber*)[_para objectForKey:@"model"]).boolValue;
    if (bm) {
        AYModel* m = MODEL;
        NSMutableDictionary* reg = [[NSMutableDictionary alloc]init];
        [reg setValue:kAYNotifyActionKeyReceive forKey:kAYNotifyActionKey];
        [reg setValue:kAYNotifyFunctionKeyRegister forKey:kAYNotifyFunctionKey];
        
        NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
        [args setValue:controller forKey:kAYNotifyControllerKey];
        
        [reg setValue:[args copy] forKey:kAYNotifyArgsKey];
        
        [m performWithResult:&reg];
    }
    
    [controller postPerform];
    return controller;
}
@end

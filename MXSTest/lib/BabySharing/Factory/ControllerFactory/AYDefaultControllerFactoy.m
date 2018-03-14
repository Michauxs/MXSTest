//
//  AYDefaultControllerFactoy.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYDefaultControllerFactoy.h"
#import "AYCommandDefines.h"
#import "AYCommand.h"
#import "AYControllerBase.h"
#import "AYNotifyDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "AYFactoryParaNode.h"

@implementation AYDefaultControllerFactoy

@synthesize para = _para;

+ (id)factoryInstance {
//    static AYDefaultControllerFactoy* instance = nil;
//    if (instance == nil) {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            instance = [[self alloc]init];
//        });
//    }
//    return instance;
    return [[self alloc]init];
}

- (id)createInstance {
    NSLog(@"para is : %@", _para);
//    NSDictionary* cmds = [_para objectForKey:@"commands"];
    NSMutableDictionary* cmds = [[NSMutableDictionary alloc]init];


    NSDictionary* facades = [_para objectForKey:@"facades"];
//    NSDictionary* views = [_para objectForKey:@"views"];
    NSDictionary* views = [[NSMutableDictionary alloc]init];
//    NSDictionary* delegates = [_para objectForKey:@"delegates"];
    NSDictionary* delegates = [[NSMutableDictionary alloc]init];
   
    id<AYControllerBase> controller = nil;
    NSString* desController = [self.para objectForKey:@"controller"];
    Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desController] stringByAppendingString:kAYFactoryManagerControllersuffix]);
    if (c == nil) {
        @throw [NSException exceptionWithName:@"error" reason:@"perform  init command error" userInfo:nil];
    } else {
        controller = [[c alloc]init];
      
        for (AYFactoryParaNode* cmd_node in [_para objectForKey:@"commands"]) {
            id<AYCommand> cmd = COMMAND(cmd_node.type, cmd_node.name);
            [cmds setValue:cmd forKey:cmd_node.name];
            controller.commands = [cmds copy];
        }

		if (facades) {
			controller.facades = facades;
		}
		
        for (AYFactoryParaNode* view_node in [_para objectForKey:@"views"]) {
            id<AYCommand> view = VIEW(view_node.type, view_node.name);
            [views setValue:view forKey:view_node.name];
            controller.views = [views copy];
        }
       
        for (AYFactoryParaNode* delegate_node in [_para objectForKey:@"delegates"]) {
            id<AYCommand> delegate = DELEGATE(delegate_node.type, delegate_node.name);
            [delegates setValue:delegate forKey:delegate_node.name];
            controller.delegates = [delegates copy];
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

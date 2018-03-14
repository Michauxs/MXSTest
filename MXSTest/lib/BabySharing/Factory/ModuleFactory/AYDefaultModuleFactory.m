//
//  AYDefaultModuleFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYDefaultModuleFactory.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"

@implementation AYDefaultModuleFactory {
    id<AYCommand> cmd; // = [[NSMutableDictionary alloc]init];
}

@synthesize para = _para;

+ (id)factoryInstance {
//    static AYDefaultModuleFactory* instance = nil;
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
    
    if (cmd == nil) {
    
        NSString* desCmd = [self.para objectForKey:@"name"];
        id<AYCommand> result = nil;
        
//        NSDictionary* cmds = [_para objectForKey:@"commands"];
//        for (id<AYCommand> subcmd in cmds.allValues) {
//            [subcmd postPerform];
//        }
        
        NSLog(@"%@ is creating", desCmd);
        
        Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desCmd] stringByAppendingString:kAYFactoryManagerCatigoryCommand]);
        if (c == nil) {
            @throw [NSException exceptionWithName:@"error" reason:@"perform module command error" userInfo:nil];
        } else {
            result = [[c alloc]init];
//            result.commands = cmds;
            cmd = result;
        }
    }
    return cmd;
//    return result;
}
@end

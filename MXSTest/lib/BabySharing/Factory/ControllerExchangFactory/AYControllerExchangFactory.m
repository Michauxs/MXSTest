//
//  AYControllerExchangFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYControllerExchangFactory.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"

// Controller 只能在主线程中，所以全部假单例
@implementation AYControllerExchangFactory {
    id<AYCommand> cmd; // = [[NSMutableDictionary alloc]init];
}

@synthesize para = _para;

+ (id)factoryInstance {
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
            @throw [NSException exceptionWithName:@"error" reason:@"perform  controller exchange command error" userInfo:nil];
        } else {
            result = [[c alloc]init];
            //            result.commands = cmds;
            cmd = result;
        }
    }
    return cmd;
}
@end

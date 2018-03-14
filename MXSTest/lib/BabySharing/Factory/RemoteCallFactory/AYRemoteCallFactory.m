//
//  AYRemoteCallFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/27/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRemoteCallFactory.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYFactoryManager.h"

@implementation AYRemoteCallFactory {
    id<AYCommand> cmd;
}

@synthesize para = _para;

+ (id)factoryInstance {
    return [[self alloc]init];
}

- (id)createInstance {
    NSLog(@"para is : %@", _para);
    
    if (cmd == nil) {

        NSString* desCmd = [self.para objectForKey:@"name"];
        NSString* path = [self.para objectForKey:@"route"];
        
        AYRemoteCallCommand* result = nil;
        NSLog(@"%@ is creating", desCmd);
        
        Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desCmd] stringByAppendingString:kAYFactoryManagerCatigoryCommand]);
        if (c == nil) {
            @throw [NSException exceptionWithName:@"error" reason:@"perform  init command error" userInfo:nil];
        } else {
            result = [[c alloc]init];
            result.route = [HOST stringByAppendingString:path];
            cmd = result;
        }
    }
    return cmd;
}
@end

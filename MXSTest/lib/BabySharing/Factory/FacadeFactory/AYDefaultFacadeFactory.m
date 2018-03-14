//
//  AYDefaultFacadeFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYDefaultFacadeFactory.h"
#import "AYFacadeBase.h"
#import "AYCommandDefines.h"

@implementation AYDefaultFacadeFactory {
    id<AYFacadeBase> facade; // = [[NSMutableDictionary alloc]init];
}

@synthesize para = _para;

+ (id)factoryInstance {
    return [[self alloc]init];
}

- (id)createInstance {
    NSLog(@"para is : %@", _para);
  
    if (facade == nil) {
    
        NSString* desFacade = [self.para objectForKey:@"facade"];
        id<AYFacadeBase> result = nil;
        
        Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desFacade] stringByAppendingString:kAYFactoryManagerFacadesuffix]);
        if (c == nil) {
            @throw [NSException exceptionWithName:@"error" reason:@"perform  init command error" userInfo:nil];
        } else {
            result = [[c alloc]init];
            facade = result;
        }
        
        NSDictionary* cmds = [_para objectForKey:@"commands"];
        result.commands = cmds;
		
		[facade postPerform];
    }
    
    return facade;
}
@end

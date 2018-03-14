//
//  AYModelFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYModelFactory.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYModel.h"

@implementation AYModelFactory {
    AYModel* m;
}
@synthesize para = _para;

+ (id)factoryInstance {
    static AYModelFactory* instance = nil;
    if (instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[self alloc]init];
        });
    }
    return instance;
}

- (id)createInstance {
    NSLog(@"para is : %@", _para);
    
    if (m == nil) {
        NSDictionary* cmds = [_para objectForKey:@"commands"];
        NSDictionary* facades = [_para objectForKey:@"facades"];
        
        m = [[AYModel alloc]init];
        if (cmds)
           m.commands = cmds;
            
        if (facades)
           m.facades = facades;
    }
    return m;
}
@end

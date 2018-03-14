//
//  AYNibViewFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYReuseViewFactory.h"
//#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYViewBase.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import <UIKit/UIKit.h>

@implementation AYReuseViewFactory {
    id<AYViewBase> baseView;
}
@synthesize para = _para;

+ (id)factoryInstance {
//    static AYReuseViewFactory* instance = nil;
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
    
    if (baseView != nil) {
        return baseView;
    }
    
    NSString* desFacade = [self.para objectForKey:@"view"];
    id<AYViewBase> result = nil;

//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:[[kAYFactoryManagerControllerPrefix stringByAppendingString:desFacade] stringByAppendingString:kAYFactoryManagerViewsuffix] owner:self options:nil];
//    result = [nib objectAtIndex:0];
//    [result postPerform];

    Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desFacade] stringByAppendingString:kAYFactoryManagerViewsuffix]);
    if (c == nil) {
        @throw [NSException exceptionWithName:@"error" reason:@"perform  init command error" userInfo:nil];
    } else {
        result = [[c alloc]init];
        [result postPerform];
    }
    
    NSDictionary* cmds = [_para objectForKey:@"commands"];
    NSMutableDictionary* commands = [[NSMutableDictionary alloc]initWithCapacity:cmds.count];
    for (NSString* cmd in cmds) {
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = result;
        c.method_name = cmd;
        c.need_args = [cmd containsString:@":"];
        [commands setObject:c forKey:cmd];
    }
    
    NSDictionary* notifies = [_para objectForKey:@"notifies"];
    NSMutableDictionary* ntf = [[NSMutableDictionary alloc]initWithCapacity:notifies.count];
    for (NSString* notify in notifies) {
        AYViewNotifyCommand* n = [[AYViewNotifyCommand alloc]init];
        n.view = result;
        n.method_name = notify;
        n.need_args = [notify containsString:@":"];
        [ntf setObject:n forKey:notify];
    }
    result.commands = [commands copy];
    result.notifies = [ntf copy];
    
    baseView = result;
    return result;
}
@end

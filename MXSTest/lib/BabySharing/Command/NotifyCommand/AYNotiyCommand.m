//
//  AYNotiyCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYNotiyCommand.h"
#import <objc/runtime.h>
#import "AYControllerBase.h"
#import "AYCommandDefines.h"

@implementation AYNotiyCommand
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize method_name = _method_name;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    if ([self checkForArgs]) {
        NSLog(@"view : %@ and target : %@", _controller, _method_name);
        
        SEL sel = NSSelectorFromString(_method_name);
        Method m = class_getInstanceMethod([((UIViewController*)_controller) class], sel);
        if (m) {
            id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
            id result = func(_controller, sel, *obj);
            if (obj != nil) {
                *obj = result;
            }
        }
    }
}

- (BOOL)checkForArgs {
    return _controller != nil && _method_name != nil;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeNotify;
}
@end

//
//  AYViewNotifyCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYViewNotifyCommand.h"
#import "AYCommandDefines.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import "AYViewController.h"

@implementation AYViewNotifyCommand
@synthesize para = _para;
@synthesize view = _view;
@synthesize method_name = _method_name;
@synthesize need_args = _need_args;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    if ([self checkForArgs]) {
        NSLog(@"view : %@ and target : %@", _view, _method_name);
        
        SEL sel = NSSelectorFromString(_method_name);
        AYViewController* controller = (AYViewController*)_view.controller;
        Method m = class_getInstanceMethod([controller class], sel);
        
        id result = nil;
        if (_need_args) {
            id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
            result = func(controller, sel, *obj);
        } else {
            id (*func)(id, SEL) = (id (*)(id, SEL))method_getImplementation(m);
            result = func(controller, sel);
        }
        
        if (obj != nil) {
            *obj = result;
        }
    }
}

- (BOOL)checkForArgs {
    return _view != nil && _method_name != nil;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeView;
}
@end

//
//  AYLogicFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFacade.h"
#import "AYCommandDefines.h"
#import <objc/runtime.h>
#import "AYNotifyDefines.h"

@interface AYWeakPointNode : NSObject
@property (nonatomic, weak) id<AYCommand> target;
@end

@implementation AYWeakPointNode
@synthesize target = _target;
@end

@implementation AYFacade

@synthesize para = _para;
@synthesize commands = _commands;
@synthesize observer = _observer;

- (id)init {
    self = [super init];
    if (self) {
        _observer = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSString*)getFacadeType {
    return kAYFactoryManagerCatigoryFacade;
}

- (NSString*)getFacadeName {
    return NSStringFromClass([self class]);
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryFacade;
}

- (void)postPerform {
    for (id<AYCommand> cmd in self.commands.allValues) {
        [cmd postPerform];
    }
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    if (obj == nil) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"you should have args" userInfo:nil];
    }
    
    NSDictionary* dic = ((NSDictionary*)*obj);
    
    if ([[dic objectForKey:kAYNotifyActionKey] isEqualToString:kAYNotifyActionKeyReceive]) {
        NSDictionary* args = [dic objectForKey:kAYNotifyArgsKey];
        NSString* message_name = [dic objectForKey:kAYNotifyFunctionKey];
        
        id result = nil;
        [self receiveMessage:message_name andArgs:args withResult:&result];
        *obj = result;
    }
    else {
        NSString* notify_name = [dic objectForKey:kAYNotifyFunctionKey];
//        NSString* notify_target = [dic objectForKey:kAYNotifyTargetKey];
        NSDictionary* notify_arg = [dic objectForKey:kAYNotifyArgsKey];
        
        [self sendNotification:notify_name withArgs:notify_arg];
    }
}

/**
 * 巨大的表驱动
 */
- (void)receiveMessage:(NSString*)message_name andArgs:(NSDictionary*)args withResult:(id*)obj {
    if ([message_name isEqualToString:kAYNotifyFunctionKeyRegister]) {
//        [_observer addObject:[args objectForKey:kAYNotifyControllerKey]];
        AYWeakPointNode* node = [[AYWeakPointNode alloc]init];
        node.target = [args objectForKey:kAYNotifyControllerKey];
        [_observer addObject:node];
        NSLog(@"observers are : %@", _observer);
        
    } else if ([message_name isEqualToString:kAYNotifyFunctionKeyUnregister]) {
//        [_observer removeObject:[args objectForKey:kAYNotifyControllerKey]];
//        id note;
//        for (AYWeakPointNode * node in [_observer copy]) {
//            id<AYCommand> controller = node.target;
//            if (controller == [args objectForKey:kAYNotifyControllerKey]) {
//                note = controller;
//            }
//        }
//        [_observer removeObject:note];
        
        NSLog(@"observers are : %@", _observer);
    }

    [self cleanObserverNode];
}

- (void)sendNotification:(NSString*)message_name withArgs:(NSDictionary*)args {

    for (AYWeakPointNode * node in [_observer copy]) {
        id<AYCommand> controller = node.target;
        if (controller) {
            SEL sel = NSSelectorFromString(message_name);
            Method m = class_getInstanceMethod([controller class], sel);
            if (m) {
                id (*func)(id, SEL, id) = (id(*)(id, SEL, id))method_getImplementation(m);
                func(controller, sel, args);
            }
        }
    }
	
//	id controller = [Tools activityViewController];
//	SEL sel = NSSelectorFromString(message_name);
//	Method m = class_getInstanceMethod([controller class], sel);
//	if (m) {
//		id (*func)(id, SEL, id) = (id(*)(id, SEL, id))method_getImplementation(m);
//		func(controller, sel, args);
//	}
	
    [self cleanObserverNode];
}

- (void)cleanObserverNode {
    NSPredicate* p = [NSPredicate predicateWithFormat:@"target!=nil"];
    _observer = [[_observer filteredArrayUsingPredicate:p] mutableCopy];
    NSLog(@"observers are : %@", _observer);
}
@end

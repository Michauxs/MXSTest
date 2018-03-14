//
//  AYButtonView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/13/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYButtonView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"

@implementation AYButtonView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- commands
- (void)touchUpInside {
    id<AYCommand> cmd = [self.notifies objectForKey:@"touchUpInside"];
    [cmd performWithResult:nil];
}
@end

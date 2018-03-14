//
//  AYFakeStatusBarView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/17/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFakeStatusBarView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"

@implementation AYFakeStatusBarView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    self.backgroundColor = [UIColor colorWithRED:250 GREEN:250 BLUE:250 ALPHA:1];
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
- (id)setStatusBarColor:(id)obj {
    self.backgroundColor = (UIColor*)obj;
    return nil;
}
@end

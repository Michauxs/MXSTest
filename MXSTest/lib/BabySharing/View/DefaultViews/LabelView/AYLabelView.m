//
//  AYLabelView.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLabelView.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"

@implementation AYLabelView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    
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
- (id)changeLabelText:(id)args {
    NSString* str = (NSString*)args;
    self.text = str;
    [self sizeToFit];
    return nil;
}
@end

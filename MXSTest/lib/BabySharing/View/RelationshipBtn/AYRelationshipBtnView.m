//
//  AYRelationshipBtnView.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRelationshipBtnView.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "PhotoTagEnumDefines.h"

@implementation AYRelationshipBtnView

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    [self addTarget:self action:@selector(selfClicked) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark -- messages
- (void)selfClicked {
    @throw [[NSException alloc]initWithName:@"error" reason:@"cannot call base view" userInfo:nil];
}
@end

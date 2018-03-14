//
//  AYWebView.m
//  BabySharing
//
//  Created by Alfred Yang on 14/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYWebView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"

@implementation AYWebView
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

#pragma mark -- life cycle
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

#pragma mark -- view commands
- (id)registerDelegate:(id)obj {
    self.delegate = (id<UIWebViewDelegate>)obj;
    return nil;
}
@end

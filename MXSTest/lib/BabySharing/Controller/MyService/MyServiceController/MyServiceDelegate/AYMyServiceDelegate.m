//
//  AYCollectServDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 8/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMyServiceDelegate.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"
#import "Notifications.h"
#import "AYModelFacade.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

@implementation AYMyServiceDelegate{
    NSArray* querydata;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}
- (id)changeQueryData:(id)array{
    querydata = (NSArray*)array;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"MyServiceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    id tmp = [querydata objectAtIndex:indexPath.row];
    kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HOMECOMMONCELLHEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
//    
//    NSDictionary* info = nil;
//    CURRENUSER(info)
//    
//    id<AYCommand> des = DEFAULTCONTROLLER(@"MainInfo");;
//    
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
//    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd_show_module = PUSH;
//    [cmd_show_module performWithResult:&dic];
}

@end

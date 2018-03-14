//
//  AYFutureOrderDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 25/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFutureOrderDelegate.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@implementation AYFutureOrderDelegate{
    NSArray *querydata;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

#pragma mark -- commands
- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (id)changeQueryData:(id)array{
    querydata = (NSArray*)array;
    return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return querydata.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    
    id tmp = [querydata objectAtIndex:indexPath.section];
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    [cmd performWithResult:&tmp];
    
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 285;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tmp = [querydata objectAtIndex:indexPath.section];
    NSLog(@"%ld",(long)indexPath.section);
    NSLog(@"%@",tmp);
    NSNumber *is_read = (NSNumber*)[tmp objectForKey:@"is_read"];
    if (is_read.intValue == 0) {
        NSString *order_id = [tmp objectForKey:@"order_id"];
        NSMutableDictionary *dic_update = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic_update setValue:[NSNumber numberWithInt:1] forKey:@"is_read"];
        [dic_update setValue:order_id forKey:@"order_id"];
        [dic_update setValue:indexPath forKey:@"index_path"];
        
        id<AYCommand> cmd = [self.notifies objectForKey:@"updateReadState:"];
        [cmd performWithResult:&dic_update];
    }
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"ReadyOrder");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
}

@end

//
//  AYFutureOrderDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 25/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFutureOrderSerDelegate.h"
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

@implementation AYFutureOrderSerDelegate{
    NSArray *querydata_paid;
    NSArray *querydata_confirm;
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

- (id)changeQueryData:(id)args {
    NSDictionary *tmp = (NSDictionary*)args;
    
    querydata_paid = [tmp objectForKey:@"paid"];
    querydata_confirm = [tmp objectForKey:@"confirm"];
    
    return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return querydata_confirm.count == 0 ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return querydata_paid.count == 0 ? 1 : querydata_paid.count;
    } else
        return querydata_confirm.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name;
    id<AYViewBase> cell;
    if (querydata_paid.count == 0) {
        if (indexPath.section == 0) {
            
            class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NoOrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
            cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        }
        else {
            class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SerOrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
            cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
            
            id tmp = [querydata_confirm objectAtIndex:indexPath.row];
            id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
            [cmd performWithResult:&tmp];
        }
        
    } else {
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SerOrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id tmp = indexPath.section == 0 ? [querydata_paid objectAtIndex:indexPath.row] : [querydata_confirm objectAtIndex:indexPath.row];
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [cmd performWithResult:&tmp];
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    header.backgroundColor = [Tools whiteColor];
    NSString *titleStr = section == 0 ? @"待处理" : @"已确认";
    UILabel *title = [Tools creatLabelWithText:titleStr textColor:[Tools black] fontSize:17.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [header addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header).offset(10);
        make.left.equalTo(header).offset(15);
    }];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 5 : 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (querydata_paid.count == 0 && indexPath.section == 0) {
        return ;
    }
    
    NSDictionary *tmp = indexPath.section == 0 ? [querydata_paid objectAtIndex:indexPath.row] : [querydata_confirm objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        
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

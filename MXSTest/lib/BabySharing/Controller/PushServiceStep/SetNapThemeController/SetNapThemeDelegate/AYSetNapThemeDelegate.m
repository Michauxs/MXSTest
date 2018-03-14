//
//  AYSetNapCostDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 23/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapThemeDelegate.h"
#import "AYModelFacade.h"
#import "AYProfileOrigCellView.h"
#import "AYProfileServCellView.h"

@implementation AYSetNapThemeDelegate {
    NSArray *options_title_cans;
    NSDictionary* querydata;
    BOOL isCanSet;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    options_title_cans = kAY_service_options_title_course;
    isCanSet = NO;
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

- (id)queryData:(NSDictionary*)args {
    querydata = args;
    NSInteger notePow = ((NSNumber*)[querydata objectForKey:@"cans"]).integerValue;
    isCanSet = notePow != 1 && notePow != 0;
    return nil;
}

- (id)changeEditMode:(NSNumber*)args {
    isCanSet = args.boolValue;
    return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else
        return options_title_cans.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetNapThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    cell.controller = _controller;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if (indexPath.section == 0) {
        [dic setValue:[options_title_cans objectAtIndex:0] forKey:@"title"];
        [dic setValue:[querydata objectForKey:@"cans"] forKey:@"cans"];
        [dic setValue:[NSNumber numberWithInteger:0] forKey:@"index"];
    }
    else {
        if (indexPath.row == options_title_cans.count - 1) {
            NSString *allowLeaveStr = @"服务期间需要家长陪伴";
            [dic setValue:allowLeaveStr forKey:@"title"];
            [dic setValue:[querydata objectForKey:@"allow_leave"] forKey:@"allow_leave"];
            [dic setValue:[NSNumber numberWithBool:isCanSet] forKey:@"is_can_set"];
            
        } else {
            [dic setValue:[options_title_cans objectAtIndex:indexPath.row + 1] forKey:@"title"];
            [dic setValue:[querydata objectForKey:@"cans"] forKey:@"cans"];
            [dic setValue:[NSNumber numberWithInteger:indexPath.row + 1] forKey:@"index"];
        }
        
    }
    
    id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
    [set_cmd performWithResult:&dic];
    
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20.f;
    } else
        return 0.001f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *marginView = [[UIView alloc]init];
    marginView.backgroundColor = [Tools garyBackgroundColor];
    return marginView;
}

@end

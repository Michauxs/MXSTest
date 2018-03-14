//
//  AYFacilityDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 1/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFacilityDelegate.h"
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

@implementation AYFacilityDelegate {
    NSArray *querydata;
    NSArray *options_title_facility;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    options_title_facility = kAY_service_options_title_facilities;
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

- (id)changeQueryData:(NSNumber*)args{
    
    long options = args.longValue;
    NSMutableArray *tmp = [NSMutableArray array];
    
    for (int i = 0; i < options_title_facility.count; ++i) {
        long note_pow = pow(2, i);
        if ((options & note_pow)) {
            NSMutableDictionary *dic_index = [[NSMutableDictionary alloc]init];
            [dic_index setValue:[options_title_facility objectAtIndex:i] forKey:@"title"];
            [dic_index setValue:[NSNumber numberWithInteger:i] forKey:@"icon_fix"];
            [tmp addObject:dic_index];
        }
    }
    querydata = [tmp copy];
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return querydata.count;
    return querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"FacilityCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = VIEW(@"FacilityCell", @"FacilityCell");
    }
    cell.controller = self.controller;
    
    NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
    id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
    [cmd performWithResult:&tmp];
    
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

@end

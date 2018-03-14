//
//  AYReadyOrderDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYReadyOrderDelegate.h"
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

@implementation AYReadyOrderDelegate {
    NSDictionary *querydata;
    
    BOOL isExpend;
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

- (id)changeQueryData:(NSDictionary*)info{
    querydata = info;
    
    return nil;
}

- (id)TransfromExpend {
    isExpend = !isExpend;
    return nil;
}

#pragma mark -- table
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    NSNumber *status = [querydata objectForKey:@"status"];
//    if (status.intValue == 0) {
//        return 4;
//    }else return 5;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell;
    if (indexPath.row == 0) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        [tmp setValue:[querydata objectForKey:@"service"] forKey:@"service"];
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [cmd performWithResult:&tmp];
        
    } else if (indexPath.row == 1) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
//        NSString *tmp = [[querydata objectForKey:@"service"] objectForKey:@"owner_id"];
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        NSDictionary *tmp = [querydata copy];
        [cmd performWithResult:&tmp];
        
    } else if (indexPath.row == 2) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderDateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        NSDictionary *tmp = [querydata copy];
        [cmd performWithResult:&tmp];
        
    } else if (indexPath.row == 3) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        NSDictionary *tmp = [querydata copy];
        [cmd performWithResult:&tmp];
        
    } else if (indexPath.row == 4) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PayWayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
    } else if (indexPath.row == 5) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderStateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
    } else {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderMapCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        id tmp = [[querydata objectForKey:@"service"] copy];
        id<AYCommand> cmd = [cell.commands objectForKey:@"setCellInfo:"];
        [cmd performWithResult:&tmp];
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).clipsToBounds = YES;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderStatus status = ((NSNumber*)[querydata objectForKey:@"status"]).intValue;
    
    if (indexPath.row == 0) {
        return 110.f;
    } else if (indexPath.row == 1) {
        return 92.f;
    } else if (indexPath.row == 2) {
        return 135.f;
    } else if (indexPath.row == 3) {
        
        return isExpend?150.f:90.f;
        
    } else if (indexPath.row == 4) {
        return 100.f;
    } else if (indexPath.row == 5) {
//        int status = ((NSNumber*)[querydata objectForKey:@"status"]).intValue;
//        return status == 0 ? 0.001 : 70.f;
        return 0.001;
        
    } else {
        if (status== OrderStatusDone || status == OrderStatusReject) {
            return 0.001;
        } else
            return 220.f;
    }
}


-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

@end

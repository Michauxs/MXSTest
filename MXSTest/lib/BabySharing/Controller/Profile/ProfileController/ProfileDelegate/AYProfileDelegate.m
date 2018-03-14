//
//  AYProfileDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 6/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYProfileDelegate.h"
#import "AYFactoryManager.h"
#import "Notifications.h"
#import "AYModelFacade.h"

@implementation AYProfileDelegate{
    NSArray *rowTitles;
	NSDictionary* querydata;
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

- (id)changeModel:(NSNumber*)args {
	
    return nil;
}

-(id)changeQueryData:(NSDictionary*)args {
    querydata = args;
    
	NSMutableArray *tmp;
    NSNumber *is_servant = [querydata objectForKey:kAYProfileArgsIsProvider];
	NSNumber *is_nap = [querydata objectForKey:@"is_nap"];
	
	if (is_nap.boolValue) {
		tmp = [NSMutableArray arrayWithObjects:@"切换为预定模式", @"发布服务", @"设置", nil];
	} else {
		tmp = [NSMutableArray arrayWithObjects:@"成为老师", @"我心仪的服务", @"设置", nil];
		if (is_servant.boolValue) {
			[tmp replaceObjectAtIndex:0 withObject:@"切换为服务者模式"];
		}
	}
    
    rowTitles = [tmp copy];
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return rowTitles.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell;
    if (indexPath.row == 0) {
        NSString* class_name = @"AYProfileHeadCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSDictionary *info = [querydata copy];
        kAYViewSendMessage(cell, @"setCellInfo:", &info)
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        return (UITableViewCell*)cell;
        
    } else {
        
        NSString *class_name = @"AYProfileOrigCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSString *title = rowTitles[indexPath.row - 1];
        kAYViewSendMessage(cell, @"setCellInfo:", &title)
    }
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120;
    } else {
        return 80;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.row == 0) {
        [self showPersonalInfo];
        
    } else if(indexPath.row == 1) {
        [self servicerOptions];
        
    } else if (indexPath.row == 2) {
        NSNumber *is_nap = [querydata objectForKey:@"is_nap"];
        is_nap.boolValue ? [self pushNewService] : [self collectService];
        
    } else
        [self appSetting];
    
}

- (void)showPersonalInfo {
    // 个人信息
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalInfo");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)servicerOptions {
    
    NSNumber *model = [querydata objectForKey:kAYProfileArgsIsProvider];
    
    if (model.boolValue) {
        id<AYCommand> cmd = [self.notifies objectForKey:@"sendRegMessage:"];
        NSNumber *args = [NSNumber numberWithInt:1];
        [cmd performWithResult:&args];
        
    } else {
		id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmRealName");
		
        NSNumber *is_has_phone = [querydata objectForKey:kAYProfileArgsIsHasPhone];
        if (!is_has_phone.boolValue ) {
			des = DEFAULTCONTROLLER(@"ConfirmPhoneNo");
        }
		
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//        [dic_push setValue:[NSNumber numberWithInt:1] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
}

- (void)collectService {
    
    AYViewController* des = DEFAULTCONTROLLER(@"CollectServ");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//    [dic_push setValue:[NSNumber numberWithInt:0] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)pushNewService {
	
    id<AYCommand> des = DEFAULTCONTROLLER(@"NapArea");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)appSetting {
    // NSLog(@"setting view controller");
    id<AYCommand> setting = DEFAULTCONTROLLER(@"Setting");
//    setting = DEFAULTCONTROLLER(@"NurseScheduleMain");
//	setting = DEFAULTCONTROLLER(@"NapScheduleMain");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[querydata copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)confirmSNS {
    id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmSNS");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"single" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
}

- (void)confirmPhoneNo {
    id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmPhoneNo");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"single" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)confirmRealName {
    id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmRealName");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"single" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

@end

//
//  AYSetBasicInfoDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 18/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetBasicInfoDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYControllerActionDefines.h"

@implementation AYSetBasicInfoDelegate {
	NSArray *titleArr;
	
	NSDictionary *querydata;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	titleArr = @[@"服务场景图片", @"服务描述", @"服务专业特色"];
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

#pragma marlk -- commands
- (id)changeQueryData:(id)args {
	querydata = args;
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[querydata objectForKey:kAYDefineArgsCellNames] objectAtIndex:indexPath.row];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:[querydata copy]];
	[tmp setValue:[titleArr objectAtIndex:indexPath.row] forKey:@"title"];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	cell.controller = self.controller;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		NSArray *imagesData = [querydata objectForKey:kAYServiceArgsImages];
		NSInteger row = (imagesData.count + 1) / 4;
		if ((imagesData.count + 1) % 4 != 0) {
			row ++;
		}
		return 175 + (row - 1)*78;
	} else if (indexPath.row == 1) {
		return 102;
	} else {
		return 169;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<AYCommand> dest = DEFAULTCONTROLLER(@"ServiceDesc");

	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];

	[dic_push setValue:[querydata objectForKey:kAYServiceArgsDescription] forKey:kAYControllerChangeArgsKey];

	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 1) {
		return YES;
	} else
		return NO;
}

#pragma mark -- notifies set service info



@end

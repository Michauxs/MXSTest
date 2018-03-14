//
//  AYChoiceContentDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYChoiceContentDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYControllerBase.h"
#import "AYControllerActionDefines.h"

@implementation AYChoiceContentDelegate {
	NSArray *sectionTitleArr;
	NSArray *querydata;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	sectionTitleArr = @[@"看顾", @"课程"];
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

- (id)changeQueryData:(id)args {
	querydata = args;
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<AYViewBase> cell;
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeServPerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	cell = [tableView dequeueReusableCellWithIdentifier:class_name];
	
	id tmp = [querydata objectAtIndex:indexPath.row];
	kAYViewSendMessage(cell, kAYCellSetInfoMessage, &tmp)
	
	cell.controller = self.controller;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return HOMECOMMONCELLHEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	
	[dic setValue:[querydata objectAtIndex:indexPath.row] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	CGPoint offset = scrollView.contentOffset;
	if (offset.y <= - 285.f) {
		offset.y = -285.f;
		scrollView.contentOffset = offset;
	}
	
	NSNumber *offset_y = [NSNumber numberWithFloat:scrollView.contentOffset.y];
	kAYDelegateSendNotify(self, @"scrollOffsetYNoyify:", &offset_y)
}

@end

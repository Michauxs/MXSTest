//
//  AYOrderListNewsDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 11/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderListNewsDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

#import "AYNoContentCell.h"

@implementation AYOrderListNewsDelegate {
	NSArray *querydata;
	
//	NSArray *waitArrData;
//	NSArray *estabArrData;
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

- (id)changeQueryData:(id)info {
	querydata = info;
//	waitArrData = [querydata objectForKey:@"wait"];
//	estabArrData = [querydata objectForKey:@"confirm"];
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return querydata.count == 0 ? 1 : querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name;
	id<AYViewBase> cell;
	id tmp ;
	
	if (querydata.count == 0) {
		AYNoContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NONewsCell"];
		if (!cell) {
			cell = [[AYNoContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NONewsCell"];
		}
		cell.titleStr = @"您没有新的动态";
		return cell;
	} else {
		class_name = @"AYOSEstabCellView";
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		
		tmp = [querydata objectAtIndex:indexPath.row];
		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
		cell.controller = self.controller;
		((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
		return (UITableViewCell*)cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 95.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools whiteColor];
	
	NSString *titleStr = @"全部订单";
	UILabel *titleLabel = [Tools creatLabelWithText:titleStr textColor:[Tools black] fontSize:625.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(headView);
		make.left.equalTo(headView).offset(20);
	}];
	[Tools addBtmLineWithMargin:10.f andAlignment:NSTextAlignmentCenter andColor:[Tools garyLineColor] inSuperView:headView];
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderInfoPage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	
	NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return querydata.count != 0;
}

@end

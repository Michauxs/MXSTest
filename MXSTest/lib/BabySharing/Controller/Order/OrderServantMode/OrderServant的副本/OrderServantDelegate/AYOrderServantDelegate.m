//
//  AYOrderServantDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 12/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderServantDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYOrderServantDelegate {
	NSArray *querydata;
	
	NSArray *funcNameArr;
//	NSArray *waitArrData;
//	NSArray *estabArrData;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	funcNameArr = @[@"showLeastOneAppli", @"showHistoryAppli", @"showRemindMessage"];
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
	return nil;
}

#pragma mark -- table
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name ;
	id<AYViewBase> cell ;
	id args;
	if (indexPath.row == 0) {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TodoApplyCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		
	} else if (indexPath.row == 1) {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HistoryEnterCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	} else {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"DayRemindCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		
		
		
	}
	
	kAYViewSendMessage(cell, @"setCellInfo:", &args)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return 110.f;
	} else if (indexPath.row == 1) {
		return 60.f;
	} else {
		return 180.f;
	}
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc] init];
	headView.backgroundColor = [Tools whiteColor];
	
	NSString *titleStr = @"待确认";
	UILabel *titleLabel = [Tools creatUILabelWithText:titleStr andTextColor:[Tools blackColor] andFontSize:625.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(headView);
		make.left.equalTo(headView).offset(20);
	}];
	
	UILabel *countlabel = [Tools creatUILabelWithText:@"0" andTextColor:[Tools whiteColor] andFontSize:313.f andBackgroundColor:[UIColor redColor] andTextAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:countlabel withRadius:10.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[headView addSubview:countlabel];
	[countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel.mas_right).offset(5);
		make.top.equalTo(titleLabel).offset(-2);
		make.size.mas_equalTo(CGSizeMake(20, 20));
	}];
	
	UIButton *readMoreBtn = [Tools creatUIButtonWithTitle:@"查看全部" andTitleColor:[Tools themeColor] andFontSize:15.f andBackgroundColor:nil];
	[headView addSubview:readMoreBtn];
	[readMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(headView).offset(-20);
		make.centerY.equalTo(headView);
		make.size.mas_equalTo(CGSizeMake(70, 30));
	}];
	[readMoreBtn addTarget:self action:@selector(didReadMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *funcName = [funcNameArr objectAtIndex:indexPath.row];
	kAYDelegateSendNotify(self, funcName, nil)
	
//	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderInfoPage");
//	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
//	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//	
//	NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
//	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
//	
//	id<AYCommand> cmd_push = PUSH;
//	[cmd_push performWithResult:&dic];
	
}

#pragma mark -- actions
- (void)didReadMoreBtnClick {
	kAYDelegateSendNotify(self, @"showMoreAppli", nil)
}

@end

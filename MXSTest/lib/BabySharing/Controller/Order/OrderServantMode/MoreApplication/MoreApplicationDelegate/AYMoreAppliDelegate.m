//
//  AYMoreAppliDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYMoreAppliDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYNoContentCell.h"

#define headViewHeight		50

@implementation AYMoreAppliDelegate {
	NSDictionary *querydata;
	NSArray *sectionTitleArr;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	sectionTitleArr = @[@"待处理", @"订单反馈"];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSArray *feedbackArr = [querydata objectForKey:@"feedback"];
	return feedbackArr.count == 0 ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *todoArr = [querydata objectForKey:@"todo"];
	NSArray *feedbackArr = [querydata objectForKey:@"feedback"];
	if (section == 0) {
		return todoArr.count == 0 ? 1 : todoArr.count;
	} else
		return feedbackArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0 && [[querydata objectForKey:@"todo"] count] == 0) {
		AYNoContentCell *no_content_cell = [tableView dequeueReusableCellWithIdentifier:@"NONewsCell"];
		if (!no_content_cell) {
			no_content_cell = [[AYNoContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NONewsCell"];
		}
		no_content_cell.titleStr = @"暂时没有需要处理的订单";
		return no_content_cell;
		
	} else {
		
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TodoApplyCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		id tmp;
		if (indexPath.section == 0) {
			tmp = [[querydata objectForKey:@"todo"] objectAtIndex:indexPath.row];
		} else {
			tmp = [[querydata objectForKey:@"feedback"] objectAtIndex:indexPath.row];
		}
		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
		
		cell.controller = self.controller;
		((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
		return (UITableViewCell*)cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 110.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools whiteColor];
	NSString *titleStr = [sectionTitleArr objectAtIndex:section];
	
	UILabel *titleLabel = [Tools creatLabelWithText:titleStr textColor:[Tools black] fontSize:625.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(headView);
		make.left.equalTo(headView).offset(20);
	}];
	
	[Tools creatCALayerWithFrame:CGRectMake(10, headViewHeight - 0.5, SCREEN_WIDTH - 10*2, 0.5) andColor:[Tools garyLineColor] inSuperView:headView];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return headViewHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderInfoPage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];

	id tmp;
	if (indexPath.section == 0) {
		tmp = [[querydata objectForKey:@"todo"] objectAtIndex:indexPath.row];
	} else
		tmp = [[querydata objectForKey:@"feedback"] objectAtIndex:indexPath.row];
	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];

	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
}

@end

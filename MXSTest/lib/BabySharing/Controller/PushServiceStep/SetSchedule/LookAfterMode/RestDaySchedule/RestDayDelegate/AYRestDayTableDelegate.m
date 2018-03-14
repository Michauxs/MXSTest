//
//  AYRestDayTableDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 3/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYRestDayTableDelegate.h"
#import "AYFactoryManager.h"

@implementation AYRestDayTableDelegate {
	NSArray *querydata;
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

-(id)changeQueryData:(id)args {
	querydata = args;
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return querydata.count == 0 ? 1 : querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NurseScheduleCellWhite"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	cell.controller = _controller;
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	[dic setValue:[NSNumber numberWithBool:(indexPath.row==0)] forKey:@"is_first"];
	if (querydata.count != 0) {
		[dic setValue:[querydata objectAtIndex:indexPath.row] forKey:@"dic_time"];
	}
	[dic setValue:[NSNumber numberWithFloat:indexPath.row] forKey:@"row"];
	
	kAYViewSendMessage(cell, kAYCellSetInfoMessage, &dic)
	
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc] init];
	headView.backgroundColor = [Tools theme];
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"服务时段" textColor:[Tools whiteColor] fontSize:620.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(headView).offset(20);
		make.centerY.equalTo(headView).offset(10);
	}];
	
	//		headView.userInteractionEnabled = NO;
	UIButton *addSignBtn = [[UIButton alloc] init];
	[addSignBtn setImage:IMGRESOURCE(@"add_icon_circle_white") forState:UIControlStateNormal];
	[headView addSubview:addSignBtn];
	[addSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(headView).offset(-20);
		make.centerY.equalTo(titleLabel);
		make.size.mas_equalTo(CGSizeMake(30, 30));
	}];
	
	addSignBtn.hidden = querydata.count == 0;
	[addSignBtn addTarget:self action:@selector(didAddTimeDurationClick) forControlEvents:UIControlEventTouchUpInside];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (querydata.count == 0) {
		kAYDelegateSendNotify(self, @"addTimeDuration", nil)
	} else {
		NSNumber *index= [NSNumber numberWithInteger:indexPath.row];
		kAYDelegateSendNotify(self, @"exchangeTimeDuration:", &index)
	}
	
}

#pragma mark -- actions
- (void)didAddTimeDurationClick {
	NSLog(@"----add");
	
	kAYDelegateSendNotify(self, @"addTimeDuration", nil)
	
}

- (void)didRestDayTap {
	NSLog(@"----tap");
	kAYDelegateSendNotify(self, @"manageRestDaySchedule", nil)
}

@end

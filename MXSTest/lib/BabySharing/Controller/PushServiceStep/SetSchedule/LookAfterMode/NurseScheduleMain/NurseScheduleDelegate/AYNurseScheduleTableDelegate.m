//
//  AYNurseScheduleTableDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 1/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNurseScheduleTableDelegate.h"
#import "AYFactoryManager.h"

@interface AYNurseScheduleTableDelegate ()

@end

@implementation AYNurseScheduleTableDelegate {
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return querydata.count == 0 ? 1 : querydata.count;
	} else {
		return 0;
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NurseScheduleCellTheme"] stringByAppendingString:kAYFactoryManagerViewsuffix];
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
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools whiteColor];
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"1. 每天的服务时段" textColor:[Tools theme] fontSize:20.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(headView).offset(20);
		make.centerY.equalTo(headView).offset(10);
	}];
	
	if (section == 0) {
//		headView.userInteractionEnabled = NO;
		UIButton *addSignBtn = [[UIButton alloc] init];
		[addSignBtn setImage:IMGRESOURCE(@"add_icon_circle") forState:UIControlStateNormal];
		[headView addSubview:addSignBtn];
		[addSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(headView).offset(-20);
			make.centerY.equalTo(titleLabel);
			make.size.mas_equalTo(CGSizeMake(30, 30));
		}];
		addSignBtn.hidden = querydata.count == 0;
		[addSignBtn addTarget:self action:@selector(didAddTimeDurationClick) forControlEvents:UIControlEventTouchUpInside];
		
	} else {
		titleLabel.text = @"2. 您的休息日和特殊时段";
		UIImageView *signView = [[UIImageView alloc] init];
		signView.image = IMGRESOURCE(@"plan_time_icon");
		[signView sizeToFit];
		[headView addSubview:signView];
		[signView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(headView).offset(-25);
			make.centerY.equalTo(titleLabel);
			make.size.mas_equalTo(signView.image.size);
		}];
		
		headView.userInteractionEnabled = YES;
		[headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRestDayTap)]];
	}
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 0) {
		return 30.f;
	} else {
		return 0.001f;
	}
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *footerView = [UIView new];
	footerView.backgroundColor = [Tools whiteColor];
	return footerView;
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

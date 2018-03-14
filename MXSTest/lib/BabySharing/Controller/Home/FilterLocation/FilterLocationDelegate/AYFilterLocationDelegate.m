//
//  AYFilterLocationDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFilterLocationDelegate.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"
#import "Notifications.h"
#import "AYModelFacade.h"
#import "AYProfileOrigCellView.h"
#import "AYProfileServCellView.h"


@implementation AYFilterLocationDelegate {
	NSArray *query_data;
	NSDictionary *dic_location;
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

- (id)changeQueryData:(id)args {
	if ([args isKindOfClass:[NSArray class]]) {
		
		query_data = [NSArray arrayWithArray:args];
	} else if ([args isKindOfClass:[NSDictionary class]]) {
		
		dic_location = args;
	} else if ([args isEqualToString:@"remove"]) {
		
		dic_location = nil;
	}
	return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else {
		return query_data.count;
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"FilterLocationCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name];
	cell.controller = self.controller;
	
	id tmp ;
	if (indexPath.section == 0) {
		tmp = !dic_location ? @"正在定位..." : [dic_location objectForKey:kAYServiceArgsAddress];
	}
	else {
		tmp = [[query_data objectAtIndex:indexPath.row] objectForKey:@""];
	}
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools whiteColor];
	UILabel *titleLabel = [Tools creatLabelWithText:@"" textColor:[Tools garyColor] fontSize:13.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(headView).offset(20);
		make.bottom.equalTo(headView).offset(-15);
	}];
	
	if (section == 0) {
		titleLabel.text = @"定位地址";
		
		UIButton *reLocationBtn = [Tools creatBtnWithTitle:@"重新定位" titleColor:[Tools theme] fontSize:13.f backgroundColor:nil];
		[headView addSubview:reLocationBtn];
		[reLocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(headView).offset(-15);
			make.centerY.equalTo(titleLabel);
			make.size.mas_equalTo(CGSizeMake(75, 25));
		}];
		[reLocationBtn addTarget:self action:@selector(didReLocationBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		UIImageView *locationSign = [[UIImageView alloc]init];
		locationSign.image = IMGRESOURCE(@"position");
		[headView addSubview:locationSign];
		[locationSign mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(reLocationBtn.mas_left).offset(5);
			make.centerY.equalTo(reLocationBtn);
			make.size.mas_equalTo(CGSizeMake(20, 20));
		}];
		
	} else {
		titleLabel.text = @"附近地址";
	}
	
	CALayer *sepLayer = [CALayer layer];
	sepLayer.frame = CGRectMake(0, 79.5, SCREEN_WIDTH, 0.5);
	sepLayer.backgroundColor = [Tools garyLineColor].CGColor;
	[headView.layer addSublayer:sepLayer];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 80.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:@"filterLocation" forKey:@"key"];
	if (indexPath.section == 0) {
		[tmp setValuesForKeysWithDictionary:dic_location];
	}
	else {
		[tmp setValuesForKeysWithDictionary:[query_data objectAtIndex:indexPath.row]];
	}
	
	[dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
	id<AYCommand> cmd_show_module = REVERSMODULE;
	[cmd_show_module performWithResult:&dic];
	
}

#pragma mark -- actions
- (void)didReLocationBtnClick {
	
	kAYDelegateSendNotify(self, @"reLocationAction", nil)
	
}

@end

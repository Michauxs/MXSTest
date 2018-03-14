//
//  AYOrderCommonDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 10/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderCommonDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYNoContentCell.h"
#import "AYOrderTOPView.h"

#define TOPHEIGHT		165


typedef enum : NSUInteger {
	PageToService = 0,
	PageToOrder = 1
} PageTo;

@implementation AYOrderCommonDelegate {
	
	NSArray *querydata;
	
	AYOrderTOPView *TOPView;
	NSArray *feedbackData;
	
	NSTimeInterval nowNode;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	nowNode = [NSDate date].timeIntervalSince1970;
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

- (id)changeQueryFBData:(id)data {
	feedbackData = (NSArray*)data;
	TOPView.userInteractionEnabled = feedbackData.count != 0;
	[TOPView setItemArgs:feedbackData];
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return querydata.count == 0 ? 1 :querydata.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
	if (querydata.count == 0) {
		AYNoContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NONewsCell"];
		if (!cell) {
			cell = [[AYNoContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NONewsCell"];
		}
		cell.titleStr = @"您目前还没有日程记录";
		return cell;
	}
	else {
		
		NSString* class_name ;
		id<AYViewBase> cell ;
		if ([self isTodayRemindWithIndex:indexPath.row]) {
			class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderNewsreelCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
			cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		} else {
			class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OTMHistoryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
			cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		}
		
		NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
		
		cell.controller = self.controller;
		((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
		return (UITableViewCell*)cell;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self isTodayRemindWithIndex:indexPath.row]) {
		return 190.f;
	} else
		return 140.f;
}

- (BOOL)isTodayRemindWithIndex:(NSInteger)index {
	if (querydata.count != 0) {
		
		NSDictionary *index_args = [querydata objectAtIndex:index];
		double start = ((NSNumber*)[index_args objectForKey:kAYServiceArgsStart]).doubleValue * 0.001;
		
		NSDateFormatter *formatter = [Tools creatDateFormatterWithString:nil];
		NSString *startStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:start]];
		NSString *nowStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowNode]];
		//	double end = ((NSNumber*)[index_args objectForKey:kAYServiceArgsEnd]).doubleValue * 0.001;
		return  [startStr isEqualToString:nowStr];
	} else
		return NO;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc] init];
	headView.backgroundColor = [Tools whiteColor];
	
	UIButton *allNewsBtn  = [Tools creatBtnWithTitle:@"全部订单" titleColor:[Tools black] fontSize:14.f backgroundColor:nil];
	[headView addSubview:allNewsBtn];
	[allNewsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(headView.mas_top).offset(22);
		make.right.equalTo(headView).offset(-20);
		make.size.mas_equalTo(CGSizeMake(70, 30));
	}];
	[allNewsBtn addTarget:self action:@selector(didAllNewsBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	TOPView = [[AYOrderTOPView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, TOPHEIGHT) andMode:OrderModeCommon];
	[headView addSubview:TOPView];
	TOPView.userInteractionEnabled = feedbackData.count != 0;
	[TOPView setItemArgs:feedbackData];
	[TOPView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAppliFeedback)]];
	
	NSString *titleStr = @"日程";
	UILabel *titleLabel = [Tools creatLabelWithText:titleStr textColor:[Tools black] fontSize:625.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(headView).offset(-12);
		make.left.equalTo(headView).offset(20);
	}];
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 55.f + 44.f + TOPHEIGHT;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return querydata.count != 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	PageTo to = [self isTodayRemindWithIndex:indexPath.row] ? PageToOrder : PageToService;
	NSDictionary *tmp = @{@"info":[querydata objectAtIndex:indexPath.row], @"type":[NSNumber numberWithInteger:to]};
	kAYViewSendNotify(self, @"didSelectedRow:", &tmp)
}

#pragma mark -- actions
- (void)didAllNewsBtnClick {
	kAYDelegateSendNotify(self, @"showOrderList", nil)
}

- (void)showAppliFeedback {
	kAYDelegateSendNotify(self, @"showFBListOrOne", nil)
}

@end

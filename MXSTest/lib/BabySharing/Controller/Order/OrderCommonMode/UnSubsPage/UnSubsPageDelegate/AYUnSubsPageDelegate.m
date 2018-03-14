//
//  AYUnSubsPageDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 5/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYUnSubsPageDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYUnSubsPageDelegate {
	NSDictionary *querydata;
	NSArray *titleArr;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	titleArr = @[@"我想重新选择时间", @"支付出现问题", @"我不想订了"];
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

- (id)changeQueryData:(NSDictionary*)info {
	querydata = info;
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TitleOptCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	cell.controller = self.controller;
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"row_index"];
	[tmp setValue:[titleArr objectAtIndex:indexPath.row] forKey:@"title"];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc] init];
	headView.backgroundColor = [Tools whiteColor];
	
	NSString *titleStr = @"请选择取消原因：";
	UILabel *titleLabel = [Tools creatLabelWithText:titleStr textColor:[Tools garyColor] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
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
	
}

@end

//
//  AYSetCourseSignDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetCourseSignDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYServiceArgsDefines.h"

@implementation AYSetCourseSignDelegate {
//    NSMutableArray *titleArr;
    NSString *coustomStr;
	
	NSString *thridlyCatStr;
	
	NSDictionary *SKU;
	NSArray *modeArr;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"SKU" ofType:@"plist"];
	SKU = [[NSDictionary alloc] initWithContentsOfFile:path];
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
    
    NSDictionary *info_categ = (NSDictionary*)args;
    NSString *cat_secondary = [info_categ objectForKey:kAYServiceArgsCatSecondary];
	modeArr = [SKU objectForKey:cat_secondary];
	
    thridlyCatStr = [info_categ objectForKey:kAYServiceArgsCatThirdly];		//exsit be or not
    
//    NSDictionary *thridlyData = kAY_service_course_title_ofall;
//    titleArr = [NSMutableArray array];
//    [titleArr addObjectsFromArray:[thridlyData objectForKey:cat_secondary]];
    return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return modeArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = @"AYSetCourseSignCellView";
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[thridlyCatStr copy] forKey:@"handle"];
	[tmp setValue:[[[modeArr objectAtIndex:indexPath.section] allValues] firstObject] forKey:@"model"];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
    cell.controller = self.controller;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *items = [[[modeArr objectAtIndex:indexPath.section] allValues] firstObject];
	int row = (int)items.count / 4;
	if (items.count % 4 != 0) {
		row++;
	}
    return row*41 + 10 + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	NSString *tmp = [titleArr objectAtIndex:indexPath.row];
//	kAYDelegateSendNotify(self, @"courseCansSeted:", &tmp)
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 40.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools whiteColor];
	NSString *titleStr = [[[modeArr objectAtIndex:section] allKeys] firstObject];
	
	UILabel *titleLabel = [Tools creatLabelWithText:titleStr textColor:[Tools garyColor] fontSize:317.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(headView);
		make.left.equalTo(headView).offset(20);
	}];
	
	return headView;
}


#pragma mark -- notifies set service info



@end

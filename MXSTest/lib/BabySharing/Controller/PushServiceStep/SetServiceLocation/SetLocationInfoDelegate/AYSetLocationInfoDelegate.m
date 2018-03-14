//
//  AYSetLocationInfoDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetLocationInfoDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYControllerActionDefines.h"

@implementation AYSetLocationInfoDelegate {
	NSArray *titleArr;
	
	NSDictionary *querydata;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	titleArr = @[@"场地类型", @"场地地址", @"场地友好性和安全设施", @"场地图片"];
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
	querydata = args;
	return nil;
}

- (id)resetCellHeight:(id)args {
//	addressCellHeight = addressCellHeight + [args floatValue];
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[querydata objectForKey:kAYDefineArgsCellNames] objectAtIndex:indexPath.row];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	cell.controller = self.controller;
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:[querydata copy]];
	[tmp setValue:[titleArr objectAtIndex:indexPath.row] forKey:@"title"];
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 || indexPath.row == 2) {
		return 69;
	} else if (indexPath.row == 1) {
		return  175;
	} else {
		
		NSArray *imagesData = [querydata objectForKey:kAYServiceArgsYardImages];
		NSInteger row = (imagesData.count + 1) / 4;
		if ((imagesData.count + 1) % 4 != 0) {
			row ++;
		}
		return 175 + (row - 1)*78;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == 0) {
		kAYDelegateSendNotify(self, @"pickYardType", nil)
	} else {
		kAYDelegateSendNotify(self, @"setServiceFacility", nil)
	}
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 || indexPath.row == 2) {
		return YES;
	} else
		return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	kAYDelegateSendNotify(self, @"didScrollHideKeyBroad", nil)
}
@end

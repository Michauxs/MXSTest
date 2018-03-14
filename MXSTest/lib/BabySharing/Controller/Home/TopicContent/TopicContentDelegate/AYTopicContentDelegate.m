//
//  AYTopicContentDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYTopicContentDelegate.h"

@implementation AYTopicContentDelegate {
	NSArray *queryData;
	NSArray *cellNameArr;
	NSString *albumCateg;
	BOOL isExpend;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	cellNameArr = @[@"AYTopicImageCellView", @"AYTopicDescCellView", @"AYTopicContentCellView", @"AYListEndSignCellView"];
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
	NSArray *service_data = [args objectForKey:kAYServiceArgsInfo];
	if (service_data) {
		queryData = service_data;
	}
	
	NSString *desc = [args objectForKey:kAYServiceArgsAlbum];
	if (desc) {
		albumCateg = desc;
	}
	return nil;
}

- (id)TransfromExpend:(NSNumber*)args {
	isExpend = !isExpend;
	return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return queryData.count + 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [cellNameArr objectAtIndex:indexPath.row > 1 ? 2 : indexPath.row];
	if (indexPath.row == queryData.count+2) {
		class_name = [cellNameArr objectAtIndex:3];
	}
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	cell.controller = self.controller;
//	[cell postPerform];
	
	if (indexPath.row <= 1) {
		NSDictionary *dic_desc = @{@"is_expend":[NSNumber numberWithBool:isExpend], kAYServiceArgsAlbum:albumCateg};
		id tmp = [dic_desc copy];
		[(UITableViewCell*)cell performAYSel:kAYCellSetInfoMessage withResult:&tmp];
	} else if (indexPath.row == queryData.count+2) {
		
	} else {
		id tmp = [queryData objectAtIndex:indexPath.row - 2];
		if (tmp) {
			[(UITableViewCell*)cell performAYSel:kAYCellSetInfoMessage withResult:&tmp];
		}
	}
	return (UITableViewCell*)cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	return 390;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == queryData.count+2) {
		return;
	}
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:[queryData objectAtIndex:indexPath.row - 2] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
}

//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//	UIView *footer = [[UIView alloc] init];
//	UIImageView *sign = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"icon_nomore_sign")];
//	[footer addSubview:sign];
//	[sign mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.center.equalTo(footer);
//		make.size.mas_equalTo(CGSizeMake(344, 16));
//	}];
//	return footer;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//	return 44;
//}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
//	CGFloat offset_y = scrollView.contentOffset.y;
//	
//	NSNumber *tmp = [NSNumber numberWithFloat:offset_y];
//	kAYDelegateSendNotify(self, @"scrollViewDidScroll:", &tmp)
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
}

#pragma mark -- actions

@end

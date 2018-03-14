//
//  AYSortServiceListDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 21/8/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSortServiceListController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYThumbsAndPushDefines.h"
#import "AYModelFacade.h"

@implementation AYSortServiceListController {
	NSString *sortmentStr;
	NSMutableArray *serviceData;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		sortmentStr = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"SortServiceList"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeServPerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	NSString *title = sortmentStr;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	[self loadNewData];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	view.backgroundColor = [Tools whiteColor];
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	view.backgroundColor = [Tools whiteColor];
	
	NSString *title = @"热门分类";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
	return nil;
}

- (void)loadNewData {
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	NSMutableDictionary *dic_search = [[NSMutableDictionary alloc] init];;
	[dic_search setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	/*condition*/
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] init];
	[dic_condt setValue:sortmentStr forKey:kAYServiceArgsCategoryInfo];
	[dic_condt setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_search setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		
//		UITableView *view_table = [self.views objectForKey:@"Table"];
		if (success) {
			
			serviceData = [[[result objectForKey:@"result"] objectForKey:@"services"] mutableCopy];
			id tmp = [serviceData copy];
			kAYDelegatesSendMessage(@"SortServiceList", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		
//		[view_table.mj_header endRefreshing];
		
	}];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}
#pragma mark -- notifies
- (id)willCollectWithRow:(id)args {
	
	NSString *service_id = [args objectForKey:kAYServiceArgsID];
	UIButton *likeBtn = [args objectForKey:@"btn"];
	
	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
	NSArray *resultArr = [serviceData filteredArrayUsingPredicate:pre_id];
	if (resultArr.count != 1) {
		return nil;
	}
	id service_data = resultArr.firstObject;
	
	NSDictionary *user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic = [Tools getBaseRemoteData];
	
	NSMutableDictionary *dic_collect = [[NSMutableDictionary alloc] init];
	[dic_collect setValue:[service_data objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[dic_collect setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic setValue:dic_collect forKey:@"collections"];
	
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] initWithDictionary:dic_collect];
	[dic setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
	if (!likeBtn.selected) {
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				likeBtn.selected = YES;
				[resultArr.firstObject setValue:[NSNumber numberWithBool:YES] forKey:kAYServiceArgsIsCollect];
			} else {
				NSString *title = @"收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	} else {
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				likeBtn.selected = NO;
				[resultArr.firstObject setValue:[NSNumber numberWithBool:NO] forKey:kAYServiceArgsIsCollect];
			} else {
				NSString *title = @"取消收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	}
	return nil;
}

@end

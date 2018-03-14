//
//  AYOrderCommonController.m
//  BabySharing
//
//  Created by Alfred Yang on 10/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderCommonController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"
#import "AYOrderTOPView.h"
#import <objc/runtime.h>

#define TOPHEIGHT		0

@implementation AYOrderCommonController {
	
	NSArray *remindArr;
	
	NSArray *result_status_fb;
	NSArray *OrderOfAll;
	NSInteger skipCount;
	
	dispatch_semaphore_t semaphore;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSString* method_name = [dic objectForKey:kAYControllerChangeArgsKey];
		
		SEL sel = NSSelectorFromString(method_name);
		Method m = class_getInstanceMethod([self class], sel);
		if (m) {
			IMP imp = method_getImplementation(m);
			id (*func)(id, SEL, ...) = imp;
			func(self, sel);
		}
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	skipCount = 0;
	
	/****************************************/
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderCommon"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
	/****************************************/
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	[self loadNewData];
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderNewsreelCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OTMHistoryCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	UITableView *view_status = [self.views objectForKey:kAYFakeStatusBarView];
	[self.view bringSubviewToFront:view_status];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	view.backgroundColor = [UIColor whiteColor];
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	NSString *title = @"确认信息";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20+TOPHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 20 -TOPHEIGHT - kTabBarH);
	//预设高度
//	((UITableView*)view).estimatedRowHeight = 120;
//	((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
	return nil;
}

#pragma mark -- actions
- (id)showFBListOrOne {
	id<AYCommand> des;
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	
	if (result_status_fb.count == 1 ) {
		des = DEFAULTCONTROLLER(@"OrderInfoPage");
		[dic setValue:[result_status_fb firstObject] forKey:kAYControllerChangeArgsKey];
	} else {
		des = DEFAULTCONTROLLER(@"AppliFBList");
		[dic setValue:[result_status_fb copy] forKey:kAYControllerChangeArgsKey];
	}
	
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

- (id)showOrderList {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderListNews");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[OrderOfAll copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

#pragma mark -- actions
- (void)loadNewData {
	[self queryOrders];
	[self queryRemind];
}

- (id)queryOrders {
	NSDictionary* user = nil;
	CURRENUSER(user)
	
	NSMutableDictionary *dic_query = [Tools getBaseRemoteData];
	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithDouble:([NSDate date].timeIntervalSince1970 * 1000)] forKey:@"date"];
	
	[dic_query setValue:[NSNumber numberWithInteger:skipCount] forKey:kAYCommArgsRemoteDataSkip];
	[dic_query setValue:[NSNumber numberWithInt:20] forKey:@"take"];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOrders"];
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			
			NSArray *resultArr = [result objectForKey:@"orders"];
			OrderOfAll = [resultArr copy];
			
			NSPredicate *pred_accept = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusAccepted];
			/*暂时没有已读功能，先不收集拒绝消息*/
			//			NSPredicate *pred_reject = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusReject];
			//			NSPredicate *pred_fb = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_accept, pred_reject]];
			result_status_fb = [resultArr filteredArrayUsingPredicate:pred_accept];
			
			id data = [result_status_fb copy];
			kAYDelegatesSendMessage(@"OrderCommon", @"changeQueryFBData:", &data)
		} else {
//			NSString *message = [result objectForKey:@"message"];
//			if([message isEqualToString:@"token过期"]) {
//				NSString *tip = @"当前用户登录实效已过期，请重新登录";
//				AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer)
//			} else
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
		[((UITableView*)view_future).mj_header endRefreshing];
		
	}];
	
	return nil;
}

- (void)queryRemind {
	
	NSDictionary* user = nil;
	CURRENUSER(user)
	
	NSMutableDictionary *dic_query = [Tools getBaseRemoteData];
	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithInt:1] forKey:@"only_history"];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryRemind"];
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			remindArr = [[result objectForKey:@"lst"] copy];
			id tmp = [remindArr copy];
			kAYDelegatesSendMessage(@"OrderCommon", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
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

- (id)rightBtnSelected {
	return nil;
}

- (id)didSelectedRow:(NSDictionary*)args {
	
	NSDictionary *dic_remind = [[args objectForKey:@"info"] objectForKey:kAYOrderArgsSelf];
	NSNumber *type = [args objectForKey:@"type"];
	if (type.integerValue == 1) {
		
		id<AYCommand> des = DEFAULTCONTROLLER(@"OrderInfoPage");
		NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
		[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
		[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
		[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
		[dic setValue:dic_remind forKey:kAYControllerChangeArgsKey];
		id<AYCommand> cmd_push = PUSH;
		[cmd_push performWithResult:&dic];
		
	} else {
		id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
		NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
		[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
		[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
		[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
		[dic setValue:dic_remind forKey:kAYControllerChangeArgsKey];
		
		id<AYCommand> cmd_push = PUSH;
		[cmd_push performWithResult:&dic];
	}
	return nil;
}

@end

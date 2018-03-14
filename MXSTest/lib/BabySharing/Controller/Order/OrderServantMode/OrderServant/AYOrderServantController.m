//
//  AYOrderServantController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderServantController.h"
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

#define TOPHEIGHT		155
#define HISTORYBTNHEIGHT		60

@implementation AYOrderServantController {
	
	NSArray *remindArr;
	NSArray *result_status_posted;
	NSArray *result_status_paid_cancel;
	NSArray *result_status_past;
	
	NSTimeInterval queryTimespan;
	NSInteger skipCount;
	
	NSTimeInterval queryTimespanRemind;
	NSInteger skipCountRemind;
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
	skipCount = skipCountRemind = 0;
	queryTimespan = queryTimespanRemind = [NSDate date].timeIntervalSince1970;
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderServant"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TodoApplyCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"DayRemindCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	[self loadNewData];
	
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	return nil;
}

- (id)TableLayout:(UIView*)view {
//	view.frame = CGRectMake(0, 40+TOPHEIGHT+HISTORYBTNHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - kTabBarH - TOPHEIGHT - HISTORYBTNHEIGHT);
	view.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - kTabBarH);
	return nil;
}

#pragma mark -- actions
- (void)didHistoryBtnClick {
	[self showHistoryAppli];
}
- (void)didReadMoreBtnClick {
	[self showMoreAppli];
}

- (void)loadNewData {
	[self queryOrders];
	[self queryReminds];
}

- (id)queryOrders {
	NSDictionary* user = nil;
	CURRENUSER(user)
	
	NSMutableDictionary *dic_query = [Tools getBaseRemoteData];
	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsOwnerID];
	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLongLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:@"date"];
	
	[dic_query setValue:[NSNumber numberWithInteger:skipCount] forKey:kAYCommArgsRemoteDataSkip];
	[dic_query setValue:[NSNumber numberWithInt:20] forKey:@"take"];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOrders"];
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray *resultArr = [result objectForKey:@"orders"];
			queryTimespan = ((NSNumber*)[result objectForKey:@"date"]).doubleValue;
			
			NSPredicate *pred_ready = [NSPredicate predicateWithFormat:@"SELF.%@=%d", kAYOrderArgsStatus, OrderStatusPosted];
			result_status_posted = [resultArr filteredArrayUsingPredicate:pred_ready];
			
			id data = [result_status_posted copy];
			kAYDelegatesSendMessage(@"OrderServant", @"changeQueryTodoData:", &data)
			
			NSPredicate *pred_paid = [NSPredicate predicateWithFormat:@"SELF.%@=%d", kAYOrderArgsStatus, OrderStatusPaid];
			NSPredicate *pred_cancel = [NSPredicate predicateWithFormat:@"SELF.%@=%d", kAYOrderArgsStatus, OrderStatusCancel];
			NSPredicate *pred_fb = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_paid, pred_cancel]];
			result_status_paid_cancel = [resultArr filteredArrayUsingPredicate:pred_fb];
			
			NSPredicate *pred_reject = [NSPredicate predicateWithFormat:@"SELF.%@=%d", kAYOrderArgsStatus, OrderStatusReject];
			NSPredicate *pred_done = [NSPredicate predicateWithFormat:@"SELF.%@=%d", kAYOrderArgsStatus, OrderStatusDone];
			NSPredicate *pred_past = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_reject, pred_cancel, pred_done, pred_paid]];
			result_status_past = [resultArr filteredArrayUsingPredicate:pred_past];
			
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
		[((UITableView*)view_future).mj_header endRefreshing];
	}];
	
	return nil;
}

- (void)queryReminds {
	NSDictionary* user = nil;
	CURRENUSER(user)
	
	NSMutableDictionary *dic_query = [Tools getBaseRemoteData];
	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsOwnerID];
	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithInt:1] forKey:@"only_today"];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryRemind"];
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			remindArr = [[result objectForKey:@"lst"] copy];
			id tmp = [remindArr copy];
			kAYDelegatesSendMessage(@"OrderServant", @"changeQueryData:", &tmp)
			
			UITableView *view_table = [self.views objectForKey:kAYTableView];
			[view_table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
			//			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		} else {
			NSString *message = [result objectForKey:@"message"];
			if([message isEqualToString:@"token过期"]) {
				NSString *tip = @"当前用户登录实效已过期，请重新登录";
				AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer)
			} else {
				AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
			}
		}
	}];
}

- (id)showAppliListOrOne {
	
	id<AYCommand> des;
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	
	if (result_status_posted.count == 1 ) {
		des = DEFAULTCONTROLLER(@"OrderInfoPage");
		[dic setValue:[result_status_posted firstObject] forKey:kAYControllerChangeArgsKey];
	}
	else if (result_status_posted.count > 1) {
		des = DEFAULTCONTROLLER(@"MoreAppli");
		NSDictionary *tmp = @{@"todo":result_status_posted, @"feedback":result_status_paid_cancel};
		[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	}
	
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	
	return nil;
}

- (void)didHistoryBtnClick:(UIButton*)btn {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServantHistory");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[result_status_past copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
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

- (id)showLeastOneAppli {
	
	return nil;
}

- (id)showMoreAppli {
	id<AYCommand> des = DEFAULTCONTROLLER(@"MoreAppli");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSDictionary *tmp = @{@"todo":result_status_posted, @"feedback":result_status_paid_cancel};
	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

- (id)showHistoryAppli {
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServantHistory");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:result_status_past forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

- (id)showRemindMessage {
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderListPending");
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:remindArr forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

@end

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

@implementation AYOrderServantController {
//	UILabel *noticeNews;
	NSArray *order_info;
	NSArray *result_status_ready;
	NSArray *order_past;
	
	NSTimeInterval queryTimespan;
	NSInteger skipCount;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	skipCount = 0;
	queryTimespan  = [NSDate date].timeIntervalSince1970 * 1000;
//	UIView *newsBoardView = [[UIView alloc]init];
//	newsBoardView.backgroundColor = [Tools whiteColor];
//	newsBoardView.layer.shadowColor = [Tools garyColor].CGColor;
//	newsBoardView.layer.shadowOffset = CGSizeMake(0, 0);
//	newsBoardView.layer.shadowOpacity = 0.5f;
//	[self.view addSubview:newsBoardView];
//	[newsBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.centerX.equalTo(self.view);
//		make.top.equalTo(self.view).offset(30);
//		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 95));
//	}];
	
//	UILabel *title = [Tools creatUILabelWithText:@"待确认日程" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
//	[newsBoardView addSubview:title];
//	[title mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.left.equalTo(newsBoardView).offset(15);
//		make.top.equalTo(newsBoardView).offset(20);
//	}];
//
//	
//	noticeNews = [Tools creatUILabelWithText:@"暂时没有待处理的日程" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
//	[newsBoardView addSubview:noticeNews];
//	[noticeNews mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.left.equalTo(title);
//		make.top.equalTo(title.mas_bottom).offset(18);
//	}];
//	noticeNews.userInteractionEnabled = YES;
//	[noticeNews addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didNoticeLabelTap)]];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderServant"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TodoApplyCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HistoryEnterCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"DayRemindCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	NSDictionary *tmp = [order_info copy];
	kAYDelegatesSendMessage(@"OrderListNews:", @"changeQueryData:", &tmp)
	
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	[self loadNewData];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
	//	NSString *title = @"确认信息";
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
//	UIImage* left = IMGRESOURCE(@"bar_left_black");
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
//	
//	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - kTabBarH); //5 margin
	return nil;
}

#pragma mark -- actions
- (void)loadNewData {
	NSDictionary* info = nil;
	CURRENUSER(info)
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOrders"];
	
	NSMutableDictionary *dic_query = [info mutableCopy];
	[dic_query setValue:[info objectForKey:@"user_id"] forKey:@"owner_id"];
	
	[dic_query setValue:[NSNumber numberWithDouble:queryTimespan] forKey:@"date"];
	[dic_query setValue:[NSNumber numberWithInteger:skipCount] forKey:@"skin"];
	[dic_query setValue:[NSNumber numberWithInt:20] forKey:@"take"];
	
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray *resultArr = [result objectForKey:@"result"];
			queryTimespan = ((NSNumber*)[result objectForKey:@"date"]).doubleValue;
			
			NSPredicate *pred_ready = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"status", OrderStatusPaid];
			result_status_ready = [resultArr filteredArrayUsingPredicate:pred_ready];
			
			if (result_status_ready.count == 0) {
//				noticeNews.text = @"暂时没有待处理的日程";
//				noticeNews.textColor = [Tools garyColor];
//				noticeNews.userInteractionEnabled = NO;
			} else {
				
//				noticeNews.text = [NSString stringWithFormat:@"您有 %d个待处理订单", (int)result_status_ready.count];
//				noticeNews.textColor = [Tools themeColor];
//				noticeNews.userInteractionEnabled = YES;
			}
			
			NSPredicate *pred_confirm = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusConfirm];
			NSArray *result_status_confirm = [resultArr filteredArrayUsingPredicate:pred_confirm];
			id tmp = [result_status_confirm copy];
			kAYDelegatesSendMessage(@"OrderServant", @"changeQueryData:", &tmp)
			
			id<AYViewBase> view_past = [self.views objectForKey:@"Table"];
			id<AYCommand> refresh_2 = [view_past.commands objectForKey:@"refresh"];
			[refresh_2 performWithResult:nil];
			
			NSPredicate *pred_done = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusDone];
			NSPredicate *pred_reject = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusReject];
			NSPredicate *pred_past = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_done, pred_reject, pred_confirm]];
			order_past = [resultArr filteredArrayUsingPredicate:pred_past];
			
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
		[((UITableView*)view_future).mj_header endRefreshing];
	}];
	
}

- (void)didNoticeLabelTap {
	
	id<AYCommand> des;
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	
	if (result_status_ready.count == 1 && result_status_ready.count != 0) {
		des = DEFAULTCONTROLLER(@"OrderInfoPage");
		[dic setValue:[result_status_ready firstObject] forKey:kAYControllerChangeArgsKey];
//		des = DEFAULTCONTROLLER(@"OrderListPending");
//		[dic setValue:[result_status_ready copy] forKey:kAYControllerChangeArgsKey];
	} else {
		des = DEFAULTCONTROLLER(@"OrderListPending");
		[dic setValue:[result_status_ready copy] forKey:kAYControllerChangeArgsKey];
	}
	
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
}

- (void)didHistoryBtnClick:(UIButton*)btn {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServantHistory");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[order_past copy] forKey:kAYControllerChangeArgsKey];
	
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
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	return nil;
}

@end

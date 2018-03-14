//
//  AYOrderInfoPageController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoPageController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#define btmViewHeight			64

@implementation AYOrderInfoPageController {
	
	NSDictionary *order_info;
	
	NSNumber *remindDateStart;
	NSNumber *remindDateEnd;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
		if ([tmp objectForKey:@"start"]) {
			remindDateStart = [tmp objectForKey:@"start"];
			remindDateEnd = [tmp objectForKey:@"end"];
			order_info = [tmp objectForKey:kAYOrderArgsSelf];
		} else {
			order_info = tmp;
		}
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [Tools whiteColor];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderInfoPage"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPageHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OPPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPageContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"UnSubsCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_query = [Tools getBaseRemoteData];
	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[order_info objectForKey:kAYOrderArgsID] forKey:kAYOrderArgsID];
	[[dic_query objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOrderDetail"];
	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
//			id info_result = [result objectForKey:kAYOrderArgsSelf];
//			if (remindDateStart) {
//				NSMutableDictionary *dic_transfrom = [[NSMutableDictionary alloc] initWithDictionary:info_result];
//				[dic_transfrom setValue:@{kAYTimeManagerArgsStart:remindDateStart, kAYTimeManagerArgsEnd:remindDateEnd} forKey:kAYOrderArgsDate];
//				order_info = [dic_transfrom copy];
//			} else {
//				order_info = info_result;
//			}
			order_info = [result objectForKey:kAYOrderArgsSelf];
			id tmp = [order_info copy];
			kAYDelegatesSendMessage(@"OrderInfoPage", @"changeQueryData:", &tmp)
			
			UIView *BTMView = [UIView new];
			BTMView.backgroundColor = [Tools whiteColor];
			[self.view addSubview:BTMView];
			
			OrderStatus status = ((NSNumber*)[order_info objectForKey:@"status"]).intValue;
			DongDaAppMode mode = [[[NSUserDefaults standardUserDefaults] valueForKey:kAYDongDaAppMode] intValue];
			BOOL isServantMode = mode == DongDaAppModeServant;
			if (isServantMode) {
				
				if (status == OrderStatusPosted) {
					
					CGFloat btmView_height = 64.f;
					BTMView.frame = CGRectMake(0, SCREEN_HEIGHT - btmView_height - HOME_IND_HEIGHT, SCREEN_WIDTH, btmView_height);
					
					UIButton *rejectBtn  = [Tools creatBtnWithTitle:@"拒绝" titleColor:[Tools theme] fontSize:14.f backgroundColor:nil];
					[Tools setViewBorder:rejectBtn withRadius:0 andBorderWidth:1.f andBorderColor:[Tools theme] andBackground:nil];
					[BTMView addSubview:rejectBtn];
					[rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
						make.left.equalTo(BTMView).offset(20);
						make.centerY.equalTo(BTMView);
						make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 60) * 0.5, 40));
					}];
					[rejectBtn addTarget:self action:@selector(didRejectBtnClick) forControlEvents:UIControlEventTouchUpInside];
					
					UIButton *acceptBtn  = [Tools creatBtnWithTitle:@"接受" titleColor:[Tools whiteColor] fontSize:14.f backgroundColor:[Tools theme]];
					[BTMView addSubview:acceptBtn];
					[acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
						make.right.equalTo(BTMView).offset(-20);
						make.centerY.equalTo(BTMView);
						make.size.equalTo(rejectBtn);
					}];
					[acceptBtn addTarget:self action:@selector(didAcceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
				}
				else if (status == OrderStatusCancel) {
					
					BTMView.frame = CGRectMake(0, SCREEN_HEIGHT - BOTTOM_HEIGHT - HOME_IND_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT);
					
					NSString *resonStr = [NSString stringWithFormat:@"拒绝原因:%@", [order_info objectForKey:kAYOrderArgsFurtherMessage]];
					UILabel *tipsLabel = [Tools creatLabelWithText:resonStr textColor:[Tools theme] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
					[BTMView addSubview:tipsLabel];
					[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
						make.left.equalTo(BTMView).offset(20);
						make.centerY.equalTo(BTMView);
					}];
				}
				else {
					BTMView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 0);
				}
				
			} else {	//用户方
				
				if (status == OrderStatusAccepted) {
					BTMView.frame = CGRectMake(0, SCREEN_HEIGHT - BOTTOM_HEIGHT - HOME_IND_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT);
					
					UIButton *gotoPayBtn = [Tools creatBtnWithTitle:@"去支付" titleColor:[Tools whiteColor] fontSize:314.f backgroundColor:[Tools theme]];
					[BTMView addSubview:gotoPayBtn];
					[gotoPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
						make.edges.equalTo(BTMView);
					}];
					[gotoPayBtn addTarget:self action:@selector(didGoPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
					
					UIButton *cancelBtn = [Tools creatBtnWithTitle:@"取消预订申请" titleColor:[Tools garyColor] fontSize:14.f backgroundColor:[Tools whiteColor]];
					[BTMView addSubview:cancelBtn];
					[cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
						make.edges.equalTo(BTMView);
					}];
					[cancelBtn addTarget:self action:@selector(didCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
					cancelBtn.hidden = YES;
				}
				else if (status == OrderStatusCancel) {
					
					BTMView.frame = CGRectMake(0, SCREEN_HEIGHT - BOTTOM_HEIGHT - HOME_IND_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT);
					
					NSString *resonStr = [NSString stringWithFormat:@"取消原因:%@", [order_info objectForKey:kAYOrderArgsFurtherMessage]];
					UILabel *tipsLabel = [Tools creatLabelWithText:resonStr textColor:[Tools theme] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
					[BTMView addSubview:tipsLabel];
					[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
						make.left.equalTo(BTMView).offset(20);
						make.centerY.equalTo(BTMView);
					}];
				}
				else {
					BTMView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 0);
				}
			}
			
			//最后添线
			[Tools creatCALayerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:BTMView];
			
			UITableView *view_table = [self.views objectForKey:kAYTableView];
			[view_table mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(self.view).offset(kStatusAndNavBarH);
				make.left.equalTo(self.view);
				make.right.equalTo(self.view);
				make.bottom.equalTo(BTMView.mas_top);
			}];
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
	}];
	
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
//	view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - btmViewHeight);
	return nil;
}

#pragma mark -- Common actions
- (void)didGoPayBtnClick {
	id<AYCommand> des = DEFAULTCONTROLLER(@"PAYPage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:order_info forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic];
}

- (void)didCancelBtnClick {
	id<AYCommand> des = DEFAULTCONTROLLER(@"UnSubsPage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:order_info forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic];
}

#pragma mark -- Servant actions
- (void)didRejectBtnClick {
	NSDictionary *user;
	CURRENUSER(user);
	
	NSMutableDictionary *dic = [Tools getBaseRemoteData];
	[[dic objectForKey:kAYCommArgsCondition] setValue:[order_info objectForKey:kAYOrderArgsID] forKey:kAYOrderArgsID];
	[[dic objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	NSMutableDictionary *dic_status = [[NSMutableDictionary alloc] init];
	[dic_status setValue:[NSNumber numberWithInt:OrderStatusReject] forKey:kAYOrderArgsStatus];
	[dic setValue:dic_status forKey:kAYOrderArgsSelf];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderNotification"];
	AYRemoteCallCommand *cmd_reject = [facade.commands objectForKey:@"RejectOrder"];
	[cmd_reject performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			
			NSString *title = @"订单已拒绝";
//			[self popToRootVCWithTip:title];
			
			id<AYCommand> des = DEFAULTCONTROLLER(@"RemoteBack");
			NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
			[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
			[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
			[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
			[dic setValue:@{@"FBType":@"FBTypeRejectOrder", kAYCommArgsTips:title} forKey:kAYControllerChangeArgsKey];
			
			id<AYCommand> cmd_push = PUSH;
			[cmd_push performWithResult:&dic];
			
		} else {
			NSString *message = @"拒绝订单申请失败!\n请检查网络是否正常连接";
			AYShowBtmAlertView(message, BtmAlertViewTypeHideWithTimer)
		}
	}];
}

- (void)didAcceptBtnClick {
	NSDictionary *user;
	CURRENUSER(user);
	
	NSMutableDictionary *dic = [Tools getBaseRemoteData];
	[[dic objectForKey:kAYCommArgsCondition] setValue:[order_info objectForKey:kAYOrderArgsID] forKey:kAYOrderArgsID];
	[[dic objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	NSMutableDictionary *dic_status = [[NSMutableDictionary alloc] init];
	[dic_status setValue:[NSNumber numberWithInt:OrderStatusAccepted] forKey:kAYOrderArgsStatus];
	[dic setValue:dic_status forKey:kAYOrderArgsSelf];
	NSLog(@"dic_accept-%@", dic);
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderNotification"];
	AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"AcceptOrder"];
	[cmd_update performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		NSString *message = nil;
		if (success) {
			message = @"订单已接受";
//			[self popToRootVCWithTip:message];
			
			id<AYCommand> des = DEFAULTCONTROLLER(@"RemoteBack");
			NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
			[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
			[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
			[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
			[dic setValue:@{@"FBType":@"FBTypeAcceptOrder", kAYCommArgsTips:message} forKey:kAYControllerChangeArgsKey];
			
			id<AYCommand> cmd_push = PUSH;
			[cmd_push performWithResult:&dic];
			
		} else {
			message = @"接受订单申请失败!\n请检查网络是否正常连接";
			AYShowBtmAlertView(message, BtmAlertViewTypeHideWithTimer)
		}
	}];
}

- (void)popToRootVCWithTip:(NSString*)tip {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:tip forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POPTOROOT;
	[cmd performWithResult:&dic];
	
}

- (void)popToDestVCWithTip:(NSString*)tip {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderCommon");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopToDestValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:tip forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POPTODEST;
	[cmd performWithResult:&dic];
	
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

- (id)didContactBtnClick:(id)args {
	
	AYViewController* des = DEFAULTCONTROLLER(@"SingleChat");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSDictionary* info = nil;
	CURRENUSER(info)
	NSMutableDictionary *dic_chat = [[NSMutableDictionary alloc]init];
	[dic_chat setValue:args forKey:@"owner_id"];
	[dic_chat setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
	[dic setValue:dic_chat forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)unsubsOrder {
	[self didCancelBtnClick];
	return nil;
}

@end

//
//  AYPAYPageController.m
//  BabySharing
//
//  Created by Alfred Yang on 5/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYPAYPageController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYPAYPageController {
	
	NSDictionary *order_info;
	NSDictionary *service_info;
	
	UIView *payOptionSignView;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		order_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"PAYPage"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PayWayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	UIButton *ConfirmPayBtn = [Tools creatBtnWithTitle:@"确认支付" titleColor:[Tools whiteColor] fontSize:314.f backgroundColor:[Tools theme]];
	[self.view addSubview:ConfirmPayBtn];
	[ConfirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kTabBarH));
	}];
	[ConfirmPayBtn addTarget:self action:@selector(didConfirmPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	NSString *title = @"在线支付";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
	return nil;
}

#pragma mark -- actions
- (void)didConfirmPayBtnClick {
	
	NSString *payway;
	CGFloat totalfee_test = 1.f;
	if (payOptionSignView.tag == PayWayOptionAlipay) {
		payway = @"alipay";
		totalfee_test = 0.01f;
	} else if (payOptionSignView.tag == PayWayOptionWechat) {
		payway = @"wechat";
		
		id<AYFacadeBase> f = [self.facades objectForKey:@"SNSWechat"];
		id<AYCommand> cmd_login = [f.commands objectForKey:@"IsInstalledWechat"];
		NSNumber *IsInstalledWechat = [NSNumber numberWithBool:NO];
		[cmd_login performWithResult:&IsInstalledWechat];
		if (!IsInstalledWechat.boolValue ) {
			NSString *title = @"未安装微信！";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			return;
		}
	}
	
	
	NSMutableDictionary *dic_prepay = [Tools getBaseRemoteData];
	[[dic_prepay objectForKey:kAYCommArgsCondition] setValue:[order_info objectForKey:kAYOrderArgsID] forKey:kAYOrderArgsID];
	[[dic_prepay objectForKey:kAYCommArgsCondition] setValue:payway forKey:kAYOrderArgsPayMethod];
	[[dic_prepay objectForKey:kAYCommArgsCondition] setValue:[order_info objectForKey:kAYOrderArgsTotalFee] forKey:kAYOrderArgsTotalFee];
	
#ifdef SANDBOX
	[[dic_prepay objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithFloat:totalfee_test] forKey:kAYOrderArgsTotalFee];
#endif
	NSLog(@"dic_prepay:\n%@",dic_prepay);
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderNotification"];
	AYRemoteCallCommand *cmd_prepay = [facade.commands objectForKey:@"PrePayOrder"];
	[cmd_prepay performWithResult:[dic_prepay copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {

			// 支付
			AYRemoteCallCommand *cmd_pay;
			
			switch (payOptionSignView.tag) {
				case PayWayOptionWechat:
				{
					id<AYFacadeBase> facade = [self.facades objectForKey:@"SNSWechat"];
					cmd_pay = [facade.commands objectForKey:@"PayWithWechat"];
				}
					break;
				case PayWayOptionAlipay:
				{
					id<AYFacadeBase> facade = [self.facades objectForKey:@"Alipay"];
					cmd_pay = [facade.commands objectForKey:@"AlipayPay"];
				}
					break;
					
				default:
					break;
			} //switch
			
			id tmp = [result objectForKey:kAYOrderArgsSelf];
			[cmd_pay performWithResult:&tmp];
			
		} else {
			
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
	}];
	
}

- (void)successForPostPay:(PayWayOption)opt {
	NSDictionary *user;
	CURRENUSER(user);
	
	NSMutableDictionary *dic_paid = [Tools getBaseRemoteData];
	[[dic_paid objectForKey:kAYCommArgsCondition] setValue:[order_info objectForKey:kAYOrderArgsID] forKey:kAYOrderArgsID];
	[[dic_paid objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	NSMutableDictionary *dic_status = [[NSMutableDictionary alloc] init];
	[dic_status setValue:[NSNumber numberWithInt:OrderStatusPaid] forKey:kAYOrderArgsStatus];
	[dic_paid setValue:dic_status forKey:kAYOrderArgsSelf];
	
	// 支付成功
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderNotification"];
	AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"PostPayOrder"];
	[cmd performWithResult:[dic_paid copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			
			id<AYCommand> des = DEFAULTCONTROLLER(@"RemoteBack");
			NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
			[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
			[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
			[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
			[dic setValue:@{@"FBType":@"FBTypePaidOrder", kAYCommArgsTips:@"支付完成，您已成功预订服务"} forKey:kAYControllerChangeArgsKey];
			
			id<AYCommand> cmd_push = PUSH;
			[cmd_push performWithResult:&dic];
			
		} else {
			NSString *title = @"当前网络太慢,服务预订发生错误,请联系客服!";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
	}];
}

- (void)BtmAlertOtherBtnClick {
	// 两个super方法
	[super BtmAlertOtherBtnClick];
	[super tabBarVCSelectIndex:2];
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

- (id)didPayOptionClick:(id)args {
	payOptionSignView.hidden = YES;
	payOptionSignView = args;
	payOptionSignView.hidden = NO;
	
	return nil;
}

#pragma mark -- payment notifies
- (id)WechatPaySuccess:(id)args {
	[self successForPostPay:PayWayOptionWechat];
	return nil;
}

- (id)WechatPayFailed:(id)args {
	int err_code = ((NSNumber*)[args objectForKey:@"err_code"]).intValue;
	if (err_code == -2) {
		//		NSString *title = @"您已取消本次支付支付";
		//		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	} else {
		NSString *title = @"支付失败\n网络不通畅，换个地方试试";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	}
	return nil;
}

- (id)AlipaySuccess:(id)args {
	NSLog(@"pay success");
	[self successForPostPay:PayWayOptionAlipay];
	return nil;
}

- (id)AlipayFailed:(id)args {
	NSLog(@"pay failed");
	NSString *title = @"支付失败\n网络不通畅，换个地方试试";
	AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	return nil;
}

@end

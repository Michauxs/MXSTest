//
//  AYOrderListPendingController.m
//  BabySharing
//
//  Created by Alfred Yang on 18/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderListPendingController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYOrderListPendingController {
	
	NSArray *orderData;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		orderData = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"OrderListPending"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
	/****************************************/
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderListPendingCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	id tmp = [orderData copy];
	kAYDelegatesSendMessage(@"OrderListPending", @"changeQueryData:", &tmp)
	
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
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	NSString *title = @"今日提醒";
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

- (id)didSelectedRow:(NSNumber*)args {
	
	NSDictionary *dic_remind = [orderData objectAtIndex:args.integerValue];
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"OrderInfoPage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:dic_remind forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	
//	NSDictionary* info = nil;
//	CURRENUSER(info)
//		
//	NSMutableDictionary *dic_query = [info mutableCopy];
//	NSDictionary *condition = @{kAYOrderArgsID:[dic_remind objectForKey:kAYOrderArgsID]};
//	[dic_query setValue:condition forKey:@"condition"];
//	
//	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
//	AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOrders"];
//	[cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//		if (success) {
//			id tmp = [[result objectForKey:@"result"] firstObject];
//			
//			
//		} else {
	
//			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
//		}
//	}];
	
	return nil;
}

@end

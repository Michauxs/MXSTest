//
//  AYOrderInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 28/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderMainController.h"
#import "TmpFileStorageModel.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYBOrderMainController {
	
	NSDictionary *order_info;
	
    NSDictionary *service_info;
	NSMutableArray *order_times;
	NSArray *initialTimeData;
	NSDictionary *setedTimes;
	
	int edit_note;
	NSString* order_id;
//	UIView *payOptionSignView;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        order_info = [dic objectForKey:kAYControllerChangeArgsKey];
		service_info = [order_info objectForKey:kAYServiceArgsInfo];
//		order_times = [[order_info objectForKey:@"order_times"] mutableCopy];
		order_times = [order_info objectForKey:@"order_times"];
		initialTimeData = [order_times copy];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
		[order_times replaceObjectAtIndex:edit_note withObject:args];
		
//		id tmp = [order_info copy];
//		kAYDelegatesSendMessage(@"BOrderMain", @"changeQueryData:", &tmp)
		kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<AYViewBase> view_table = [self.views objectForKey:kAYTableView];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"BOrderMain"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    /****************************************/
    id<AYCommand> cmd_head = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* head_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderMainHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&head_class];
    
    NSString* date_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderMainDateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&date_class];
    
    NSString* price_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderMainPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&price_class];
    
    NSString* payway_class = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PayWayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_head performWithResult:&payway_class];
	
    NSDictionary *tmp = [order_info copy];
    kAYDelegatesSendMessage(@"BOrderMain", kAYDelegateChangeDataMessage, &tmp)
    
//    id<AYCommand> cmd_nib = [view_table.commands objectForKey:@"registerCellWithNib:"];
//    NSString* nib_contact_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//    [cmd_nib performWithResult:&nib_contact_name];
//    /****************************************/
    
    UIButton *applyBtn = [Tools creatBtnWithTitle:@"提交" titleColor:[Tools whiteColor] fontSize:316.f backgroundColor:[Tools theme]];
    [self.view addSubview:applyBtn];
    [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset( - HOME_IND_HEIGHT);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
    }];
    [applyBtn addTarget:self action:@selector(didApplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
	
    NSString *title = @"订单详情";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH - kTabBarH - HOME_IND_HEIGHT);
    return nil;
}

#pragma mark -- actions
- (void)didApplyBtnClick:(UIButton*)btn {
	
	CGFloat sumPrice = 0;
	
	NSString *service_cat = [[service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	__block int count_times = 0;
	if ([service_cat isEqualToString:kAYStringNursery]) {
		[order_times enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			
			NSNumber *start = [obj objectForKey:kAYServiceArgsStart];
			NSNumber *end = [obj objectForKey:kAYServiceArgsEnd];
			
			double duration = end.doubleValue * 0.001 - start.doubleValue * 0.001 ;
			count_times += (duration / 60 / 60);
		}];
		
	} else if ([service_cat isEqualToString:kAYStringCourse]) {
		count_times = (int)order_times.count;
	} else {
		
	}
	
	NSNumber *unit_price = [[service_info objectForKey:kAYServiceArgsDetailInfo] objectForKey:kAYServiceArgsPrice];
	sumPrice = unit_price.floatValue * count_times;		// /元 -> /分
	
	NSDictionary* user = nil;
	CURRENUSER(user)
	
	NSMutableDictionary *dic_push = [Tools getBaseRemoteData];
	[[dic_push objectForKey:kAYCommArgsCondition] setValue:[service_info objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[[dic_push objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	NSMutableDictionary *dic_order = [[NSMutableDictionary alloc] init];
	[dic_order setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_order setValue:[service_info objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[dic_order setValue:[NSNumber numberWithInt:sumPrice] forKey:kAYOrderArgsTotalFee];
	[dic_order setValue:[service_info objectForKey:kAYServiceArgsTitle] forKey:kAYOrderArgsTitle];
	NSArray *images = [service_info objectForKey:kAYServiceArgsImages];
	if (images.count != 0) {
		[dic_order setValue:[images firstObject] forKey:kAYOrderArgsThumbs];
	}
	[dic_order setValue:[order_times copy] forKey:kAYOrderArgsDate];
	
	[dic_push setValue:[dic_order copy] forKey:kAYOrderArgsSelf];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderNotification"];
	AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushOrder"];
	[cmd_push performWithResult:[dic_push copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			
			id<AYCommand> des = DEFAULTCONTROLLER(@"RemoteBack");
			NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
			[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
			[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
			[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
			[dic setValue:@{@"FBType":@"FBTypePostOrder", kAYCommArgsTips:@"申请发送成功"} forKey:kAYControllerChangeArgsKey];
			
			id<AYCommand> cmd_push = PUSH;
			[cmd_push performWithResult:&dic];
			
		} else {
			
			NSString *title = @"预订申请失败\n网络不通畅，换个地方试试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
	}];
	
}
- (void)BtmAlertOtherBtnClick {
	NSLog(@"didOtherBtnClick");
	
	[super BtmAlertOtherBtnClick];
	[super tabBarVCSelectIndex:2];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	id<AYCommand> dest = DEFAULTCONTROLLER(@"BOrderTime");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopToDestValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	
	id<AYCommand> cmd = POPTODEST;
	[cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}



- (id)didServiceDetailClick {
    id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    //    NSDictionary *tmp = [querydata objectAtIndex:indexPath.row];
    //    [dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}

/**
 *  date
 */
- (id)didEditDate {
    
    AYHideBtmAlertView
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"SearchFilterDate");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[service_info objectForKey:@"offer_date"] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic];
    return nil;
}

- (id)setOrderTime:(NSNumber*)index {
	
	edit_note = index.intValue;
	
    id<AYCommand> des = DEFAULTCONTROLLER(@"OrderTimes");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_times = [[NSMutableDictionary alloc]init];
    [dic_times setValue:[order_times objectAtIndex:edit_note] forKey:@"order_time"];
    [dic_times setValue:[initialTimeData objectAtIndex:edit_note] forKey:@"initail"];
    [dic setValue:dic_times forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic];
    return nil;
}

/**
 *  price
 */
- (id)didShowDetailClick {
    
    UITableView *table_view = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_delegate = [self.delegates objectForKey:@"BOrderMain"];
    id<AYCommand> cmd_animation = [cmd_delegate.commands objectForKey:@"TransfromExpend"];
    [cmd_animation performWithResult:nil];
    
    [table_view beginUpdates];
    [table_view endUpdates];
    
    return nil;
}


@end

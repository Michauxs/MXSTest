//
//  AYReadyOrderController.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYReadyOrderController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "AYDongDaSegDefines.h"
//#import "AYSearchDefines.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "AYTabBarServiceController.h"
#import "AYNavigationController.h"


@implementation AYReadyOrderController{
    NSMutableArray *loading_status;
    
    NSDictionary *order_info;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        order_info = [dic objectForKey:kAYControllerChangeArgsKey];
//        NSLog(@"%@",order_info);
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ReadyOrder"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> change_data = [cmd_recommend.commands objectForKey:@"changeQueryData:"];
    NSDictionary *args = [order_info copy];
    [change_data performWithResult:&args];
    
//    id<AYCommand> refresh_2 = [view_table.commands objectForKey:@"refresh"];
//    [refresh_2 performWithResult:nil];
    
    /****************************************/
    id<AYCommand> cmd_class = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* head_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&head_name];
    
    NSString* price_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&price_name];
    
    NSString* nib_map_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderMapCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&nib_map_name];
    
    NSString* pay_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PayWayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&pay_name];
    
    NSString* nib_state_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderStateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_class performWithResult:&nib_state_name];
    
    id<AYCommand> cmd_nib = [view_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* nib_contact_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderContactCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_nib performWithResult:&nib_contact_name];
    
    NSString* nib_date_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderDateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_nib performWithResult:&nib_date_name];
    
//    NSString* nib_pay_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderPayCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
//    [cmd_nib performWithResult:&nib_pay_name];
    /****************************************/
    
    NSNumber *status = [order_info objectForKey:@"status"];
    AYViewController* des = DEFAULTCONTROLLER(@"TabBarService");
    if ([self.tabBarController isKindOfClass:[des class]]) {
        UIButton *confirmSerBtn = [[UIButton alloc]init];
        confirmSerBtn.backgroundColor = [Tools theme];
        [confirmSerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmSerBtn setTitleColor:[Tools garyColor] forState:UIControlStateDisabled];
        confirmSerBtn.titleLabel.font = kAYFontLight(17.f);
        [self.view addSubview:confirmSerBtn];
        [self.view bringSubviewToFront:confirmSerBtn];
        [confirmSerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        }];
        
        if (status.intValue == OrderStatusPaid) {
            
            [confirmSerBtn setTitle:@"接受或者拒绝" forState:UIControlStateNormal];
            [confirmSerBtn addTarget:self action:@selector(didComfirmOrRejectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        } else if (status.intValue == OrderStatusConfirm) {
            
            [confirmSerBtn setTitle:@"日程完成" forState:UIControlStateNormal];
            [confirmSerBtn addTarget:self action:@selector(didFinishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        } else
            confirmSerBtn.hidden = YES;
    }
    
    NSString *title;
    switch (status.intValue) {
        case OrderStatusReady:
            title = @"待确认日程";
            break;
        case OrderStatusConfirm:
            title = @"已确认日程";
            break;
        case OrderStatusPaid:
            title = @"待确认日程";
            break;
        case OrderStatusDone:
            title = @"已完成日程";
            break;
        case OrderStatusReject:
            title = @"已拒绝日程";
            break;
        default:
            title = @"异次元日程";
            break;
    }
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    loading_status = [[NSMutableArray alloc]init];
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"订单状态";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    id<AYCommand> cmd_bot = [bar.commands objectForKey:@"setBarBotLine"];
    [cmd_bot performWithResult:nil];
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    NSNumber *status = [order_info objectForKey:@"status"];
    AYViewController* des = DEFAULTCONTROLLER(@"TabBarService");
    BOOL isNapAndDone = ((status.intValue == OrderStatusPaid || status.intValue == OrderStatusConfirm) && [self.tabBarController isKindOfClass:[des class]]);
    
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - (isNapAndDone?44:0));
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

#pragma mark -- actions
- (void)loadNewData {
    
}

- (void)didComfirmOrRejectBtnClick {
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"接受",@"拒绝", nil];
//    [sheet showInView:self.view];
    
//    AYViewController* des = DEFAULTCONTROLLER(@"AcceptOrReject");
////    UINavigationController * nav = CONTROLLER(@"DefaultController", @"Navigation");
//    AYNavigationController * nav = CONTROLLER(@"DefaultController", @"Navigation");
//    
//    [nav pushViewController:des animated:NO];
//    [des.navigationController setNavigationBarHidden:YES];
//    
//    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
//    [dic_push setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
//    [dic_push setValue:nav forKey:kAYControllerActionDestinationControllerKey];
//    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic_push setValue:order_info forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd = SHOWMODULEUP;
//    [cmd performWithResult:&dic_push];
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"AcceptOrReject");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:order_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSHFROMBOT;
    [cmd_show_module performWithResult:&dic];
    
}

- (void)didFinishBtnClick {
    
    NSTimeInterval timeSpan = ((NSNumber*)[[order_info objectForKey:@"order_date"] objectForKey:@"end"]).doubleValue * 0.001;
    NSDate *nowDate = [NSDate date];
    NSTimeInterval now = nowDate.timeIntervalSince1970;
//    confirmSerBtn.enabled = (timeSpan <= now);
    if (timeSpan >= now) {
        NSString *title = @"服务尚未完成";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return;
    }
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_reject = [facade.commands objectForKey:@"AccomplishOrder"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setValue:[order_info objectForKey:@"user_id"] forKey:@"user_id"];
    [dic setValue:[order_info objectForKey:@"order_id"] forKey:@"order_id"];
    [dic setValue:[order_info objectForKey:@"owner_id"] forKey:@"owner_id"];
    [dic setValue:[order_info objectForKey:@"service_id"] forKey:@"service_id"];
    
    [cmd_reject performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
//            kAYUIAlertView(@"提示", @"订单已完成");
//            kAYPopToRootVC
            NSString *title = @"订单已完成";
            [self popToRootVCWithTip:title];
        } else {
            
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"UpdateOrderInfo"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[order_info objectForKey:@"order_id"] forKey:@"order_id"];
    
    if (buttonIndex == 0) {
        [dic setValue:[NSNumber numberWithInt:1] forKey:@"status"];
        
    } else if (buttonIndex == 1) {
        [dic setValue:[NSNumber numberWithInt:3] forKey:@"status"];
    } else
        return;
    
    [cmd_update performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            NSString *message = nil;
            if (buttonIndex == 0)
                message = @"您已经接受订单，请及时处理!";
            else if
                (buttonIndex == 1) message = @"您已经拒绝该订单";
            
            [[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        } else {
            NSLog(@"error with:%@",result);
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

/**
 *  price
 */
- (id)didShowDetailClick {
    UITableView *table_view = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_delegate = [self.delegates objectForKey:@"ReadyOrder"];
    id<AYCommand> cmd_animation = [cmd_delegate.commands objectForKey:@"TransfromExpend"];
    [cmd_animation performWithResult:nil];
    
    [table_view beginUpdates];
    [table_view endUpdates];
    
    return nil;
}

- (id)didServiceDetailClick {
    id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[[order_info objectForKey:@"service"] copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

- (id)didQRCodeBtnClick {
    id<AYCommand> des = DEFAULTCONTROLLER(@"ScanQRCode");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

- (id)didContactBtnClick {
    
    AYViewController* des = DEFAULTCONTROLLER(@"SingleChat");
//    id<AYCommand> des = DEFAULTCONTROLLER(@"GroupList");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_chat = [[NSMutableDictionary alloc]init];
    [dic_chat setValue:[order_info objectForKey:@"owner_id"] forKey:@"owner_id"];
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    NSString *user_id = [info objectForKey:@"user_id"];
    NSString *order_user_id = [order_info objectForKey:@"user_id"];
    NSString *order_owner_id = [order_info objectForKey:@"owner_id"];
    
    if ([user_id isEqualToString:order_owner_id]) {     //我发的服务
        [dic_chat setValue:order_user_id forKey:@"owner_id"];
    } else {
        [dic_chat setValue:order_owner_id forKey:@"owner_id"];
    }
    
    [dic setValue:dic_chat forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}
@end

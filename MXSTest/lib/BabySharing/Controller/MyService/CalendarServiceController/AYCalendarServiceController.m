//
//  AYOrderServiceController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCalendarServiceController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"

@implementation AYCalendarServiceController {
    BOOL isSer;
    NSDictionary *service_info;
    BOOL isChangeCalendar;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        service_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools whiteColor];
	
	DongDaAppMode mode = [[[NSUserDefaults standardUserDefaults] valueForKey:kAYDongDaAppMode] intValue];
	isSer = mode == DongDaAppModeServant;
    if (!isSer) {
        NSString *title = @"可预约日期";
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSArray *offer_date = [service_info objectForKey:@"offer_date"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:offer_date forKey:@"offer_date"];
    [dic setValue:[NSNumber numberWithBool:isSer] forKey:@"is_serv"];
    
    kAYViewsSendMessage(@"Schedule", @"changeQueryData:", &dic)
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    id<AYViewBase> fiter = [self.views objectForKey:@"FiterScroll"];
//    id<AYCommand> cmd = [fiter.commands objectForKey:@"dateScrollToCenter:"];
//    NSString *str = [dateString copy];
//    [cmd performWithResult:&str];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- Layout
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
    NSString *title = @"时间管理";
    [cmd_title performWithResult:&title];
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, @"setRightBtnVisibility:", &right_hidden);
    
    return nil;
}

- (id)ScheduleLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64 +10, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 -10);
    return nil;
}

- (id)leftBtnSelected {
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    if (isChangeCalendar) {
        [dic_pop setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    }
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
    
    NSArray *unavilableDateArr = nil;
    kAYViewsSendMessage(@"Schedule", @"queryUnavluableDate:", &unavilableDateArr)
    
//    NSMutableArray *tmp = [NSMutableArray array];
//    for (int i = 0; i < unavluableDateArr.count; ++i) {
//        NSNumber *timeSpan = unavluableDateArr[i];
//        [tmp addObject:[NSNumber numberWithLong:(timeSpan.longValue * 1000)]];
//    }
    
    NSMutableDictionary *update_info = [[NSMutableDictionary alloc]init];
    [update_info setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    [update_info setValue:unavilableDateArr forKey:@"offer_date"];
    
    NSDictionary* args = nil;
    CURRENUSER(args)
    NSMutableDictionary *dic_revert = [[NSMutableDictionary alloc]init];
    [dic_revert setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
    [dic_revert setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
    //1.撤销服务
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
//    AYRemoteCallCommand *cmd_revert  = [facade.commands objectForKey:@"RevertMyService"];
//    [cmd_revert performWithResult:[dic_revert copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//        if (success) {
    
            AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"UpdateMyService"];
            [cmd_update performWithResult:[update_info copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                if (success) {
                    
                    NSString *title = @"日程已修改";
                    AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
                    
                    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
                    kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnVisibility:", &right_hidden);
                    
                    isChangeCalendar = YES;
                    
//                    NSMutableDictionary *dic_publish = [[NSMutableDictionary alloc]init];
//                    [dic_publish setValue:[args objectForKey:@"user_id"] forKey:@"owner_id"];
//                    [dic_publish setValue:[result objectForKey:@"service_id"] forKey:@"service_id"];
//                    AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"PublishService"];
//                    [cmd_publish performWithResult:[dic_publish copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//                        if (success) {
//                            
//                            NSString *title = @"日程已修改";
//                            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//                            
//                            NSNumber* right_hidden = [NSNumber numberWithBool:YES];
//                            kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnVisibility:", &right_hidden);
//                            
//                            isChangeCalendar = YES;
//                        }
//                    }];
                }
            }];
//        }
//    }];
    
    return nil;
}

- (id)ChangeOfSchedule {
    UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:16.f backgroundColor:nil];
    kAYViewsSendMessage(kAYFakeNavBarView, @"setRightBtnWithBtn:", &bar_right_btn)
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

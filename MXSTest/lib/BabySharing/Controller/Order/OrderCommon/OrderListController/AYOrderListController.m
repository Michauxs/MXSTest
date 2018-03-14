//
//  AYOrderListController.m
//  BabySharing
//
//  Created by Alfred Yang on 25/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderListController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYDongDaSegDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYUserDisplayDefines.h"

#define kFakeNavBarH                54
#define kTableViewY                 74
#define SEARCH_BAR_MARGIN_BOT       -2
#define SEGAMENT_MARGIN_BOTTOM      10.5
#define BOTTOM_BAR_HEIGHT           49

@implementation AYOrderListController {
    
    NSMutableArray *result_status_0;
    BOOL isSer;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
//        isPush = YES;
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        id backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
        if (backArgs) {
            
            [self loadNewData];
            
            if ([backArgs isKindOfClass:[NSString class]]) {
                
                NSString *title = (NSString*)backArgs;
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_reg = [self.views objectForKey:@"DongDaSeg"];
    [view_nav addSubview:(UIView*)view_reg];
    [view_nav bringSubviewToFront:(UIView*)view_reg];
	
	DongDaAppMode mode = [[[NSUserDefaults standardUserDefaults] valueForKey:kAYDongDaAppMode] intValue];
	isSer = mode == DongDaAppModeServant;
    if (isSer) {
        {
            id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
            id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"FutureOrderSer"];
            
            id<AYCommand> cmd_datasource = [view_future.commands objectForKey:@"registerDatasource:"];
            id<AYCommand> cmd_delegate = [view_future.commands objectForKey:@"registerDelegate:"];
            
            id obj = (id)cmd_notify;
            [cmd_datasource performWithResult:&obj];
            obj = (id)cmd_notify;
            [cmd_delegate performWithResult:&obj];
            
            id<AYCommand> cmd_cell = [view_future.commands objectForKey:@"registerCellWithClass:"];
            NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SerOrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
            [cmd_cell performWithResult:&class_name];
            
            NSString* class_name1 = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NoOrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
            [cmd_cell performWithResult:&class_name1];
            
            ((UITableView*)view_future).mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        }
        
        {
            id<AYViewBase> view_past = [self.views objectForKey:@"Table2"];
            id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"PastOrderSer"];
            
            id<AYCommand> cmd_datasource = [view_past.commands objectForKey:@"registerDatasource:"];
            id<AYCommand> cmd_delegate = [view_past.commands objectForKey:@"registerDelegate:"];
            
            id obj = (id)cmd_relations;
            [cmd_datasource performWithResult:&obj];
            obj = (id)cmd_relations;
            [cmd_delegate performWithResult:&obj];
            
            id<AYCommand> cmd_hot_cell = [view_past.commands objectForKey:@"registerCellWithClass:"];
            NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SerOrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
            [cmd_hot_cell performWithResult:&class_name];
            
            ((UITableView*)view_past).mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        }
    }
    else {
        {
            id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
            id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"FutureOrder"];
            
            id<AYCommand> cmd_datasource = [view_future.commands objectForKey:@"registerDatasource:"];
            id<AYCommand> cmd_delegate = [view_future.commands objectForKey:@"registerDelegate:"];
            
            id obj = (id)cmd_notify;
            [cmd_datasource performWithResult:&obj];
            obj = (id)cmd_notify;
            [cmd_delegate performWithResult:&obj];
            
            id<AYCommand> cmd_cell = [view_future.commands objectForKey:@"registerCellWithNib:"];
            NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
            [cmd_cell performWithResult:&class_name];
            
            ((UITableView*)view_future).mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        }
        
        {
            id<AYViewBase> view_past = [self.views objectForKey:@"Table2"];
            id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"PastOrder"];
            
            id<AYCommand> cmd_datasource = [view_past.commands objectForKey:@"registerDatasource:"];
            id<AYCommand> cmd_delegate = [view_past.commands objectForKey:@"registerDelegate:"];
            
            id obj = (id)cmd_relations;
            [cmd_datasource performWithResult:&obj];
            obj = (id)cmd_relations;
            [cmd_delegate performWithResult:&obj];
            
            id<AYCommand> cmd_hot_cell = [view_past.commands objectForKey:@"registerCellWithNib:"];
            NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OrderCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
            [cmd_hot_cell performWithResult:&class_name];
            
            ((UITableView*)view_past).mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        }
    }
    
    [self loadNewData];
}

#pragma mark -- actions
- (void)loadNewData {
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    
    if (isSer) {
        
        id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
        AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOwnOrders"];
        NSMutableDictionary *dic_query = [info mutableCopy];

        NSMutableDictionary *dic_conditon = [[NSMutableDictionary alloc]init];
        [dic_conditon setValue:[info objectForKey:@"user_id"] forKey:@"owner_id"];
        
        [dic_query setValue:[dic_conditon copy] forKey:@"condition"];
        [cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                [self sortSerResultArray:result];
            }else {
                NSLog(@"query orders error: %@",result);
            }
            
            id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
            [((UITableView*)view_future).mj_header endRefreshing];
            
            id<AYViewBase> view_past = [self.views objectForKey:@"Table2"];
            [((UITableView*)view_past).mj_header endRefreshing];
        }];
    } else {
        
        id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
        AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryApplyOrders"];
        NSMutableDictionary *dic_query = [info mutableCopy];
        
        NSMutableDictionary *dic_conditon = [[NSMutableDictionary alloc]init];
        [dic_conditon setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
        
        [dic_query setValue:[dic_conditon copy] forKey:@"condition"];
        
        [cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                [self sortResultArray:result];
            }else {
                NSLog(@"query orders error: %@",result);
            }
            
            id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
            [((UITableView*)view_future).mj_header endRefreshing];
            
            id<AYViewBase> view_past = [self.views objectForKey:@"Table2"];
            [((UITableView*)view_past).mj_header endRefreshing];
        }];
    }
    
}

- (void)sortSerResultArray:(NSDictionary*)result {
    
    NSArray *resultArr = [result objectForKey:@"result"];
    
    NSPredicate *pred_done = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusDone];
    NSPredicate *pred_reject = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusReject];
    
    NSPredicate *pred_past = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_done, pred_reject]];
    NSArray *result_past = [resultArr filteredArrayUsingPredicate:pred_past];
    
//    NSArray *result_status_done = [resultArr filteredArrayUsingPredicate:pred_done];
//    NSArray *result_status_reject = [resultArr filteredArrayUsingPredicate:pred_reject];
    
//    NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
//    [tmpArr addObjectsFromArray:result_status_done];
//    [tmpArr addObjectsFromArray:result_status_reject];
    
    id<AYDelegateBase> cmd_past = [self.delegates objectForKey:@"PastOrderSer"];
    id<AYCommand> changeData_2 = [cmd_past.commands objectForKey:@"changeQueryData:"];
//    NSArray *all_past = [tmpArr copy];
    [changeData_2 performWithResult:&result_past];
    
    id<AYViewBase> view_past = [self.views objectForKey:@"Table2"];
    id<AYCommand> refresh_2 = [view_past.commands objectForKey:@"refresh"];
    [refresh_2 performWithResult:nil];
    
    /*****************************/
    
    NSPredicate *pred_ready = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusPaid];
    NSPredicate *pred_confirm = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusConfirm];
    NSArray *result_status_ready = [resultArr filteredArrayUsingPredicate:pred_ready];
    NSArray *result_status_confirm = [resultArr filteredArrayUsingPredicate:pred_confirm];
    
    result_status_0 = [result_status_ready copy];
    
//    result_status_0 = [[NSMutableArray alloc]init];
//    [result_status_0 addObjectsFromArray:result_status_ready];
//    [result_status_0 addObjectsFromArray:result_status_confirm];
    
//    NSPredicate *pred_0_1 = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_0, pred_1]];
//    result_status_0 = [NSMutableArray arrayWithArray:[resultArr filteredArrayUsingPredicate:pred_0_1]];
    
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"FutureOrderSer"];
    id<AYCommand> changeData_0 = [cmd_notify.commands objectForKey:@"changeQueryData:"];
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc]initWithCapacity:2];
    [tmp setValue:[result_status_ready copy] forKey:@"paid"];
    [tmp setValue:[result_status_confirm copy] forKey:@"confirm"];
    [changeData_0 performWithResult:&tmp];
    
    id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
    id<AYCommand> refresh_0 = [view_future.commands objectForKey:@"refresh"];
    [refresh_0 performWithResult:nil];
}

- (void)sortResultArray:(NSDictionary*)result {
    
    NSArray *resultArr = [result objectForKey:@"result"];
    
    NSPredicate *pred_done = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusDone];
    NSPredicate *pred_reject = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusReject];
    NSArray *result_status_done = [resultArr filteredArrayUsingPredicate:pred_done];
    NSArray *result_status_reject = [resultArr filteredArrayUsingPredicate:pred_reject];
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
    [tmpArr addObjectsFromArray:result_status_done];
    [tmpArr addObjectsFromArray:result_status_reject];
    
    id<AYDelegateBase> cmd_past = [self.delegates objectForKey:@"PastOrder"];
    id<AYCommand> changeData_2 = [cmd_past.commands objectForKey:@"changeQueryData:"];
    NSArray *all_past = [tmpArr copy];
    [changeData_2 performWithResult:&all_past];
    
    id<AYViewBase> view_past = [self.views objectForKey:@"Table2"];
    id<AYCommand> refresh_2 = [view_past.commands objectForKey:@"refresh"];
    [refresh_2 performWithResult:nil];
    
    /*****************************/
    
    NSPredicate *pred_ready = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusPaid];
    NSPredicate *pred_confirm = [NSPredicate predicateWithFormat:@"SELF.status=%d",OrderStatusConfirm];
    NSArray *result_status_ready = [resultArr filteredArrayUsingPredicate:pred_ready];
    NSArray *result_status_confirm = [resultArr filteredArrayUsingPredicate:pred_confirm];
    
    result_status_0 = [[NSMutableArray alloc]init];
    [result_status_0 addObjectsFromArray:result_status_ready];
    [result_status_0 addObjectsFromArray:result_status_confirm];
    
    //    NSPredicate *pred_0_1 = [NSCompoundPredicate orPredicateWithSubpredicates:@[pred_0, pred_1]];
    //    result_status_0 = [NSMutableArray arrayWithArray:[resultArr filteredArrayUsingPredicate:pred_0_1]];
    
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"FutureOrder"];
    id<AYCommand> changeData_0 = [cmd_notify.commands objectForKey:@"changeQueryData:"];
    NSArray *arr = [result_status_0 copy];
    [changeData_0 performWithResult:&arr];
    
    id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
    id<AYCommand> refresh_0 = [view_future.commands objectForKey:@"refresh"];
    [refresh_0 performWithResult:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layout commands
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, kStatusBarH, width, kFakeNavBarH);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    {
        id<AYCommand> cmd_left_vis = [bar.commands objectForKey:@"setLeftBtnVisibility:"];
        NSNumber* left_hidden = [NSNumber numberWithBool:YES];
        [cmd_left_vis performWithResult:&left_hidden];
    }
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, kFakeNavBarH - 4.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools garyLineColor].CGColor;
    [view.layer addSublayer:line];
    
    CALayer *separtor = [CALayer layer];
    separtor.frame = CGRectMake(0, kFakeNavBarH - 4, SCREEN_WIDTH, 4);
    separtor.backgroundColor = [Tools garyBackgroundColor].CGColor;
    [view.layer addSublayer:separtor];
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, kTableViewY, SCREEN_WIDTH, SCREEN_HEIGHT - 69 - (49));
    view.backgroundColor = [UIColor clearColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

- (id)Table2Layout:(UIView*)view {
    
    view.frame = CGRectMake(SCREEN_WIDTH, kTableViewY, SCREEN_WIDTH, SCREEN_HEIGHT - 69 - (49));
    view.backgroundColor = [UIColor clearColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

- (id)DongDaSegLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 54);
    
    id<AYViewBase> seg = (id<AYViewBase>)view;
    id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
    
    id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
    NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
    [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_0 setValue:@"将至日程" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_0];
    
    NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
    [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
    [dic_add_item_1 setValue:@"过往日程" forKey:kAYSegViewTitleKey];
    [cmd_add_item performWithResult:&dic_add_item_1];
    
    NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
    [dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
    [dic_user_info setValue:[NSNumber numberWithFloat:0.f * [UIScreen mainScreen].bounds.size.width] forKey:kAYSegViewMarginBetweenKey];
    
    [cmd_info performWithResult:&dic_user_info];
    
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)segValueChanged:(id)obj {
    id<AYViewBase> seg = (id<AYViewBase>)obj;
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    NSLog(@"current index %@", index);
    
    UIView* table = [self.views objectForKey:@"Table"];
    UIView* table2 = [self.views objectForKey:@"Table2"];
    
    if (index.intValue == 0){
        [UIView animateWithDuration:0.3 animations:^{
            table.center = CGPointMake(SCREEN_WIDTH * 0.5, table.center.y);
            table2.center = CGPointMake(SCREEN_WIDTH * 1.5, table2.center.y);
        }];
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            table.center = CGPointMake(- SCREEN_WIDTH * 0.5, table.center.y);
            table2.center = CGPointMake(SCREEN_WIDTH * 0.5, table2.center.y);
        }];
    }
    return nil;
}

- (id)updateReadState:(NSDictionary*)args {
//    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
//    AYRemoteCallCommand *cmd_update = [facade.commands objectForKey:@"UpdateOrderInfo"];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:[args objectForKey:@"is_read"] forKey:@"is_read"];
//    [dic setValue:[args objectForKey:@"order_id"] forKey:@"order_id"];
//    
//    [cmd_update performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//        if (success) {
//            NSIndexPath *indexPath = [args objectForKey:@"index_path"];
//            [[result_status_0 objectAtIndex:indexPath.section] setValue:[NSNumber numberWithInt:1] forKey:@"is_read"];
//            
//            id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"FutureOrder"];
//            id<AYCommand> changeData_0 = [cmd_notify.commands objectForKey:@"changeQueryData:"];
//            NSArray *arr = result_status_0;
//            [changeData_0 performWithResult:&arr];
//            
//            id<AYViewBase> view_future = [self.views objectForKey:@"Table"];
//            id<AYCommand> refresh_0 = [view_future.commands objectForKey:@"refresh"];
//            [refresh_0 performWithResult:nil];
//            
//        } else {
//            NSLog(@"error with:%@",result);
//        }
//    }];
    return nil;
}

//michauxs:scrollToHideKeyBoard
- (id)scrollToHideKeyBoard {
    return nil;
}

@end

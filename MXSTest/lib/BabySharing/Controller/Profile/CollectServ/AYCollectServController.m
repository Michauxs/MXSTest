//
//  AYCollectServController.m
//  BabySharing
//
//  Created by Alfred Yang on 8/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCollectServController.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"

@implementation AYCollectServController {
    
    UILabel *tipsLabel;
	NSMutableArray *resultArr;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSDictionary *backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
		NSString *key = [backArgs objectForKey:kAYVCBackArgsKey];
		
		if ([key isEqualToString:kAYVCBackArgsKeyCollectChange]) {
			id service_info = [backArgs objectForKey:kAYServiceArgsInfo];
			NSString *service_id = [service_info objectForKey:kAYServiceArgsID];
			
			NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
			NSArray *result = [resultArr filteredArrayUsingPredicate:pre_id];
			if (result.count == 1) {
				NSNumber *is_collect = [backArgs objectForKey:kAYServiceArgsIsCollect];
				[result.firstObject setValue:is_collect forKey:kAYServiceArgsIsCollect];
				NSInteger index = [resultArr indexOfObject:result.firstObject];
				[resultArr removeObject:result.firstObject];
				id tmp = [resultArr copy];
				kAYDelegatesSendMessage(@"CollectServ", kAYDelegateChangeDataMessage, &tmp)
				UITableView *view_table = [self.views objectForKey:kAYTableView];
				
				if (!is_collect.boolValue) {
					[view_table deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
				}
				
			}
		}
		
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	resultArr = [NSMutableArray array];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_collect = [self.delegates objectForKey:@"CollectServ"];
    
    id obj = (id)cmd_collect;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_collect;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NursaryListCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_search performWithResult:&class_name];
    
    UITableView *tableView = (UITableView*)view_table;
    tipsLabel = [Tools creatLabelWithText:@"您还没有收藏过服务" textColor:[Tools garyColor] fontSize:16.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    [tableView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView).offset(60);
//        make.left.equalTo(tableView).offset(20);
		make.centerX.equalTo(tableView);
    }];
    tipsLabel.hidden = YES;
    
    tableView.mj_header = [MXSRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
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
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    
    NSString *title = @"我心仪的服务";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* left_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &left_hidden)
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusAndNavBarH , SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    return nil;
}

#pragma mark -- actions
- (void)loadNewData {
    
    NSDictionary* user = nil;
    CURRENUSER(user)
	NSMutableDictionary *dic = [Tools getBaseRemoteData:user];
    [[dic objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:@"user_id"] forKey:@"user_id"];
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"AllCollectService"];
	[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_push andArgs:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//    [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            
            NSArray *data = [result objectForKey:@"services"];
			resultArr = [data mutableCopy];
            if (data.count == 0) {
                tipsLabel.hidden = NO;
            } else {
                tipsLabel.hidden = YES;
                kAYDelegatesSendMessage(@"CollectServ", @"changeQueryData:", &data)
                kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
            }
        } else {
            tipsLabel.hidden = YES;
            AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
        }
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        [((UITableView*)view_table).mj_header endRefreshing];
    }];
}

- (id)ownerIconTap:(id)args {
    return nil;
}

#pragma mark -- notifies
- (id)willCollectWithRow:(id)args {
	
	NSString *service_id = [args objectForKey:kAYServiceArgsID];
	UIButton *likeBtn = [args objectForKey:@"btn"];
	
	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
	NSArray *result_pred = [resultArr filteredArrayUsingPredicate:pre_id];
	if (result_pred.count != 1) {
		return nil;
	}
	id service_data = result_pred.firstObject;
	
	NSDictionary *user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic = [Tools getBaseRemoteData];
	
	NSMutableDictionary *dic_collect = [[NSMutableDictionary alloc] init];
	[dic_collect setValue:[service_data objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[dic_collect setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic setValue:dic_collect forKey:@"collections"];
	
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] initWithDictionary:dic_collect];
	[dic setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
	if (!likeBtn.selected) {
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
		[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_push andArgs:[dic_collect copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				likeBtn.selected = YES;
			} else {
				NSString *title = @"收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	} else {
		
		UIAlertController *alertController= [UIAlertController alertControllerWithTitle:@"取消收藏" message:@"您确认要从我心仪的服务中移除\n当前服务吗？" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
		UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"移除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			
			AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
			[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_push andArgs:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//			[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
				if (success) {
					NSInteger row = [resultArr indexOfObject:result_pred.firstObject];
					[resultArr removeObject:result_pred.firstObject];
					id data = [resultArr copy];
					kAYDelegatesSendMessage(@"CollectServ", @"changeQueryData:", &data)
//					kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
					dispatch_async(dispatch_get_main_queue(), ^{
						UITableView *view_table = [self.views objectForKey:kAYTableView];
						[view_table deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
					});
				} else {
					NSString *title = @"取消收藏失败!请检查网络链接是否正常";
					AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
				}
			}];
			
		}];
		[alertController addAction:cancelAction];
		[alertController addAction:certainAction];
		[self presentViewController:alertController animated:YES completion:nil];
		
	}
	return nil;
}

- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

@end

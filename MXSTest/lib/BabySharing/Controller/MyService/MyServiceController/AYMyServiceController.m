//
//  AYCollectServController.m
//  BabySharing
//
//  Created by Alfred Yang on 8/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMyServiceController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYMyServiceController {
	
	NSTimeInterval remoteTimespan;
	NSInteger skipedCount;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        id backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
        if (backArgs) {
            if ([backArgs isKindOfClass:[NSString class]]) {
                AYShowBtmAlertView(backArgs, BtmAlertViewTypeHideWithTimer)
            }
			//backargs string? end
			[self loadRefreshData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	skipedCount = 0;
    
    id<AYDelegateBase> deleg = [self.delegates objectForKey:@"MyService"];
	id obj = (id)deleg;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	obj = (id)deleg;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"MyServiceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    ((UITableView*)view_table).mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    
    [self loadRefreshData];
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
    
    NSString *title = @"我的服务";
    kAYViewsSendMessage(@"FakeNavBar", @"setTitleText:", &title)
    
    NSNumber* left_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(@"FakeNavBar", @"setLeftBtnVisibility:", &left_hidden);
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnVisibility:", &right_hidden);
    
    kAYViewsSendMessage(@"FakeNavBar", @"setBarBotLine", nil);
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusAndNavBarH , SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH - kTabBarH);
    return nil;
}

#pragma mark -- actions
- (void)loadRefreshData {
    
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	NSMutableDictionary *dic_search = [[NSMutableDictionary alloc] init];;
	[dic_search setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
//	[dic_search setValue:[NSNumber numberWithInteger:skipedCount] forKey:kAYCommArgsRemoteDataSkip];
	/*condition*/
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] init];
//	[dic_condt setValue:[NSNumber numberWithLong:remoteTimespan*1000] forKey:kAYCommArgsRemoteDate];
	[dic_condt setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsOwnerID];
	[dic_condt setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_search setValue:dic_condt forKey:kAYCommArgsCondition];
	NSLog(@"search-\n%@", dic_search);
	
    id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    AYRemoteCallCommand *cmd_search = [facade.commands objectForKey:@"SearchFiltService"];
    [cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
			
			remoteTimespan = ((NSNumber*)[[result objectForKey:@"result"] objectForKey:@"date"]).longValue * 0.001;
			
            NSArray *data = [[result objectForKey:@"result"] objectForKey:@"services"];
			skipedCount = data.count;
            kAYDelegatesSendMessage(@"MyService", kAYDelegateChangeDataMessage, &data)
            kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
            
        } else {
            AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
        }
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        [((UITableView*)view_table).mj_header endRefreshing];
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

- (id)didManagerBtnClick:(id)args {
    
    id<AYCommand> dest;
	NSString *serviceCat = [[args objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	if ([serviceCat isEqualToString:kAYStringCourse]) {
		dest = DEFAULTCONTROLLER(@"NapScheduleMain");
	} else {
		dest = DEFAULTCONTROLLER(@"NurseScheduleMain");
	}
	
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
}

@end

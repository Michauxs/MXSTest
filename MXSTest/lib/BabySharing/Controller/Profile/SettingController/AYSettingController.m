//
//  AYSettingController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSettingController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYFacadeBase.h"
#import "AYAlbumDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYFacade.h"
#import "AppDelegate.h"

@implementation AYSettingController

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_setting = [self.delegates objectForKey:@"AppSetting"];
        
        id obj = (id)cmd_setting;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_setting;
        [cmd_delegate performWithResult:&obj];
        
    }
    
    UIButton *logout_btn = [Tools creatBtnWithTitle:@"退出登录" titleColor:[UIColor whiteColor] fontSize:317.f backgroundColor:[Tools theme]];
	[Tools setViewBorder:logout_btn withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
    [logout_btn addTarget:self action:@selector(signOutSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout_btn];
    [logout_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 17.5*2, 44));
    }];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"设置";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)LogoutCurrentUser {
    NSLog(@"current user logout");
    //    [_lm signOutCurrentUser];
	
    
    return nil;
}

#pragma mark -- actions
- (void)signOutSelected {
	
	NSDictionary* current_login_user = nil;
	CURRENUSER(current_login_user);
	
	id<AYFacadeBase> f_login_remote = [self.facades objectForKey:@"LandingRemote"];
	AYRemoteCallCommand* cmd_sign_out = [f_login_remote.commands objectForKey:@"AuthSignOut"];
	[cmd_sign_out performWithResult:current_login_user andFinishBlack:^(BOOL success, NSDictionary * result) {
		NSLog(@"login out %@", result);
		
//        AYFacade* f_em = [self.facades objectForKey:@"EM"];
//        id<AYCommand> cmd_xmpp_logout = [f_em.commands objectForKey:@"LogoutEM"];
//        [cmd_xmpp_logout performWithResult:nil];
		
		AYFacade* f_login = LOGINMODEL;
		id<AYCommand> cmd_sign_out_local = [f_login.commands objectForKey:@"SignOutLocal"];
		[cmd_sign_out_local performWithResult:nil];
		
	}];
}
@end

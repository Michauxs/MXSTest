//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYInputCoderController.h"
#import "AYViewBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"

@interface AYInputCoderController () <UINavigationControllerDelegate>
@property (nonatomic, strong) NSString* reg_token;
@end

@implementation AYInputCoderController {
    CGRect keyBoardFrame;
}

@synthesize reg_token = _reg_token;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
	
	
	/****** *****/
	UIButton *pri_btn = [[UIButton alloc]init];
	[self.view addSubview:pri_btn];
	pri_btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
	[pri_btn setTitle:@"登录即代表我同意用户 服务条款 及 隐私协议" forState:UIControlStateNormal];
	[pri_btn setTitleColor:[UIColor theme] forState:UIControlStateNormal];
	pri_btn.clipsToBounds = YES;
	[pri_btn addTarget:self action:@selector(pri_btnDidClick) forControlEvents:UIControlEventTouchUpInside];
	[pri_btn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.bottom.equalTo(self.view.mas_bottom).offset(-24.5);
		make.width.mas_equalTo(SCREEN_WIDTH - 30);
		make.height.mas_equalTo(15);
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark -- views layouts
- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusAndNavBarH);
    view.backgroundColor = [UIColor clearColor];
	
//	NSString *title = @"确认信息";
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)LandingInputCoderLayout:(UIView*)view {
    CGFloat margin = 25.f;
    view.frame = CGRectMake(margin, kStatusAndNavBarH+20, SCREEN_WIDTH - margin*2, 320);
    return nil;
}

#pragma mark -- actions
- (void)pri_btnDidClick {
	
	id<AYCommand> UserAgree = DEFAULTCONTROLLER(@"UserAgree");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:UserAgree forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic];
}

- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
    id<AYViewBase> view = [self.views objectForKey:@"LandingInputCoder"];
    id<AYCommand> cmd = [view.commands objectForKey:@"hideKeyboard"];
    [cmd performWithResult:nil];
}

- (id)beginEditTextFiled {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [self performWithResult:&dic];
    return nil;
}

- (id)leftBtnSelected {
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
    return nil;
}

-(id)reReqConfirmCode:(id)args {
    NSDictionary *args_dic = (NSDictionary*)args;
    
    NSMutableDictionary* dic_coder = [[NSMutableDictionary alloc]init];
    [dic_coder setValue:[args_dic objectForKey:kAYProfileArgsPhone] forKey:kAYProfileArgsPhone];
    
    AYFacade* f = [self.facades objectForKey:@"LandingRemote"];
    AYRemoteCallCommand* cmd_coder = [f.commands objectForKey:@"LandingReqConfirmCode"];
	[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_coder andArgs:[dic_coder copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//    [cmd_coder performWithResult:[dic_coder copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            NSLog(@"验证码已发送");//is_reg
			NSDictionary *reg_info = [result objectForKey:@"reg"];
            AYModel* m = MODEL;
            AYFacade* f = [m.facades objectForKey:@"LoginModel"];
            id<AYCommand> cmd = [f.commands objectForKey:@"ChangeTmpUser"];
            [cmd performWithResult:&result];
            _reg_token = [reg_info objectForKey:@"reg_token"];
            
            id<AYViewBase> coder_view = [self.views objectForKey:@"LandingInputCoder"];
            id<AYCommand> cmd_coder = [coder_view.commands objectForKey:@"startConfirmCodeTimer"];
            [cmd_coder performWithResult:nil];
            
            id<AYViewBase> input = [self.views objectForKey:@"LandingInputCoder"];
            NSNumber *is_reg = [reg_info objectForKey:@"is_reg"];
            if (is_reg.intValue == 0) {
                id<AYCommand> hide_cmd = [input.commands objectForKey:@"showNextBtnForNewUser"];
                [hide_cmd performWithResult:nil];
            }
			else if (is_reg.intValue == 1) {
                id<AYCommand> show_cmd = [input.commands objectForKey:@"showEnterBtnForOldUser"];
                [show_cmd performWithResult:nil];
            }
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
    }];
    return nil;
}

- (id)AuthWithPhoneNoAndCode:(id)args {
	
	NSMutableDictionary* dic_auth = [[NSMutableDictionary alloc]init];
	[dic_auth setValue:[args objectForKey:kAYProfileArgsPhone] forKey:kAYProfileArgsPhone];
	[dic_auth setValue:self.reg_token forKey:@"reg_token"];
	[dic_auth setValue:[args objectForKey:@"code"] forKey:@"code"];
	
	AYFacade* f_auth = [self.facades objectForKey:@"LandingRemote"];
	AYRemoteCallCommand* cmd_auth = [f_auth.commands objectForKey:@"AuthPhoneCode"];
	[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_auth andArgs:[dic_auth copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//	[cmd_auth performWithResult:[dic_auth copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			
			NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithDictionary:[result objectForKey:@"user"]];
			[user setValue:[result objectForKey:kAYCommArgsAuthToken] forKey:kAYCommArgsToken];
			NSDictionary* args = [user copy];
			NSDictionary *back_result = [user copy];
			
			AYModel* m = MODEL;
			AYFacade* f = [m.facades objectForKey:@"LoginModel"];
			id<AYCommand> cmd = [f.commands objectForKey:@"ChangeRegUser"];
			[cmd performWithResult:&back_result];
			
			NSString* screen_name = [args objectForKey:@"screen_name"];
			if ([screen_name isEqualToString:@""]) {
				id<AYCommand> inputName = DEFAULTCONTROLLER(@"InputName");
				NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:3];
				[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
				[dic setValue:inputName forKey:kAYControllerActionDestinationControllerKey];
				[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
				[dic setValue:args forKey:kAYControllerChangeArgsKey];
				id<AYCommand> cmd_push = PUSH;
				[cmd_push performWithResult:&dic];
				
			} else {
				AYModel* m = MODEL;
				AYFacade* f = [m.facades objectForKey:@"LoginModel"];
				id<AYCommand> cmd = [f.commands objectForKey:@"ChangeCurrentLoginUser"];
				[cmd performWithResult:&args];
			}
			
		} else {
			NSString* msg = [result objectForKey:@"message"];
			if([msg isEqualToString:@"电话号码或者验证码出错"]) {
				NSString *title = @"动态密码输入错误";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			} else {
				NSString *title = @"验证动态密码失败，请检查网络是否正常连接";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}
	}];
	return nil;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (id)CurrentLoginUserChanged:(id)args {
    NSLog(@"Notify args: %@", args);
	
    UIViewController* cv = [Tools activityViewController];
    if (cv == self) {
        NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
        [dic_pop setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
        [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
        
        NSString* message_name = @"LoginSuccess";
        [dic_pop setValue:message_name forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = POPTOROOT;
        [cmd performWithResult:&dic_pop];
    }
    
    return nil;
}

@end

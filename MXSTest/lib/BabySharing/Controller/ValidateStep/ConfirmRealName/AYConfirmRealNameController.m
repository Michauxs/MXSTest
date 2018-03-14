//
//  AYConfirmRealNameController.m
//  BabySharing
//
//  Created by Alfred Yang on 14/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYConfirmRealNameController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"


@implementation AYConfirmRealNameController {
    UITextField *nameTextField;
    UITextField *coderTextField;
	BOOL isRightBtnEnable;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    UILabel *title = [Tools creatLabelWithText:@"实名认证" textColor:[Tools black] fontSize:622.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusAndNavBarH+28);
        make.left.equalTo(self.view).offset(20);
    }];
	
	UILabel *nameLabel = [Tools creatLabelWithText:@"姓名" textColor:[Tools black] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:nameLabel];
	[nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(title);
		make.top.equalTo(title.mas_bottom).offset(75);
	}];
	
	
	CGFloat inputTextFieldWidth = 276;
	CGFloat inputTextFieldHeight = 50;
	
    nameTextField = [[UITextField alloc]init];
    nameTextField.font = kAYFontMedium(17.f);
    nameTextField.textColor = [Tools black];
	nameTextField.delegate = self;
    [self.view addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.left.equalTo(nameLabel);
        make.size.mas_equalTo(CGSizeMake(inputTextFieldWidth, inputTextFieldHeight));
    }];
    [Tools creatCALayerWithFrame:CGRectMake(0, inputTextFieldHeight - 1, inputTextFieldWidth, 1) andColor:[Tools garyLineColor] inSuperView:nameTextField];
	
	UILabel *socialLabel = [Tools creatLabelWithText:@"身份证号" textColor:[Tools black] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:socialLabel];
	[socialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(nameLabel);
		make.top.equalTo(nameTextField.mas_bottom).offset(45);
	}];
	
    coderTextField = [[UITextField alloc]init];
    coderTextField.font = kAYFontMedium(22.f);
    coderTextField.textColor = [Tools black];
	coderTextField.delegate = self;
//	coderTextField.keyboardType = UIKeyboardTypeNumberPad;		// X
    [self.view addSubview:coderTextField];
    [coderTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(socialLabel.mas_bottom);
        make.left.equalTo(nameLabel);
        make.size.equalTo(nameTextField);
    }];
	[Tools creatCALayerWithFrame:CGRectMake(0, inputTextFieldHeight - 1, inputTextFieldWidth, 1) andColor:[Tools garyLineColor] inSuperView:coderTextField];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameOrCodeTextDidChange:) name:UITextFieldTextDidChangeNotification object:coderTextField];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameOrCodeTextDidChange:) name:UITextFieldTextDidChangeNotification object:nameTextField];
	
	UIView *loadingView = [self.views objectForKey:kValidatingView];
	[self.view bringSubviewToFront:loadingView];
	
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)nameOrCodeTextDidChange:(NSNotification*)tf {
	
	if (![nameTextField.text isEqualToString:kAYStringNull] && ![coderTextField.text isEqualToString:kAYStringNull]) {
		if (!isRightBtnEnable) {
			UIButton *btn_right = [Tools creatBtnWithTitle:@"下一步" titleColor:[Tools theme] fontSize:316 backgroundColor:nil];
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &btn_right)
			isRightBtnEnable = YES;
		}
	} else {
		UIButton *btn_right = [Tools creatBtnWithTitle:@"下一步" titleColor:[Tools RGB225GaryColor] fontSize:316 backgroundColor:nil];
		btn_right.userInteractionEnabled = NO;
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &btn_right)
		isRightBtnEnable = NO;
	}
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton *btn_right = [Tools creatBtnWithTitle:@"下一步" titleColor:[Tools RGB225GaryColor] fontSize:316 backgroundColor:nil];
	btn_right.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &btn_right)
	
    return nil;
}

- (id)ValidatingLayout:(UIView*)view {
	NSString *tip = @"身份验证中";
	kAYViewsSendMessage(kValidatingView, @"setTipContext:", &tip)
	return nil;
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
    
    if ([nameTextField.text isEqualToString:@""] || [coderTextField.text isEqualToString:@""]) {
        NSString *title = @"请完善个人信息！";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return nil;
    }
    
	NSDictionary* user = nil;
	CURRENUSER(user);
	
//	id<AYFacadeBase> f = [self.facades objectForKey:@"AuthRemote"];
//	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"PushRealName"];
//	
//	NSMutableDictionary *dic_update = [[NSMutableDictionary alloc]initWithCapacity:3];
//	[dic_update setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
//	[dic_update setValue:nameTextField.text forKey:@"real_name"];
//	[dic_update setValue:coderTextField.text forKey:@"social_id"];
	
	id<AYFacadeBase> f = [self.facades objectForKey:@"ProfileRemote"];
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"UpdateUserDetail"];
	
	NSMutableDictionary *dic_update = [[NSMutableDictionary alloc]initWithCapacity:3];
	[dic_update setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	
	NSDictionary *dic_condt = @{kAYCommArgsUserID:[user objectForKey:kAYCommArgsUserID]};
	[dic_update setValue:dic_condt forKey:kAYCommArgsCondition];
	
	NSMutableDictionary *info_profile = [[NSMutableDictionary alloc] init];
	[info_profile setValue:nameTextField.text forKey:kAYProfileArgsOwnerName];
	[info_profile setValue:[coderTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:kAYProfileArgsSocialId];
	
	[dic_update setValue:info_profile forKey:@"profile"];
	
	[self.view endEditing:YES];
	kAYViewsSendMessage(kValidatingView, @"showValidatingViewWithAnimate", nil);
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		[cmd performWithResult:[dic_update copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				
//				kAYViewsSendMessage(kValidatingView, @"hideValidatingView", nil);
				NSString *tip = @"身份验证成功";
				kAYViewsSendMessage(kValidatingView, @"changeStatusWithSuccessTip:", &tip);
				
				//save to coredata
				id<AYFacadeBase> facade = LOGINMODEL;
				id<AYCommand> cmd_profile = [facade.commands objectForKey:@"UpdateLocalCurrentUserProfile"];
	
				NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
				[dic setValue:[NSNumber numberWithInt:1] forKey:kAYProfileArgsIsProvider];
				[cmd_profile performWithResult:&dic];
				
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					id<AYCommand> des = DEFAULTCONTROLLER(@"TabBarService");
					[self exchangeWindowsWithDest:des];
				});
				
				// go on
//				AYViewController* des = DEFAULTCONTROLLER(@"ConfirmFinish");
//				NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
//				[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//				[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
//				[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//	
//				NSString *tip = @"您的信息已成功提交";
//				[dic_push setValue:tip forKey:kAYControllerChangeArgsKey];
//	
//				id<AYCommand> cmd = PUSH;
//				[cmd performWithResult:&dic_push];
				
			} else {
				AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
			}
			
		}];
	});
	
	
    return nil;
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture {
	[self.view endEditing:YES];
}
- (void)exchangeWindowsWithDest:(id)dest {
	AYViewController *des = dest;
	NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc] init];
	[dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
	[dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_exchange = [[NSMutableDictionary alloc] init];
	[dic_exchange setValue:[NSNumber numberWithInteger:3] forKey:@"index"];
	[dic_exchange setValue:[NSNumber numberWithInteger:ModeExchangeTypeUnloginToAllModel] forKey:@"type"];
	[dic_show_module setValue:dic_exchange forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = EXCHANGEWINDOWS;
	[cmd_show_module performWithResult:&dic_show_module];
	
}
#pragma mark -- UITextFiled Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if (textField == coderTextField) {
		NSString *existStr = textField.text;
		NSString *progressStr;
		if (string.length == 0) {
			progressStr = [existStr substringToIndex:existStr.length - 1];
			if ([progressStr hasSuffix:@" "]) {
				progressStr = [progressStr substringToIndex:progressStr.length - 1];
			}
		}
		else if(string.length == 1){
			if (existStr.length == 6 || existStr.length == 15) {
				progressStr = [[existStr stringByAppendingString:@" "] stringByAppendingString:string];
			} else if(existStr.length < 20) {
				progressStr = [existStr stringByAppendingString:string];
			} else
				return NO;
		}
		else {
//			TODO:copy action
		}
		textField.text = progressStr;
		[self nameOrCodeTextDidChange:nil];
		return NO;
	} else {
		return YES;
	}
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	//禁止粘贴
	if (action == @selector(paste:))
		return NO;
	return [super canPerformAction:action withSender:sender];
}

#pragma mark -- Keyboard facade
- (id)KeyboardShowKeyboard:(id)args {
	
	NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
	
	CGFloat maxY = CGRectGetMaxY(coderTextField.frame);
	CGFloat keyBoardMinY  = SCREEN_HEIGHT - step.floatValue;
	
	if (maxY > keyBoardMinY) {
		[UIView animateWithDuration:0.25f animations:^{
			self.view.frame = CGRectMake(0, -(maxY - keyBoardMinY), SCREEN_WIDTH, SCREEN_HEIGHT);
		}];
	}
	return nil;
}

- (id)KeyboardHideKeyboard:(id)args {
	
	[UIView animateWithDuration:0.25f animations:^{
		self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	}];
	return nil;
}

@end

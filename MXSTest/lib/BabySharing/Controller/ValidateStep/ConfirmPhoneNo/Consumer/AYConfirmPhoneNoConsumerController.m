//
//  AYConfirmPhoneNoConsumerController.m
//  BabySharing
//
//  Created by BM on 29/09/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYConfirmPhoneNoConsumerController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"
#import "AYModel.h"

#define TEXT_FIELD_LEFT_PADDING             10
#define TimeZore                            5
#define kPhoneNoLimit                       13

@interface AYConfirmPhoneNoConsumerController ()

@end

@implementation AYConfirmPhoneNoConsumerController {
    NSString* reg_token;
    NSDictionary* service_info;
	NSDictionary* book_info;
}

#pragma mark -- commands

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
		book_info = [dic objectForKey:kAYControllerChangeArgsKey];
		service_info = [book_info objectForKey:kAYServiceArgsInfo];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    UIView* view = [self.views objectForKey:@"ServiceConsumerFace"];
    view.backgroundColor = [UIColor clearColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kStatusAndNavBarH);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(200);
    }];
    
    UIView* inpu_view = [self.views objectForKey:@"PhoneCheckInput"];
    inpu_view.backgroundColor = [UIColor clearColor];
    [inpu_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(25);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(inpu_view.frame.size.height);
    }];
	
	UIButton *nextBtn = [Tools creatBtnWithTitle:@"提交" titleColor:[Tools whiteColor] fontSize:318.f backgroundColor:[Tools theme]];
	[Tools setViewBorder:nextBtn withRadius:22.5f andBorderWidth:0 andBorderColor:nil andBackground:[Tools theme]];
	[nextBtn addTarget:self action:@selector(rightBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:nextBtn];
	[nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(inpu_view.mas_bottom).offset(30);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(130, 45));
	}];
    
    {
        NSDictionary* user = nil;
        CURRENPROFILE(user);
        NSString* photo_name = [user objectForKey:@"screen_photo"];
       
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue:photo_name forKey:@"image"];
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
			UIImage* img = (UIImage*)result;
			
            id<AYViewBase> face_view = [self.views objectForKey:@"ServiceConsumerFace"];
            id<AYCommand> cmd = [face_view.commands objectForKey:@"lhsImage:"];
            [cmd performWithResult:&img];
        }];
    }
    
    {
		NSMutableDictionary* dic = [Tools getBaseRemoteData];
		NSString* owner_id = [[service_info objectForKey:@"owner"] objectForKey:kAYCommArgsUserID];
		[[dic objectForKey:kAYCommArgsCondition] setValue:owner_id  forKey:kAYCommArgsUserID];
        
        id<AYFacadeBase> facade = [self.facades objectForKey:@"ProfileRemote"];
        AYRemoteCallCommand* cmd = [facade.commands objectForKey:@"QueryUserProfile"];
		[cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary* result) {
			if (success) {
				NSString* photo_name = [[result objectForKey:kAYProfileArgsSelf ] objectForKey:@"screen_photo"];
				
				NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
				[dic setValue:photo_name forKey:@"image"];
				
				id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
				AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
				[cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary* result) {
					UIImage* img = (UIImage*)result;
					
					id<AYViewBase> face_view = [self.views objectForKey:@"ServiceConsumerFace"];
					id<AYCommand> cmd = [face_view.commands objectForKey:@"rhsImage:"];
					[cmd performWithResult:&img];
				}];
			} else {
			
			}
		}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor clearColor];
    
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    return nil;
}

- (id)PhoneCheckInputLayout:(UIView*)view {
    
    return nil;
}

- (id)ServiceConsumerFaceLayout:(UIView*)view {
//    view.frame = CGRectMake(0, 100, SCREEN_WIDTH, 210);
    return nil;
}

#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
    id<AYCommand> cmd = [view.commands objectForKey:@"resignFocus"];
    [cmd performWithResult:nil];
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
    
    //注销响应者防止键盘挡住底部提示
    kAYViewsSendMessage(@"PhoneCheckInput", @"resignFocus", nil)
    
    NSString* tmp = @"";
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"queryPhoneInput:"];
        [cmd performWithResult:&tmp];
    }
    
    NSString* code = @"";
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"queryCodeInput:"];
        [cmd performWithResult:&code];
    }
    
    NSDictionary* user = nil;
    CURRENUSER(user);
    id<AYFacadeBase> f = [self.facades objectForKey:@"AuthRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"CheckCode"];
    
	NSMutableDictionary *dic_check = [[NSMutableDictionary alloc] init];
	[dic_check setValue:reg_token forKey:@"reg_token"];
	[dic_check setValue:code forKey:@"code"];
	tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
	[dic_check setValue:tmp forKey:@"phone"];
	
    [cmd performWithResult:[dic_check copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            {
                id<AYFacadeBase> facade = LOGINMODEL;
                id<AYCommand> cmd = [facade.commands objectForKey:@"UpdateLocalCurrentUserProfile"];
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:tmp forKey:@"contact_no"];
                [dic setValue:[NSNumber numberWithInt:1] forKey:@"has_phone"];
                
                [cmd performWithResult:&dic];
            }
			
			dispatch_async(dispatch_get_main_queue(), ^{
				
				AYViewController* des = DEFAULTCONTROLLER(@"BOrderMain");
				NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
				[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
				[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
				[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
				[dic_push setValue:book_info forKey:kAYControllerChangeArgsKey];
				
				id<AYCommand> cmd = PUSH;
				[cmd performWithResult:&dic_push];
			});
			
        } else {
			
            NSString *title = @"验证码错误，请重试";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
    }];
    return nil;
}

- (id)setRightBtnEnabled {
	UIButton *btn_right = [Tools creatBtnWithTitle:@"下一步" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &btn_right)
	return nil;
}

#pragma mark -- actions
- (id)requeryForCode {
    
    NSString* tmp = @"";
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"queryPhoneInput:"];
        [cmd performWithResult:&tmp];
    }
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]initWithCapacity:1];
    tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dic_push setValue:tmp forKey:@"phone"];
	
	id<AYFacadeBase> f = [self.facades objectForKey:@"AuthRemote"];
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"RequireCode"];
    [cmd performWithResult:[dic_push copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            reg_token = [[result objectForKey:@"reg"] objectForKey:@"reg_token"];
            
            id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
            
            {
                id<AYCommand> cmd = [view.commands objectForKey:@"startTimer"];
                [cmd performWithResult:nil];
            }
            
            {
                id<AYCommand> cmd = [view.commands objectForKey:@"setCodeBtnTitle"];
                [cmd performWithResult:nil];
            }
            
			NSString *title = @"正在为您发送动态密码，请稍等...";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			
        } else {
            
            AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
        }
    }];
    
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"resetCodeInput"];
        [cmd performWithResult:nil];
    }
    
    return nil;
}

#pragma mark -- Keyboard facade
- (id)KeyboardShowKeyboard:(id)args {
	
	NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
	
	UIView *inputView = [self.views objectForKey:@"PhoneCheckInput"];
	CGFloat maxY = CGRectGetMaxY(inputView.frame);
	
	CGFloat keyBoardMinY  = SCREEN_HEIGHT - step.floatValue;
	
	if (maxY > keyBoardMinY) {
		
		[UIView animateWithDuration:0.25f animations:^{
			self.view.frame = CGRectMake(0, -(maxY - keyBoardMinY) - 5, SCREEN_WIDTH, SCREEN_HEIGHT);
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

//
//  AYInputCoustomController.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYInputCoustomController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYInsetLabel.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define LIMITNUMB                   18

@implementation AYInputCoustomController {
	
	UITextField *coustomField;
    NSString *coustomStr;
	
	BOOL isEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        coustomStr = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	coustomField = [[UITextField alloc] init];
	coustomField.font = [UIFont systemFontOfSize:17.f];
	coustomField.textColor = [Tools black];
	coustomField.placeholder = @"创建标签";
	coustomField.delegate = self;
	[self.view addSubview:coustomField];
	[coustomField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(20);
		make.top.equalTo(self.view).offset(84);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 20));
	}];
	if (coustomStr && coustomStr.length != 0) {
		coustomField.text = coustomStr;
	}
	
	UIView *line = [UIView new];
	line.backgroundColor = [Tools garyLineColor];
	[self.view addSubview:line];
	[line mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(coustomField);
		make.height.mas_equalTo(0.5);
		make.centerX.equalTo(self.view);
		make.top.equalTo(coustomField.mas_bottom).offset(10);
	}];
	
	self.view.userInteractionEnabled = YES;
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapElse)]];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[coustomField becomeFirstResponder];
}


#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    
    NSString *title = @"创建课程标签";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
	UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
	UIButton *btn_right = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools RGB225GaryColor] fontSize:316 backgroundColor:nil];
	btn_right.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &btn_right)
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- UITextDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (string.length != 0) {
		if (!isEnable) {
			UIButton *btn_right = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:316 backgroundColor:nil];
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &btn_right)
			isEnable = YES;
		}
	} else {
		if (textField.text.length == 1 || textField.text.length == 0) {
			if (isEnable) {
				UIButton *btn_right = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools RGB225GaryColor] fontSize:316 backgroundColor:nil];
				btn_right.userInteractionEnabled = NO;
				kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &btn_right)
				isEnable = NO;
			}
		}
	}
	return YES;
}



#pragma mark -- actions
- (void)didTapElse {
	[self.view endEditing:YES];
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

- (id)rightBtnSelected {
//	[coustomField resignFirstResponder];
	//	[coustomField resignFirstResponder];
	
	NSString *coustom = coustomField.text;
	if (coustom.length == 0) {
		return nil;
	}
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"SetServiceTheme");
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopToDestValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:coustom forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POPTODEST;
	[cmd performWithResult:&dic];
	
    return nil;
}

@end

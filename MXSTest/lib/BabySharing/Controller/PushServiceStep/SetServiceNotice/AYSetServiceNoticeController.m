//
//  AYSetServiceNoticeController.m
//  BabySharing
//
//  Created by Alfred Yang on 5/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceNoticeController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYInsetLabel.h"
#import "AYServiceArgsDefines.h"

#define LIMITNUMB                   228
#define kTableFrameY                (kStatusAndNavBarH+154)

@implementation AYSetServiceNoticeController {
	
	NSMutableDictionary *push_service_info;
	BOOL isFirstEnter;
	BOOL isValueChanged;
	
    UISwitch *isALeaveSwitch;
	UISwitch *isHealth;
	UITextView *noticeTextView;
	UILabel *placeHold;
	
	BOOL isAlreadyEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		if(![[push_service_info objectForKey:kAYServiceArgsDetailInfo] objectForKey:kAYServiceArgsAllowLeave]) {
			isFirstEnter = YES;
		}
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"服务守则" textColor:[Tools black] fontSize:630.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(kStatusAndNavBarH+20);
		make.left.equalTo(self.view).offset(20);
	}];
	
	UILabel *h1 = [Tools creatLabelWithText:@"需要家长陪同" textColor:[Tools black] fontSize:616.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:h1];
	[h1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(titleLabel.mas_bottom).offset(30);
		make.left.equalTo(titleLabel);
	}];
	
	isALeaveSwitch = [[UISwitch alloc]init];
	isALeaveSwitch.onTintColor = [Tools theme];
	//    isALeaveSwitch.transform= CGAffineTransformMakeScale(0.69, 0.69);
	[self.view addSubview:isALeaveSwitch];
	[isALeaveSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(h1);
		make.right.equalTo(self.view).offset(-20);
		make.size.mas_equalTo(CGSizeMake(49, 31));
	}];
	isALeaveSwitch.on = [[[push_service_info objectForKey:kAYServiceArgsDetailInfo] objectForKey:kAYServiceArgsAllowLeave] boolValue];
	
	UILabel *h2 = [Tools creatLabelWithText:@"需要孩子健康证明" textColor:[Tools black] fontSize:616.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:h2];
	[h2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(h1.mas_bottom).offset(30);
		make.left.equalTo(titleLabel);
	}];
	
	isHealth = [[UISwitch alloc]init];
	isHealth.onTintColor = [Tools theme];
	//    isHealth.transform= CGAffineTransformMakeScale(0.69, 0.69);
	[self.view addSubview:isHealth];
	[isHealth mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(h2);
		make.right.equalTo(self.view).offset(-20);
		make.size.mas_equalTo(CGSizeMake(49, 31));
	}];
	isHealth.on = [[[push_service_info objectForKey:kAYServiceArgsDetailInfo] objectForKey:kAYServiceArgsIsHealth] boolValue];;
	
	[isALeaveSwitch addTarget:self action:@selector(didSwithClick) forControlEvents:UIControlEventValueChanged];
	[isHealth addTarget:self action:@selector(didSwithClick) forControlEvents:UIControlEventValueChanged];
	
	UIView *lineView = [[UIView alloc] init];
	lineView.backgroundColor = [Tools garyLineColor];
	[self.view addSubview:lineView];
	[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(h2.mas_bottom).offset(25);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 0.5));
	}];
	
	UILabel *otherLabel = [Tools creatLabelWithText:@"更多守则" textColor:[Tools black] fontSize:616.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:otherLabel];
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(lineView.mas_bottom).offset(20);
		make.left.equalTo(titleLabel);
    }];
	
	noticeTextView = [[UITextView alloc] init];
	noticeTextView.font = [UIFont systemFontOfSize:15];
	noticeTextView.textColor = [Tools black];
	noticeTextView.scrollEnabled = NO;
	[noticeTextView setContentInset:UIEdgeInsetsMake(-5, -3, -5, -3)];
	noticeTextView.delegate = self;
	[self.view addSubview:noticeTextView];
	[noticeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(otherLabel.mas_bottom).offset(20);
		make.left.equalTo(titleLabel);
		make.right.equalTo(self.view).offset(-20);
	}];
	
	placeHold = [Tools creatLabelWithText:@"请输入" textColor:[Tools garyColor] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:placeHold];
	[placeHold mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(noticeTextView).offset(2);
		make.top.equalTo(noticeTextView).offset(2);
	}];
	
	NSString *notice = [[push_service_info objectForKey:kAYServiceArgsDetailInfo] objectForKey:kAYServiceArgsNotice];
	if (notice.length != 0) {
		placeHold.hidden = YES;
		noticeTextView.text = notice;
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(@"FakeNavBar", @"setLeftBtnImg:", &left)
	
//	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:616.f andBackgroundColor:nil];
	UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:616.f backgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kTableFrameY, SCREEN_WIDTH, SCREEN_HEIGHT - kTableFrameY);
    return nil;
}

- (void)textViewDidChange:(UITextView *)textView {
	if (textView.text.length != 0) {
		placeHold.hidden = YES;
		[self setNavRightBtnEnableStatus];
	} else {
		placeHold.hidden = NO;
		
		if (!isValueChanged) {
			UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:616.f backgroundColor:nil];
			bar_right_btn.userInteractionEnabled = NO;
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
			isAlreadyEnable = NO;
		}
	}
}

#pragma mark -- actions
- (void)didSwithClick {
	isValueChanged = YES;
	[self setNavRightBtnEnableStatus];
}

- (void)setNavRightBtnEnableStatus {
	isFirstEnter = NO;
	if (!isAlreadyEnable) {
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
		kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = YES;
	}
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	if (isFirstEnter) {
		NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
		[dic_info setValue:[NSNumber numberWithBool:isALeaveSwitch.on] forKey:kAYServiceArgsAllowLeave];
		[dic_info setValue:[NSNumber numberWithBool:isHealth.on] forKey:kAYServiceArgsIsHealth];
		[dic_info setValue:@"part_notice" forKey:@"key"];
		[dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
	}
	
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    //整合数据
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
	[dic_info setValue:[NSNumber numberWithBool:isHealth.on] forKey:kAYServiceArgsIsHealth];
	[dic_info setValue:[NSNumber numberWithBool:isALeaveSwitch.on] forKey:kAYServiceArgsAllowLeave];
	[dic_info setValue:noticeTextView.text forKey:kAYServiceArgsNotice];
	[dic_info setValue:@"part_notice" forKey:@"key"];
	
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

@end

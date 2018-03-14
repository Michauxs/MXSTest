//
//  AYInputNapTitleController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYInputNapTitleController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYInsetLabel.h"

#define LIMITNUMB                   24

@implementation AYInputNapTitleController {
    UITextView *inputTitleTextView;
	UILabel *placeHolder;
//    UILabel *countlabel;
	
	NSString *setedTitleStr;
	NSMutableDictionary *service_info;
	
    BOOL isAlreadyEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        service_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"Servant' Servcie" textColor:[Tools black] fontSize:622.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	NSDictionary *profile;
	CURRENPROFILE(profile);
	NSString *name = [profile objectForKey:kAYProfileArgsScreenName];
	
	NSDictionary *info_categ = [service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *cat = [info_categ objectForKey:kAYServiceArgsCat];
	NSString *titleStr;
	if ([cat isEqualToString:kAYStringNursery]) {
		NSString *cat_secondary = [info_categ objectForKey:kAYServiceArgsCatSecondary];
		titleStr = [NSString stringWithFormat:@"%@的%@",name, cat_secondary];
	} else if([cat isEqualToString:kAYStringCourse]){
		NSString *cat_thirdly = [info_categ objectForKey:kAYServiceArgsCourseCoustom];
		if (cat_thirdly.length == 0) {
			cat_thirdly = [info_categ objectForKey:kAYServiceArgsCatThirdly];
		}
		titleStr = [NSString stringWithFormat:@"%@的%@%@",name, cat_thirdly, cat];
	}
	titleLabel.text = titleStr;
	
	[Tools creatCALayerWithFrame:CGRectMake(20, 125, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
	
    inputTitleTextView = [[UITextView alloc]init];
    [self.view addSubview:inputTitleTextView];
    inputTitleTextView.font = [UIFont systemFontOfSize:15.f];
    inputTitleTextView.textColor = [Tools black];
    inputTitleTextView.delegate = self;
    [inputTitleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 90));
    }];
	placeHolder = [Tools creatLabelWithText:@"请用一句话来描述您的服务" textColor:[Tools garyColor] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[inputTitleTextView addSubview:placeHolder];
	[placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(inputTitleTextView).offset(5);
		make.top.equalTo(inputTitleTextView).offset(8);
	}];
	
//    countlabel = [Tools creatUILabelWithText:[NSString stringWithFormat:@"还可以输入%d个字符",LIMITNUMB] andTextColor:[Tools themeColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:0];
//    [self.view addSubview:countlabel];
//    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(inputTitleTextView.mas_bottom).offset(-10);
//        make.right.equalTo(inputTitleTextView).offset(-10);
//    }];
	
	if (setedTitleStr && ![setedTitleStr isEqualToString:@""]) {
		inputTitleTextView.text = setedTitleStr;
//		countlabel.text = [NSString stringWithFormat:@"还可以输入%d个字符",LIMITNUMB - (int)setedTitleStr.length];
		placeHolder.hidden = YES;
	}
	
	self.view.userInteractionEnabled = YES;
	UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere)];
	[self.view addGestureRecognizer:tap];
	
	[inputTitleTextView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)tapElseWhere {
	[inputTitleTextView resignFirstResponder];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    
//    NSString *title = @"标题";
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
    UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"下一步" titleColor:[Tools garyColor] fontSize:616.f backgroundColor:nil];
    bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- UITextDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = textView.text.length;
	
	if (count != 0) {
		placeHolder.hidden = YES;
		if (!isAlreadyEnable) {
			UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"下一步" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
			isAlreadyEnable = YES;
		}
	} else {
		
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"下一步" titleColor:[Tools garyColor] fontSize:616.f backgroundColor:nil];
		bar_right_btn.userInteractionEnabled = NO;
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = NO;
	}
	
    if (count > LIMITNUMB) {
        inputTitleTextView.text = [textView.text substringToIndex:LIMITNUMB];
    }
//    countlabel.text = [NSString stringWithFormat:@"还可以输入%ld个字符",(LIMITNUMB - count)>=0?(LIMITNUMB - count):0];
}

#pragma mark -- actions
- (void)didCourseSignLabelTap {
    
//    if (((NSNumber*)[titleAndCourseSignInfo objectForKey:kAYServiceArgsCatSecondary]).intValue == -1) {
//        kAYUIAlertView(@"提示", @"您需要重新设置服务主题，才能进行服务标签设置");
//        return;
//    }
//    
//    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetCourseSign");
//    
//    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
//    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
//    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//    
//    [dic_push setValue:titleAndCourseSignInfo forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd = PUSH;
//    [cmd performWithResult:&dic_push];
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
	
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
//    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//	
//	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
//	[tmp setValue:kAYServiceArgsTitle forKey:@"key"];
//	
//    if (![inputTitleTextView.text isEqualToString:@""]) {
//        [tmp setValue:inputTitleTextView.text forKey:kAYServiceArgsTitle];
//    }
//    [dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd = POP;
//    [cmd performWithResult:&dic];
	
	[service_info setValue:inputTitleTextView.text forKey:kAYServiceArgsTitle];
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"PushServiceMain");
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_push setValue:service_info forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	
    return nil;
}

#pragma mark -- Keyboard facade
- (id)KeyboardShowKeyboard:(id)args {
	
//	NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
//	[countlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//		make.bottom.equalTo(self.view).offset(- step.floatValue - 10);
//		make.right.equalTo(self.view).offset(-20);
//	}];
	
	return nil;
}

- (id)KeyboardHideKeyboard:(id)args {
	
	return nil;
}
@end

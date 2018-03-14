//
//  AYOtherNoticeTextController.m
//  BabySharing
//
//  Created by Alfred Yang on 6/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOtherNoticeTextController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYServiceArgsDefines.h"

#define LIMITNUMB                   88

@implementation AYOtherNoticeTextController {
    UITextView *descTextView;
	UILabel *placeHolder;
	
    UILabel *countlabel;
    NSString *setedStr;
	BOOL isAlreadyEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        setedStr = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"其他守则" textColor:[Tools theme] fontSize:620.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	[Tools creatCALayerWithFrame:CGRectMake(20, 115, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
	
    descTextView = [[UITextView alloc]init];
    [self.view addSubview:descTextView];
    descTextView.font = [UIFont systemFontOfSize:14.f];
    descTextView.textColor = [Tools black];
    descTextView.delegate = self;
    [descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(84);
		make.top.equalTo(titleLabel.mas_bottom).offset(30);
		make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 200));
    }];
	
	placeHolder = [Tools creatLabelWithText:@"其他要求告知家长的需要" textColor:[Tools garyColor] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[descTextView addSubview:placeHolder];
	[placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(descTextView).offset(5);
		make.top.equalTo(descTextView).offset(8);
	}];
	
	if (setedStr && ![setedStr isEqualToString:@""]) {
		descTextView.text = setedStr;
		placeHolder.hidden  = YES;
	}
	
    countlabel = [Tools creatLabelWithText:[NSString stringWithFormat:@"还可以输入%lu个字符",LIMITNUMB - setedStr.length] textColor:[Tools theme] fontSize:12.f backgroundColor:nil textAlignment:0];
    [self.view addSubview:countlabel];
    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(descTextView.mas_bottom).offset(-10);
        make.right.equalTo(descTextView).offset(-10);
    }];
	
	[descTextView becomeFirstResponder];
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
    
//    NSString *title = @"其他守则";
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:16.f backgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- UITextDelegate
- (void)textViewDidChange:(UITextView *)textView {
	NSInteger count = textView.text.length;
	placeHolder.hidden = count != 0;
	
	if (!isAlreadyEnable) {
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:16.f backgroundColor:nil];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = YES;
	}
	
    if (count > LIMITNUMB) {
        descTextView.text = [textView.text substringToIndex:LIMITNUMB];
    }
    countlabel.text = [NSString stringWithFormat:@"还可以输入%ld个字符",(LIMITNUMB - count) >= 0 ? (LIMITNUMB - count) : 0];
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
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:descTextView.text forKey:kAYServiceArgsNotice];
    [dic_info setValue:kAYServiceArgsNotice forKey:@"key"];
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    [descTextView resignFirstResponder];
    return nil;
}

#pragma mark -- Keyboard facade
- (id)KeyboardShowKeyboard:(id)args {
	
	NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
	[countlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(- step.floatValue - 10);
		make.right.equalTo(self.view).offset(-20);
	}];
	
	return nil;
}

- (id)KeyboardHideKeyboard:(id)args {
	
	return nil;
}

@end

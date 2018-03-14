//
//  AYSetServiceNoticeController.m
//  BabySharing
//
//  Created by Alfred Yang on 5/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceOptInfoController.h"
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
#define kTableFrameY                218

@implementation AYSetServiceOptInfoController {
    
    NSString *setedNoticeStr;
    BOOL isAllowLeave;
    
    UIButton *optionBtn;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *notice_args = [dic objectForKey:kAYControllerChangeArgsKey];
        setedNoticeStr = [notice_args objectForKey:kAYServiceArgsNotice];
        isAllowLeave = ((NSNumber*)[notice_args objectForKey:kAYServiceArgsAllowLeave]).boolValue;
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary *notice_args = [dic objectForKey:kAYControllerChangeArgsKey];
        setedNoticeStr = [notice_args objectForKey:kAYServiceArgsNotice];
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    AYInsetLabel *h1 = [[AYInsetLabel alloc]initWithTitle:@"需要家长陪同" andTextColor:[Tools black] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    h1.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.view addSubview:h1];
    [h1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(124);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 42));
    }];
    
    optionBtn = [[UIButton alloc]init];
    [optionBtn setImage:IMGRESOURCE(@"tab_home") forState:UIControlStateNormal];
    [optionBtn setImage:IMGRESOURCE(@"tab_home_selected") forState:UIControlStateSelected];
    [self.view addSubview:optionBtn];
    [optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(h1);
        make.right.equalTo(h1).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 40));
    }];
    
    optionBtn.selected = isAllowLeave;
    [optionBtn addTarget:self action:@selector(didYesBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    AYInsetLabel *h2 = [[AYInsetLabel alloc]initWithTitle:@"其他守则" andTextColor:[Tools black] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    h2.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.view addSubview:h2];
    [h2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(h1.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 42));
    }];
    h2.userInteractionEnabled = YES;
    [h2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didOtherNoticeTap)]];
    
    UIImageView *access = [[UIImageView alloc]init];
    [self.view addSubview:access];
    access.image = IMGRESOURCE(@"plan_time_icon");
    [access mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(h2.mas_right).offset(-15);
        make.centerY.equalTo(h2);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
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
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"《服务守则》";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
//    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
//    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
//    [cmd_right performWithResult:&bar_right_btn];
    
    NSNumber *is_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kTableFrameY, SCREEN_WIDTH, SCREEN_HEIGHT - kTableFrameY);
    return nil;
}

#pragma mark -- actions
- (void)didYesBtnClick {
    optionBtn.selected = !optionBtn.selected;
}

- (void)didOtherNoticeTap {
    
    id<AYCommand> dest = DEFAULTCONTROLLER(@"OtherNoticeText");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:setedNoticeStr forKey:kAYControllerChangeArgsKey];
//    [dic_push setValue:[napBabyArgsInfo copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:[NSNumber numberWithBool:optionBtn.selected] forKey:kAYServiceArgsAllowLeave];
    [dic_info setValue:setedNoticeStr forKey:kAYServiceArgsNotice];
    [dic_info setValue:kAYServiceArgsNotice forKey:@"key"];
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
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
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

@end

//
//  AYRejectOrderController.m
//  BabySharing
//
//  Created by Alfred Yang on 18/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYRejectOrderController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "AYDongDaSegDefines.h"
//#import "AYSearchDefines.h"

#define LIMITNUMB                   88

@interface AYRejectOrderController () <UITextViewDelegate>

@end

@implementation AYRejectOrderController {
    
    NSDictionary *order_info;
    
    UITextView *seasonOfTextView;
    UILabel *placeholderLabel;
    
    UILabel *countLabel;
}

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        order_info = [dic objectForKey:kAYControllerChangeArgsKey];
        //        NSLog(@"%@",order_info);
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools darkBackgroundColor];
    
    UILabel *tipsLabel = [Tools creatLabelWithText:@"确认拒绝订单" textColor:[UIColor whiteColor] fontSize:16.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(150);
        make.centerX.equalTo(self.view);
    }];
    
    UIView *seprator = [UIView new];
    seprator.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:seprator];
    [seprator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 1));
    }];
    
    seasonOfTextView = [[UITextView alloc]init];
    [self.view addSubview:seasonOfTextView];
    seasonOfTextView.scrollEnabled = NO;
    seasonOfTextView.showsHorizontalScrollIndicator = NO;
    seasonOfTextView.font = kAYFontLight(14.f);
    seasonOfTextView.textColor = [Tools black];
    seasonOfTextView.contentInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    seasonOfTextView.delegate = self;
    [seasonOfTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(seprator.mas_bottom).offset(15);
        make.width.equalTo(seprator);
        make.height.mas_equalTo(120);
    }];
    
    placeholderLabel = [Tools creatLabelWithText:@"您拒绝的理由？" textColor:[Tools garyColor] fontSize:13.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:placeholderLabel];
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seasonOfTextView).offset(7);
        make.left.equalTo(seasonOfTextView).offset(7);
    }];
	
    countLabel = [Tools creatLabelWithText:@"还可以输入88个字符" textColor:[Tools garyColor] fontSize:13.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
    [self.view addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(seasonOfTextView).offset(-10);
        make.right.equalTo(seasonOfTextView).offset(-10);
    }];
    
    UIButton *rejectBtn = [[UIButton alloc]init];
    [self.view addSubview:rejectBtn];
    rejectBtn.backgroundColor = [Tools theme];
    [rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    rejectBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    rejectBtn.layer.borderWidth = 1.f;
//    rejectBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seasonOfTextView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.width.equalTo(seprator);
        make.height.mas_equalTo(44);
    }];
    [rejectBtn addTarget:self action:@selector(didConfirmRejectBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, 54);
    view.backgroundColor = [UIColor clearColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    //    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    //    NSString *title = @"待确认订单";
    //    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"content_close_white");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    //    id<AYCommand> cmd_bot = [bar.commands objectForKey:@"setBarBotLine"];
    //    [cmd_bot performWithResult:nil];
    
    return nil;
}

#pragma mark -- textViewDelegate
//- (BOOL)text

- (void)textViewDidChange:(UITextView *)textView {
    long length = textView.text.length;
    if (length != 0) {
        placeholderLabel.hidden = YES;
    } else placeholderLabel.hidden = NO;
    
    if (length > LIMITNUMB) {
        textView.text = [textView.text substringToIndex:LIMITNUMB];
    }
    
    countLabel.text = [NSString stringWithFormat:@"还可以输入个%lu字符", LIMITNUMB - textView.text.length];
    
}

#pragma mark -- actions
- (void)didConfirmRejectBtnClick {
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_reject = [facade.commands objectForKey:@"RejectOrder"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setValue:[order_info objectForKey:@"user_id"] forKey:@"user_id"];
    [dic setValue:[order_info objectForKey:@"order_id"] forKey:@"order_id"];
    [dic setValue:[order_info objectForKey:@"owner_id"] forKey:@"owner_id"];
    [dic setValue:[order_info objectForKey:@"service_id"] forKey:@"service_id"];
    [dic setValue:seasonOfTextView.text forKey:@"further_message"];
    
    [cmd_reject performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            
            NSString *title = @"已拒绝日程";
            [self popToRootVCWithTip:title];
        } else {
            
        }
    }];
}

- (void)popToRootVCWithTip:(NSString*)tip {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:tip forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic];
    
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

@end

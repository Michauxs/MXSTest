//
//  AYConfirmSNSController.m
//  BabySharing
//
//  Created by Alfred Yang on 14/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYConfirmSNSController.h"
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


@interface AYConfirmSNSController ()

@end

@implementation AYConfirmSNSController {
    NSMutableArray *loading_status;
    
    UITextField *phoneTextField;
    UITextField *coderTextField;
    
    NSString* reg_token;
}

- (void)postPerform{
    
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    UILabel *title = [Tools creatLabelWithText:@"确认社交账号" textColor:[Tools black] fontSize:16.f backgroundColor:nil textAlignment:1];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(160);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *descLabel = [Tools creatLabelWithText:@"链接您的社交账号\n完成我们的线上验证" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:1];
    descLabel.numberOfLines = 2;
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(20);
        make.centerX.equalTo(title);
    }];
    
    UIButton *weiboBtn = [[UIButton alloc]init];
    [self.view addSubview:weiboBtn];
    [weiboBtn setTitleColor:[Tools garyColor] forState:UIControlStateNormal];
    [weiboBtn setTitle:@"微博链接" forState:UIControlStateNormal];
    weiboBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    [weiboBtn addTarget:self action:@selector(didWeiboBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *weiChatBtn = [[UIButton alloc]init];
    [self.view addSubview:weiChatBtn];
    [weiChatBtn setTitleColor:[Tools garyColor] forState:UIControlStateNormal];
    [weiChatBtn setTitle:@"微信链接" forState:UIControlStateNormal];
    weiChatBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [weiChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weiboBtn.mas_bottom).offset(20);
        make.centerX.equalTo(weiboBtn);
        make.size.equalTo(weiboBtn);
    }];
    [weiChatBtn addTarget:self action:@selector(didWeiChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *QQBtn = [[UIButton alloc]init];
    [self.view addSubview:QQBtn];
    [QQBtn setTitleColor:[Tools garyColor] forState:UIControlStateNormal];
    [QQBtn setTitle:@"QQ链接" forState:UIControlStateNormal];
    QQBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weiChatBtn.mas_bottom).offset(20);
        make.centerX.equalTo(weiboBtn);
        make.size.equalTo(weiboBtn);
    }];
    [QQBtn addTarget:self action:@selector(didQQBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 20, width, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.f] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"完成" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(width - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, 44 - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"验证您的身份";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

#pragma mark -- actions
-(void)didWeiboBtnClick:(UIButton*)btn{

    
}
-(void)didWeiChatBtnClick:(UIButton*)btn{
    
}
-(void)didQQBtnClick:(UIButton*)btn{
    
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

    return nil;
}

@end

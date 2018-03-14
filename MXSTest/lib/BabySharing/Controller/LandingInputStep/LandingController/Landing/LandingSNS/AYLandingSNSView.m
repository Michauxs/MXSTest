//
//  AYLandingSNSView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingSNSView.h"
#import "AYCommandDefines.h"
#import "AYControllerBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"

#define BASICMARGIN     8

#define KSCREENW                    [UIScreen mainScreen].bounds.size.width
#define KSCREENH                    [UIScreen mainScreen].bounds.size.height

#define SNS_BUTTON_WIDTH                    36
#define SNS_BUTTON_HEIGHT                   SNS_BUTTON_WIDTH

#define SNS_BUTTON_MARGIN                   50

#define SNS_WECHAT                          0
#define SNS_QQ                              1
#define SNS_WEIBO                           2

#define SNS_COUNT                           3
#define INPUT_MARGIN                        32.5
#define MARGIN_MODIFY                       5

@implementation AYLandingSNSView {
    UIView* split_img;
    NSArray* sns_btns;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.bounds = CGRectMake(0, 0, KSCREENW, 106);
    
    /****** *****/
    UILabel *or = [[UILabel alloc]init];
    or.backgroundColor = [UIColor clearColor];
    or.text = @"第三方社交账号登陆";
    or.font = [UIFont systemFontOfSize:10.f];
    or.textColor = [UIColor whiteColor];
    or.textAlignment = NSTextAlignmentCenter;
    [self addSubview:or];
    
    [or mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(37.5);
        make.right.equalTo(self).offset(-37.5);
        make.height.mas_equalTo(10);
    }];
    
    CALayer* left_line = [[CALayer alloc]init];
    left_line.backgroundColor = [UIColor whiteColor].CGColor;
    left_line.frame = CGRectMake(0, 5, (KSCREENW - 2*37.5 - 124)/2, 1);
    [or.layer addSublayer:left_line];
    CALayer* right_line = [[CALayer alloc]init];
    right_line.backgroundColor = [UIColor whiteColor].CGColor;
    right_line.frame = CGRectMake((KSCREENW - 2*37.5 - 124)/2 + 124, 5, (KSCREENW - 2*37.5 - 124)/2, 1);
    [or.layer addSublayer:right_line];
    
    UIButton* wechat_btn = [[UIButton alloc]init];
    [self addSubview:wechat_btn];
    [wechat_btn setBackgroundImage:PNGRESOURCE(@"wechat_icon") forState:UIControlStateNormal];
    [wechat_btn addTarget:self action:@selector(wechatBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    wechat_btn.backgroundColor = [UIColor clearColor];
    wechat_btn.clipsToBounds = YES;
    [wechat_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
//        make.bottom.equalTo(self).offset(-24);
        make.centerY.equalTo(self).offset(2);
        make.width.mas_offset(SNS_BUTTON_WIDTH);
        make.height.mas_offset(SNS_BUTTON_HEIGHT);
    }];
    
    UIButton* qq_btn = [[UIButton alloc]init];
    [qq_btn setBackgroundImage:PNGRESOURCE(@"qq_icon") forState:UIControlStateNormal];
    [qq_btn addTarget:self action:@selector(qqBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    qq_btn.backgroundColor = [UIColor clearColor];
    [self addSubview:qq_btn];
    [qq_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wechat_btn.mas_left).offset(-SNS_BUTTON_MARGIN);
        make.centerY.equalTo(wechat_btn);
        make.size.equalTo(wechat_btn);
    }];
    
    UIButton* weibo_btn = [[UIButton alloc]init];
    [weibo_btn setBackgroundImage:PNGRESOURCE(@"weibo_icon") forState:UIControlStateNormal];
    [weibo_btn addTarget:self action:@selector(weiboBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    weibo_btn.backgroundColor = [UIColor clearColor];
    [self addSubview:weibo_btn];
    [weibo_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wechat_btn.mas_right).offset(SNS_BUTTON_MARGIN);
        make.centerY.equalTo(wechat_btn);
        make.size.equalTo(wechat_btn);
    }];
    
    CALayer* bottom = [[CALayer alloc]init];
    bottom.backgroundColor = [UIColor whiteColor].CGColor;
    bottom.frame = CGRectMake(37.5, self.bounds.size.height - 1, KSCREENW - 2*37.5, 1);
    [self.layer addSublayer:bottom];
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (void)qqBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:@"SNSQQ" andMessage:@"LoginSNSWithQQ" andArgs:nil];
}

- (void)weiboBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:@"SNSWeibo" andMessage:@"LoginSNSWithWeibo" andArgs:nil];
}

- (void)wechatBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:@"SNSWechat" andMessage:@"LoginSNSWithWechat" andArgs:nil];
}
@end

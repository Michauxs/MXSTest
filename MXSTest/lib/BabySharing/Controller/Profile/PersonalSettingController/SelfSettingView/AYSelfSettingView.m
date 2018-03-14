//
//  AYSelfSettingView.m
//  BabySharing
//
//  Created by Alfred Yang on 7/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSelfSettingView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewController.h"
#import "Tools.h"

@implementation AYSelfSettingView{
    UITextField *user_name;
    UILabel *address;
    UILabel *boby;
    UILabel *registTime;
}
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	
    UILabel *nameLabel = [Tools creatLabelWithText:@"姓名" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:0];
	[self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.left.equalTo(self).offset(15);
    }];
    
    user_name = [[UITextField alloc]init];
    [self addSubview:user_name];
    user_name.text = @"姓名";
    user_name.clearButtonMode = UITextFieldViewModeWhileEditing;
    user_name.placeholder = @"请输入姓名";
    user_name.font = [UIFont systemFontOfSize:14.f];
    user_name.textColor = [Tools black];
    user_name.delegate = self;
    [user_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.left.equalTo(self).offset(90);
        make.right.equalTo(self);
    }];
    
    UIView *line01 = [[UIView alloc]init];
    [self addSubview:line01];
    line01.backgroundColor = [UIColor lightGrayColor];
    [line01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    /*********/
    
    UILabel *addressLabel = [Tools creatLabelWithText:@"所在城市" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:0];
	[self addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line01.mas_bottom).offset(25);
        make.left.equalTo(self).offset(15);
    }];
    
    address = [[UILabel alloc]init];
    [self addSubview:address];
//    address.clearButtonMode = UITextFieldViewModeWhileEditing;
//    address.placeholder = @"请输入地址";
    address.font = [UIFont systemFontOfSize:14.f];
    address.textColor = [Tools black];
//    address.delegate = self;
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressLabel);
        make.left.equalTo(user_name);
        make.right.equalTo(self);
    }];
    
    address.userInteractionEnabled = YES;
    [address addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddressLabelTap:)]];
    
    UIView *line02 = [[UIView alloc]init];
    [self addSubview:line02];
    line02.backgroundColor = [UIColor lightGrayColor];
    [line02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLabel.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    /*********/
    
    UILabel *bobyLabel = [Tools creatLabelWithText:@"宝宝信息" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:0];
	[self addSubview:bobyLabel];
    [bobyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line02.mas_bottom).offset(25);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(14);
    }];
	
    boby = [Tools creatLabelWithText:@"2岁9个月男宝宝，2岁9个月男宝宝，2岁9个月男宝宝" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:0];
	[self addSubview:boby];
    boby.numberOfLines = 0;
    [boby mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bobyLabel);
        make.left.equalTo(self).offset(90);
        make.right.equalTo(self).offset(-50);
    }];
    boby.userInteractionEnabled = YES;
    [boby addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bobySet:)]];
    
    UIImageView *nextIcon = [[UIImageView alloc]init];
    [self addSubview:nextIcon];
    nextIcon.image = IMGRESOURCE(@"chan_group_back");
    [nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bobyLabel);
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    nextIcon.userInteractionEnabled = YES;
    [nextIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bobySet:)]];
    
    UIView *line03 = [[UIView alloc]init];
    [self addSubview:line03];
    line03.backgroundColor = [UIColor lightGrayColor];
    [line03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boby.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    /*********/

    UILabel *timeLabel = [Tools creatLabelWithText:@"注册时间" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:0];
	[self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line03.mas_bottom).offset(25);
        make.left.equalTo(self).offset(15);
    }];
	
    registTime = [Tools creatLabelWithText:@"2016.6.12" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:0];
	[self addSubview:registTime];
    [registTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(self).offset(90);
    }];
    
    UIView *line04 = [[UIView alloc]init];
    [self addSubview:line04];
    line04.backgroundColor = [UIColor lightGrayColor];
    [line04 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    /*********/
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

#pragma mark -- UITextFiledDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {

    NSString *text = nil;
    id<AYCommand> cmd = nil;
    
    if (textField == user_name) {
        cmd = [self.notifies objectForKey:@"screenNameChanged:"];
        text = user_name.text;
    } else {
        cmd = [self.notifies objectForKey:@"addressChanged:"];
        text = address.text;
    }
    [cmd performWithResult:&text];
}

#pragma mark -- actions
-(void)bobySet:(UIGestureRecognizer*)tap{
    NSLog(@"BabyInfo view controller");
    id<AYCommand> setting = DEFAULTCONTROLLER(@"BabyInfo");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)didAddressLabelTap:(UITapGestureRecognizer*)tap{
    id<AYCommand> cmd = [self.notifies objectForKey:@"showPickerView"];
    [cmd performWithResult:nil];
}

#pragma mark -- notifies
- (id)setPersonalInfo:(NSDictionary*)args {
    user_name.text = [args objectForKey:@"screen_name"];
    NSString *adr = [args objectForKey:@"address"];
    address.text = (adr && ![adr isEqualToString:@""]) ? adr : @"点击设置";
    
    return  nil;
}

- (id)hideKeyboard {
    if ([user_name isFirstResponder]) {
        [user_name resignFirstResponder];
    }
    if ([address isFirstResponder]) {
        [address resignFirstResponder];
    }
    return nil;
}

- (id)changeAdrss:(NSString*)args{
    address.text = args;
    return nil;
}
@end

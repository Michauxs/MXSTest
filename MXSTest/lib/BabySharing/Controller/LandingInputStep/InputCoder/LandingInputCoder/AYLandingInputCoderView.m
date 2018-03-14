//
//  AYLandingInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingInputCoderView.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"
#import "AYControllerBase.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYFactoryManager.h"
#import "AYAlertView.h"

#define TEXT_FIELD_LEFT_PADDING             10
#define TimeZore                            60
#define kPhoneNoLimit                       13

@implementation AYLandingInputCoderView {
    
    NSTimer* timer;
    NSInteger seconds;
    
    /**/
    UILabel *inputArea;
	UITextField *inputPhoneNo;
	UIImageView *checkIcon;
	
//    UIView *inputCodeView;
    UITextField *coder_area;
	
    UIButton *getCodeBtn;
    UIButton *enterBtn;
	UIButton *nextBtn;
    
    BOOL isNewUser;
	BOOL isAlreadyreReqCode;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	
    UILabel *tips = [Tools creatLabelWithText:@"您的手机号码？" textColor:[Tools theme] fontSize:20.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
    
    /* 电话号码 */
    UIView *inputPhoneNoView = [[UIView alloc]init];
    [self addSubview:inputPhoneNoView];
	CGFloat phoneBgHeight = 60;
    [inputPhoneNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tips.mas_bottom).offset(15);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(phoneBgHeight);
    }];
	[Tools creatCALayerWithFrame:CGRectMake(0, phoneBgHeight - 0.5, SCREEN_WIDTH - 50, 0.5) andColor:[Tools theme] inSuperView:inputPhoneNoView];
	
    UILabel *phoneNo = [Tools creatLabelWithText:@"+ 86" textColor:[Tools whiteColor] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:phoneNo withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools theme]];
    [inputPhoneNoView addSubview:phoneNo];
    [phoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputPhoneNoView);
        make.left.equalTo(inputPhoneNoView);
        make.size.mas_equalTo(CGSizeMake(60, 35));
    }];
	
	checkIcon = [[UIImageView alloc]init];
	checkIcon.image = IMGRESOURCE(@"checked_icon_iphone");
	[inputPhoneNoView addSubview:checkIcon];
	[checkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(inputPhoneNoView);
		make.centerY.equalTo(inputPhoneNoView);
		make.size.mas_equalTo(CGSizeMake(18, 14));
	}];
	checkIcon.hidden = YES;
	
    inputPhoneNo = [[UITextField alloc]init];
    inputPhoneNo.delegate = self;
    inputPhoneNo.backgroundColor = [UIColor clearColor];
    inputPhoneNo.font = [UIFont boldSystemFontOfSize:18.f];
    inputPhoneNo.textColor = [Tools theme];
    inputPhoneNo.keyboardType = UIKeyboardTypeNumberPad;
//    inputPhoneNo.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputPhoneNo.placeholder = @"手机号码";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:inputPhoneNo];
    [inputPhoneNoView addSubview:inputPhoneNo];
    [inputPhoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(phoneNo.mas_right).offset(15);
        make.right.equalTo(checkIcon.mas_left).offset(-10);
        make.centerY.equalTo(inputPhoneNoView);
        make.height.equalTo(@34);
    }];
    
    /* 验证码 */
    UIView *inputCodeView = [[UIView alloc]init];
    [self addSubview:inputCodeView];
    [inputCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputPhoneNoView.mas_bottom).offset(15);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(phoneBgHeight);
    }];
    [Tools creatCALayerWithFrame:CGRectMake(0, phoneBgHeight - 0.5, SCREEN_WIDTH - 50, 0.5) andColor:[Tools theme] inSuperView:inputCodeView];
	
	coder_area = [[UITextField alloc]init];
	coder_area.backgroundColor = [UIColor clearColor];
	coder_area.font = [UIFont boldSystemFontOfSize:18.f];
	coder_area.textColor = [Tools theme];
	coder_area.keyboardType = UIKeyboardTypeNumberPad;
    coder_area.delegate = self;
    coder_area.placeholder = @"动态密码";
    [inputCodeView addSubview:coder_area];
    [coder_area mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(inputCodeView).offset(10);
        make.right.equalTo(inputCodeView).offset(-150);
        make.centerY.equalTo(inputCodeView);
        make.height.equalTo(inputCodeView);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:coder_area];
    
    /* 重新获取coder */
    getCodeBtn = [[UIButton alloc]init];
    [getCodeBtn setTitle:@"获取动态密码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[Tools theme] forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[Tools garyColor] forState:UIControlStateDisabled];
    getCodeBtn.enabled = NO;
    getCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
//    getCodeBtn.layer.cornerRadius = 2.f;
//    getCodeBtn.clipsToBounds = YES;
    [getCodeBtn addTarget:self action:@selector(getcodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [inputCodeView addSubview:getCodeBtn];
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(inputCodeView);
        make.size.mas_equalTo(CGSizeMake(110, 42));
    }];
    
    
	enterBtn = [Tools creatBtnWithTitle:@"进入咚哒" titleColor:[Tools whiteColor] fontSize:318.f backgroundColor:[Tools theme]];
	[Tools setViewBorder:enterBtn withRadius:22.5f andBorderWidth:0 andBorderColor:nil andBackground:[Tools theme]];
//    [enterBtn setImage:[UIImage imageNamed:@"enter_selected"] forState:UIControlStateNormal];
//    [enterBtn setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateDisabled];
//    enterBtn.enabled = NO;
    enterBtn.hidden = YES;
    [enterBtn addTarget:self action:@selector(requestCoder:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:enterBtn];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputCodeView.mas_bottom).offset(70);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(130, 45));
    }];
	
	nextBtn = [[UIButton alloc]init];
	[nextBtn setImage:IMGRESOURCE(@"loginstep_next_icon") forState:UIControlStateNormal];
	[self addSubview:nextBtn];
	[nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(enterBtn);
		make.right.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(50, 50));
	}];
	nextBtn.hidden = YES;
	[nextBtn addTarget:self action:@selector(requestCoder:) forControlEvents:UIControlEventTouchUpInside];
	
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                             target: self
                                           selector: @selector(timerRun:)
                                           userInfo: nil
                                            repeats: YES];
    [timer setFireDate:[NSDate distantFuture]];
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

- (void)areaCodeBtnSelected:(UIButton*)sender {
    [_controller performForView:self andFacade:nil andMessage:@"LandingAreaCode" andArgs:nil];
}

- (void)textFieldTextDidChange:(NSNotification*)tf {
	
    if (tf.object == coder_area ) {
        if ( coder_area.text.length == 4 && isAlreadyreReqCode) {
            [self showEnterOrNextBtn];
			[coder_area resignFirstResponder];
        } else {
            [self hideEnterOrNextBtn];
        }
    }
    else if (tf.object == inputPhoneNo) {
        
        NSString *string = ((UITextField*)tf.object).text;
        if (string.length == 11) {
            if (![[string substringWithRange:NSMakeRange(3, 1)] isEqualToString:@" "]) {
                string = [[[string substringToIndex:3] stringByAppendingString:@" "] stringByAppendingString:[string substringFromIndex:3]];
                
                NSString *subs = [string substringWithRange:NSMakeRange(8, 1)];
                if (![subs isEqualToString:@" "]) {
                    string = [[[string substringToIndex:8] stringByAppendingString:@" "] stringByAppendingString:[string substringFromIndex:8]];
                    inputPhoneNo.text = string;
                }
            }
        }
        
        if (inputPhoneNo.text.length >= kPhoneNoLimit) {
            if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{1} \\d{4} \\d{4}$"] evaluateWithObject:inputPhoneNo.text]) {
                [inputPhoneNo resignFirstResponder];
                NSString *title = @"手机号码输入错误";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithAction)
                return;
            } else
				checkIcon.hidden = NO;
				
            if (seconds == TimeZore || seconds == 0) {
                getCodeBtn.enabled = YES;
            }
		} else {
			getCodeBtn.enabled = NO;
			checkIcon.hidden = YES;
		}
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	/*
	 *控制格式
	 */
    if (textField == inputPhoneNo) {
        if ( inputPhoneNo.text.length >= kPhoneNoLimit && ![string isEqualToString:@""]){
            return NO;
        } else {
            NSString *tmp = inputPhoneNo.text;
            if ((tmp.length == 3 || tmp.length == 8) && ![string isEqualToString:@""]) {
                tmp = [tmp stringByAppendingString:@" "];
                inputPhoneNo.text = tmp;
            }
            return YES;
        }
    } else
		return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    AYHideBtmAlertView
}

#pragma mark -- handle
- (id)startConfirmCodeTimer {
    getCodeBtn.enabled = NO;
    seconds = TimeZore;
    [getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
    [getCodeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
    [timer setFireDate:[NSDate distantPast]];
    
    [self hideKeyboard];
	
	NSString *title = @"动态密码已发送";
	AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	
    return nil;
}

- (void)timerRun:(NSTimer*)sender {
    seconds--;
    if (seconds > 0) {
        [getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
        
    } else {
        [timer setFireDate:[NSDate distantFuture]];
        [getCodeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [getCodeBtn setTitle:@"重获动态密码" forState:UIControlStateNormal];
        if (inputPhoneNo.text.length >= kPhoneNoLimit) {
            getCodeBtn.enabled = YES;
        }
    }
}

#pragma mark -- actions
-(void)areaBtnClick{
	
	NSString *title = @"目前只支持中国地区电话号码";
	AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
}

- (void)getcodeBtnClick {
	
	coder_area.text = @"";
	[self hideEnterOrNextBtn];
	[self hideKeyboard];
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	NSString *tmp = inputPhoneNo.text;
	tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
	[dic setValue:tmp forKey:kAYProfileArgsPhone];
	id<AYCommand> cmd = [self.notifies objectForKey:@"reReqConfirmCode:"];
	[cmd performWithResult:&dic];
}

-(void)requestCoder:(UIButton*)sender {
	[self hideKeyboard];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[inputPhoneNo.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:kAYProfileArgsPhone];
	[tmp setValue:coder_area.text forKey:@"code"];
	id<AYCommand> cmd = [self.notifies objectForKey:@"AuthWithPhoneNoAndCode:"];
	[cmd performWithResult:&tmp];
}

-(void)hideEnterOrNextBtn {
	enterBtn.hidden = YES;
	nextBtn.hidden = YES;
}
-(void)showEnterOrNextBtn {
    if (isNewUser) {
		nextBtn.hidden = NO;
	} else {
		enterBtn.hidden = NO;
	}
}

#pragma mark -- view commands
- (id)hideKeyboard {
    if ([coder_area isFirstResponder]) {
        [coder_area resignFirstResponder];
    }
    if ([inputPhoneNo isFirstResponder]) {
        [inputPhoneNo resignFirstResponder];
    }
    return nil;
}

-(id)showEnterBtnForOldUser {
	isAlreadyreReqCode = YES;
    isNewUser = NO;
    return nil;
}

-(id)showNextBtnForNewUser {
	isAlreadyreReqCode = YES;
    isNewUser = YES;
    return nil;
}

@end

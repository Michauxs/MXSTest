//
//  AYPhoneCheckInputView.m
//  BabySharing
//
//  Created by BM on 29/09/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPhoneCheckInputView.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "PhotoTagEnumDefines.h"
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

#define TEXT_FIELD_LEFT_PADDING             10
#define TimeZore                            60
#define kPhoneNoLimit                       13

@interface AYPhoneCheckInputView () <UITextFieldDelegate>

@end

@implementation AYPhoneCheckInputView {
    NSString* reg_token;
    
    NSTimer* timer;
    NSInteger seconds;
    
    UITextField *coder_area;
    UITextField *inputPhoneNo;
	
    UIButton *getCodeBtn;
	UILabel *count_timer;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
	self.bounds = CGRectMake(0, 0, 0, 190);
    self.backgroundColor = [UIColor clearColor];
	
	UILabel *phoneLabel = [Tools creatLabelWithText:@"手机号" textColor:[Tools black] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self addSubview:phoneLabel];
	[phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self);
		make.top.equalTo(self);
	}];
	
	/* 电话号码 */
	UIView *inputPhoneNoView = [[UIView alloc]init];
	[self addSubview:inputPhoneNoView];
	CGFloat phoneBgHeight = 50;
	[inputPhoneNoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(phoneLabel.mas_bottom);
		make.left.equalTo(self);
		make.right.equalTo(self);
		make.height.mas_equalTo(phoneBgHeight);
	}];
	[Tools creatCALayerWithFrame:CGRectMake(0, phoneBgHeight - 1, 194, 1) andColor:[Tools garyLineColor] inSuperView:inputPhoneNoView];
	
	inputPhoneNo = [[UITextField alloc]init];
	inputPhoneNo.delegate = self;
	inputPhoneNo.backgroundColor = [UIColor clearColor];
	inputPhoneNo.font = [UIFont boldSystemFontOfSize:18.f];
	inputPhoneNo.textColor = [Tools theme];
	inputPhoneNo.keyboardType = UIKeyboardTypeNumberPad;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:inputPhoneNo];
	[inputPhoneNoView addSubview:inputPhoneNo];
	[inputPhoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(inputPhoneNoView);
//		make.right.equalTo(inputPhoneNoView);
		make.centerY.equalTo(inputPhoneNoView);
		make.height.equalTo(@34);
		make.width.equalTo(@194);
	}];
	
	
	/* (重新)获取coder */
	getCodeBtn = [[UIButton alloc]init];
	[getCodeBtn setTitle:@"获取动态密码" forState:UIControlStateNormal];
	[getCodeBtn setTitleColor:[Tools whiteColor] forState:UIControlStateNormal];
	[getCodeBtn setTitleColor:[Tools RGB153GaryColor] forState:UIControlStateDisabled];
	getCodeBtn.enabled = NO;
	getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
	[Tools setViewBorder:getCodeBtn withRadius:19.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools RGB225GaryColor]];
	[getCodeBtn addTarget:self action:@selector(getcodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[inputPhoneNoView addSubview:getCodeBtn];
	[getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(inputPhoneNoView);
		make.centerY.equalTo(inputPhoneNoView);
		make.size.mas_equalTo(CGSizeMake(110, 38));
	}];
	
	UILabel *codeLabel = [Tools creatLabelWithText:@"验证码" textColor:[Tools black] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self addSubview:codeLabel];
	[codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self);
		make.top.equalTo(inputPhoneNoView.mas_bottom).offset(45);
	}];
	
	/* 验证码 */
	UIView *inputCodeView = [[UIView alloc]init];
	[self addSubview:inputCodeView];
	[inputCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(codeLabel.mas_bottom);
		make.left.equalTo(self);
		make.width.equalTo(self);
		make.height.mas_equalTo(phoneBgHeight);
	}];
	[Tools creatCALayerWithFrame:CGRectMake(0, phoneBgHeight - 1, 194, 1) andColor:[Tools garyLineColor] inSuperView:inputCodeView];
	
	coder_area = [[UITextField alloc]init];
	coder_area.backgroundColor = [UIColor clearColor];
	coder_area.font = [UIFont boldSystemFontOfSize:18.f];
	coder_area.textColor = [Tools theme];
	coder_area.keyboardType = UIKeyboardTypeNumberPad;
	coder_area.delegate = self;
	coder_area.userInteractionEnabled = NO;
//	coder_area.placeholder = @"动态密码";
	[inputCodeView addSubview:coder_area];
	[coder_area mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(inputCodeView);
		make.right.equalTo(inputCodeView).offset(-150);
		make.centerY.equalTo(inputCodeView);
		make.height.equalTo(inputCodeView);
	}];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:coder_area];
	
	
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

#pragma mark -- messages
- (void)selfClicked {
    @throw [[NSException alloc]initWithName:@"error" reason:@"cannot call base view" userInfo:nil];
}

- (void)setRightBtnEnabled {
	id<AYCommand> cmd = [self.notifies objectForKey:@"setRightBtnEnabled"];
	[cmd performWithResult:nil];
}

#pragma mark -- ################
- (void)textFieldTextDidChange:(NSNotification*)tf {
    if (tf.object == coder_area ) {
        if ( coder_area.text.length == 4) {
			[self setRightBtnEnabled];
			[self resignFocus];
        }
    } else if (tf.object == inputPhoneNo) {
        if (inputPhoneNo.text.length >= kPhoneNoLimit) {
            if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{1} \\d{4} \\d{4}$"] evaluateWithObject:inputPhoneNo.text]) {
                
                [inputPhoneNo resignFirstResponder];
                NSString *title = @"您输入了错误的电话号码";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithAction)
                return;
            }
			
            if (seconds == TimeZore || seconds == 0) {
                getCodeBtn.enabled = YES;
				getCodeBtn.backgroundColor = [Tools theme];
            }
		} else {
			getCodeBtn.enabled = NO;
			getCodeBtn.backgroundColor = [Tools RGB225GaryColor];
		}
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
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
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    AYHideBtmAlertView
}

- (void)getcodeBtnClick {
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{1} \\d{4} \\d{4}$"] evaluateWithObject:inputPhoneNo.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入了错误的电话号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self resignFocus];
    id<AYCommand> cmd = [self.notifies objectForKey:@"requeryForCode"];
    [cmd performWithResult:nil];
}

#pragma mark -- timer handle
- (void)timerRun:(NSTimer*)sender {
    seconds--;
    if (seconds > 0) {
        [getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
        
    } else {
        [timer setFireDate:[NSDate distantFuture]];
//        [getCodeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [getCodeBtn setTitle:@"重获动态密码" forState:UIControlStateNormal];
        if (inputPhoneNo.text.length >= kPhoneNoLimit) {
            getCodeBtn.enabled = YES;
			getCodeBtn.backgroundColor = [Tools theme];
        }
    }
}

#pragma mark -- actions
- (id)invalidateTimer {
    [timer invalidate];
    return nil;
}

- (id)resignFocus {
    
    if ([inputPhoneNo isFirstResponder]) {
        [inputPhoneNo resignFirstResponder];
    }
    if ([coder_area isFirstResponder]) {
        [coder_area resignFirstResponder];
    }
    
    return nil;
}

- (id)queryPhoneInput:(id)args {
    return inputPhoneNo.text;
}

- (id)queryCodeInput:(id)args {
    return coder_area.text;
}

- (id)setCodeBtnTitle {
    [getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
//    [getCodeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
    return nil;
}

- (id)startTimer {
	getCodeBtn.enabled = NO;
	getCodeBtn.backgroundColor = [Tools RGB225GaryColor];
	coder_area.userInteractionEnabled = YES;
    seconds = TimeZore;
    [timer setFireDate:[NSDate distantPast]];
    return nil;
}

- (id)endTimer {
    [timer setFireDate:[NSDate distantFuture]];
    return nil;
}

- (id)resetCodeInput {
    coder_area.text = @"";
    return nil;
}
@end

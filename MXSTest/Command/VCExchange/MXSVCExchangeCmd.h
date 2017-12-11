//
//  MXSPushCommand.h
//  MXSTest
//
//  Created by Alfred Yang on 2/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXSViewController.h"
#import <objc/runtime.h>

#import "MXShowTableCell.h"
#import "MXSProfileVC.h"
#import "MXSShowImageVC.h"

static NSString *const MethodReceiveArgsTypePost =		@"ReceiveCmdArgsActionPost:";
static NSString *const MethodReceiveArgsTypeBack =		@"ReceiveCmdArgsActionBack:";

@interface MXSVCExchangeCmd : NSObject

+ (MXSVCExchangeCmd*)shared;

#pragma mark - Push
- (void)fromVC:(id)f_vc pushVC:(id)t_vc withArgs:(id)args;

#pragma mark - Pop
- (void)fromVC:(id)f_vc popOneStepWithArgs:(id)args;
- (void)fromVC:(id)f_vc popToDestVC:(id)d_vc withArgs:(id)args;
- (void)fromVC:(id)f_vc popToRootWithArgs:(id)args;

#pragma mark - Push/Pop Animat
- (void)pushAnimatVCFrom:(id)f_vc to:(id)t_vc withArgs:(id)args;
- (void)popAnimatVCFrom:(id)f_vc withArgs:(id)args;

#pragma mark - Module
- (void)fromVC:(id)f_vc moduleVC:(id)t_vc withArgs:(id)args;
- (void)fromVC:(id)f_vc dismissWithArgs:(id)args;




#pragma mark - Exchange Keywindow

@end

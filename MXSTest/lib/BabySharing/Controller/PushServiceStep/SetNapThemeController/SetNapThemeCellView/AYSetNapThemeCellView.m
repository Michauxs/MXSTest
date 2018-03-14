//
//  AYSetNapOptionsCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 23/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapThemeCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYSetNapThemeCellView {
    
    UILabel *titleLabel;
    UIButton *optionBtn;
    
    int index;
    UITextField *customField;
    
    NSDictionary *service;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
        self.backgroundColor = [UIColor whiteColor];
        
        CALayer *btm_line = [[CALayer alloc]init];
        btm_line.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40, 1);
        btm_line.backgroundColor = [Tools garyBackgroundColor].CGColor;
        [self.layer addSublayer:btm_line];
        
        titleLabel = [Tools creatLabelWithText:nil textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:0];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(self);
        }];
        
        optionBtn = [[UIButton alloc]init];
        [self addSubview:optionBtn];
        [optionBtn setImage:[UIImage imageNamed:@"icon_pick"] forState:UIControlStateNormal];
        [optionBtn setImage:[UIImage imageNamed:@"icon_pick_selected"] forState:UIControlStateSelected];
        [optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-20);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"SetNapOptionsCell", @"SetNapOptionsCell");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

#pragma mark -- commands
- (void)postPerform {
    
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

#pragma mark -- actions
- (void)didServiceDetailClick:(UIGestureRecognizer*)tap{
    id<AYCommand> cmd = [self.notifies objectForKey:@"didServiceDetailClick"];
    [cmd performWithResult:nil];
    
}

-(void)didPushInfo{
    id<AYCommand> cmd = [self.notifies objectForKey:@"didPushInfo"];
    [cmd performWithResult:nil];
}

-(void)didOptionBtnClick:(UIButton*)btn {
//    btn.selected = !btn.selected;
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"didOptionBtnClick:"];
    [cmd performWithResult:&btn];
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)args {
    
    titleLabel.text = [args objectForKey:@"title"];
    optionBtn.enabled = YES;
    
    NSNumber *cell_index = [args objectForKey:@"index"];
    if (cell_index) {
        titleLabel.textColor = [Tools black];
        NSInteger index_tag = cell_index.integerValue;
        optionBtn.tag = index_tag;
        NSInteger notePow = ((NSNumber*)[args objectForKey:@"cans"]).integerValue;
        optionBtn.selected = ((notePow & (long)pow(2, index_tag)) != 0);
        
        if (optionBtn.selected) {
            id<AYCommand> cmd = [self.notifies objectForKey:@"didSetNoteBtn:"];
            UIButton *btn = optionBtn;
            [cmd performWithResult:&btn];
        }
        
    } else {
        NSNumber *isCanSet = [args objectForKey:@"is_can_set"];
        if (isCanSet.boolValue) {
            titleLabel.textColor = [Tools theme];
            optionBtn.enabled = YES;
        } else {
            titleLabel.textColor = [Tools garyColor];
            optionBtn.enabled = NO;
        }
        
        BOOL isAllowLeaveOption = ((NSNumber*)[args objectForKey:@"allow_leave"]).boolValue;
        optionBtn.selected = isAllowLeaveOption;
        optionBtn.tag = 99;
    }
    
    return nil;
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    id<AYCommand> cmd_textchange = [self.notifies objectForKey:@"textChange:"];
    NSString *text = textField.text;
    text = [text stringByAppendingString:string];
    [cmd_textchange performWithResult:&text];
    return YES;
}

- (id)queryCustom:(NSString*)args {
    return customField.text;
}
@end

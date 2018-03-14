//
//  AYNapBabyAgeCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 19/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNapEditInfoCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYNapEditInfoCellView {
    NSString *title;
    NSString *content;
    
    UILabel *titleLabel;
    UILabel *subTitlelabel;
    UIButton *optionBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLabel = [Tools creatLabelWithText:@"" textColor:[Tools theme] fontSize:616.f backgroundColor:nil textAlignment:0];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self.mas_centerY).offset(-2);
        }];
        
        subTitlelabel = [Tools creatLabelWithText:@"" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:0];
        [self addSubview:subTitlelabel];
        [subTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(self.mas_centerY).offset(2);
            make.right.equalTo(self).offset(-60);
        }];
        
        optionBtn = [[UIButton alloc]init];
        [self addSubview:optionBtn];
        [optionBtn setImage:[UIImage imageNamed:@"icon_pick"] forState:UIControlStateNormal];
        [optionBtn setImage:[UIImage imageNamed:@"icon_pick_selected"] forState:UIControlStateSelected];
        [optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        optionBtn.selected = NO;
        optionBtn.userInteractionEnabled = NO;
        
        CALayer *separator = [CALayer layer];
        CGFloat margin = 0;
        separator.frame = CGRectMake(margin, 0, [UIScreen mainScreen].bounds.size.width - margin*2, 0.5);
        separator.backgroundColor = [Tools garyLineColor].CGColor;
        [self.layer addSublayer:separator];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"NapEditInfoCell", @"NapEditInfoCell");
    
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

- (id)setCellInfo:(NSDictionary*)args {
    
    BOOL isSeted = ((NSNumber*)[args objectForKey:@"is_seted"]).boolValue;
    optionBtn.selected = isSeted;
    
    titleLabel.text = [args objectForKey:@"title"];
    subTitlelabel.text = [args objectForKey:@"sub_title"];
    
    return nil;
}

@end

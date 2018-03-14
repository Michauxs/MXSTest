//
//  AYOrderPayWayCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPayWayCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "InsetsLabel.h"
#import "OBShapedButton.h"

@implementation AYPayWayCellView {
    
//    UILabel *titleLabel;
//    UIImageView *payWayIcon;
    
    NSDictionary *service;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel = [Tools setLabelWith:titleLabel andText:@"支付方式" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.left.equalTo(self).offset(15);
        }];
        
        UIImageView *payWayIcon = [UIImageView new];
        payWayIcon.image = IMGRESOURCE(@"wechat");
        [self addSubview:payWayIcon];
        [payWayIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
            make.left.equalTo(titleLabel);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UILabel *payWayLabel = [UILabel new];
        payWayLabel = [Tools setLabelWith:payWayLabel andText:@"微信" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:payWayLabel];
        [payWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(payWayIcon);
            make.left.equalTo(payWayIcon.mas_right).offset(15);
        }];
        
        UIImageView *signView = [UIImageView new];
        signView.image = IMGRESOURCE(@"checked_icon");
        [self addSubview:signView];
        [signView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(payWayIcon);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(12.5, 12.5));
        }];
        
        
        CALayer *line_separator = [CALayer layer];
        line_separator.backgroundColor = [Tools garyLineColor].CGColor;
        line_separator.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
        [self.layer addSublayer:line_separator];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"PayWayCell", @"PayWayCell");
    
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

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
    
    return nil;
}

@end

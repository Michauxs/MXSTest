//
//  AYOneProfileAboutCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 16/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOneProfileAboutCellView.h"
#import "QueryContentItem.h"
#import "Define.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "AYThumbsAndPushDefines.h"

@implementation AYOneProfileAboutCellView {
    
    UIImageView *headImage;
    UILabel *titleLabel;
    
    NSDictionary *service;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
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
    id<AYViewBase> cell = VIEW(@"OneProfileAboutCell", @"OneProfileAboutCell");
    
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
- (void)didServiceDetailClick:(UIGestureRecognizer*)tap {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didServiceDetailClick"];
    [cmd performWithResult:nil];
    
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
    NSString *single = [dic_args objectForKey:@"validate"];
    if (single) {
        UILabel *title = [Tools creatLabelWithText:@"已验证的身份" textColor:[Tools black] fontSize:15.f backgroundColor:nil textAlignment:0];
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
    } else {
        NSString *title = [dic_args objectForKey:@"title"];
        NSString *sub_title = [dic_args objectForKey:@"sub_title"];
		
        titleLabel = [Tools creatLabelWithText:title textColor:[Tools black] fontSize:15.f backgroundColor:nil textAlignment:0];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(20);
        }];
        
        UILabel *subTitle = [Tools creatLabelWithText:sub_title textColor:[Tools garyColor] fontSize:13.f backgroundColor:nil textAlignment:0];
        [self addSubview:subTitle];
        [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
        }];
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 89.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    line.backgroundColor = [Tools garyLineColor];
    [self addSubview:line];
    return nil;
}

@end

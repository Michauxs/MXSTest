//
//  AYPersonalInfoHeadCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 27/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPersonalInfoHeadCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

@implementation AYPersonalInfoHeadCellView {
    
    UIImageView *userImageView;
    UILabel *nameLabel;
    
    UILabel *registTimeLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        nameLabel = [Tools creatLabelWithText:@"服务者" textColor:[Tools black] fontSize:17.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(20);
        }];
		
        registTimeLabel = [Tools creatLabelWithText:@"Registration date" textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:registTimeLabel];
        [registTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(nameLabel.mas_bottom).offset(17);
        }];
        
        CALayer *separtor = [CALayer layer];
        separtor.frame = CGRectMake(0, 349.5f, SCREEN_WIDTH, 0.5);
        separtor.backgroundColor = [Tools garyLineColor].CGColor;
        [self.layer addSublayer:separtor];
        
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
    id<AYViewBase> cell = VIEW(@"PersonalInfoHeadCell", @"PersonalInfoHeadCell");
    
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

-(void)didPushInfo {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didPushInfo"];
    [cmd performWithResult:nil];
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
    
    nameLabel.text = [args objectForKey:@"screen_name"];
    
    double date = ((NSNumber*)[args objectForKey:@"date"]).doubleValue;
    NSDateFormatter *format = [Tools creatDateFormatterWithString:@"yyyy年MM月"];
    NSDate *registDate = [NSDate dateWithTimeIntervalSince1970:date * 0.001];
    NSString *dateStr = [format stringFromDate:registDate];
    
    registTimeLabel.text = [NSString stringWithFormat:@"注册时间：%@",dateStr];
    
    return nil;
}

@end

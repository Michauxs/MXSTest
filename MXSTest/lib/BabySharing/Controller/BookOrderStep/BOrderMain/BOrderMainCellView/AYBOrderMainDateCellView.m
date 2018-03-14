//
//  AYOrderInfoDateCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderMainDateCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "InsetsLabel.h"
#import "OBShapedButton.h"

@implementation AYBOrderMainDateCellView {
    
    UILabel *dateLabel;
    UILabel *timeLabel;
	UIView *btmLineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
//		[Tools creatCALayerWithFrame:CGRectMake(0, 84.5, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
        
        dateLabel =  [Tools creatLabelWithText:@"Service Date" textColor:[Tools black] fontSize:17.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.bottom.equalTo(self.mas_centerY).offset(-3);
		}];
		
		timeLabel =  [Tools creatLabelWithText:@"Service Time" textColor:[Tools theme] fontSize:20.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:timeLabel];
		[timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(self.mas_centerY).offset(3);
		}];
		
		btmLineView = [[UIView alloc] init];
		btmLineView.backgroundColor = [Tools garyLineColor];
		[self addSubview:btmLineView];
		[btmLineView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.right.equalTo(self).offset(-15);
			make.bottom.equalTo(self);
			make.height.mas_equalTo(0.5);
		}];
		
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"BOrderMainDateCell", @"BOrderMainDateCell");
    
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

- (void)didEditBtnClick:(UIButton*)btn {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didEditDate"];
    [cmd performWithResult:nil];
    
}

- (void)didEditTimes {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didEditTimes"];
    [cmd performWithResult:nil];
    
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
	
	NSDictionary *dic_time = [dic_args objectForKey:@"order_time"];
	NSNumber *start = [dic_time objectForKey:kAYServiceArgsStart];
	NSNumber *end = [dic_time objectForKey:kAYServiceArgsEnd];
	
	NSDateFormatter *format = [Tools creatDateFormatterWithString:@"yyyy-MM-dd, EEEE"];
	NSDateFormatter *format_time = [Tools creatDateFormatterWithString:@"HH:mm"];
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start.doubleValue * 0.001];
	NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end.doubleValue * 0.001];
	
	NSString *dateStr = [format stringFromDate:startDate];
	dateLabel.text = dateStr;
	
	NSString *startStr = [format_time stringFromDate:startDate];
	NSString *endStr = [format_time stringFromDate:endDate];
	timeLabel.text = [NSString stringWithFormat:@"%@-%@", startStr, endStr];
	
	NSNumber *is_last = [dic_args objectForKey:@"is_last"];
	if (is_last.boolValue) {
		[btmLineView removeFromSuperview];
	}
	
    return nil;
}

@end

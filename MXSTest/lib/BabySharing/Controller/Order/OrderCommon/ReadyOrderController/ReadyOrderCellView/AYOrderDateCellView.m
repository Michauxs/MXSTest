//
//  AYOrderDateCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 14/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderDateCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "AYThumbsAndPushDefines.h"

@interface AYOrderDateCellView ()
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end

@implementation AYOrderDateCellView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    CALayer *line_separator = [CALayer layer];
    line_separator.backgroundColor = [Tools garyLineColor].CGColor;
    line_separator.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
    [self.layer addSublayer:line_separator];
    
    //    _contactBtn.layer.cornerRadius = 2.f;
    //    _contactBtn.clipsToBounds = YES;
    //    _contactBtn.layer.borderColor = [Tools themeColor].CGColor;
    //    _contactBtn.layer.borderWidth = 1.f;
    
    // Initialization code
    [self setUpReuseCell];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"OrderDateCell", @"OrderDateCell");
    
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

- (id)setCellInfo:(NSDictionary*)dic_args {
    
    NSDictionary *args = [dic_args objectForKey:@"order_date"];
    
    double start = ((NSNumber*)[args objectForKey:@"start"]).doubleValue * 0.001;
    double end = ((NSNumber*)[args objectForKey:@"end"]).doubleValue * 0.001;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日, EEEE"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:end];
    NSString *dateStr = [format stringFromDate:today];
    _orderDateLabel.text = dateStr;
    
    NSDateFormatter *formatTimes = [[NSDateFormatter alloc] init];
    [formatTimes setDateFormat:@"HH:mm"];
    [formatTimes setTimeZone:timeZone];
    
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:start];
    NSString *startStr = [formatTimes stringFromDate:startTime];
    _startLabel.text = startStr;
    
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:end];
    NSString *endStr = [formatTimes stringFromDate:endTime];
    _endLabel.text = endStr;
    
//        NSDictionary *times = [dic_args objectForKey:@"order_times"];
//        NSString *start = [times objectForKey:@"start"];
//        NSString *end = [times objectForKey:@"end"];
    
    
    return nil;
}
@end

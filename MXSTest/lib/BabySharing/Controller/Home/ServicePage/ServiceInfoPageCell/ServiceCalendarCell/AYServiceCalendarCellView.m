//
//  AYServiceCalendarCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceCalendarCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"

@implementation AYServiceCalendarCellView {
    UILabel *tipsTitleLabel;
	UILabel *timeLabel;
	UILabel *moreScheduleLabel;
	UILabel *moreLabel;
	
	NSDictionary *service_info;
	
	NSCalendar *calendar;
	NSTimeInterval todayInterval;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
        CGFloat margin = 0;
		[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
        
        tipsTitleLabel = [Tools creatLabelWithText:@"Section Head" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:tipsTitleLabel];
		[tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(self).offset(30);
			make.bottom.equalTo(self).offset(-85);
		}];
		
		timeLabel = [Tools creatLabelWithText:@"最近可预定时间" textColor:[Tools black] fontSize:15.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		timeLabel.numberOfLines = 0;
		[self addSubview:timeLabel];
		[timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
		}];
		
		moreLabel = [Tools creatLabelWithText:@"没有可预定时间" textColor:[Tools theme] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
		[self addSubview:moreLabel];
		[moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(timeLabel);
			make.right.equalTo(self).offset(-15);
		}];
		moreLabel.userInteractionEnabled = YES;
		[moreLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didMoreLabelTap)]];
		
//		UIImageView *access = [[UIImageView alloc]init];
//		[self addSubview:access];
//		access.image = IMGRESOURCE(@"plan_time_icon");
//		[access mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.right.equalTo(self).offset(-20);
//			make.centerY.equalTo(moreLabel);
//			make.size.mas_equalTo(CGSizeMake(15, 15));
//		}];
		
		[self setInitDateInfo];
		
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)setInitDateInfo {
	
	NSDate *nowDate = [NSDate date];
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:nil];
	NSString *todayDateStr = [formatter stringFromDate:nowDate];
	todayInterval = [formatter dateFromString:todayDateStr].timeIntervalSince1970;
	
	calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
	[calendar setTimeZone: timeZone];
	//	NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
	//	NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nowDate];
	//	NSInteger sepNumb = theComponents.weekday - 1; 		//sep
	
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ServiceCalendarCell", @"ServiceCalendarCell");
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
- (void)didMoreLabelTap {
    kAYViewSendNotify(self, @"showServiceOfferDate", nil)
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	service_info = args;
	
	NSArray *tms = [service_info objectForKey:kAYServiceArgsTimes];
	NSString *ableDateStr;
	for (int i = 0; i < 30; ++i) {		//查找30天之内，30天之后还没有的 应该也不能算最近了
		NSTimeInterval compInterval = todayInterval + OneDayTimeInterval * i;
		BOOL isBreak = NO;
		for (NSDictionary *dic_tm in tms) {
			NSNumber *pattern = [dic_tm objectForKey:kAYServiceArgsPattern];
			NSTimeInterval startdate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
			NSTimeInterval enddate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsEndDate]).doubleValue * 0.001;
			int startHours = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartHours]).intValue;		//startHours==1 用于标记当天时间不可用
			
			if (pattern.intValue == TMPatternTypeDaily) {
				if (compInterval < enddate+OneDayTimeInterval-1 && startHours != 1) { 		//enddate+OneDayTimeInterval-1 :结束那天的最后一秒时间戳
					ableDateStr = [self ableDateStringWithTM:dic_tm andTimeInterval:compInterval];
					isBreak = YES;
					break;
				}
			}
			else if (pattern.intValue == TMPatternTypeWeekly) {
				NSDateComponents *cellComponents = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSince1970:compInterval]];
				int compWeekday = (int)cellComponents.weekday - 1;
				NSDateComponents *startComponents = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSince1970:startdate]];
				int startWeekday = (int)startComponents.weekday - 1;
				if (compWeekday == startWeekday && (compInterval < enddate+OneDayTimeInterval-1 || enddate == -0.001) && startHours != 1) {
					ableDateStr = [self ableDateStringWithTM:dic_tm andTimeInterval:compInterval];
					isBreak = YES;
					break;
				}
			}
			else if (pattern.intValue == TMPatternTypeOnce) {
				if ((startdate <= compInterval) && (startdate + OneDayTimeInterval -1 > compInterval) && startHours != 1) {
					ableDateStr = [self ableDateStringWithTM:dic_tm andTimeInterval:compInterval];
					isBreak = YES;
					break;
				}
			}
			else {
				
			}
		} //forin status
		
		if (isBreak) {
			if (ableDateStr) {
				timeLabel.text = ableDateStr;
			}
			break;
		}
	}
	
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsCat];
	if (service_cat.intValue == ServiceTypeNursery) {
		tipsTitleLabel.text = @"看顾时间";
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		tipsTitleLabel.text = @"课程时间";
	} else {
		tipsTitleLabel.text = @"服务类型待调整";
	}
	
	
	if ([timeLabel.text isEqualToString:@"最近可预定时间"]) {
		moreLabel.userInteractionEnabled = NO;
	} else
		moreLabel.text = @"查看可预定时间";
	
    return nil;
}

- (NSString *)ableDateStringWithTM:(NSDictionary*)dic_tm andTimeInterval:(NSTimeInterval)interval {
	NSNumber *stratNumb = [dic_tm objectForKey:kAYServiceArgsStartHours];
	NSNumber *endNumb = [dic_tm objectForKey:kAYServiceArgsEndHours];
	NSMutableString *timesStr = [NSMutableString stringWithFormat:@"%.4d-%.4d", stratNumb.intValue, endNumb.intValue];
	[timesStr insertString:@":" atIndex:2];
	[timesStr insertString:@":" atIndex:8];
	
	NSDate *ableDate = [NSDate dateWithTimeIntervalSince1970:interval];
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日,  EEE"];
	NSString *dateStrPer = [formatter stringFromDate:ableDate];
	
	return [NSString stringWithFormat:@"%@\n%@", dateStrPer, timesStr];
	
}

@end

//
//  AYPushServiceTMNurseCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 6/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYPushServiceTMNurseCommand.h"
#import "AYFactoryManager.h"

@implementation AYPushServiceTMNurseCommand

@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	// need to be modified
	
	NSMutableArray* result = [[NSMutableArray alloc]init];
	NSDictionary *time_brige_args = (NSDictionary*)*obj;
	
	NSArray *restDayScheduleArr = [time_brige_args objectForKey:@"schedule_restday"];
	NSArray *workDaySchedule = [time_brige_args objectForKey:@"schedule_workday"];
	
	NSDate *nowDate = [NSDate date];
	
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy-MM-dd"];
	NSString *dateStr = [formatter stringFromDate:nowDate];
	NSDate *todayDate = [formatter dateFromString:dateStr];
	/*update: 之前是用的date是now，now存在匹配问题 =>转截成以“日”为标准的date*/
	NSTimeInterval nowInterval = todayDate.timeIntervalSince1970;
	
	if (restDayScheduleArr.count != 0) {
		
		for (NSDictionary *dic_rest in restDayScheduleArr) {		//All Day
			
			NSNumber *TPointSpan = [dic_rest objectForKey:kAYServiceArgsTPHandle];
			NSNumber *isAble = [dic_rest objectForKey:@"rest_isable"];
			if (isAble.boolValue) {
				
				NSArray *restSchedule = [dic_rest objectForKey:@"rest_schedule"];
				for (NSDictionary *dic_time in restSchedule) {		//All Times
					
					NSMutableDictionary *time_args = [[NSMutableDictionary alloc] init];
					[time_args setValue:[NSNumber numberWithInt:TMPatternTypeOnce] forKey:@"pattern"];
					[time_args setValue:[dic_time objectForKey:@"start"] forKey:@"starthours"];
					[time_args setValue:[dic_time objectForKey:@"end"] forKey:@"endhours"];
					[time_args setValue:[NSNumber numberWithDouble:TPointSpan.doubleValue * 1000] forKey:@"startdate"];
					[time_args setValue:[NSNumber numberWithDouble:-1] forKey:@"enddate"];
					
					[result addObject:time_args];
				}
			}//is able day
			else {
				NSMutableDictionary *time_args = [[NSMutableDictionary alloc] init];
				[time_args setValue:[NSNumber numberWithInt:TMPatternTypeOnce] forKey:@"pattern"];
				[time_args setValue:[NSNumber numberWithInt:1] forKey:@"starthours"];
				[time_args setValue:[NSNumber numberWithInt:1] forKey:@"endhours"];
				[time_args setValue:[NSNumber numberWithDouble:TPointSpan.doubleValue * 1000] forKey:@"startdate"];
				[time_args setValue:[NSNumber numberWithDouble:-1] forKey:@"enddate"];
				
				[result addObject:time_args];
			}// end
			
		} //end forin
		
		//rest time span <-> nowTimeSpan
		NSMutableArray *TPointArr = [NSMutableArray array];
		for (int i = 0; i < restDayScheduleArr.count; ++i) {
			NSNumber *TPointSpan = [[restDayScheduleArr objectAtIndex:i] objectForKey:kAYServiceArgsTPHandle];
			if (i == 0) {
				
				NSMutableDictionary *dic_tp_s_and_e = [[NSMutableDictionary alloc] init];
				[dic_tp_s_and_e setValue:TPointSpan forKey:@"tp_start"];
				[dic_tp_s_and_e setValue:[NSNumber numberWithDouble:TPointSpan.doubleValue + OneDayTimeInterval] forKey:@"tp_end"];
				[TPointArr addObject:dic_tp_s_and_e];
			} else {
				
				if (((NSNumber*)[[TPointArr lastObject] objectForKey:@"tp_end"]).doubleValue == TPointSpan.doubleValue) {
					[[TPointArr lastObject] setValue:[NSNumber numberWithDouble:TPointSpan.doubleValue + OneDayTimeInterval] forKey:@"tp_end"];
				} else {
					NSMutableDictionary *dic_tp_s_and_e = [[NSMutableDictionary alloc] init];
					[dic_tp_s_and_e setValue:TPointSpan forKey:@"tp_start"];
					[dic_tp_s_and_e setValue:[NSNumber numberWithDouble:TPointSpan.doubleValue + OneDayTimeInterval] forKey:@"tp_end"];
					[TPointArr addObject:dic_tp_s_and_e];
				}
			}
		}
		
		for (int i = 0; i < TPointArr.count +1; ++i) {
			
			if (i == 0) {
				if(((NSNumber*)[[TPointArr objectAtIndex:i] objectForKey:@"tp_start"]).doubleValue <= nowInterval) {
					continue;
				} else {
					for (NSDictionary *dic_duration in workDaySchedule) {
						NSMutableDictionary *time_args = [[NSMutableDictionary alloc] init];
						[time_args setValue:[NSNumber numberWithInt:TMPatternTypeDaily] forKey:@"pattern"];
						[time_args setValue:[dic_duration objectForKey:@"start"] forKey:@"starthours"];
						[time_args setValue:[dic_duration objectForKey:@"end"] forKey:@"endhours"];
						[time_args setValue:[NSNumber numberWithDouble:nowInterval * 1000] forKey:@"startdate"];
						[time_args setValue:[NSNumber numberWithDouble:((NSNumber*)[[TPointArr objectAtIndex:i] objectForKey:@"tp_start"]).doubleValue * 1000] forKey:@"enddate"];
						
						[result addObject:time_args];
					}
					
				}
			} else if(i == TPointArr.count ) {
				for (NSDictionary *dic_duration in workDaySchedule) {
					NSMutableDictionary *time_args = [[NSMutableDictionary alloc] init];
					[time_args setValue:[NSNumber numberWithInt:TMPatternTypeDaily] forKey:@"pattern"];
					[time_args setValue:[dic_duration objectForKey:@"start"] forKey:@"starthours"];
					[time_args setValue:[dic_duration objectForKey:@"end"] forKey:@"endhours"];
					[time_args setValue:[NSNumber numberWithDouble:((NSNumber*)[[TPointArr objectAtIndex:i-1] objectForKey:@"tp_end"]).doubleValue * 1000] forKey:@"startdate"];
					[time_args setValue:[NSNumber numberWithDouble:-1] forKey:@"enddate"];
					
					[result addObject:time_args];
				}
			} else {
				for (NSDictionary *dic_duration in workDaySchedule) {
					NSMutableDictionary *time_args = [[NSMutableDictionary alloc] init];
					[time_args setValue:[NSNumber numberWithInt:TMPatternTypeDaily] forKey:@"pattern"];
					[time_args setValue:[dic_duration objectForKey:@"start"] forKey:@"starthours"];
					[time_args setValue:[dic_duration objectForKey:@"end"] forKey:@"endhours"];
					[time_args setValue:[NSNumber numberWithDouble:((NSNumber*)[[TPointArr objectAtIndex:i-1] objectForKey:@"tp_end"]).doubleValue * 1000] forKey:@"startdate"];
					[time_args setValue:[NSNumber numberWithDouble:((NSNumber*)[[TPointArr objectAtIndex:i] objectForKey:@"tp_start"]).doubleValue * 1000] forKey:@"enddate"];
					
					[result addObject:time_args];
				}
			}
			
		}
		
	}	//restDayScheduleArr end
 	else {
		for (NSDictionary *dic_duration in workDaySchedule) {
//			enddate = "-1";
//			endhours = 1400;
//			pattern = 1;
//			startdate = 1487560812325;
//			starthours = 1200;
			NSMutableDictionary *time_args = [[NSMutableDictionary alloc] init];
			[time_args setValue:[NSNumber numberWithInt:TMPatternTypeDaily] forKey:@"pattern"];
			[time_args setValue:[dic_duration objectForKey:@"start"] forKey:@"starthours"];
			[time_args setValue:[dic_duration objectForKey:@"end"] forKey:@"endhours"];
			[time_args setValue:[NSNumber numberWithDouble:nowInterval * 1000] forKey:@"startdate"];
			[time_args setValue:[NSNumber numberWithDouble:-1] forKey:@"enddate"];
			
			[result addObject:time_args];
		}
	}
	
	*obj = result;
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

#pragma mark -- get day
- (long)startdateFromDay:(int)day {
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDate *now = [NSDate date];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	//    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
	NSInteger unitFlags = NSCalendarUnitWeekday;
	comps = [calendar components:unitFlags fromDate:now];
	NSInteger cur = [comps weekday] - 1;
	
	/*update: 之前是用的date是now，now存在匹配问题 =>转截成以“日”为标准的date*/
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy-MM-dd"];
	NSString *dateStr = [formatter stringFromDate:now];
	NSDate *todayDate = [formatter dateFromString:dateStr];
	
	NSInteger gap = (day - cur) * 60 * 60 * 24;
	return ([todayDate timeIntervalSince1970] + gap) * 1000;
}

- (long)enddateFromDay:(int)day {
	return -1;
}
@end

//
//  AYPushServiceTMCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 19/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYPushServiceTMCommand.h"

@implementation AYPushServiceTMCommand {
	NSCalendar *calendar;
}

@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	// need to modify
	calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	[calendar setTimeZone:[NSTimeZone defaultTimeZone]];
	
	NSDictionary* args = (NSDictionary*)*obj;
	NSMutableArray *TMS = [NSMutableArray array];
	
	/*basic*/
	NSDictionary *tm_basic = [args objectForKey:kBasic];
	for (int i = 0; i < 7; ++i) {
		NSArray *tm_arr = [tm_basic objectForKey:[NSString stringWithFormat:@"%d", i]];
		for (NSDictionary *info_tm in tm_arr) {
			//1.@"start"  2.@"end"
			NSMutableDictionary *dic_tm = [[NSMutableDictionary alloc] init];
			
			long long startdate = [self startdateFromDay:i];
			[dic_tm setValue:[NSNumber numberWithLongLong:startdate] forKey:kAYTimeManagerArgsStartDate];
			[dic_tm setValue:[NSNumber numberWithInt:-1] forKey:kAYTimeManagerArgsEndDate];
			[dic_tm setValue:[info_tm objectForKey:kAYTimeManagerArgsStart] forKey:kAYTimeManagerArgsStartHours];
			[dic_tm setValue:[info_tm objectForKey:kAYTimeManagerArgsEnd] forKey:kAYTimeManagerArgsEndHours];
			[dic_tm setValue:[NSNumber numberWithInt:TMPatternTypeWeekly] forKey:kAYTimeManagerArgsPattern];
			[TMS addObject:dic_tm];
		}
	}
	
	/*special*/
	NSDictionary *tm_special = [args objectForKey:kSpecial];
	NSMutableArray *noteArr = [NSMutableArray array];
	for (NSString *tm_key in [tm_special allKeys]) {
		for (NSDictionary *info_tm in TMS) {
			long long startdate = [[info_tm objectForKey:kAYTimeManagerArgsStartDate] longLongValue];
			
			if ([self isSameWeekday:startdate*0.001 compTimeInterval:tm_key.longLongValue]) {
				NSMutableDictionary *info_tm_next = [[NSMutableDictionary alloc] initWithDictionary:info_tm];
				
				[info_tm setValue:[NSNumber numberWithLongLong:(tm_key.longLongValue-OneDayTimeInterval)*1000] forKey:kAYTimeManagerArgsEndDate];
				
				[info_tm_next setValue:[NSNumber numberWithLongLong:(tm_key.longLongValue+OneDayTimeInterval)*1000] forKey:kAYTimeManagerArgsStartDate];
				
				[noteArr addObject:info_tm_next];	//记录下来 一会添加
				
			}
		}
		
		for (NSDictionary *info_tm_special in [tm_special objectForKey:tm_key]) {
			NSMutableDictionary *dic_tm = [[NSMutableDictionary alloc] init];
			[dic_tm setValue:[NSNumber numberWithLongLong:tm_key.longLongValue*1000] forKey:kAYTimeManagerArgsStartDate];
			[dic_tm setValue:[NSNumber numberWithInt:-1] forKey:kAYTimeManagerArgsEndDate];
			[dic_tm setValue:[info_tm_special objectForKey:kAYTimeManagerArgsStart] forKey:kAYTimeManagerArgsStartHours];
			[dic_tm setValue:[info_tm_special objectForKey:kAYTimeManagerArgsEnd] forKey:kAYTimeManagerArgsEndHours];
			[dic_tm setValue:[NSNumber numberWithInt:TMPatternTypeOnce] forKey:kAYTimeManagerArgsPattern];
			[TMS addObject:dic_tm];
		}
	}
	
	//加入
	if (noteArr.count != 0) {
		[TMS addObjectsFromArray:noteArr];
	}
	
	/*openday*/
	NSDictionary *tm_openday = [args objectForKey:kOpenDay];
	for (NSString *tm_key in [tm_openday allKeys]) {
		
		for (NSDictionary *info_tm_openday in [tm_openday objectForKey:tm_key]) {
			NSMutableDictionary *dic_tm = [[NSMutableDictionary alloc] init];
			[dic_tm setValue:[NSNumber numberWithLongLong:tm_key.longLongValue*1000] forKey:kAYTimeManagerArgsStartDate];
			[dic_tm setValue:[NSNumber numberWithInt:-1] forKey:kAYTimeManagerArgsEndDate];
			[dic_tm setValue:[info_tm_openday objectForKey:kAYTimeManagerArgsStart] forKey:kAYTimeManagerArgsStartHours];
			[dic_tm setValue:[info_tm_openday objectForKey:kAYTimeManagerArgsEnd] forKey:kAYTimeManagerArgsEndHours];
			[dic_tm setValue:[NSNumber numberWithInt:TMPatternTypeOpenDay] forKey:kAYTimeManagerArgsPattern];
			[TMS addObject:dic_tm];
		}
	}
	
	NSArray* result = [TMS copy];
	*obj = result;
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

#pragma mark -- get day
- (long long)startdateFromDay:(int)day {
	
	NSDate *now = [NSDate date];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger unitFlags = NSCalendarUnitWeekday;
	comps = [calendar components:unitFlags fromDate:now];
	NSInteger cur = [comps weekday] - 1;
	
	NSInteger gap = (day - cur) * 60 * 60 * 24;
	
	/* update: now date存在匹配问题 =>转截成以“日”为标准的date */
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy-MM-dd"];
	NSString *dateStr = [formatter stringFromDate:now];
	NSDate *todayDate = [formatter dateFromString:dateStr];
	
	return ([todayDate timeIntervalSince1970] + gap) * 1000;
	
	/*⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️
	 startdate在basic下只要 再转化回来的weekday是对的就行
	 */
}

- (long)enddateFromDay:(int)day {
	return -1;
}

- (BOOL)isSameWeekday:(NSTimeInterval)timespan compTimeInterval:(NSTimeInterval)comp{
	
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timespan];
	NSDate *dateComp = [NSDate dateWithTimeIntervalSince1970:comp];
	
	NSInteger unitFlags = NSCalendarUnitWeekday;
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	comps = [calendar components:unitFlags fromDate:date];
	
	NSDateComponents *compsComp = [[NSDateComponents alloc] init];
	compsComp = [calendar components:unitFlags fromDate:dateComp];
	
	return [comps weekday] == [compsComp weekday];
}

@end

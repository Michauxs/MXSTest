//
//  AYParseServiceTMNurseCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 8/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYParseServiceTMNurseCommand.h"

@implementation AYParseServiceTMNurseCommand

@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	// need to modify
	NSArray* tms = (NSArray*)*obj;
	
	NSMutableArray* workdayTimesArr = [NSMutableArray array];
	NSArray* restdayTimesArr = [NSArray array];
	
	NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF.pattern=%d", TMPatternTypeDaily];
	NSArray* schedule_workday = [tms filteredArrayUsingPredicate:pred];
	
	NSPredicate* pred_once = [NSPredicate predicateWithFormat:@"SELF.pattern=%d", TMPatternTypeOnce];
	NSArray* schedule_restday = [tms filteredArrayUsingPredicate:pred_once];
	
	for (NSDictionary* dic in schedule_workday) {
		NSLog(@"one tms is %@", dic);
		NSMutableDictionary *duration = [[NSMutableDictionary alloc] init];
		[duration setValue:[dic objectForKey:@"starthours"] forKey:kAYServiceArgsStart];
		[duration setValue:[dic objectForKey:@"endhours"] forKey:kAYServiceArgsEnd];
			
		if (![workdayTimesArr containsObject:duration]) {
			[workdayTimesArr addObject:duration];
		}
	}
	
	for (NSDictionary* dic in schedule_restday) {
		NSLog(@"one tms is %@", dic);
//		NSNumber *startdate = [dic objectForKey:@"startdate"];
		NSTimeInterval startdate = ((NSNumber*)[dic objectForKey:@"startdate"]).doubleValue * 0.001;
		NSNumber* starthours = ((NSNumber*)[dic objectForKey:@"starthours"]);
		NSNumber* endhours =  ((NSNumber*)[dic objectForKey:@"endhours"]);
		
		NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF.timePointHandle=%ld", (long)startdate];
		NSPredicate* pred_other = [NSPredicate predicateWithFormat:@"SELF.timePointHandle!=%ld", (long)startdate];
		
		NSArray *oneArr = [restdayTimesArr filteredArrayUsingPredicate:pred];
		NSMutableDictionary* one = oneArr.firstObject;
		NSMutableArray* other = [[restdayTimesArr filteredArrayUsingPredicate:pred_other] mutableCopy];//当前已存入的数据Arr
		
		if (one) {
			NSMutableArray* arr = [one objectForKey:@"rest_schedule"];
			NSMutableDictionary* nd = [[NSMutableDictionary alloc]init];
			[nd setValue:starthours forKey:kAYServiceArgsStart];
			[nd setValue:endhours forKey:kAYServiceArgsEnd];
			
			[arr addObject:nd];
		} else {
			one = [[NSMutableDictionary  alloc]init];
			[one setValue:[NSNumber numberWithDouble:startdate] forKey:kAYServiceArgsTPHandle];
			
			NSMutableArray* arr = [[NSMutableArray alloc]init];
			NSMutableDictionary* nd = [[NSMutableDictionary alloc]init];
			[nd setValue:starthours forKey:kAYServiceArgsStart];
			[nd setValue:endhours forKey:kAYServiceArgsEnd];
			
			[arr addObject:nd];
			
			[one setValue:arr forKey:@"rest_schedule"];
			[one setValue:[NSNumber numberWithBool:(![starthours isEqualToNumber:@1] && ![endhours isEqualToNumber:@1])] forKey:@"rest_isable"];
			
		}
		
		[other addObject:one];
		restdayTimesArr = [other copy];
		
	}
	
	
	
	NSMutableDictionary *back_args = [[NSMutableDictionary alloc] init];
	[back_args setValue:[workdayTimesArr copy] forKey:@"schedule_workday"];
	[back_args setValue:[restdayTimesArr copy] forKey:@"schedule_restday"];
	
	*obj = [back_args copy];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}
@end

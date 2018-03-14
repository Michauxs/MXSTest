//
//  AYParseSTMForDayCourseCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 27/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYParseSTMForDayCourseCommand.h"

@implementation AYParseSTMForDayCourseCommand

@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic_parse = (NSDictionary*)*obj;
	NSArray* tms = [dic_parse objectForKey:kAYServiceArgsTimes];
//	NSNumber *timeHandle = [dic_parse objectForKey:kAYServiceArgsTPHandle];
	
	NSMutableArray *result = [NSMutableArray array];
	
	for (NSDictionary *dic_tm in tms) {
		TMPatternType type = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsPattern]).intValue;
		switch (type) {
			case TMPatternTypeDaily: {
				
			}
				break;
			case TMPatternTypeWeekly: {
				
			}
				break;
			case TMPatternTypeMonthly: {
				
			}
				break;
			case TMPatternTypeOnce: {
				
			}
				break;
				
			default:
			break;
		}
	}
	
	*obj = [result copy];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}
@end

//
//  AYParseServiceTMProtocolCommand.m
//  BabySharing
//
//  Created by BM on 17/02/2017.
//  Copyright © 2017 Alfred Yang. All rights reserved.
//

#import "AYParseServiceTMProtocolCommand.h"

@implementation AYParseServiceTMProtocolCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    // need to modify
    NSArray* tms = (NSArray*)*obj;
    
    NSArray* result = [[NSArray alloc]init];
    
    for (NSDictionary* dic in tms) {
        NSLog(@"one tms is %@", dic);
        
        /**
         * 1. pattern 现在没有用
         */
        // [dic objectForKey:@"pattern"];
        
        /**
         * 2. startdate and enddate
         */
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitWeekday;
		
        bool isValidate = true;
        long start = ((NSNumber*)[dic objectForKey:@"startdate"]).longValue;
//        {
//            long now = [[NSDate date] timeIntervalSince1970] * 1000;
//            isValidate &= now > start;
//            long end = ((NSNumber*)[dic objectForKey:@"enddate"]).longValue;
//            isValidate &= end < 0 || now < end;
//        }
		
        if (isValidate) {
            NSDate* d = [NSDate dateWithTimeIntervalSince1970:start / 1000];
            
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            comps = [calendar components:unitFlags fromDate:d];
            NSInteger day = [comps weekday] - 1;
            
            NSNumber* starthours = ((NSNumber*)[dic objectForKey:@"starthours"]);
            NSNumber* endhours =  ((NSNumber*)[dic objectForKey:@"endhours"]);
            
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF.day=%d", day];
            NSPredicate* pred_other = [NSPredicate predicateWithFormat:@"SELF.day!=%d", day];
			
            NSMutableDictionary* one = [result filteredArrayUsingPredicate:pred].firstObject;
			
            NSMutableArray* other = [[result filteredArrayUsingPredicate:pred_other] mutableCopy];
            
            if (one) {
                NSMutableArray* arr = [one objectForKey:@"occurance"];
                NSMutableDictionary* nd = [[NSMutableDictionary alloc]init];
                [nd setValue:starthours forKey:kAYServiceArgsStart];
                [nd setValue:endhours forKey:kAYServiceArgsEnd];
                
                [arr addObject:nd];
            } else {
                one = [[NSMutableDictionary  alloc]init];
                [one setValue:[NSNumber numberWithInteger:day] forKey:@"day"];
                
                NSMutableArray* arr = [[NSMutableArray alloc]init];
                NSMutableDictionary* nd = [[NSMutableDictionary alloc]init];
                [nd setValue:starthours forKey:kAYServiceArgsStart];
                [nd setValue:endhours forKey:kAYServiceArgsEnd];
                
                [arr addObject:nd];
                
                [one setValue:arr forKey:@"occurance"];
            }
            
            [other addObject:one];
            result = [other copy];
        }
    }
    
    *obj = result;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end

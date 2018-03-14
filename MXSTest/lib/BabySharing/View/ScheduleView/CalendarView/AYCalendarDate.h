//
//  AYCalendarDate.h
//  BabySharing
//
//  Created by Alfred Yang on 23/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYCalendarDate : NSObject

/** 公历 */
@property (nonatomic, strong) NSCalendar *gregorianCalendar;
/** 农历 */
@property (nonatomic, strong) NSCalendar *chineseCalendar;
/** 格式化 date <--> string */
@property (nonatomic, strong) NSDateFormatter *formatter;

/** 农历年 */
@property (nonatomic, strong) NSArray *chineseYears;
/** 农历月 */
@property (nonatomic, strong) NSArray *chineseMonths;
/** 农历日 */
@property (nonatomic, strong) NSArray *chineseDays;
/** 星期 */
@property (nonatomic, strong) NSArray *chineseWeekDays;

/**
 *  根据给定字符串返回字符串代表月的天数
 *  @param dateStr @"xxxx-xx-xx"
 *  @return 28 or 29 or 30 or 31
 */
-(NSInteger) timeNumberOfDaysInString:(NSString *) dateStr;
-(NSInteger) timeNumberOfDaysInDate:(NSDate *) date;

/**
 *  根据给定字字符串返回字符串代表天是星期几
 *  @param dateStr @"xxxx-xx-xx"
 *  @return 0-周日 or 1－周一 or 2－周二 or 3－周三 or 4－周四 or 5－周五 or 6－周六
 */
-(NSInteger) timeMonthWeekDayOfFirstDay:(NSString *)dateStr;

/**
 * 获得一个月“占”几个星期
 *  @param dateStr @"xxxx-xx-xx"
 *  @return 4 or 5 or 6
 */
-(NSInteger)timeFewWeekInMonth:(NSString *)dateStr;

/**
 *  根据给定字符串返回字符串代表的农历的日
 *  @param dateStr @"xxxx-xx-xx"
 *  @return 1～30
 */
-(NSString *)timeChineseDaysWithDate:(NSString *)dateStr;

/**
 *  根据给定字符串返回字符串代表的农历的日期
 *  @param dateStr @"xxxx-xx-xx"
 *  @return 丙寅虎年 四月廿四 星期三
 */
- (NSString *) timeChineseCalendarWithString:(NSString *)dateStr;
- (NSString *) timeChineseCalendarWithDate:(NSDate *)date;

// 字符串转日期
- (NSDate *) strToDate:(NSString *)dateStr;
// 日期转字符串
- (NSString *) dataToString:(NSDate *)date;
//返回当前年
-(int)getYear;
//返回当前月
-(int)getMonth;
//返回当前日
-(int)getDay;

@end

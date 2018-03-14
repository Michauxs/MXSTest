//
//  AYBOrderTimeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderTimeDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYMapMatchCellView.h"
#import "AYBOrderTimeItemView.h"
#import "AYBOrderTimeDefines.h"

@implementation AYBOrderTimeDelegate {
	NSArray *serviceTMs;
	NSDictionary *querydata;
	NSTimeInterval todayTimeSpan;
	NSDate *currentDate;
	NSCalendar *calendarTools;
	
	int theYear;
	int theMonth;
	int theDay;
	
	NSTimeInterval selectedItemHandle;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	if (!_useTime) {
		_useTime = [[AYCalendarDate alloc]init];
	}
	currentDate = [NSDate date];
	NSString *dateStr = [_useTime dataToString:currentDate];
	todayTimeSpan = [_useTime strToDate:dateStr].timeIntervalSince1970;
	
	theYear = [self.useTime getYear];
	theMonth = [self.useTime getMonth];
	
//	NSDate *handleDate = [NSDate dateWithTimeIntervalSince1970:timeSpanhandle.doubleValue];
	calendarTools = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
	[calendarTools setTimeZone: timeZone];
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (id)setInitStatesData:(id)args {
	serviceTMs = args;
	return nil;
}

- (id)changeQueryData:(id)args {
	querydata = args;
	return nil;
}

#pragma mark -- collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	NSInteger numb = 1 * 12;
	return numb;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger sect = section + theMonth -1;
	NSString *strYear = [NSString stringWithFormat:@"%ld", sect / 12 + theYear];
	NSString *strMonth = [NSString stringWithFormat:@"%ld", sect % 12 + 1];
	NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01", strYear, strMonth];
	
	return [self.useTime timeFewWeekInMonth:dateStr] * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYBOrderTimeItemView *cell = (AYBOrderTimeItemView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AYBOrderTimeItemView" forIndexPath:indexPath];
	
	NSInteger sect = indexPath.section + theMonth -1;		//月份本比序号大1，之前版本序号转月份+1，不改保持不变，此处-1
	
	//每个月的第一天
	NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%d", sect/12 + theYear, sect%12 + 1, 1];
	//获得这个月的天数
	self.monthNumber = [self.useTime timeNumberOfDaysInString:dateStr];
	//获得这个月第一天是星期几
	self.dayOfWeek = [self.useTime timeMonthWeekDayOfFirstDay:dateStr];
	
	NSInteger firstCorner = self.dayOfWeek;
	NSInteger lastConter = self.dayOfWeek + self.monthNumber - 1;
	NSInteger gregoiain = indexPath.item - firstCorner+1;
	cell.day = (int)gregoiain;
	if (indexPath.item < firstCorner || indexPath.item > lastConter) {
		cell.hidden = YES;
	} else {
		cell.hidden = NO;
		[cell setInitStates];
		NSInteger gregoiain = indexPath.item - firstCorner+1;
		NSString *cellDateStr = [NSString stringWithFormat:@"%ld-%ld-%d", sect/12 + theYear, (sect)%12 + 1, (int)gregoiain];
		NSDate *cellDate = [_useTime strToDate:cellDateStr];
		NSTimeInterval cellTimeSpan = cellDate.timeIntervalSince1970;
		cell.timeSpan = cellTimeSpan;
		if (cellTimeSpan == todayTimeSpan) {
			[cell setTodayStates];
		}
		
		for (NSDictionary *dic_tm in serviceTMs) {
			NSNumber *pattern = [dic_tm objectForKey:kAYServiceArgsPattern];
			double start = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
			double end = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsEndDate]).doubleValue * 0.001;
			int startHours = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartHours]).intValue;
			
			if (pattern.intValue == TMPatternTypeDaily) {
				if (cellTimeSpan >= todayTimeSpan && (cellTimeSpan <= end || end == -0.001) && start != 1) {
					[cell setEnAbleStates];
					break;
				}
			}
			else if (pattern.intValue == TMPatternTypeWeekly) {
				NSDateComponents *cellComponents = [calendarTools components:NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSince1970:cellTimeSpan]];
				int cellWeekday = (int)cellComponents.weekday - 1;
				NSDateComponents *startComponents = [calendarTools components:NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSince1970:start]];
				int startWeekday = (int)startComponents.weekday - 1;
				if (cellWeekday == startWeekday && (cellTimeSpan <= end || end == -0.001) && cellTimeSpan >= todayTimeSpan && start != 1) {
					[cell setEnAbleStates];
					break;
				}
			}
			else if (pattern.intValue == TMPatternTypeOnce) {
				if ((cellTimeSpan >= start) && (cellTimeSpan < start + OneDayTimeInterval -1) && (cellTimeSpan >= todayTimeSpan)) {
					if (startHours == 1) {
						[cell setInitStates];
					} else {
						[cell setEnAbleStates];
					}
					break;
				}
			}
			else {
				
			}
		} //forin item status
		
		for (NSString *k in [querydata allKeys]) {
			double handle = k.doubleValue;
			
			NSArray *times = [querydata objectForKey:k];
			if (handle == cellTimeSpan && times.count != 0) {
				if ([times.firstObject count] == 2) {
					[cell setSelectedStates];
				}
				else if([times.firstObject count] == 3){
					NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"is_selected", 1];
					NSArray *resultArr = [times filteredArrayUsingPredicate:pred];
					if (resultArr.count != 0) {
						[cell setSelectedStates];
					}
				}
			}
		}	//forin 是否选定当前日期
		
		if(cellTimeSpan == selectedItemHandle) {
			[cell setDidSelected];
		}
	}
	return cell;
}

//获得据section／cell的完整日期
- (NSString *)getDateStrForSection:(NSInteger)section day:(NSInteger)day {
	section = section + theMonth -1;		//月份本比序号大1，之前版本序号转月份+1(不改保持不变)，此处-1
	return [NSString stringWithFormat:@"%ld-%ld-%ld", section/12 + theYear, section%12 + 1, day];
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AYDayCollectionHeader" forIndexPath:indexPath];
		UILabel *label = [headerView viewWithTag:119];
		if (label == nil) {
			label = [Tools creatLabelWithText:nil textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
			label.tag = 119;
			[headerView addSubview:label];
			[label mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerY.equalTo(headerView);
				make.left.equalTo(headerView).offset(15);
			}];
			[Tools creatCALayerWithFrame:CGRectMake(0, itemWidth - 0.5, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:headerView];
		}
		
		NSInteger sect = indexPath.section + theMonth -1;
		label.text = [NSString stringWithFormat:@"%ld年 %.2ld月", sect/12 + theYear, sect % 12 + 1];
		return headerView;
	}
	return nil;
}

//设置header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	CGFloat width = SCREEN_WIDTH - screenPadding * 2;
	return (CGSize){width, itemWidth};
}

#pragma mark -- cell点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	AYBOrderTimeItemView * cell = (AYBOrderTimeItemView *)[collectionView cellForItemAtIndexPath:indexPath];
	
	[cell setDidSelected];
}

#pragma mark -- cell反选
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//	AYBOrderTimeItemView * cell = (AYBOrderTimeItemView *)[collectionView cellForItemAtIndexPath:indexPath];
//	if (cell.isEnAbled) {
//		
//		NSTimeInterval time_p = cell.timeSpan;
//		NSNumber *tmp = [NSNumber numberWithDouble:time_p];
//		kAYViewSendNotify(self, @"didDeselectItemAtIndexPath:", &tmp)
//	}
//}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	AYBOrderTimeItemView * cell = (AYBOrderTimeItemView *)[collectionView cellForItemAtIndexPath:indexPath];
	NSLog(@"%d", cell.isEnAbled);
	if (cell.isEnAbled) {
		selectedItemHandle = cell.timeSpan;
		NSInteger sect = indexPath.section + theMonth -1;
		NSString *strYear = [NSString stringWithFormat:@"%ld", sect / 12 + theYear];
		NSString *strMonth = [NSString stringWithFormat:@"%ld", sect % 12 + 1];
		NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01", strYear, strMonth];
		NSInteger weekNumb = [self.useTime timeFewWeekInMonth:dateStr];
		
		NSTimeInterval time_p = cell.timeSpan;
		//		NSNumber *tmp = [NSNumber numberWithDouble:time_p];
		
		NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
		[tmp setValue:[NSNumber numberWithInteger:weekNumb] forKey:@"numb_weeks"];
		[tmp setValue:[NSNumber numberWithDouble:time_p] forKey:@"interval"];
		[tmp setValue:indexPath forKey:@"index_path"];
		
		kAYDelegateSendNotify(self, @"didSelectItemAtIndexPath:", &tmp)
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (id)dateScrollToCenter:(NSString*)str {
	str = [str substringToIndex:10];
	NSArray *calendar = [str componentsSeparatedByString:@"年"];
	NSArray *calendar2 = [calendar[1] componentsSeparatedByString:@"月"];
	[self refreshControlWithYear:calendar[0] month:calendar2[0] day:calendar2[1]];
	return nil;
}

- (void)refreshControlWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day {
	// 每个月的第一天
	NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@", year, month, @1];
	// 获得这个月第一天是星期几
	NSInteger dayOfFirstWeek = [_useTime timeMonthWeekDayOfFirstDay:dateStr];
	NSInteger section = (year.integerValue - theYear)*12 + (month.integerValue - 1);
	NSInteger item = day.integerValue + dayOfFirstWeek - 1;
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
	kAYDelegateSendNotify(self, @"scrollToCenter:", &indexPath)
}

- (NSString*)transformTimespanToMouthAndDayWithDate:(NSTimeInterval)timespan {
	NSDate *itemDate = [NSDate dateWithTimeIntervalSince1970:timespan];
	NSDateFormatter *unformat = [Tools creatDateFormatterWithString:@"MM月dd日"];
	NSString *date_string = [unformat stringFromDate:itemDate];
	return date_string;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(itemWidth, itemWidth);
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	static CGFloat offset_origin_y = 0;
	CGFloat offset_now_y = scrollView.contentOffset.y;
	if (offset_origin_y - offset_now_y  > 10) {		//下滑
		id<AYCommand> cmd = [self.notifies objectForKey:@"scrollToShowMore"];
		[cmd performWithResult:nil];
	}
	offset_origin_y = offset_now_y;
}

#pragma mark -- actions

@end

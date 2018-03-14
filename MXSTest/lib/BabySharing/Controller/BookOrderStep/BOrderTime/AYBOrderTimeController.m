//
//  AYBOrderTimeController.m
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderTimeController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYModelFacade.h"
#import "AYBOrderTimeDefines.h"
#import "AYServTimesBtn.h"

@implementation AYBOrderTimeController {
	
	NSMutableArray *offer_date_mutable;
	NSDictionary *service_info;
//	NSInteger timesCount;
	/******/
	UILabel *dateShowLabel;
	UIButton *certainBtn;
	
	NSInteger creatOrUpdateNote;
	NSMutableArray *timesArr;
	NSMutableDictionary *OTMSet;
	
	NSIndexPath *indexPathHandle;
	NSNumber *timeSpanhandle;
	
	NSString *serviceCat;
	
	NSArray *serviceTMs;
	NSMutableArray *tms_mutable;
	
	BOOL isAnimateCompletion;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		NSDictionary *tmp = [dic objectForKey:kAYControllerChangeArgsKey];
		offer_date_mutable = [tmp objectForKey:kAYServiceArgsOfferDate];
		service_info = [tmp objectForKey:kAYServiceArgsInfo];
		serviceCat = [[service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
		serviceTMs = [service_info objectForKey:kAYServiceArgsTimes];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (NSDictionary*)transTimeSpanWithDic:(NSDictionary*)dic_time andDate:(NSDate*)now andDay:(NSNumber*)day andweektoday:(NSInteger)weekday andMultiple:(NSInteger)multiple {
	
	NSTimeInterval nowSpan = now.timeIntervalSince1970;
	NSNumber *time_start = [dic_time objectForKey:kAYServiceArgsStart];
	NSNumber *time_end = [dic_time objectForKey:kAYServiceArgsEnd];
	
	// (weekday + x ) % 7 = "day"    x=?
	int lag;
	for (int i = 0; ; ++i) {
		if ((weekday + i ) % 7 == day.intValue) {
			lag = i;
			break ;
		}
	}
	
	NSTimeInterval transDaySpan = nowSpan + (lag + multiple * 7) * 86400;
	NSDate *transDayDate = [NSDate dateWithTimeIntervalSince1970:transDaySpan];
	NSDateFormatter *form = [Tools creatDateFormatterWithString:@"yyyy-MM-dd"];
	NSString *transDayStr = [form stringFromDate:transDayDate];
	
	NSMutableString *tmp = [NSMutableString stringWithFormat:@"%@", time_start];
	[tmp insertString:@":" atIndex:tmp.length - 2];
	NSString *startTimeStr = [NSString stringWithFormat:@"%@ %@", transDayStr, tmp];
	
	tmp = [NSMutableString stringWithFormat:@"%@", time_end];
	[tmp insertString:@":" atIndex:tmp.length - 2];
	NSString *endTimeStr = [NSString stringWithFormat:@"%@ %@", transDayStr, tmp];
	
	NSDateFormatter *formTime = [Tools creatDateFormatterWithString:@"yyyy-MM-dd H:mm"];
	
	NSDate *startTimeDate = [formTime dateFromString:startTimeStr];
	NSDate *endTimeDate = [formTime dateFromString:endTimeStr];
	
	NSTimeInterval startTimeSpan = startTimeDate.timeIntervalSince1970;
	NSTimeInterval endTimeSpan = endTimeDate.timeIntervalSince1970;
	
	NSMutableDictionary *dic_timespan = [[NSMutableDictionary alloc]init];
	[dic_timespan setValue:[NSNumber numberWithDouble:startTimeSpan * 1000] forKey:kAYServiceArgsStart];
	[dic_timespan setValue:[NSNumber numberWithDouble:endTimeSpan * 1000] forKey:kAYServiceArgsEnd];
	
	return dic_timespan;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [Tools whiteColor];
	[self preferredStatusBarStyle];
	
	timesArr = [NSMutableArray array];
	if (!OTMSet) {
		OTMSet = [[NSMutableDictionary alloc] init];
	}
	
	dateShowLabel = [Tools creatLabelWithText:@"选择日期" textColor:[Tools whiteColor] fontSize:13.f backgroundColor:[Tools theme] textAlignment:NSTextAlignmentCenter];
	[self.view addSubview:dateShowLabel];
	[dateShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.top.equalTo(self.view).offset(kStatusAndNavBarH);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
	}];
	
	NSArray *weekdayTitle = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
	for (int i = 0; i < weekdayTitle.count; ++i) {
		UILabel *itemLabel = [Tools creatLabelWithText:[weekdayTitle objectAtIndex:i] textColor:[Tools black] fontSize:311.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self.view addSubview:itemLabel];
		[itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(dateShowLabel.mas_bottom).offset(20);
			make.centerX.equalTo(self.view.mas_left).offset(itemWidth*0.5 + itemWidth * i);
		}];
	}
	
	{
		id<AYViewBase> view_collection= [self.views objectForKey:kAYCollectionVerView];
		id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"BOrderTime"];
		id<AYCommand> cmd_datasource = [view_collection.commands objectForKey:@"registerDatasource:"];
		id<AYCommand> cmd_delegate = [view_collection.commands objectForKey:@"registerDelegate:"];
		
		id obj = (id)cmd_notify;
		[cmd_datasource performWithResult:&obj];
		obj = (id)cmd_notify;
		[cmd_delegate performWithResult:&obj];
		
		id<AYCommand> cmd_cell = [view_collection.commands objectForKey:@"registerCellWithClass:"];
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderTimeItem"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		[cmd_cell performWithResult:&class_name];
		[(UICollectionView*)view_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AYDayCollectionHeader"];
		id args = [serviceTMs copy];
		
		kAYDelegatesSendMessage(@"BOrderTime", @"setInitStatesData:", &args)
	}
	
	{
		id<AYViewBase> view_picker = [self.views objectForKey:kAYPickerView];
		id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
		id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
		
		id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServiceTimesPick"];
		
		id obj = (id)cmd_recommend;
		[cmd_datasource performWithResult:&obj];
		obj = (id)cmd_recommend;
		[cmd_delegate performWithResult:&obj];
	}
	{
		id<AYViewBase> view_table = [self.views objectForKey:kAYTableView];
		id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"BOTimeTable"];
		
		id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
		id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
		
		id obj = (id)cmd_notify;
		[cmd_datasource performWithResult:&obj];
		obj = (id)cmd_notify;
		[cmd_delegate performWithResult:&obj];
		
		id<AYCommand> cmd_class = [view_table.commands objectForKey:@"registerCellWithClass:"];
		NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"AddOTimeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		[cmd_class performWithResult:&cell_name];
		cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OTMNurseCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		[cmd_class performWithResult:&cell_name];
		cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OTMCourseCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		[cmd_class performWithResult:&cell_name];
		
		id t = [serviceCat copy];
		kAYDelegatesSendMessage(@"BOTimeTable", @"setDelegateType:", &t)
	}
	
	certainBtn = [Tools creatBtnWithTitle:@"申请预订" titleColor:[Tools whiteColor] fontSize:318.f backgroundColor:[Tools disableBackgroundColor]];
	[self.view addSubview:certainBtn];
	[certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset( -HOME_IND_HEIGHT);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, BOTTOM_HEIGHT));
	}];
	certainBtn.enabled = NO;
	[certainBtn addTarget:self action:@selector(didCertainBtnnClick) forControlEvents:UIControlEventTouchUpInside];
	
	UIView* picker = [self.views objectForKey:@"Picker"];
	[self.view bringSubviewToFront:picker];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	view.backgroundColor = [Tools theme];
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	view.backgroundColor = [Tools theme];
	
	UIImage *left = IMGRESOURCE(@"bar_left_white");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSString *title = @"可预约时间";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIColor *color = [Tools whiteColor];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleColorMessage, &color)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	return nil;
}

- (id)CollectionVerLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusAndNavBarH + 40 + 40, SCREEN_WIDTH - screenPadding * 2, SCREEN_HEIGHT - kStatusAndNavBarH - 40 - 40 - BOTTOM_HEIGHT - HOME_IND_HEIGHT);
	view.backgroundColor = [UIColor clearColor];
	((UICollectionView*)view).allowsMultipleSelection = YES;
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.backgroundColor = [Tools garyBackgroundColor];
	view.frame = CGRectMake(0, SCREEN_HEIGHT - BOTTOM_HEIGHT - HOME_IND_HEIGHT, SCREEN_WIDTH, 0);
		
	if ([serviceCat isEqualToString:kAYStringCourse]) {
		UIView *libgView = [[UIView alloc] initWithFrame:CGRectMake(26.5, 0, 1.f, 736)];
		libgView.backgroundColor = [Tools theme];
		[view addSubview:libgView];
		[view sendSubviewToBack:libgView];
	}
	return nil;
}

- (id)PickerLayout:(UIView*)view {
	view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
	return nil;
}

#pragma mark -- actions
- (NSArray *)transDicWithOTMDictionary:(NSDictionary*)dic_otm {
	NSMutableArray *orderTimeSpans = [NSMutableArray array];
	NSEnumerator* enumerator = OTMSet.keyEnumerator;
	id iter = nil;
	while ((iter = [enumerator nextObject]) != nil) {
		
		NSDateFormatter *dateform = [Tools creatDateFormatterWithString:@"yyyy-MM-dd"];
		NSString *dateStr = [dateform stringFromDate:[NSDate dateWithTimeIntervalSince1970:((NSString*)iter).doubleValue]];
		
		NSArray *order_times = [OTMSet objectForKey:iter];
		for (NSDictionary *dic_tm in order_times) {
			if ([serviceCat isEqualToString:kAYStringCourse]) {
				if (((NSNumber*)[dic_tm objectForKey:@"is_selected"]).boolValue) {
					NSString *date_start = [NSString stringWithFormat:@"%@%.4d", dateStr, ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStart]).intValue];
					NSString *date_end = [NSString stringWithFormat:@"%@%.4d", dateStr, ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsEnd]).intValue];
					NSDateFormatter *formatter_c = [Tools creatDateFormatterWithString:@"yyyy-MM-ddHHmm"];
					NSTimeInterval start_timespan = [formatter_c dateFromString:date_start].timeIntervalSince1970;
					NSTimeInterval end_timespan = [formatter_c dateFromString:date_end].timeIntervalSince1970;
					
					NSMutableDictionary *dic_offer_date = [[NSMutableDictionary alloc] init];
					[dic_offer_date setValue:[NSNumber numberWithDouble:start_timespan*1000] forKey:kAYServiceArgsStart];
					[dic_offer_date setValue:[NSNumber numberWithDouble:end_timespan*1000] forKey:kAYServiceArgsEnd];
					[orderTimeSpans addObject:dic_offer_date];
				}
			} else {
				NSString *date_start = [NSString stringWithFormat:@"%@%.4d", dateStr, ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStart]).intValue];
				NSString *date_end = [NSString stringWithFormat:@"%@%.4d", dateStr, ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsEnd]).intValue];
				NSDateFormatter *formatter_c = [Tools creatDateFormatterWithString:@"yyyy-MM-ddHHmm"];
				NSTimeInterval start_timespan = [formatter_c dateFromString:date_start].timeIntervalSince1970;
				NSTimeInterval end_timespan = [formatter_c dateFromString:date_end].timeIntervalSince1970;
				
				NSMutableDictionary *dic_offer_date = [[NSMutableDictionary alloc] init];
				[dic_offer_date setValue:[NSNumber numberWithDouble:start_timespan*1000] forKey:kAYServiceArgsStart];
				[dic_offer_date setValue:[NSNumber numberWithDouble:end_timespan*1000] forKey:kAYServiceArgsEnd];
				[orderTimeSpans addObject:dic_offer_date];
			}
			
		}
		
	}
	[orderTimeSpans sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [[obj1 objectForKey:kAYServiceArgsStart] doubleValue] > [[obj2 objectForKey:kAYServiceArgsStart] doubleValue];
	}];
	return [orderTimeSpans copy];
}

- (void)didCertainBtnnClick {
	
	NSDictionary* user = nil;
	CURRENPROFILE(user);
	NSString *user_id = [user objectForKey:@"user_id"];
	NSString *owner_id = [service_info objectForKey:@"owner_id"];
	if ([user_id isEqualToString:owner_id]) {
		NSString *title = @"您不能预订自己发布的服务";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return;
	}
	
	NSNumber *leastNode;
	NSArray *order_times = [self transDicWithOTMDictionary:nil];
	NSDictionary *info_detail = [service_info objectForKey:kAYServiceArgsDetailInfo];
	if ([serviceCat isEqualToString:kAYStringCourse]) {
		leastNode = [info_detail objectForKey:kAYServiceArgsLeastTimes];
		if (order_times.count < leastNode.intValue) {
			NSString *title = [NSString stringWithFormat:@"该服务最少预定%@次", leastNode];
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			return;
		}
	} else if ([serviceCat isEqualToString:kAYStringNursery]) {
		leastNode = [info_detail objectForKey:kAYServiceArgsLeastHours];
		double sum = 0;
		for (NSDictionary *dic_time in order_times) {
			double start = ((NSNumber*)[dic_time objectForKey:kAYServiceArgsStart]).doubleValue;
			double end = ((NSNumber*)[dic_time objectForKey:kAYServiceArgsEnd]).doubleValue;
			sum += end - start;
		}
		CGFloat sum_hours = sum *0.001 / 60 / 60;
		if (sum_hours < leastNode.floatValue) {
			NSString *title = [NSString stringWithFormat:@"该服务最少预定%@小时", leastNode];
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			return;
		}
	}
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:order_times forKey:@"order_times"];
	[tmp setValue:[service_info copy] forKey:kAYServiceArgsInfo];
	
	/**
	 * 2. check profile has_phone, if not, go confirmNoConsumer
	 */
	if (((NSNumber*)[user objectForKey:kAYProfileArgsIsHasPhone]).boolValue) {
		
		id<AYCommand> des = DEFAULTCONTROLLER(@"BOrderMain");
		NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
		[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
		[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
		[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
		[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
		
		id<AYCommand> cmd_show_module = PUSH;
		[cmd_show_module performWithResult:&dic];
		
	} else {
		id<AYCommand> des = DEFAULTCONTROLLER(@"ConfirmPhoneNoConsumer");
		NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
		[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
		[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
		[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
		[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
		
		id<AYCommand> cmd_show_module = PUSH;
		[cmd_show_module performWithResult:&dic];
	}
	
}

- (void)setTipTitleWithInterval:(NSTimeInterval)interval {
	NSDateFormatter *formatter = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日"];
	NSString *title = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
	dateShowLabel.text = title;
}

- (void)checkCertainBtnStates {
	
	//1.判断Set中的数据是否可以响应 下一步btn
	if ([serviceCat isEqualToString:kAYStringCourse]) {
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.%@=%@", @"is_selected", @1];
		NSArray *result = [timesArr filteredArrayUsingPredicate:pred];
		[self checkTimesArrOrCheckOTMSetWithHandle:result];
	} else {
		[self checkTimesArrOrCheckOTMSetWithHandle:timesArr];
	}
	
}
- (void)checkTimesArrOrCheckOTMSetWithHandle:(NSArray*)array {
	//当前handle中 是否有数据
	if (array.count == 0) {
		//删除 空handle，检查Set中是否有数据			update:空handle不删除，更新判断条件
//		[OTMSet removeObjectForKey:timeSpanhandle.stringValue];
		
		BOOL isContainsSet = NO;
		for (NSArray *arr in [OTMSet allValues]) {
			if (arr.count != 0) {
				isContainsSet = YES;
				break;
			}
		}
		
		if (isContainsSet) {
			certainBtn.backgroundColor = [Tools theme];
			certainBtn.enabled = YES;
		} else {
			//没有数据，btn不可用
			certainBtn.backgroundColor = [Tools disableBackgroundColor];
			certainBtn.enabled = NO;
		}
	} else {
		certainBtn.backgroundColor = [Tools theme];
		certainBtn.enabled = YES;
	}
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	id<AYCommand> cmd = REVERSMODULE;
	[cmd performWithResult:&dic];
	return nil;
}

#pragma mark -- collection delegate notifies
- (id)didSelectItemAtIndexPath:(id)args {
	
	UICollectionView *view_collection = [self.views objectForKey:@"CollectionVer"];
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	if (indexPathHandle) {
		
		id tmp_set = [OTMSet copy];
		kAYDelegatesSendMessage(@"BOrderTime", kAYDelegateChangeDataMessage, &tmp_set)
		[view_collection reloadItemsAtIndexPaths:@[indexPathHandle]];
		//	[view_collection selectItemAtIndexPath:indexPathHandle animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	}
	
	//替换 NSIndexPath handle数据
	indexPathHandle = [args objectForKey:@"index_path"];
	timeSpanhandle = [args objectForKey:@"interval"];
	timesArr = [OTMSet objectForKey:timeSpanhandle.stringValue];
	
	if ([serviceCat isEqualToString:kAYStringNursery]) {
		if (!timesArr || timesArr.count == 0) {
			timesArr = [NSMutableArray array];
			[OTMSet setValue:timesArr forKey:timeSpanhandle.stringValue];
		}
		
		int maxEnd = 0;
		int minStart = 24;		//确保遍历第一个元素时 重新赋值
		for (NSDictionary *dic_tm in serviceTMs) {
			NSTimeInterval startdate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartDate]).doubleValue * 0.001;
			NSTimeInterval enddate = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsEndDate]).doubleValue * 0.001;
			if (timeSpanhandle.doubleValue + OneDayTimeInterval -1 >= startdate && (timeSpanhandle.doubleValue < enddate || enddate == -0.001)) {
				int starthours = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsStartHours]).intValue / 100;
				int endhours = ((NSNumber*)[dic_tm objectForKey:kAYServiceArgsEndHours]).intValue / 100;
				if (starthours != 0 && starthours < minStart) {
					minStart = starthours;
				}
				if (endhours != 0 && endhours > maxEnd) {
					maxEnd = endhours;
				}
			}
		}
		NSMutableArray *tmpArr = [NSMutableArray array];
		int span = maxEnd-minStart;
		for (int i = 0; i<= span; ++i) {
			[tmpArr addObject:[NSString stringWithFormat:@"%.2d",minStart + i]];
		}
		NSMutableDictionary *dic_data = [[NSMutableDictionary alloc] init];
		[dic_data setValue:[tmpArr copy] forKey:@"hours"];
		kAYDelegatesSendMessage(@"ServiceTimesPick", @"changeOptionData:", &dic_data);
		kAYViewsSendMessage(kAYPickerView, kAYTableRefreshMessage, nil);
	}
	else if ([serviceCat isEqualToString:kAYStringCourse]) {
		if (!timesArr) {
			
			NSDate *handleDate = [NSDate dateWithTimeIntervalSince1970:timeSpanhandle.doubleValue];
			NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
			NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
			[calendar setTimeZone: timeZone];
			NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
			NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:handleDate];
			int weekdaySep = (int)theComponents.weekday - 1;
			
			NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF.%@=%d", @"day", weekdaySep];
			NSArray *resultArr = [offer_date_mutable filteredArrayUsingPredicate:pred];
			NSMutableArray *f = [[[resultArr firstObject] mutableCopy] objectForKey:kAYServiceArgsOccurance];
			
			timesArr = [NSMutableArray array];
			for (NSDictionary *dic in f) {
				NSMutableDictionary *dic_div = [[NSMutableDictionary alloc] init];
				[dic_div setValue:[NSNumber numberWithInt:[[dic objectForKey:kAYServiceArgsStart] intValue]] forKey:kAYServiceArgsStart];
				[dic_div setValue:[NSNumber numberWithInt:[[dic objectForKey:kAYServiceArgsEnd] intValue]] forKey:kAYServiceArgsEnd];
				[dic_div setValue:[NSNumber numberWithBool:[[dic objectForKey:@"is_selected"] boolValue]] forKey:@"is_selected"];
				[timesArr addObject:dic_div];
			}
			[OTMSet setValue:timesArr forKey:timeSpanhandle.stringValue];
		} else {
			NSLog(@"exist");
		}
	}
	
	NSArray *tmp = [timesArr copy];
	kAYDelegatesSendMessage(@"BOTimeTable", kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	
	NSTimeInterval t = timeSpanhandle.doubleValue;
	[self setTipTitleWithInterval:t];
	
	NSInteger numb = ((NSNumber*)[args objectForKey:@"numb_weeks"]).integerValue;
	numb = 2;
	CGFloat transHeight = itemWidth * (numb+1);
	
	isAnimateCompletion = NO;
	/*
	 frame变化时  会计算scrollView contentOffset，此处offset变化会触发 《uicollectionview的展示更多》
	 现象：展示table时，uicollectionview再反复回弹 一次，最后uicollectioview展开了，table展不开
	 isAnimateCompletion：保护table顺利展开
	 */
	[UIView animateWithDuration:0.25 animations:^{
		view_collection.frame = CGRectMake(0, kStatusAndNavBarH + 40 + 40, SCREEN_WIDTH - screenPadding * 2, transHeight);
		view_table.frame = CGRectMake(0, kStatusAndNavBarH + 40 + 40 + transHeight, SCREEN_WIDTH, SCREEN_HEIGHT - (kStatusAndNavBarH + 40 + 40 + transHeight + BOTTOM_HEIGHT - HOME_IND_HEIGHT));
	} completion:^(BOOL finished) {
		isAnimateCompletion = YES;
	}];
	[view_collection scrollToItemAtIndexPath:indexPathHandle atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
	
	return nil;
}

- (id)scrollToShowMore {
		
	if (isAnimateCompletion) {
		UITableView *view_table = [self.views objectForKey:kAYTableView];
		UICollectionView *view_collection = [self.views objectForKey:@"CollectionVer"];
		[UIView animateWithDuration:0.25 animations:^{
			view_collection.frame = CGRectMake(0, kStatusAndNavBarH + 40 + 40, SCREEN_WIDTH - screenPadding * 2, SCREEN_HEIGHT - kStatusAndNavBarH - 40 - 40 - BOTTOM_HEIGHT - HOME_IND_HEIGHT);
			view_table.frame = CGRectMake(0, SCREEN_HEIGHT - BOTTOM_HEIGHT - HOME_IND_HEIGHT, SCREEN_WIDTH, 0);
		}];
	}
	return nil;
}

- (id)scrollToCenter:(id)args {
	UICollectionView *view_collection = [self.views objectForKey:@"CollectionVer"];
	[view_collection scrollToItemAtIndexPath:args atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
	return nil;
}

#pragma mark -- table delegate notifies
- (id)cellDeleteFromTable:(NSNumber*)args {
	[timesArr removeObjectAtIndex:args.integerValue];
	NSArray *tmp = [timesArr copy];
	kAYDelegatesSendMessage(@"BOTimeTable", @"changeQueryData:", &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	[self checkCertainBtnStates];
	
	return nil;
}

- (id)cellShowPickerView:(NSNumber*)args {
	creatOrUpdateNote = args.integerValue;
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)didClickTheCellRow:(id)args {
	
	NSInteger sect = ((NSIndexPath*)args).section;
	NSMutableDictionary *dic_op = [timesArr objectAtIndex:sect];
	BOOL isSelected = ((NSNumber*)[dic_op objectForKey:@"is_selected"]).boolValue;
	[dic_op setValue:[NSNumber numberWithBool:!isSelected] forKey:@"is_selected"];
	[self checkCertainBtnStates];
	
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	[view_table reloadRowsAtIndexPaths:@[args] withRowAnimation:UITableViewRowAnimationNone];
	return nil;
}

#pragma mark -- pickerView notifies
- (id)didSaveClick {
	id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"ServiceTimesPick"];
	id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
	NSDictionary *args = nil;
	[cmd_index performWithResult:&args];
	//eg: (int)1400-1600
	
	if (!args) {
		NSString *title = @"服务时间设置错误";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	NSDictionary *argsHolder = nil;
	if (creatOrUpdateNote == timesArr.count) {
		//添加
		[timesArr addObject:args];
	} else {
		//修改
		argsHolder = [timesArr objectAtIndex:creatOrUpdateNote];
		[timesArr replaceObjectAtIndex:creatOrUpdateNote withObject:args];
	}
	
	[timesArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [[obj1 objectForKey:kAYServiceArgsStart] intValue] > [[obj2 objectForKey:kAYServiceArgsStart] intValue];
	}];
	if (![self isCurrentTimesLegal]) {
		if (!argsHolder) {
			[timesArr removeObject:args];
		} else {
			NSInteger holderIndex = [timesArr indexOfObject:args];
			[timesArr replaceObjectAtIndex:holderIndex withObject:argsHolder];
		}
		NSString *title = @"服务时间设置错误";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}		//输入数据 检测合法性 => 确定存入/再移除
	
	NSArray *tmp = [timesArr copy];
	kAYDelegatesSendMessage(@"BOTimeTable", kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	[self checkCertainBtnStates];
	
	return nil;
}

- (id)didCancelClick {
	//do nothing else ,but be have to invoke this methed
	return nil;
}

- (BOOL)isCurrentTimesLegal {
	__block BOOL isLegal = YES;
	[timesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		NSNumber *currentEnd = [obj objectForKey:@"end"];
		if (idx+1 < timesArr.count) {
			NSNumber *nextStart = [[timesArr objectAtIndex:idx+1] objectForKey:@"start"];
			if (currentEnd.intValue > nextStart.intValue) {
				isLegal = NO;
				*stop = YES;
			}
		}
	}];
	return isLegal;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end

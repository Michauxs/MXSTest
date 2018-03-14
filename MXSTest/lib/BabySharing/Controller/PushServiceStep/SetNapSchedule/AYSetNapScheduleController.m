//
//  AYSetNapScheduleController.m
//  BabySharing
//
//  Created by Alfred Yang on 11/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapScheduleController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "TmpFileStorageModel.h"
#import "AYServiceTimesRule.h"

#import "AYAddTimeSignView.h"

#define weekdaysViewHeight          95
static NSString* const kAYScheduleWeekDaysView = 	@"ScheduleWeekDays";
static NSString* const kAYSpecialTMAndStateView = 	@"SpecialTMAndState";

@implementation AYSetNapScheduleController {
	
	NSMutableDictionary *push_service_info;
	
	NSMutableDictionary *push_tms;
    NSMutableDictionary *basicTMS;
    
    NSMutableArray *oneWeekDayTMs;
    int segCurrentIndex;
    NSInteger creatOrUpdateNote;
	
	AYAddTimeSignView *addBasicTMView;
	UIImageView *maskTableHeadView;
	
	BOOL isAlreadyEnable;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [Tools garyBackgroundColor];
	self.view.clipsToBounds = YES;
	
	id tmp_tms = [push_service_info objectForKey:kAYServiceArgsTimes];
	if (tmp_tms) {
		push_tms = [[NSMutableDictionary alloc] initWithDictionary:tmp_tms];
		basicTMS = [push_tms objectForKey:kBasic];
		[self setScheduleViewTM];
		kAYViewsSendMessage(kAYScheduleWeekDaysView, @"setViewState", nil)
		
	} else {
		push_tms = [NSMutableDictionary dictionary];
		basicTMS = [NSMutableDictionary dictionary];
		[push_tms setValue:basicTMS forKey:kBasic];
	}
	id tmp = [push_tms mutableCopy];
	kAYViewsSendMessage(kAYSpecialTMAndStateView, @"setViewInfo:", &tmp)
	
    oneWeekDayTMs = [NSMutableArray array];  //value
    segCurrentIndex = -1;
    
	id<AYDelegateBase> dlg_pick = [self.delegates objectForKey:@"ServiceTimesPick"];
	id obj = (id)dlg_pick;
	kAYViewsSendMessage(kAYPickerView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)dlg_pick;
	kAYViewsSendMessage(kAYPickerView, kAYTCViewRegisterDatasourceMessage, &obj)
	
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"ServiceTimesShow"];
    obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
    obj = (id)cmd_notify;
    kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
    NSString* cell_name = @"AYServiceTimesCellView";
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
	
	NSArray *tms_oneweekday = [oneWeekDayTMs copy];
	kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tms_oneweekday)
    
    //提升view层级
    UIView *weekdaysView = [self.views objectForKey:kAYScheduleWeekDaysView];
    [self.view bringSubviewToFront:weekdaysView];
	
	addBasicTMView = [[AYAddTimeSignView alloc] initWithTitle:@"服务时间"];
	[self.view addSubview:addBasicTMView];
	[addBasicTMView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(weekdaysView.mas_bottom).offset(8);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 46));
	}];
	[addBasicTMView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddBasicTMViewTap)]];
	
	UIView* view_table = [self.views objectForKey:kAYTableView];
	[view_table mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(addBasicTMView.mas_bottom);
		make.centerX.equalTo(self.view);
		make.width.equalTo(addBasicTMView);
		make.bottom.equalTo(self.view);
	}];
	[self.view bringSubviewToFront:view_table];
	maskTableHeadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_add_basic_tms"]];
	[self.view addSubview:maskTableHeadView];
	[maskTableHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(view_table);
		make.centerX.equalTo(view_table);
		make.width.equalTo(addBasicTMView);
		make.height.mas_equalTo(17);
	}];
	view_table.hidden = maskTableHeadView.hidden = YES;
	
	UIView *view_table_div = [self.views objectForKey:kAYSpecialTMAndStateView];
	view_table_div.hidden = YES;
	
    UIView* picker = [self.views objectForKey:@"Picker"];
    [self.view bringSubviewToFront:picker];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServiceTimesPick"];
	id<AYCommand> cmd_scroll_center = [cmd_recommend.commands objectForKey:@"scrollToCenterWithOffset:"];
	NSNumber *offset = [NSNumber numberWithInt:0];
	[cmd_scroll_center performWithResult:&offset];
}

#pragma mark -- Layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
    NSString *title = @"服务时间设置";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
	UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:616.f backgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)ScheduleWeekDaysLayout:(UIView*)view {
	
    view.frame = CGRectMake(view.frame.origin.x, kStatusAndNavBarH+6, view.frame.size.width, view.frame.size.height);
    view.backgroundColor = [Tools whiteColor];
    return nil;
}

- (id)TableLayout:(UIView*)view {
//	((UITableView*)view).contentInset = UIEdgeInsetsMake(17, 0, 0, 0);
    view.frame = CGRectMake(0, kStatusAndNavBarH + weekdaysViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - weekdaysViewHeight - kStatusAndNavBarH );
    return nil;
}

- (id)SpecialTMAndStateLayout:(UIView*)view {
	view.frame = CGRectMake(0,kStatusAndNavBarH+306, SCREEN_WIDTH, SCREEN_HEIGHT - (kStatusAndNavBarH+306));
	return nil;
}

- (id)PickerLayout:(UIView*)view {
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
    return nil;
}

#pragma mark -- actions
- (void)setScheduleViewTM {
	NSDictionary *date_info = [push_tms copy];
	kAYViewsSendMessage(kAYScheduleWeekDaysView, @"setViewInfo:", &date_info)
}

- (void)didAddBasicTMViewTap {
	creatOrUpdateNote = -1;
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
}

- (void)setNavRightBtnStatus {
	BOOL isSeted = NO;
	for (NSArray *tms in [basicTMS allValues]) {
		if (tms.count != 0) {
			isSeted = YES;
			break;
		}
	}
	
	if (isSeted) {
		if (!isAlreadyEnable) {
			UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
			kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
			isAlreadyEnable = YES;
		}
	} else {
		if (isAlreadyEnable) {
			UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:616.f backgroundColor:nil];
			bar_right_btn.userInteractionEnabled = NO;
			kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
			isAlreadyEnable = NO;
		}
	}
	
}

- (void)popToRootVCWithTip:(NSString*)tip {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:tip forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic];
    
}

- (BOOL)isCurrentTimesLegal {
    //    NSMutableArray *allTimeNotes = [NSMutableArray array];
    __block BOOL isLegal = YES;
    [oneWeekDayTMs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSNumber *currentEnd = [obj objectForKey:@"end"];
        
        if (idx+1 < oneWeekDayTMs.count) {
            NSNumber *nextStart = [[oneWeekDayTMs objectAtIndex:idx+1] objectForKey:@"start"];
            
            if (currentEnd.intValue > nextStart.intValue) {
                isLegal = NO;
                *stop = YES;
            }
        }
    }];
    
    return isLegal;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
	
	NSMutableDictionary *tmp;
	kAYViewsSendMessage(kAYSpecialTMAndStateView, @"callbackTMS:", &tmp)
	[tmp setValue:basicTMS forKey:@"basic"];
	
	NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
	[dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	//去重
	NSDictionary *tms_basic = [[tmp objectForKey:kBasic] copy];
	NSDictionary *tms_special = [[tmp objectForKey:kSpecial] copy];
	NSMutableArray *noteKeyArr = [NSMutableArray array];
	
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	[calendar setTimeZone:[NSTimeZone defaultTimeZone]];
	NSInteger unitFlags = NSCalendarUnitWeekday;
	
	for (NSString *key in [tms_special allKeys]) {
		NSArray *comp_arr = [tms_special objectForKey:key];
		
		for (NSString *weekdayKey in [tms_basic allKeys]) {
			
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:[key doubleValue]];
			NSDateComponents *comps = [[NSDateComponents alloc] init];
			comps = [calendar components:unitFlags fromDate:date];
			
			if (([comps weekday]-1) == [weekdayKey intValue]) {
				
				BOOL isSame = YES;
				NSArray *weekdayTMs = [tms_basic objectForKey:weekdayKey];
				if (weekdayTMs.count == comp_arr.count) {
					for (int i = 0; i < comp_arr.count; ++i) {
						if ([[[weekdayTMs objectAtIndex:i] objectForKey:kAYTimeManagerArgsStart] intValue] != [[[comp_arr objectAtIndex:i] objectForKey:kAYTimeManagerArgsStart] intValue] || [[[weekdayTMs objectAtIndex:i] objectForKey:kAYTimeManagerArgsEnd] intValue] != [[[comp_arr objectAtIndex:i] objectForKey:kAYTimeManagerArgsEnd] intValue]) {
							isSame = NO;
							break;
						}
					}
				} else {
					isSame = NO;
				}
				
				if (isSame) {
					[noteKeyArr addObject:key];
				}
			}
		}
	}
	for (NSString *key in noteKeyArr) {
		[[tmp objectForKey:kSpecial] removeObjectForKey:key];
	}
	
	NSMutableDictionary *tms = [[NSMutableDictionary alloc] init];
	[tms setValue:tmp forKey:kAYTimeManagerArgsTMs];
	[tms setValue:@"part_tms" forKey:@"key"];
	[dic_pop setValue:[tms copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic_pop];
    return nil;
}

- (id)firstTimeTouchWeekday:(NSNumber *)args {
	segCurrentIndex = args.intValue;
	
	if ([[basicTMS objectForKey:args.stringValue] count] != 0) {
		oneWeekDayTMs = [basicTMS objectForKey:args.stringValue];
		addBasicTMView.state = AYAddTMSignStateHead;
		
		UIView* view_table = [self.views objectForKey:kAYTableView];
		view_table.hidden = addBasicTMView.hidden = maskTableHeadView.hidden = NO;
		
		NSArray *tmp = [oneWeekDayTMs copy];
		kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
		kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	} else {
		
		[basicTMS setValue:oneWeekDayTMs forKey:args.stringValue];
		addBasicTMView.state = AYAddTMSignStateEnable;
	}
	
	return nil;
}

- (id)changeCurrentIndex:(NSNumber *)args {
    /*
     日程管理可以是集合，不超出从日到一，是不按顺序的，以keyValue:day为序号(0-6)进行各种操
     */
    
    WeekDayBtnState state = WeekDayBtnStateNormal;
	
	//1.接收到切换seg的消息后，整理容器内当前的内容
	if (oneWeekDayTMs.count != 0) {
		state = WeekDayBtnStateSeted;
		oneWeekDayTMs = [NSMutableArray array];
	} else
		[basicTMS removeObjectForKey:[NSString stringWithFormat:@"%d", segCurrentIndex]];
	
	//2.切换 - 判断新index中是否有数据
	if ([basicTMS objectForKey:[NSString stringWithFormat:@"%d", args.intValue]]) {
		oneWeekDayTMs = [basicTMS objectForKey:[NSString stringWithFormat:@"%d", args.intValue]];
		addBasicTMView.state = AYAddTMSignStateHead;
	}
	else {
		addBasicTMView.state = AYAddTMSignStateEnable;
		[basicTMS setValue:oneWeekDayTMs forKey:args.stringValue];
	}
	
	NSArray *tmp = [oneWeekDayTMs copy];
	kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	
    //切换index
    segCurrentIndex = args.intValue;
    
    //3.如果有数据：返回yes，用于btn作已设置标记
    return [NSNumber numberWithInt:state];
}

- (id)swipeDownExpandSchedule:(id)args {
	UIView* view_table = [self.views objectForKey:kAYTableView];
	view_table.hidden = addBasicTMView.hidden = maskTableHeadView.hidden = YES;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([args floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		UIView *view_table_div = [self.views objectForKey:kAYSpecialTMAndStateView];
		view_table_div.hidden = NO;
	});
	
	id tmp = [basicTMS copy];
	kAYViewsSendMessage(kAYSpecialTMAndStateView, @"setBasicTM:", &tmp)
	return nil;
}

- (id)swipeUpShrinkSchedule:(id)args {
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([args floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		UIView* view_table = [self.views objectForKey:kAYTableView];
		view_table.hidden = addBasicTMView.hidden = maskTableHeadView.hidden = NO;
	});
	UIView *view_table_div = [self.views objectForKey:kAYSpecialTMAndStateView];
	view_table_div.hidden = YES;
	
	kAYViewsSendMessage(kAYSpecialTMAndStateView, @"resetInitialState", nil)
	
	return nil;
}

- (id)didSomeTMSChanged {
	[self setNavRightBtnStatus];
	return nil;
}

#pragma mark -- brige message
- (id)didSelectItemAtIndexPath:(id)args {
	id tmp = [args copy];
	kAYViewsSendMessage(kAYSpecialTMAndStateView, @"recodeTMHandle:", &tmp)
	return tmp;
}

- (id)sendScheduleState:(id)args {
	id tmp = [args copy];
	kAYViewsSendMessage(kAYScheduleWeekDaysView, @"receiveScheduleState:", &tmp)
	return nil;
}

- (id)queryTMS:(id)args {
	id tmp = [basicTMS copy];
	return tmp;
}

- (id)cellDeleteFromTable:(NSNumber*)args {
    
    [oneWeekDayTMs removeObjectAtIndex:args.integerValue];
	if (oneWeekDayTMs.count == 0) {
		addBasicTMView.state = AYAddTMSignStateEnable;
	}
    NSArray *tmp = [oneWeekDayTMs copy];
    kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
    kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    
    [self setNavRightBtnStatus];
	[self setScheduleViewTM];
    return nil;
}

- (id)specialOrOpendayAddTM {
	creatOrUpdateNote = -2;
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)cellShowPickerView:(NSNumber*)args {
    
    creatOrUpdateNote = args.integerValue;
    kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
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
	if (creatOrUpdateNote == -2) { //添加／修改 特殊、开放日
		kAYViewsSendMessage(kAYSpecialTMAndStateView, @"pushTMArgs:", &args)
		return nil;
	} else if (creatOrUpdateNote == -1) { //添加基础
        [oneWeekDayTMs addObject:args];
    } else { //修改基础
        argsHolder = [oneWeekDayTMs objectAtIndex:creatOrUpdateNote];
        [oneWeekDayTMs replaceObjectAtIndex:creatOrUpdateNote withObject:args];
    }
    
	[oneWeekDayTMs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [[obj1 objectForKey:kAYServiceArgsStart] intValue] > [[obj2 objectForKey:kAYServiceArgsStart] intValue];
	}];
	
    if (![self isCurrentTimesLegal]) {
        if (!argsHolder) {
            [oneWeekDayTMs removeObject:args];
        } else {
            NSInteger holderIndex = [oneWeekDayTMs indexOfObject:args];
            [oneWeekDayTMs replaceObjectAtIndex:holderIndex withObject:argsHolder];
        }
        NSString *title = @"服务时间设置错误";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return nil;
    }
    
    [self setNavRightBtnStatus];
	
	if (oneWeekDayTMs.count != 0 && addBasicTMView.state == AYAddTMSignStateEnable) {
		kAYViewsSendMessage(kAYScheduleWeekDaysView, @"havenAddTM", nil)
		
		addBasicTMView.state = AYAddTMSignStateHead;
		UIView *view_table = [self.views objectForKey:kAYTableView];
		view_table.hidden = NO;
	}
	
	NSArray *tmp = [oneWeekDayTMs copy];
	kAYDelegatesSendMessage(@"ServiceTimesShow", @"changeQueryData:", &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	
	[self setScheduleViewTM];
    return nil;
}

- (id)didCancelClick {
    //do nothing else ,but be have to invoke this methed
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

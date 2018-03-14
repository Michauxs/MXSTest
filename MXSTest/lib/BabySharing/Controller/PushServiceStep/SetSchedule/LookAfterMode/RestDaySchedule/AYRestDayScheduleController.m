//
//  AYRestDayScheduleController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYRestDayScheduleController.h"
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

#define weekdaysViewHeight          95

@implementation AYRestDayScheduleController {
	
	NSMutableArray *timeDurationArr;
	UIButton *isAllowedBtn;
	
	NSNumber *timeSpanHandle;
	NSNumber *isAble;
	
	NSNumber *exchangeIndexNote;
	BOOL isChange;
}

- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		NSDictionary *dic_args = [dic objectForKey:kAYControllerChangeArgsKey];
		
		timeSpanHandle = [dic_args objectForKey:kAYServiceArgsTPHandle];
		timeDurationArr = [[dic_args objectForKey:@"times_note"] mutableCopy];
		isAble = [dic_args objectForKey:@"rest_isable"];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.view.backgroundColor = [Tools theme];
	
	if (!timeDurationArr) {
		timeDurationArr  = [NSMutableArray array];
	} else {
		[self showRightBtn];
	}
	
	if (!isAble) {
		isAble = [NSNumber numberWithBool:YES];
	}
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"看顾状态" textColor:[Tools whiteColor] fontSize:620.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(110);
		make.left.equalTo(self.view).offset(20);
	}];
	
	isAllowedBtn = [[UIButton alloc] init];
	[isAllowedBtn setImage:IMGRESOURCE(@"switch_off") forState:UIControlStateNormal];
	[isAllowedBtn setImage:IMGRESOURCE(@"switch_on") forState:UIControlStateSelected];
	[self.view addSubview:isAllowedBtn];
	[isAllowedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.view).offset(-20);
		make.centerY.equalTo(titleLabel);
		make.size.mas_equalTo(CGSizeMake(62, 42));
	}];
	[isAllowedBtn addTarget:self action:@selector(didAllowedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	isAllowedBtn.selected = isAble.boolValue;
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	tableView.hidden = !isAble.boolValue;
	
	{
		
		id<AYDelegateBase> pick_delegate = [self.delegates objectForKey:@"ServiceTimesPick"];
		
		id obj = (id)pick_delegate;
		kAYViewsSendMessage(kAYPickerView, kAYPickerRegisterDelegateMessage, &obj)
		obj = (id)pick_delegate;
		kAYViewsSendMessage(kAYPickerView, kAYPickerRegisterDatasourceMessage, &obj)
	}
	
	{
		id<AYDelegateBase> table_delegate = [self.delegates objectForKey:@"RestDayTable"];
		id obj = (id)table_delegate;
		kAYViewsSendMessage(kAYTableView, kAYPickerRegisterDelegateMessage, &obj)
		obj = (id)table_delegate;
		kAYViewsSendMessage(kAYTableView, kAYPickerRegisterDatasourceMessage, &obj)
		
		NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NurseScheduleCellWhite"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
	}
	
	NSArray *tmp = [timeDurationArr copy];
	kAYDelegatesSendMessage(@"RestDayTable", kAYDelegateChangeDataMessage, &tmp)
	
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
	NSNumber *offset = [NSNumber numberWithInt:6];
	[cmd_scroll_center performWithResult:&offset];
}

#pragma mark -- Layout
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	UIImage* left = IMGRESOURCE(@"bar_left_white");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, @"setRightBtnVisibility:", &right_hidden);
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	CGFloat marginTop = 150.f;
	view.frame = CGRectMake(0, marginTop, SCREEN_WIDTH, SCREEN_HEIGHT - marginTop);
	return nil;
}

- (id)PickerLayout:(UIView*)view {
	view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
	return nil;
}

#pragma mark -- actions
- (void)didAllowedBtnClick:(UIButton*)btn {
	btn.selected = !btn.selected;
	
	// selected = on
	UITableView *tableView = [self.views objectForKey:kAYTableView];
	tableView.hidden = !btn.selected;
	
	[self showRightBtn];
}

- (void)showRightBtn {
	if (!isChange) {
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools whiteColor] fontSize:316.f backgroundColor:nil];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isChange = YES;
	}
}

- (BOOL)isCurrentTimesLegal {
	//    NSMutableArray *allTimeNotes = [NSMutableArray array];
	__block BOOL isLegal = YES;
	[timeDurationArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		NSNumber *currentEnd = [obj objectForKey:@"end"];
		
		if (idx+1 < timeDurationArr.count) {
			NSNumber *nextStart = [[timeDurationArr objectAtIndex:idx+1] objectForKey:@"start"];
			
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
	NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
	[dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[timeDurationArr copy] forKey:@"rest_schedule"];
	[tmp setValue:[NSNumber numberWithBool:isAllowedBtn.selected] forKey:@"rest_isable"];
	[tmp setValue:timeSpanHandle forKey:kAYServiceArgsTPHandle];
	[dic_pop setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic_pop];
	return nil;
}

- (id)ChangeOfSchedule {
	return nil;
}

#pragma mark -- pickerView notifies
- (id)addTimeDuration {
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)exchangeTimeDuration:(id)args {
	exchangeIndexNote = args;
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)delTimeDuration:(id)args {
	NSNumber *row = args;
	[timeDurationArr removeObjectAtIndex:row.integerValue];
	
	id tmp = [timeDurationArr copy];
	kAYDelegatesSendMessage(@"RestDayTable", kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	[self showRightBtn];
	return nil;
}

- (id)didSaveClick {
	
	id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"ServiceTimesPick"];
	id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
	NSDictionary *args = nil;
	[cmd_index performWithResult:&args];
	//eg: {(int)1400,1600}
	
	if (!args) {
		NSString *title = @"服务时间设置错误";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		exchangeIndexNote = nil;
		return nil;
	}
	
	if (exchangeIndexNote) {
		[timeDurationArr replaceObjectAtIndex:exchangeIndexNote.integerValue withObject:args];
	} else {
		[timeDurationArr addObject:args];
	}
	
	[timeDurationArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [[obj1 objectForKey:kAYServiceArgsStart] intValue] > [[obj2 objectForKey:kAYServiceArgsStart] intValue];
	}];
	
	if (![self isCurrentTimesLegal]) {
		[timeDurationArr removeObject:args];
		
		NSString *title = @"服务时间设置错误";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		exchangeIndexNote = nil;
		return nil;
	}
	
	id tmp = [timeDurationArr copy];
	kAYDelegatesSendMessage(@"RestDayTable", kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	[self showRightBtn];
	
	exchangeIndexNote = nil;
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


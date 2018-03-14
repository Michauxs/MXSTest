//
//  AYSpecialTMAndStateView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSpecialTMAndStateView.h"

#import "AYServicePriceCatBtn.h"
#import "AYAddTimeSignView.h"
#import "AYShadowRadiusView.h"

static NSString *const kSpecialKey = @"special";
static NSString *const kOpenDayKey = @"openday";
static NSString *const kBasicKey = @"basic";

@implementation AYSpecialTMAndStateView {
	UIView *specialView;
	UIView *openDayView;
	
	AYServicePriceCatBtn *specialBtn;
	AYServicePriceCatBtn *openDayBtn;
	AYServicePriceCatBtn *handleBtn;
	
	UISwitch *specialSwitch;
	UISwitch *openDaySwitch;
	AYAddTimeSignView *specialAddSign;
	AYAddTimeSignView *openDayAddSign;
	NSDictionary *addSignViewDic;
	
	UITableView *specialTableView;
	UITableView *openDayTableView;
	NSDictionary *tableViewDic;
	
	NSMutableDictionary *TMS;
	NSString *handleKey;
	int updateOrAddNote;
	NSMutableDictionary *TMHandDic;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	CGFloat margin = 20.f;
	
	handleKey = kSpecialKey;
	
	specialBtn = [[AYServicePriceCatBtn alloc] initWithFrame:CGRectMake(margin, 0, (SCREEN_WIDTH-margin*2)*0.5, 38) andTitle:@"可预订日"];
	[self addSubview:specialBtn];
	[specialBtn setSelected:YES];
	handleBtn = specialBtn;
	openDayBtn = [[AYServicePriceCatBtn alloc] initWithFrame:CGRectMake(specialBtn.bounds.size.width + margin, 0, specialBtn.bounds.size.width, 38) andTitle:@"开放日"];
	[self addSubview:openDayBtn];
	UIButton *confuseBtn = [[UIButton alloc] init];
	[confuseBtn setImage:IMGRESOURCE(@"icon_sign_confuse") forState:UIControlStateNormal];
	[self addSubview:confuseBtn];
	[confuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(openDayBtn.mas_centerX).offset(30);
		make.centerY.equalTo(openDayBtn);
		make.size.mas_equalTo(CGSizeMake(22, 22));
	}];
	[confuseBtn addTarget:self action:@selector(didConfuseBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[specialBtn addTarget:self action:@selector(didOptionClick:) forControlEvents:UIControlEventTouchUpInside];
	[openDayBtn addTarget:self action:@selector(didOptionClick:) forControlEvents:UIControlEventTouchUpInside];
	
	specialView = [[UIView alloc] init];
	[self addSubview:specialView];
	[specialView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.width.mas_equalTo(SCREEN_WIDTH-margin*2);
		make.bottom.equalTo(self);
		make.top.equalTo(specialBtn.mas_bottom).offset(8);
	}];
	
	AYShadowRadiusView *specialStateView = [[AYShadowRadiusView alloc] initWithRadius:4];
	[specialView addSubview:specialStateView];
	[specialStateView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(specialView);
		make.centerX.equalTo(specialView);
		make.height.mas_equalTo(46);
		make.width.equalTo(specialView);
	}];
	UILabel *specialStateTitle = [Tools creatLabelWithText:@"服务状态" textColor:[Tools black] fontSize:615 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[specialStateView addSubview:specialStateTitle];
	[specialStateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(specialStateView).offset(15);
		make.centerY.equalTo(specialStateView);
	}];
	specialSwitch = [[UISwitch alloc] init];
	[specialSwitch setOnTintColor:[Tools theme]];
	[specialStateView addSubview:specialSwitch];
	[specialSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(specialStateView).offset(-15);
		make.centerY.equalTo(specialStateView);
	}];
	
	specialAddSign = [[AYAddTimeSignView alloc] initWithTitle:@"服务时间"];
	[specialView addSubview:specialAddSign];
	[specialAddSign mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(specialStateView.mas_bottom).offset(8);
		make.centerX.equalTo(specialView);
		make.size.equalTo(specialStateView);
	}];
	
	specialTableView = [[UITableView alloc] init];
	[specialView addSubview:specialTableView];
	[specialTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(specialView);
		make.top.equalTo(specialAddSign.mas_bottom);
		make.bottom.equalTo(specialView);
		make.centerX.equalTo(specialView);
	}];
	
	/*-------------------------------------*/
	openDayView = [[UIView alloc] init];
	[self addSubview:openDayView];
	[openDayView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self).offset(SCREEN_WIDTH);
		make.width.mas_equalTo(SCREEN_WIDTH-margin*2);
		make.bottom.equalTo(self);
		make.top.equalTo(specialBtn.mas_bottom).offset(8);
	}];
	
	AYShadowRadiusView *openDayStateView = [[AYShadowRadiusView alloc] initWithRadius:4];
	[openDayView addSubview:openDayStateView];
	[openDayStateView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(openDayView);
		make.centerX.equalTo(openDayView);
		make.height.mas_equalTo(46);
		make.width.equalTo(openDayView);
	}];
	UILabel *openDayStateTitle = [Tools creatLabelWithText:@"开放日状态" textColor:[Tools black] fontSize:615 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[openDayStateView addSubview:openDayStateTitle];
	[openDayStateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(openDayStateView).offset(15);
		make.centerY.equalTo(openDayStateView);
	}];
	openDaySwitch = [[UISwitch alloc] init];
	[openDaySwitch setOnTintColor:[Tools theme]];
	[openDayStateView addSubview:openDaySwitch];
	[openDaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(openDayStateView).offset(-15);
		make.centerY.equalTo(openDayStateView);
	}];
	[openDaySwitch addTarget:self action:@selector(didOpenDaySwitchChanged) forControlEvents:UIControlEventValueChanged];
	[specialSwitch addTarget:self action:@selector(didSpecialSwitchChanged) forControlEvents:UIControlEventValueChanged];
	
	openDayAddSign = [[AYAddTimeSignView alloc] initWithTitle:@"开放日服务时间"];
	[openDayView addSubview:openDayAddSign];
	[openDayAddSign mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(openDayStateView.mas_bottom).offset(8);
		make.centerX.equalTo(openDayView);
		make.size.equalTo(openDayStateView);
	}];
	
	openDayTableView = [[UITableView alloc] init];
	[openDayView addSubview:openDayTableView];
	[openDayTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(openDayView);
		make.top.equalTo(openDayAddSign.mas_bottom);
		make.bottom.equalTo(openDayView);
		make.centerX.equalTo(openDayView);
	}];
	
	specialTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	specialTableView.showsVerticalScrollIndicator = NO;
	specialTableView.backgroundColor = [UIColor clearColor];
	specialTableView.delegate = self;
	specialTableView.dataSource = self;
	openDayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	openDayTableView.showsVerticalScrollIndicator = NO;
	openDayTableView.backgroundColor = [UIColor clearColor];
	openDayTableView.delegate = self;
	openDayTableView.dataSource = self;
	[specialTableView registerClass:NSClassFromString(@"AYServiceTimesCellView") forCellReuseIdentifier:@"AYServiceTimesCellView"];
	[openDayTableView registerClass:NSClassFromString(@"AYServiceTimesCellView") forCellReuseIdentifier:@"AYServiceTimesCellView"];
	
	[self resetInitialState];
	TMHandDic = [[NSMutableDictionary alloc] init];
	
	[specialAddSign addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddSignTap:)]];
	[openDayAddSign addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddSignTap:)]];
	
	addSignViewDic = @{kSpecialKey:specialAddSign, kOpenDayKey:openDayAddSign};
	tableViewDic = @{kSpecialKey:specialTableView, kOpenDayKey:openDayTableView};
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCatigoryView;
}

#pragma mark -- actions
- (NSCalendar*)calendar {
	if (!_calendar) {
		_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		[_calendar setTimeZone:[NSTimeZone defaultTimeZone]];
	}
	return _calendar;
}

- (BOOL)isSameWeekday:(NSTimeInterval)timespan compTimeInterval:(NSTimeInterval)comp {
	
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timespan];
	NSDate *dateComp = [NSDate dateWithTimeIntervalSince1970:comp];
	
	NSInteger unitFlags = NSCalendarUnitWeekday;
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	comps = [self.calendar components:unitFlags fromDate:date];
	
	NSDateComponents *compsComp = [[NSDateComponents alloc] init];
	compsComp = [self.calendar components:unitFlags fromDate:dateComp];
	
	return [comps weekday] == [compsComp weekday];
}

- (BOOL)isTimestampHasSameWeekday:(NSTimeInterval)timestamp {
	
	BOOL isHas = NO;
	for (NSString *key in [[TMS objectForKey:kBasicKey] allKeys]) {
		isHas = [self weekdayOfTimestamp: timestamp] == key.intValue;
		if (isHas) {
			break;
		}
	}
	return isHas;
}

- (int)weekdayOfTimestamp:(NSTimeInterval)timestamp {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
	NSInteger unitFlags = NSCalendarUnitWeekday;
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	comps = [self.calendar components:unitFlags fromDate:date];
	
	return (int)[comps weekday] - 1;
}

- (void)didAddSignTap:(UITapGestureRecognizer*)tap {
	updateOrAddNote = -1;
	kAYViewSendNotify(self, @"specialOrOpendayAddTM", nil)
}

- (void)didOpenDaySwitchChanged {
	NSString *tmpHandTP = [[TMHandDic objectForKey:handleKey] stringValue];
	if (openDaySwitch.on) {
		[[TMS objectForKey:handleKey] setValue:[NSMutableArray array] forKey:tmpHandTP];
		openDayAddSign.state = AYAddTMSignStateEnable;
		openDayTableView.hidden = NO;
	} else {
		openDayAddSign.state = AYAddTMSignStateUnable;
		openDayTableView.hidden = YES;
		[[[TMS objectForKey:handleKey] objectForKey:tmpHandTP] removeAllObjects];
		[self doChangeAction];
		[openDayTableView reloadData];
	}
}
- (void)didSpecialSwitchChanged {
	NSString *tmpHandTP = [[TMHandDic objectForKey:handleKey] stringValue];
	if (specialSwitch.on) {
		[[TMS objectForKey:handleKey] setValue:[NSMutableArray array] forKey:tmpHandTP];
		specialAddSign.state = AYAddTMSignStateEnable;
		specialTableView.hidden = NO;
	} else {
		specialAddSign.state = AYAddTMSignStateUnable;
		specialTableView.hidden = YES;
		[[[TMS objectForKey:handleKey] objectForKey:tmpHandTP] removeAllObjects];
		[self doChangeAction];
		[specialTableView reloadData];
	}
}

- (void)didConfuseBtnClick {
	
}

- (void)didOptionClick:(AYServicePriceCatBtn*)btn {
	if (handleBtn == btn)  return;
	
	handleBtn.selected = NO;
	btn.selected = YES;
	handleBtn = btn;
	
	if (btn == specialBtn) {
		handleKey = kSpecialKey;
		[UIView animateWithDuration:0.5 animations:^{
			[specialView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self);
			}];
			[openDayView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self).offset(SCREEN_WIDTH);
			}];
			[self layoutIfNeeded];
		}];
	} else {
		handleKey = kOpenDayKey;
		[UIView animateWithDuration:0.5 animations:^{
			[specialView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self).offset(-SCREEN_WIDTH);
			}];
			[openDayView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self).offset(0);
			}];
			[self layoutIfNeeded];
		}];
	}
	
//	id tmp = [TMS copy];
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	[dic setValue:[TMS copy] forKey:kAYServiceArgsTimes];
	[dic setValue:[TMHandDic objectForKey:handleKey] forKey:kAYServiceArgsTPHandle];
	kAYViewSendNotify(self, @"sendScheduleState:", &dic)
}

- (void)doChangeAction {
	kAYViewSendNotify(self, @"didSomeTMSChanged", nil)
}

#pragma mark -- table delegate database
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == specialTableView) {
		NSInteger c = [[[TMS objectForKey:kSpecialKey] objectForKey:[[TMHandDic objectForKey:handleKey] stringValue]] count];
		return c;
	} else
		return [[[TMS objectForKey:kOpenDayKey] objectForKey:[[TMHandDic objectForKey:handleKey] stringValue]] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* class_name = @"AYServiceTimesCellView";
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	id tmp;
	if (tableView == specialTableView) {
		tmp = [[[TMS objectForKey:kSpecialKey] objectForKey:[[TMHandDic objectForKey:handleKey] stringValue]] objectAtIndex:indexPath.row];
	} else
		tmp = [[[TMS objectForKey:kOpenDayKey] objectForKey:[[TMHandDic objectForKey:handleKey] stringValue]] objectAtIndex:indexPath.row];
	
	kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
	
	cell.controller = self.controller;
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	updateOrAddNote = (int)indexPath.row;
	kAYViewSendNotify(self, @"specialOrOpendayAddTM", nil)
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除时间" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		[[[TMS objectForKey:handleKey] objectForKey:[[TMHandDic objectForKey:handleKey] stringValue]] removeObjectAtIndex:indexPath.row];
		if ([[[TMS objectForKey:handleKey] objectForKey:[[TMHandDic objectForKey:handleKey] stringValue]] count] == 0) {
			((AYAddTimeSignView*)[addSignViewDic objectForKey:handleKey]).state = AYAddTMSignStateEnable;
		}
		[self doChangeAction];
		[tableView reloadData];
	}];
	
	//    rowAction.backgroundColor = [UIColor colorWithPatternImage:IMGRESOURCE(@"cell_delete")];
	rowAction.backgroundColor = [Tools theme];
	return @[rowAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y < 0) {
		scrollView.contentOffset = CGPointMake(0, 0);
	}
}

#pragma mark -- notifies
- (id)setBasicTM:(id)args {
	[TMS setValue:args forKey:kBasicKey];
	return nil;
}

- (id)setViewInfo:(id)args {
	id tmp_special = [args objectForKey:kSpecialKey];
	id tmp_openday = [args objectForKey:kOpenDayKey];
	
	if (!tmp_special) {
		[args setValue:[NSMutableDictionary dictionary] forKey:kSpecialKey];
	}
	if (!tmp_openday) {
		[args setValue:[NSMutableDictionary dictionary] forKey:kOpenDayKey];
	}
	TMS = [args mutableCopy];
	return nil;
}

- (id)resetInitialState {
	[TMHandDic removeAllObjects];
	
	specialSwitch.userInteractionEnabled = NO;
	openDaySwitch.userInteractionEnabled = NO;
	specialAddSign.state = AYAddTMSignStateUnable;
	specialTableView.hidden = YES;
	
	openDayAddSign.state = AYAddTMSignStateUnable;
	openDayTableView.hidden = YES;
	return nil;
}

- (id)callbackTMS:(id)args {
	id tmp = [TMS mutableCopy];
	return tmp;
}

- (id)recodeTMHandle:(id)args {
	
	if ([handleKey isEqualToString:kSpecialKey]) {
		specialSwitch.userInteractionEnabled = YES;
	} else {
		openDaySwitch.userInteractionEnabled = YES;
	}
	
	AYTMDayState state = AYTMDayStateNull;
	NSNumber *tmpHandleTP = [TMHandDic objectForKey:handleKey];
	
	NSString *dateKey = [tmpHandleTP stringValue];
	NSArray *comp_arr = [[TMS objectForKey:handleKey] objectForKey:dateKey];
	if (comp_arr) {
		if ([comp_arr count] != 0) {	//如果选在了基础时间上 没动的时候后续判断／动的时候后续判断／删完说明设置了没有时间的特殊日
			if ([handleKey isEqualToString:kSpecialKey]) {
				
				if ([self isTimestampHasSameWeekday:[tmpHandleTP doubleValue]]) {
					BOOL isSame = YES;
					NSArray *weekdayTMs = [[TMS objectForKey:kBasicKey] objectForKey:[NSString stringWithFormat:@"%d", [self weekdayOfTimestamp:[tmpHandleTP doubleValue]]]];
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
					
					if (!isSame) {
						state = AYTMDayStateSpecial;
					}
					
				} else {
					state = AYTMDayStateSpecial;
				}
			} else {
				state = AYTMDayStateOpenDay;
			}
		} else {
//			[[TMS objectForKey:handleKey] removeObjectForKey:dateKey];
			state = AYTMDayStateNormal;
		}
	}
	
	//1.特殊日／开放日等单一日上是否有时间段 2.是否在基础时间上
	NSMutableArray *containsArr = [[TMS objectForKey:handleKey] objectForKey:[args stringValue]];
	if (containsArr) {
		if ([containsArr count] != 0) {
			if ([handleKey isEqualToString:kSpecialKey]) {
				[specialSwitch setOn:YES animated:YES];
				specialAddSign.state = AYAddTMSignStateHead;
				specialTableView.hidden = NO;
			} else {
				[openDaySwitch setOn:YES animated:YES];
				openDayAddSign.state = AYAddTMSignStateHead;
				openDayTableView.hidden = NO;
			}
		} else {
			if ([handleKey isEqualToString:kSpecialKey]) {
				[specialSwitch setOn:NO animated:YES];
				specialAddSign.state = AYAddTMSignStateUnable;
				specialTableView.hidden = YES;
			} else {
				[openDaySwitch setOn:NO animated:YES];
				openDayAddSign.state = AYAddTMSignStateUnable;
				openDayTableView.hidden = YES;
			}
		}
	}
	else {
		if ([handleKey isEqualToString:kSpecialKey]) {
			[specialSwitch setOn:NO animated:YES];
			specialAddSign.state = AYAddTMSignStateUnable;
			specialTableView.hidden = YES;
			
			if ([self isTimestampHasSameWeekday:[args doubleValue]]) {
				NSMutableArray *oneweekdayTMs = [NSMutableArray arrayWithArray:[[TMS objectForKey:kBasicKey] objectForKey:[NSString stringWithFormat:@"%d",[self weekdayOfTimestamp:[args doubleValue]] ]] ];
				[[TMS objectForKey:handleKey] setValue:oneweekdayTMs forKey:[args stringValue]];
				[specialSwitch setOn:YES animated:YES];
				specialAddSign.state = AYAddTMSignStateHead;
				specialTableView.hidden = NO;
				
			} else {
//				[[TMS objectForKey:handleKey] setValue:[NSMutableArray array] forKey:[args stringValue]];
			}
			
		} else {
//			[[TMS objectForKey:handleKey] setValue:[NSMutableArray array] forKey:[args stringValue]];
			[openDaySwitch setOn:NO animated:YES];
			openDayAddSign.state = AYAddTMSignStateUnable;
			openDayTableView.hidden = YES;
		}
		
	}
	
	[TMHandDic setValue:args forKey:handleKey];
	[(UITableView*)[tableViewDic objectForKey:handleKey] reloadData];
	
	return [NSNumber numberWithInt:state];
}

- (id)pushTMArgs:(id)args {
	NSMutableArray *timesArr = [[TMS objectForKey:handleKey] objectForKey:[[TMHandDic objectForKey:handleKey] stringValue]];
	NSDictionary *argsHolder = nil;
	if (updateOrAddNote == -1) { //添加
		[timesArr addObject:args];
	} else { //修改基础 1.add   2.？  3.remove/save
		argsHolder = [timesArr objectAtIndex:updateOrAddNote];
		[timesArr replaceObjectAtIndex:updateOrAddNote withObject:args];
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
	}
	
	
	if (timesArr.count != 0 && ((AYAddTimeSignView*)[addSignViewDic objectForKey:handleKey]).state == AYAddTMSignStateEnable) {
		((AYAddTimeSignView*)[addSignViewDic objectForKey:handleKey]).state = AYAddTMSignStateHead;
		((UIView*)[tableViewDic objectForKey:handleKey]).hidden = NO;
	}
	[self doChangeAction];
	[(UITableView*)[tableViewDic objectForKey:handleKey] reloadData];
	return nil;
}

- (BOOL)isCurrentTimesLegal {
	//    NSMutableArray *allTimeNotes = [NSMutableArray array];
	__block BOOL isLegal = YES;
	NSMutableArray *timesArr = [[TMS objectForKey:handleKey] objectForKey:[[TMHandDic objectForKey:handleKey] stringValue]];
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
@end

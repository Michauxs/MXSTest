//
//  AYScheduleWeekDaysView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYScheduleWeekDaysView.h"
#import "AYShadowRadiusView.h"
#import "AYSpecialDayCellView.h"


#define btnSpaceW				(SCREEN_WIDTH - 40) / 7
#define btnWH					30
#define btnMarginTop			15
#define kItemCellWH				btnSpaceW

#define kUnableHeight					60
#define kEnableHeight					80
#define kExpendHeight					290

@implementation AYScheduleWeekDaysView {
    AYWeekDayBtn *noteBtn;
	UIView *sepLineView;
    UIView *currentSign;
	NSMutableArray *dayBtnArr;
	
	UIView *animatView;
	CALayer *flickerLayer;
	
	UICollectionView *scheduleView;
	NSString *currentDate;
	int tmpCurrentIndex;
	AYSpecialDayCellView * handleCell;
	AYTMDayState handleState;
	NSNumber *TMHandle;
	
	BOOL isSpecialState;
	NSDictionary *basicTMS;
	NSDictionary *specialTMS;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
	CGFloat margin  = 20;
	self.frame = CGRectMake(margin, 0, SCREEN_WIDTH - margin*2, kUnableHeight);
	
	AYShadowRadiusView *BGView = [[AYShadowRadiusView alloc] initWithRadius:4.f];
	[self addSubview:BGView];
	[self sendSubviewToBack:BGView];
	[BGView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	isSpecialState = YES;
	tmpCurrentIndex = -1;
	
	NSArray *weekdays = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六" ];
	dayBtnArr = [NSMutableArray array];
	for (int i = 0; i < weekdays.count; ++i) {
		AYWeekDayBtn *dayBtn = [[AYWeekDayBtn alloc] initWithTitle:weekdays[i]];
		dayBtn.tag = i;
		dayBtn.states = WeekDayBtnStateNormal;
		[dayBtn addTarget:self action:@selector(didDayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:dayBtn];
		[dayBtnArr addObject:dayBtn];
		[dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (i+1) - btnSpaceW * 0.5);
			make.top.equalTo(self).offset(btnMarginTop);
			make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
		}];
	}
	
	animatView = [[UIView alloc] init];
	[BGView.radiusBGView addSubview:animatView];
	[animatView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(BGView);
		make.bottom.equalTo(BGView);
		make.width.equalTo(BGView);
		make.height.equalTo(@20);
	}];
	flickerLayer = [CALayer layer];
	flickerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - margin*2, 20);
	flickerLayer.backgroundColor = [Tools theme].CGColor;
	[animatView.layer addSublayer:flickerLayer];
	
	sepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 31, self.frame.size.width, 1)];
	[self addSubview:sepLineView];
	sepLineView.backgroundColor = [Tools garyLineColor];
	sepLineView.hidden = YES;
	
	animatView.userInteractionEnabled = YES;
	UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
	//如果想支持上下左右清扫  那么一个手势不能实现  需要创建两个手势
	swipe.direction = UISwipeGestureRecognizerDirectionDown;
	[animatView addGestureRecognizer:swipe];
	
	UISwipeGestureRecognizer *swipe_up =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
	swipe_up.direction = UISwipeGestureRecognizerDirectionUp;
	[animatView addGestureRecognizer:swipe_up];
	
	UIView *swipeSignView = [[UIView alloc] init];
	[animatView addSubview:swipeSignView];
	[swipeSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(animatView);
		make.size.mas_equalTo(CGSizeMake(35, 5));
	}];
	[Tools setViewBorder:swipeSignView withRadius:2.5 andBorderWidth:0 andBorderColor:nil andBackground:[Tools colorWithRED:213 GREEN:228 BLUE:238 ALPHA:1]];
	animatView.hidden = YES;
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.itemSize = CGSizeMake(kItemCellWH, kItemCellWH);
	layout.minimumLineSpacing = 0;
	layout.minimumInteritemSpacing = 0;
	
	NSDate *current = [[NSDate alloc]init];
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	currentDate = [formatter stringFromDate:current];
	
	scheduleView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 31, self.frame.size.width, kItemCellWH*5 ) collectionViewLayout:layout];
	scheduleView.backgroundColor = [UIColor clearColor];
	[BGView.radiusBGView addSubview:scheduleView];
	scheduleView.delegate = self;
	scheduleView.dataSource = self;
	//	_calendarContentView.allowsMultipleSelection = YES;
	scheduleView.showsVerticalScrollIndicator = NO;
	scheduleView.alpha = 0;
	
	[scheduleView registerClass:[AYSpecialDayCellView class] forCellWithReuseIdentifier:@"AYSpecialDayCellView"];
	[scheduleView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AYSpecialDayHeader"];
	
    currentSign = [[UIView alloc] init];
	currentSign.backgroundColor = [Tools theme];
    [sepLineView addSubview:currentSign];
    [currentSign mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sepLineView);
        make.centerX.equalTo(self.mas_left).offset(btnSpaceW - btnSpaceW * 0.5);
        make.size.mas_equalTo(CGSizeMake(btnSpaceW, 2));
    }];
	currentSign.hidden = YES;
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

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
	CGFloat duration = 0.75;
	if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
		NSLog(@"UP");
		if(self.frame.size.height == kEnableHeight) return;
		
		NSNumber *tmp = [NSNumber numberWithFloat:duration];
		kAYViewSendNotify(self, @"swipeUpShrinkSchedule:", &tmp)
		sepLineView.hidden = YES;
		[UIView animateWithDuration:duration animations:^{
			for (AYWeekDayBtn *btn in dayBtnArr) {
				btn.states = WeekDayBtnStateNormal;
				[btn mas_updateConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(self).offset(btnMarginTop);
				}];
			}
		} completion:^(BOOL finished) {
			[self resetWeekdayBtnState];
			if (tmpCurrentIndex!= -1) {
				((AYWeekDayBtn*)[dayBtnArr objectAtIndex:tmpCurrentIndex]).states = WeekDayBtnStateSelected;
			}
		}];
		
		[UIView animateWithDuration:duration animations:^{
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kEnableHeight);
			scheduleView.alpha = 0;
			[self layoutIfNeeded];
		}];
	}
	else if(swipe.direction == UISwipeGestureRecognizerDirectionDown) {
		NSLog(@"DOWN");
		if(self.frame.size.height == kExpendHeight) return;
		
		NSNumber *tmp = [NSNumber numberWithFloat:duration];
		kAYViewSendNotify(self, @"swipeDownExpandSchedule:", &tmp)
		
		[scheduleView reloadData];
		
		[UIView animateWithDuration:duration animations:^{
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kExpendHeight);
			scheduleView.alpha = 1;
			for (AYWeekDayBtn *btn in dayBtnArr) {
				btn.states = WeekDayBtnStateSmall;
				[btn mas_updateConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(self);
				}];
			}
			[self layoutIfNeeded];
		} completion:^(BOOL finished) {
			sepLineView.hidden = NO;
		}];
		
	}
}
#pragma mark === 闪烁动画
- (CABasicAnimation *)opacityForever_Animation:(float)time andRepeat:(int)count {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.fromValue = [NSNumber numberWithFloat:0.25f];
	animation.toValue = [NSNumber numberWithFloat:1.f];
	animation.autoreverses = NO;
	animation.duration = time;
//	animation.repeatDuration = time;
	animation.repeatCount = count;
	animation.removedOnCompletion = YES;
	animation.fillMode = kCAFillModeForwards;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//没有的话是均匀的动画。
	return animation;
}

- (void)resetWeekdayBtnState {
	for (int i = 0; i < dayBtnArr.count; ++i) {
		if([[basicTMS objectForKey:[NSString stringWithFormat:@"%d", i]] count] != 0) {
			AYWeekDayBtn *btn = [dayBtnArr objectAtIndex:i];
			btn.states = WeekDayBtnStateSeted;
		}
	}
}

#pragma mark -- notifies
- (id)setViewInfo:(NSDictionary*)args {
	specialTMS = [args copy];
	basicTMS = [[args objectForKey:@"basic"] copy];
    return nil;
}

- (id)setViewState {
	[self resetWeekdayBtnState];
	
	[UIView animateWithDuration:0.25 animations:^{
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kEnableHeight);
		[self layoutIfNeeded];
	} completion:^(BOOL finished) {
		animatView.hidden = NO;
	}];
	return nil;
}

- (id)havenAddTM {
	if (self.frame.size.height > kUnableHeight) {
		return nil;
	}
	[UIView animateWithDuration:0.25 animations:^{
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kEnableHeight);
		[self layoutIfNeeded];
	} completion:^(BOOL finished) {
		animatView.hidden = NO;
//		animatView.backgroundColor = [Tools themeLightColor];
		[flickerLayer addAnimation:[self opacityForever_Animation:0.75 andRepeat:2] forKey:nil];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//			animatView.backgroundColor = [Tools whiteColor];
			flickerLayer.backgroundColor = [Tools whiteColor].CGColor;
		});
	}];
	return nil;
}

- (id)currentColSignOffset:(NSInteger)args {
	
	[UIView animateWithDuration:0.25 animations:^{
		[currentSign mas_updateConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (args + 1) - btnSpaceW * 0.5);
		}];
		[self layoutIfNeeded];
	}];
	return nil;
}

- (id)receiveScheduleState:(id)args {
	
	isSpecialState = !isSpecialState;
	
	specialTMS = [args objectForKey:kAYServiceArgsTimes];
	TMHandle = [args objectForKey:kAYServiceArgsTPHandle];
	[scheduleView reloadData];
	return nil;
}

#pragma mark -- actions
- (void)didDayBtnClick:(AYWeekDayBtn*)btn {
    if (noteBtn == btn || btn.states == WeekDayBtnStateSmall) {
        return;
    }
	tmpCurrentIndex = (int)btn.tag;
	
	//notifies
	NSNumber *index = [NSNumber numberWithInteger:btn.tag];
	if (!noteBtn) {
		//第一次触发weekday btn -> 发送消息：激活添加时间sign
		kAYViewSendNotify(self, @"firstTimeTouchWeekday:", &index)
		btn.states = WeekDayBtnStateSelected;
		noteBtn = btn;
	} else {
		kAYViewSendNotify(self, @"changeCurrentIndex:", &index)
		//此处index返回值是有意义的：是否有值（是否切换）／NSNumber封装int(0/2)（是否已设置TM的标志）
		
		btn.states = WeekDayBtnStateSelected;
		noteBtn.states = index.intValue;
		noteBtn = btn;
	}
}

#pragma mark -- ollectionViewDelegate
- (AYCalendarDate*)useTime {
	if (!_useTime) {
		_useTime = [[AYCalendarDate alloc]init];
	}
	return _useTime;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 12;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	//每个月的第一天
	NSString *dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02d", (section+[self.useTime getMonth]-1)/12 + [_useTime getYear], (section+[self.useTime getMonth]-1)%12+1, 1];
	
	return [self.useTime timeFewWeekInMonth:dateStr] * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYSpecialDayCellView *cell = (AYSpecialDayCellView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AYSpecialDayCellView" forIndexPath:indexPath];
	
	//每个月的第一天
	NSString *dateStr = [self getDateStrForSection:indexPath.section day:1];
	//获得这个月的天数
	NSInteger monthNumber = [self.useTime timeNumberOfDaysInString:dateStr];
	//获得这个月第一天是星期几
	NSInteger dayOfWeek = [self.useTime timeMonthWeekDayOfFirstDay:dateStr];
	
	NSInteger firstCorner = dayOfWeek;
	NSInteger lastConter = dayOfWeek + monthNumber - 1;
	cell.hidden = NO;	//reset reusecell.hidden
	cell.state = AYTMDayStateNormal;
	if (indexPath.item < firstCorner || indexPath.item > lastConter) {
		cell.hidden = YES;
	} else {
		NSInteger day = indexPath.item - firstCorner+1;
		NSString *cellDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02d", (indexPath.section+[self.useTime getMonth]-1)/12 + [_useTime getYear], (indexPath.section+[self.useTime getMonth]-1)%12 + 1, (int)day];
		NSDate *cellDate = [_useTime strToDate:cellDateStr];
		NSTimeInterval cellTimeSpan = cellDate.timeIntervalSince1970;
		
		NSDate *today = [_useTime strToDate:currentDate];
		NSTimeInterval todayTimeSpan = today.timeIntervalSince1970;
		
		cell.day = day;
		cell.timeSpan = cellTimeSpan;
		
		if (todayTimeSpan > cellTimeSpan) {
			cell.state = AYTMDayStateGone;
		}
		else {
			if (todayTimeSpan == cellTimeSpan) {
				[cell isToday];
			}
			
			if (isSpecialState) {
				if ([[basicTMS objectForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row%7]] count] != 0) {
					cell.state = AYTMDayStateInServ;
				}
				
				NSArray *ones_tms = [[specialTMS objectForKey:@"special"] objectForKey:[[NSNumber numberWithDouble:cellTimeSpan] stringValue]];
				if (ones_tms) {
					if ([ones_tms count] != 0) {
						NSArray *weekdayTMs = [basicTMS objectForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row%7]];
						if (weekdayTMs.count == ones_tms.count) {
							for (int i = 0; i < ones_tms.count; ++i) {
								if ([[[weekdayTMs objectAtIndex:i] objectForKey:kAYTimeManagerArgsStart] intValue] != [[[ones_tms objectAtIndex:i] objectForKey:kAYTimeManagerArgsStart] intValue] || [[[weekdayTMs objectAtIndex:i] objectForKey:kAYTimeManagerArgsEnd] intValue] != [[[ones_tms objectAtIndex:i] objectForKey:kAYTimeManagerArgsEnd] intValue]) {
									cell.state = AYTMDayStateSpecial;
									break;
								}
							}
						} else {
							cell.state = AYTMDayStateSpecial;
						}
						
					} else {
						cell.state = AYTMDayStateNormal;
					}
				}
				
			} else {
				if ([[[specialTMS objectForKey:@"openday"] objectForKey:[[NSNumber numberWithDouble:cellTimeSpan] stringValue]] count] != 0) {
					cell.state = AYTMDayStateOpenDay;
				}
			}
			
			if ([TMHandle isEqualToNumber:[NSNumber numberWithDouble:cellTimeSpan]]) {
				cell.state = AYTMDayStateSelect;
				handleCell = cell;
//				handleState = AYTMDayStateSelect;
			}
		}
		
	}
	return cell;
}

//获得据section／cell的完整日期
- (NSString *)getDateStrForSection:(NSInteger)section day:(NSInteger)day {
	return [NSString stringWithFormat:@"%ld-%02ld-%02d", (section+[self.useTime getMonth]-1)/12 + [_useTime getYear], (section+[self.useTime getMonth]-1)%12+1, (int)day];
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AYSpecialDayHeader" forIndexPath:indexPath];
		
		UILabel *label = [headerView viewWithTag:119];
		if (label == nil) {
			label = [Tools creatLabelWithText:nil textColor:[Tools black] fontSize:616.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
			label.tag = 119;
			[headerView addSubview:label];
			[label mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerY.equalTo(headerView);
				make.left.equalTo(headerView).offset(13);
			}];
		}
		label.text = [NSString stringWithFormat:@"%ld年 %02ld月", (indexPath.section+([self.useTime getMonth]-1))/12 + [_useTime getYear], (indexPath.section+[self.useTime getMonth]-1) % 12 +1];
		return headerView;
	}
	return nil;
}

//设置header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	
	CGFloat width = SCREEN_WIDTH - 40;
	return (CGSize){width, width / 7};
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	AYSpecialDayCellView * cell = (AYSpecialDayCellView *)[collectionView cellForItemAtIndexPath:indexPath];
	if (cell.state == AYTMDayStateGone) {
		return ;
	}
	
	NSTimeInterval time_p = cell.timeSpan;
	NSNumber *tmp = [NSNumber numberWithDouble:time_p];
	kAYViewSendNotify(self, @"didSelectItemAtIndexPath:", &tmp)
	
	[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
	
	if (handleCell) {
		
		if ([tmp intValue] == AYTMDayStateNull || !tmp) {
			handleCell.state = handleState;
		} else {
			handleCell.state = [tmp intValue];
		}
	}
	
	handleState = cell.state;
	cell.state = AYTMDayStateSelect;
	handleCell = cell;
	
	currentSign.hidden = NO;
	NSInteger col = indexPath.row % 7;
	[self currentColSignOffset:col];
	
}
@end

//
//  AYNurseCalendarController.m
//  BabySharing
//
//  Created by Alfred Yang on 2/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNurseCalendarController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#define CollectionViewHeight				200

@implementation AYNurseCalendarController {
	
//	NSArray *timeDurationArr;
//	UIButton *editBtn;
	
	NSMutableArray *RestDayArr;
	NSMutableArray *timesArrNote;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
		NSDictionary *dic_args = [dic objectForKey:kAYControllerChangeArgsKey];
		timesArrNote = [[dic_args objectForKey:@"schedule_workday"] mutableCopy];
		RestDayArr = [[dic_args objectForKey:@"schedule_restday"] mutableCopy];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSDictionary *back_args = [dic objectForKey:kAYControllerChangeArgsKey];
		timesArrNote = [back_args objectForKey:@"rest_schedule"];
		
		NSNumber *handle = [back_args objectForKey:kAYServiceArgsTPHandle];
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.timePointHandle=%@", handle];
		NSArray *result = [RestDayArr filteredArrayUsingPredicate:pred];
		
		if (result.count != 0) {
			NSInteger handle_index = [RestDayArr indexOfObject:result.firstObject];
			[RestDayArr replaceObjectAtIndex:handle_index withObject:back_args];
			
		} else {
			
			[RestDayArr addObject:back_args];
		}
		
		[RestDayArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
			return [[obj1 objectForKey:kAYServiceArgsTPHandle] intValue] > [[obj2 objectForKey:kAYServiceArgsTPHandle] intValue];
		}];
		
		
		NSArray *tmp = [RestDayArr copy];
		kAYViewsSendMessage(@"Schedule", kAYDelegateChangeDataMessage, &tmp)
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (!RestDayArr) {
		RestDayArr = [NSMutableArray array];
	}
	
	NSArray *tmp = [RestDayArr copy];
	kAYViewsSendMessage(@"Schedule", kAYDelegateChangeDataMessage, &tmp)
	
//	editBtn = [Tools creatUIButtonWithTitle:@"编辑日期" andTitleColor:[Tools whiteColor] andFontSize:316.f andBackgroundColor:[Tools themeColor]];
//	[Tools setViewBorder:editBtn withRadius:25.f andBorderWidth:0 andBorderColor:0 andBackground:[Tools themeColor]];
//	[self.view addSubview:editBtn];
//	[editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.bottom.equalTo(self.view).offset(-25);
//		make.right.equalTo(self.view).offset(-25);
//		make.size.mas_equalTo(CGSizeMake(125, 50));
//	}];
//	
//	editBtn.alpha = 0.f;
//	[editBtn addTarget:self action:@selector(didEditBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, @"setRightBtnVisibility:", &right_hidden);
	return nil;
}

- (id)ScheduleLayout:(UIView*)view {
	view.frame = CGRectMake(0, 75, SCREEN_WIDTH, SCREEN_HEIGHT - 75);
	return nil;
}

#pragma mark -- actions
- (void)didEditBtnClick:(UIButton*)btn {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"RestDaySchedule");
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[RestDayArr copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	return nil;
}

#pragma mark -- calendarView nitifies
- (id)didSelectItemAtIndexPath:(id)args {
	
//	if (!isContains) {
//		[UIView animateWithDuration:0.25 animations:^{
//			editBtn.alpha = 1.f;
//		}];
//		isContains = YES;
//	}
	
	//NSNumber (double)
//	[RestDayArr addObject:args];
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"RestDaySchedule");
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:args forKey:kAYServiceArgsTPHandle];
	
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.timePointHandle=%@", args];
	NSArray *result = [RestDayArr filteredArrayUsingPredicate:pred];
	if (result.count == 0) {
		[tmp setValue:timesArrNote forKey:@"times_note"];
	} else {
		NSDictionary *dic_times = result.firstObject;
		NSArray *tmpArr = [dic_times objectForKey:@"rest_schedule"];
		[tmp setValue:[tmpArr copy] forKey:@"times_note"];
		[tmp setValue:[dic_times objectForKey:@"rest_isable"] forKey:@"rest_isable"];
	}
	
	
	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
	
	return nil;
}

- (id)didDeselectItemAtIndexPath:(id)args {
	
//	__block id tmp;
//	[RestDayArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//		if ([obj isEqualToNumber:args]) {
//			tmp = obj;
//			*stop = YES;
//		}
//	}];
//	[RestDayArr removeObject:tmp];
	
	return nil;
}

@end

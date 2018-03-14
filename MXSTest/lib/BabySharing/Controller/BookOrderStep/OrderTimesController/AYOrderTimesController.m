//
//  AYOrderTimesController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderTimesController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"
#import "AYCommandDefines.h"

#import "OrderTimesOptionView.h"

@implementation AYOrderTimesController {
    
    OrderTimesOptionView *startView;
    OrderTimesOptionView *endView;
    
    NSDictionary *dic_times;
	NSDictionary *initialData;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *tmp = [dic objectForKey:kAYControllerChangeArgsKey];
		dic_times = [tmp objectForKey:@"order_time"];
		initialData = [tmp objectForKey:@"initail"];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    startView = [[OrderTimesOptionView alloc]initWithTitle:@"开始时间"];
    [self.view addSubview:startView];
    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(65);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.5, 75));
    }];
    startView.userInteractionEnabled = YES;
    [startView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSetStartTime)]];
    startView.states = 1;
    
    endView = [[OrderTimesOptionView alloc]initWithTitle:@"结束时间"];
    [self.view addSubview:endView];
    [endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startView);
        make.right.equalTo(self.view);
        make.size.equalTo(startView);
    }];
    endView.userInteractionEnabled = YES;
    [endView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSetEndTime)]];
    endView.states = 0;
	
	NSNumber *start = [dic_times objectForKey:kAYServiceArgsStart];
	NSNumber *end = [dic_times objectForKey:kAYServiceArgsEnd];
	
	NSDateFormatter *format_time = [Tools creatDateFormatterWithString:@"HH:mm"];
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start.doubleValue * 0.001];
	NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end.doubleValue * 0.001];
	
	NSString *startStr = [format_time stringFromDate:startDate];
	startView.timeLabel.text = startStr ? startStr : @"10:00";
	
	NSString *endStr = [format_time stringFromDate:endDate];
    endView.timeLabel.text = endStr ? endStr : @"12:00";
    
	{
		NSNumber *start = [initialData objectForKey:kAYServiceArgsStart];
		NSNumber *end = [initialData objectForKey:kAYServiceArgsEnd];
		NSDateFormatter *format_time = [Tools creatDateFormatterWithString:@"HH:mm"];
		
		NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start.doubleValue * 0.001];
		NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end.doubleValue * 0.001];
		NSString *startStr = [format_time stringFromDate:startDate];
		NSString *endStr = [format_time stringFromDate:endDate];
		
		UILabel *tipslabel = [Tools creatLabelWithText:[NSString stringWithFormat:@"当前可预订时间段 %@-%@", startStr, endStr] textColor:[Tools garyColor] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		tipslabel.numberOfLines = 0;
		[self.view addSubview:tipslabel];
		[tipslabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.view);
			make.top.equalTo(endView.mas_bottom).offset(80);
		}];
	}
		
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
        [self.view bringSubviewToFront:(UIView*)view_picker];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"OrderTimes"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    }
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, kNavBarH);
	
	NSString *title = @"时间修改";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
    return nil;
}

- (id)PickerLayout:(UIView*)view {
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
    return nil;
}

#pragma mark -- actions
- (void)saveBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
}

- (void)didSetStartTime {
    endView.states = 0;
    startView.states = 1;
    
    endView.userInteractionEnabled = NO;
    [self showPickerViewWithTime:startView.timeLabel.text];
}
- (void)didSetEndTime {
    endView.states = 1;
    startView.states = 0;
    
    startView.userInteractionEnabled = NO;
    [self showPickerViewWithTime:endView.timeLabel.text];
}

- (void)showPickerViewWithTime:(NSString*)time {
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"OrderTimes"];
    id<AYCommand> cmd_scroll_center = [cmd_recommend.commands objectForKey:@"scrollToCenterWithOffset:"];
    NSNumber *offset = [NSNumber numberWithInt: [[time substringToIndex:2] intValue]];
    [cmd_scroll_center performWithResult:&offset];
    
    id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
    id<AYCommand> cmd_show = [view_picker.commands objectForKey:@"showPickerView"];
    [cmd_show performWithResult:nil];
}

#pragma mark -- commands
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

- (id)rightBtnSelected {
    
    int startClock = [startView.timeLabel.text substringToIndex:2].intValue;
    int endClock = [endView.timeLabel.text substringToIndex:2].intValue;
//    int least = ((NSNumber*)[dic_times objectForKey:@"least_hours"]).intValue;
    if (endClock < startClock) {
        
        NSString *title = @"结束时间需大于开始时间";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return nil;
    }
	
	NSNumber *start = [dic_times objectForKey:kAYServiceArgsStart];
	NSDateFormatter *format = [Tools creatDateFormatterWithString:@"yyyy-MM-dd日"];
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start.doubleValue * 0.001];
	NSString *dateStr = [format stringFromDate:startDate];
	
	NSDateFormatter *unformat = [Tools creatDateFormatterWithString:@"yyyy-MM-dd日HH:mm"];
	NSString *setStartStr = [dateStr stringByAppendingString:startView.timeLabel.text];
	NSDate *setStartDate = [unformat dateFromString:setStartStr];
	NSTimeInterval startSpan = setStartDate.timeIntervalSince1970 * 1000;
	
	NSString *setEndStr = [dateStr stringByAppendingString:endView.timeLabel.text];
	NSDate *setEndtDate = [unformat dateFromString:setEndStr];
	NSTimeInterval endSpan = setEndtDate.timeIntervalSince1970 * 1000;
	
	/**/
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic_args setValue:[NSNumber numberWithDouble:startSpan] forKey:kAYServiceArgsStart];
    [dic_args setValue:[NSNumber numberWithDouble:endSpan] forKey:kAYServiceArgsEnd];
    [dic setValue:[dic_args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

- (id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"OrderTimes"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSString *args = nil;
    [cmd_index performWithResult:&args];
    
    if (startView.userInteractionEnabled) {
        startView.timeLabel.text = args;
    }
    if (endView.userInteractionEnabled) {
        endView.timeLabel.text = args;
    }
    
	UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"下一步" titleColor:[Tools theme] fontSize:NavBarRightBtnFontSize backgroundColor:nil];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
    
    [self didCancelClick];
    
    return nil;
}

- (id)didCancelClick {
    startView.userInteractionEnabled = endView.userInteractionEnabled = YES;
    return nil;
}
@end

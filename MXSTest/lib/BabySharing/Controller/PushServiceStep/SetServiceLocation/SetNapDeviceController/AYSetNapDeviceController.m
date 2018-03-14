//
//  AYSetNapDeviceController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapDeviceController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYServiceArgsDefines.h"

#import "AYCourseSignView.h"

#define LIMITNUMB                   228

@implementation AYSetNapDeviceController {
	
    NSArray *push_options_data;
	NSMutableArray *tmp_options_data;
	
	BOOL isAlreadyEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        push_options_data = [dic objectForKey:kAYControllerChangeArgsKey];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetServiceFacility"];
	id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetNapOptionsCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	if (push_options_data) {
		tmp_options_data = [[NSMutableArray alloc] initWithArray:push_options_data];
		id data = [push_options_data copy];
		kAYDelegatesSendMessage(@"SetServiceFacility", kAYDelegateChangeDataMessage, &data)
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	NSString *title = @"场地友好性和安全设施";
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:616.f backgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat margin = 0;
    view.frame = CGRectMake(margin, kStatusAndNavBarH, SCREEN_WIDTH - margin * 2, SCREEN_HEIGHT - kStatusAndNavBarH);
    return nil;
}

#pragma mark -- actions
- (void)setNavRightBtnEnableStatus {
	if (!isAlreadyEnable) {
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
		kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = YES;
	}
}

- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    //整合数据
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
	[dic_info setValue:[tmp_options_data copy] forKey:kAYServiceArgsFacility];
	[dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
	
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}


-(id)didFacilityOptViewTap:(id)args {
	AYCourseSignView *tapView = args;
	NSString *opt = tapView.sign;
	
	if (!tmp_options_data) {
		tmp_options_data = [NSMutableArray array];
	}
	if ([tmp_options_data containsObject:opt]) {
		[tmp_options_data removeObject:opt];
		[tapView setUnselectStatus];
	} else {
		[tmp_options_data addObject:opt];
		[tapView setSelectStatus];
	}
	
	[self setNavRightBtnEnableStatus];
	return nil;
}

@end

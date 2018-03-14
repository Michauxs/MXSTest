//
//  AYFilterThemeController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFilterThemeController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYFilterThemeController {
	NSMutableDictionary *dic_theme;
	UIButton *noteBtn;
	
	NSDictionary *filterInfo;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		filterInfo = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

#pragma mark -- life cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"FilterTheme"];
	id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
	id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
	
	id obj = (id)cmd_notify;
	[cmd_datasource performWithResult:&obj];
	obj = (id)cmd_notify;
	[cmd_delegate performWithResult:&obj];
	
	id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
	NSString* class_name_tip = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"FilterThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	[cmd_cell performWithResult:&class_name_tip];
	
	id tmp = [filterInfo copy];
	kAYDelegatesSendMessage(@"FilterTheme", kAYDelegateChangeDataMessage, &tmp)
	
	UIButton *doFilterBtn = [Tools creatBtnWithTitle:@"查看" titleColor:[Tools whiteColor] fontSize:320.f backgroundColor:[Tools theme]];
	[self.view addSubview:doFilterBtn];
	[doFilterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
	}];
	
	[doFilterBtn addTarget:self action:@selector(didFilterBtnClick) forControlEvents:UIControlEventTouchUpInside];
	dic_theme = [[NSMutableDictionary alloc]init];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	UIImage *left = IMGRESOURCE(@"content_close");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton *right = [Tools creatBtnWithTitle:@"重置" titleColor:[Tools theme] fontSize:316.f backgroundColor:nil];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &right)
	
//	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
	((UITableView*)view).backgroundColor = [UIColor whiteColor];
	return nil;
}

#pragma mark -- actions
- (void)didFilterBtnClick {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[dic_theme copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = REVERSMODULE;
	[cmd performWithResult:&dic];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = REVERSMODULE;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	[dic_theme removeAllObjects];
	[dic_theme setValue:@"服务主题" forKey:@"title"];
	[dic_theme setValue:@"filterTheme" forKey:@"key"];
	noteBtn = nil;
	id tmp;
	kAYDelegatesSendMessage(@"FilterTheme", kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	return nil;
}

- (id)didSelectedOpt:(NSDictionary*)args {
	
	UIButton *btn = [args objectForKey:@"option_btn"];
	btn.selected = !btn.selected;
	
	if (btn.selected) {
		
		dic_theme = [args mutableCopy];
		[dic_theme removeObjectForKey:@"option_btn"];
		[dic_theme setValue:@"filterTheme" forKey:@"key"];
		
		noteBtn.selected = NO;
		noteBtn = btn;
	} else {
		[dic_theme removeAllObjects];
		[dic_theme setValue:@"服务主题" forKey:@"title"];
		[dic_theme setValue:@"filterTheme" forKey:@"key"];
		noteBtn = nil;
	}
	
	return nil;
}

@end

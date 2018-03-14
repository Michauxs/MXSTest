//
//  AYSetCourseSignController.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetCourseSignController.h"
#import "AYViewBase.h"
#import "AYFactoryManager.h"
#import "AYServiceArgsDefines.h"

#define kExpandHeight		110

@implementation AYSetCourseSignController {
    NSMutableDictionary *info_categ;
	
	UIView *coustomView;
	UILabel *coustomLabel;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        info_categ = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSString *coustom = [dic objectForKey:kAYControllerChangeArgsKey];
		
		[info_categ setValue:coustom forKey:kAYServiceArgsCourseCoustom];
		[info_categ removeObjectForKey:kAYServiceArgsCatThirdly];
		id tmp = [info_categ copy];
		kAYDelegatesSendMessage(@"SetCourseSign", @"changeQueryData:", &tmp);
		kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		
		coustomLabel.text = coustom;
		UIView *view_table = [self.views objectForKey:kAYTableView];
		[UIView animateWithDuration:0.25 animations:^{
			coustomView.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, 110);
			CGFloat marginTop = 64+kExpandHeight+10;
			view_table.frame = CGRectMake(0, marginTop, SCREEN_WIDTH, SCREEN_HEIGHT - marginTop);
		}];
		
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	coustomView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, 45)];
	[self.view addSubview:coustomView];
	coustomView.clipsToBounds = YES;
	
	UILabel *tipCoustomLabel = [Tools creatLabelWithText:@"创建新的标签" textColor:[Tools black] fontSize:617 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[coustomView addSubview:tipCoustomLabel];
	[tipCoustomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(coustomView).offset(20);
		make.right.equalTo(coustomView).offset(-20);
		make.top.equalTo(coustomView);
		make.height.equalTo(@44);
	}];
	tipCoustomLabel.userInteractionEnabled = YES;
	[tipCoustomLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTipCoustomLabelTap)]];
	
	UIImageView *accessView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"plan_time_icon")];
	[coustomView addSubview:accessView];
	[accessView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(coustomView).offset(-20);
		make.centerY.equalTo(tipCoustomLabel);
		make.size.mas_equalTo(CGSizeMake(14, 14));
	}];
	
	[Tools creatCALayerWithFrame:CGRectMake(20, 44, SCREEN_WIDTH - 40, 0.5) andColor:[Tools garyLineColor] inSuperView:coustomView];
	
	CGFloat itemWidth = (SCREEN_WIDTH - 40 - 3*8)/4;
	coustomLabel = [Tools creatLabelWithText:@"Coustom" textColor:[Tools whiteColor] fontSize:315 backgroundColor:[Tools theme] textAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:coustomLabel withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[coustomView addSubview:coustomLabel];
	[coustomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(tipCoustomLabel);
		make.top.equalTo(tipCoustomLabel.mas_bottom).offset(26);
		make.size.mas_equalTo(CGSizeMake(itemWidth, 33));
	}];
	
	NSString *coustom = [info_categ objectForKey:kAYServiceArgsCourseCoustom];
	if (coustom.length != 0) {
		coustomLabel.text = coustom;
		UIView *view_table = [self.views objectForKey:kAYTableView];
		coustomView.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, 110);
		CGFloat marginTop = 64+kExpandHeight+10;
		view_table.frame = CGRectMake(0, marginTop, SCREEN_WIDTH, SCREEN_HEIGHT - marginTop);
	}
	
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetCourseSign"];
	id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
    
    NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetCourseSignCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
	
    id tmp = [info_categ copy];
    kAYDelegatesSendMessage(@"SetCourseSign", @"changeQueryData:", &tmp);
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    
//    NSString *title = @"服务标签";
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
	CGFloat marginTop = kStatusAndNavBarH+45+10;
    view.frame = CGRectMake(0, marginTop, SCREEN_WIDTH, SCREEN_HEIGHT - marginTop);
    view.backgroundColor = [Tools whiteColor];
    return nil;
}

#pragma mark -- actions
- (void)didTipCoustomLabelTap {
	id<AYCommand> des = DEFAULTCONTROLLER(@"InputCoustom");
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic_push setValue:[info_categ objectForKey:kAYServiceArgsCourseCoustom] forKey:kAYControllerChangeArgsKey];

	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[NSNumber numberWithBool:NO] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}

- (id)courseCansSeted:(id)args {
	[info_categ setValue:args forKey:kAYServiceArgsCatThirdly];
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)didCourseSignViewTap:(id)args {
	[info_categ setValue:args forKey:kAYServiceArgsCatThirdly];
	
	//有SKU内的标签 删除自定义
	[info_categ removeObjectForKey:kAYServiceArgsCourseCoustom];
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

@end

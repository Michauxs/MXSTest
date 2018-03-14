//
//  AYServiceMapController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServiceMapController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"
//#import "AYSearchDefines.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define CollectionViewHeight				200

@implementation AYServiceMapController {
	
	NSDictionary *p2pData;
	
}

- (void)postPerform{
	
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		p2pData = [dic objectForKey:kAYControllerChangeArgsKey];
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIButton *closeBtn = [[UIButton alloc]init];
	[closeBtn setImage:IMGRESOURCE(@"map_icon_close") forState:UIControlStateNormal];
	[self.view addSubview:closeBtn];
	[closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(25);
		make.left.equalTo(self.view).offset(10);
		make.size.mas_equalTo(CGSizeMake(51, 51));
	}];
	[closeBtn addTarget:self action:@selector(leftBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	
	id<AYViewBase> map = [self.views objectForKey:@"ServiceMap"];
	id<AYCommand> cmd_map = [map.commands objectForKey:@"changePositionData:"];
	NSDictionary *dic_map = [p2pData copy];
	[cmd_map performWithResult:&dic_map];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	view.backgroundColor = [UIColor clearColor];
	return nil;
}

- (id)ServiceMapLayout:(UIView*)view {
	CGFloat margin = 0.f;
	view.frame = CGRectMake(margin, 0, SCREEN_WIDTH - 2* margin, SCREEN_HEIGHT);
	view.backgroundColor = [UIColor clearColor];
	return nil;
}

#pragma mark -- actions


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
//	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
//	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//	id<AYCommand> cmd = POP;
//	[cmd performWithResult:&dic];
	return nil;
}

@end

//
//  AYFilterLocationController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFilterLocationController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

@implementation AYFilterLocationController {
	NSDictionary *dic_loc;
}

- (CLLocationManager *)manager {
	if (!_manager) {
		_manager = [[CLLocationManager alloc]init];
	}
	return _manager;
}
- (CLGeocoder *)gecoder {
	if (!_gecoder) {
		_gecoder = [[CLGeocoder alloc]init];
	}
	return _gecoder;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
		NSDictionary* dic_push = [dic copy];
		id<AYCommand> cmd = PUSH;
		[cmd performWithResult:&dic_push];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		id backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
		if (backArgs) {
			
			if ([backArgs isKindOfClass:[NSString class]]) {
				
				NSString *title = (NSString*)backArgs;
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
			
		}
	}
}

#pragma mark -- life cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	[self.manager requestWhenInUseAuthorization];
	self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
	self.manager.delegate = self;
	
	BOOL isEnabled = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
	if (isEnabled) {
		[self.manager startUpdatingLocation];
	} else {
		NSString *title = @"发布服务需要开启定位服务";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
	}
	
	id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"FilterLocation"];
	id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
	id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
	
	id obj = (id)cmd_notify;
	[cmd_datasource performWithResult:&obj];
	obj = (id)cmd_notify;
	[cmd_delegate performWithResult:&obj];
	
	id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
	NSString* class_name_tip = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"FilterLocationCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	[cmd_cell performWithResult:&class_name_tip];
	
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
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 );
	((UITableView*)view).backgroundColor = [UIColor whiteColor];
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
	
	return nil;
}

- (id)reLocationAction {
	
	NSString *tmp = @"remove";
	kAYDelegatesSendMessage(@"FilterLocation", @"changeQueryData:", &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	[self.manager startUpdatingLocation];
	return nil;
}

#pragma mark -- 定位代理方法
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	switch (status) {
		case kCLAuthorizationStatusAuthorizedAlways:
		case kCLAuthorizationStatusAuthorizedWhenInUse: {
			[self.manager startUpdatingLocation];
		}
			break;
		case kCLAuthorizationStatusDenied: NSLog(@"Denied"); break;
		case kCLAuthorizationStatusNotDetermined: NSLog(@"not Determined"); break;
		case kCLAuthorizationStatusRestricted: NSLog(@"Restricted"); break;
		default:
			break;
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	
	CLLocation *loc = [locations firstObject];
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:[NSNumber numberWithDouble:loc.coordinate.latitude] forKey:kAYServiceArgsLatitude];
	[tmp setValue:[NSNumber numberWithDouble:loc.coordinate.longitude] forKey:kAYServiceArgsLongtitude];
	dic_loc = [tmp copy];
	
	[manager stopUpdatingLocation];
	[self.gecoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
		if (!error) {
			CLPlacemark *pl = [placemarks firstObject];
			NSString *name = pl.name;
			NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
			[tmp setValue:dic_loc forKey:kAYServiceArgsPin];
			[tmp setValue:name forKey:kAYServiceArgsAddress];
			
			kAYDelegatesSendMessage(@"FilterLocation", @"changeQueryData:", &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		}
	}];
}

@end

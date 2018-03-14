//
//  AYNapAreaController.m
//  BabySharing
//
//  Created by Alfred Yang on 18/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNapAreaController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import <AMapSearchKit/AMapSearchKit.h>

#define SHOW_OFFSET_Y				SCREEN_HEIGHT - 196
#define FAKE_BAR_HEIGHT				44
#define locBGViewHeight				175
#define nextBtnHeight				50

@implementation AYNapAreaController {
	
	NSDictionary *show_service_info;
	NSMutableDictionary *note_update_info;
	
    CLLocation *loc;
	
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
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [Tools darkBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	kAYViewsSendMessage(kValidatingView, @"showValidatingView", nil)
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		[self.manager requestWhenInUseAuthorization];
		self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
		self.manager.delegate = self;
		
		BOOL isEnabled = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
		if (isEnabled) {
			[self.manager startUpdatingLocation];
		} else {
			NSString *title = @"发布服务需要开启定位服务";
			[self popVCWithTip:title];
		}
	});
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)ValidatingLayout:(UIView*)view {
	NSString *tip = @"正在验证您的地理位置";
	kAYViewsSendMessage(kValidatingView, @"setTipContext:", &tip)
	return nil;
}

#pragma mark -- 定位代理方法
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    switch (status) {
//        case kCLAuthorizationStatusAuthorizedAlways:
//        case kCLAuthorizationStatusAuthorizedWhenInUse: {
//            [self.manager startUpdatingLocation];
//        }
//            break;
//        case kCLAuthorizationStatusDenied: NSLog(@"Denied"); break;
//        case kCLAuthorizationStatusNotDetermined: NSLog(@"not Determined"); break;
//        case kCLAuthorizationStatusRestricted: NSLog(@"Restricted"); break;
//        default:
//            break;
//    }
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	
	loc = [locations firstObject];
	[manager stopUpdatingLocation];
	
    id<AYViewBase> map = [self.views objectForKey:@"NapAreaMap"];
    id<AYCommand> cmd = [map.commands objectForKey:@"queryOnesLocal:"];
    CLLocation *loction = loc;
    [cmd performWithResult:&loction];
	
    
    [self.gecoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *pl = [placemarks firstObject];
        NSString *city = pl.locality;
		NSString *district = pl.subLocality;
		NSString *prov = pl.administrativeArea;
		NSString *tree = pl.thoroughfare;
//		NSString *name = pl.name;
//		NSString *subTree = pl.subThoroughfare;
		
        if (city && ([city isEqualToString:@"北京市"] || [city isEqualToString:@"Beijing"])) {
			
			NSString *tip = @"地理位置验证成功";
			kAYViewsSendMessage(kValidatingView, @"changeStatusWithSuccessTip:", &tip);
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				
//				kAYViewsSendMessage(kValidatingView, @"hideValidatingView", nil)
				id<AYCommand> des = DEFAULTCONTROLLER(@"SetServiceType");
				NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
				[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
				[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
				[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
				
				NSMutableDictionary *service_info = [[NSMutableDictionary alloc] init];
				NSMutableDictionary *dic_location = [[NSMutableDictionary alloc] init];
				[dic_location setValue:prov forKey:kAYServiceArgsProvince];
				[dic_location setValue:city forKey:kAYServiceArgsCity];
				[dic_location setValue:district forKey:kAYServiceArgsDistrict];
				[dic_location setValue:tree forKey:kAYServiceArgsAddress];
				[service_info setValue:dic_location forKey:kAYServiceArgsLocationInfo];
				
				NSMutableDictionary *pin = [[NSMutableDictionary alloc] init];
				[pin setValue:[NSNumber numberWithDouble:loc.coordinate.latitude] forKey:kAYServiceArgsLatitude];
				[pin setValue:[NSNumber numberWithDouble:loc.coordinate.longitude] forKey:kAYServiceArgsLongtitude];
				[dic_location setValue:pin forKey:kAYServiceArgsPin];
				
				[service_info setValue:@"kidnapPush" forKey:@"push"];		//用于信息主页判断是修改还是发布
				[dic_push setValue:service_info forKey:kAYControllerChangeArgsKey];
				
				id<AYCommand> cmd = PUSH;
				[cmd performWithResult:&dic_push];
				
			});
			
			
		} else {
			NSString *title = [NSString stringWithFormat:@"咚哒目前只支持北京市地区\n我们正在努力达到%@", city];
//			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"非常抱歉" message:title preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				[self leftBtnSelected];
			}];
			[alertController addAction:okAction];
			[self presentViewController:alertController animated:YES completion:nil];
		}
    }];
}

#pragma mark -- actions
- (void)didSelectedArea:(UIButton*)btn {
    id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
    UIView *picker = (UIView*)view_picker;
    [self.view bringSubviewToFront:picker];
    
    id<AYCommand> cmd_show = [view_picker.commands objectForKey:@"showPickerView"];
    [cmd_show performWithResult:nil];
}

- (void)didAdressLabeTap {
    id<AYCommand> des = DEFAULTCONTROLLER(@"NapLocation");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"push" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)popVCWithTip:(NSString*)tip {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:tip forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}
- (id)rightBtnSelected {
    
    return nil;
}


#pragma mark -- Keyboard facade
//- (id)KeyboardShowKeyboard:(id)args {
//    
//    NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
//	[UIView animateWithDuration:0.25 animations:^{
//		[locBGView mas_updateConstraints:^(MASConstraintMaker *make) {
//			make.bottom.equalTo(self.view).offset(-step.floatValue+nextBtnHeight);
//		}];
//		[self.view layoutIfNeeded];
//	}];
//	
//    return nil;
//}
//
//- (id)KeyboardHideKeyboard:(id)args {
//	
//	[UIView animateWithDuration:0.25 animations:^{
//		[locBGView mas_updateConstraints:^(MASConstraintMaker *make) {
//			make.bottom.equalTo(self.view);
//		}];
//		[self.view layoutIfNeeded];
//	}];
//    return nil;
//}

@end

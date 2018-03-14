//
//  AYLocationAuthCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 28/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYLocationAuthCommand.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"

@implementation AYLocationAuthCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    BOOL isEnabled = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
	
	*obj = [NSNumber numberWithBool:isEnabled];
	
//    if (isEnabled) {
//        *obj = [NSNumber numberWithBool:YES];
//        
//    } else {
//        NSString *title = @"发布服务需要开启定位服务";
//		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//		*obj = [NSNumber numberWithBool:NO];
//		
//    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

@end

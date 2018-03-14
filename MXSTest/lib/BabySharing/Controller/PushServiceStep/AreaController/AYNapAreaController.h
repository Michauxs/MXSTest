//
//  AYNapAreaController.h
//  BabySharing
//
//  Created by Alfred Yang on 18/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AYNapAreaController : AYViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager  *manager;
@property (nonatomic, strong) CLGeocoder *gecoder;
@end



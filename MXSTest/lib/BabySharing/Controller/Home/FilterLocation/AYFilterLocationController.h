//
//  AYFilterLocationController.h
//  BabySharing
//
//  Created by Alfred Yang on 20/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AYFilterLocationController : AYViewController <CLLocationManagerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) CLLocationManager  *manager;
@property (nonatomic, strong) CLGeocoder *gecoder;

@end
